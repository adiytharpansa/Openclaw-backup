#!/bin/bash
# monitor.sh - Monitor heartbeats and trigger deploy on failure

ACTION="${1:-help}"
SCRIPT_DIR="$(dirname "$0")"
CONFIG_FILE="$SCRIPT_DIR/monitor.conf"
STATE_FILE="/tmp/dms-monitor-state.json"
LOG_FILE="/var/log/openclaw/dms-monitor.log"

# Ensure log dir
mkdir -p "$(dirname "$LOG_FILE")" 2>/dev/null || LOG_FILE="/tmp/dms-monitor.log"

# Load config
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Defaults
HEARTBEAT_TIMEOUT="${HEARTBEAT_TIMEOUT:-1800}"  # 30 minutes
DEPLOY_SCRIPT="${DEPLOY_SCRIPT:-$SCRIPT_DIR/deploy.sh}"
NOTIFY_CHANNELS="${NOTIFY_CHANNELS:-telegram}"
LAST_HEARTBEAT_FILE="/tmp/dms-last-heartbeat"

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Record heartbeat
record_heartbeat() {
    local instance_id="$1"
    local timestamp=$(date +%s)
    
    echo "$timestamp" > "$LAST_HEARTBEAT_FILE.$instance_id"
    
    log "💓 Heartbeat received from: $instance_id"
}

# Check for timeout
check_timeout() {
    local instance_id="$1"
    local heartbeat_file="$LAST_HEARTBEAT_FILE.$instance_id"
    local current_time=$(date +%s)
    
    if [ ! -f "$heartbeat_file" ]; then
        log "⚠️  No heartbeat ever received from: $instance_id"
        return 1
    fi
    
    local last_heartbeat=$(cat "$heartbeat_file")
    local elapsed=$((current_time - last_heartbeat))
    
    if [ "$elapsed" -gt "$HEARTBEAT_TIMEOUT" ]; then
        log "🚨 TIMEOUT! No heartbeat for ${elapsed}s (threshold: ${HEARTBEAT_TIMEOUT}s)"
        return 1
    fi
    
    log "✅ Heartbeat OK (${elapsed}s ago)"
    return 0
}

# Trigger deployment
trigger_deploy() {
    local reason="$1"
    
    log "🚨 TRIGGERING DEPLOY! Reason: $reason"
    
    # Send alert
    if command -v "$SCRIPT_DIR/../alert-notification/alert.sh" &> /dev/null; then
        "$SCRIPT_DIR/../alert-notification/alert.sh" \
            "Dead Man's Switch Triggered" \
            "Deploying backup instances. Reason: $reason" \
            "critical"
    fi
    
    # Run deploy script
    if [ -x "$DEPLOY_SCRIPT" ]; then
        log "🚀 Running deploy script..."
        "$DEPLOY_SCRIPT" --reason "$reason"
    else
        log "⚠️  Deploy script not found or not executable: $DEPLOY_SCRIPT"
    fi
}

# Start monitor service
start_monitor() {
    log "🚀 Starting Dead Man's Switch Monitor"
    log "Timeout: ${HEARTBEAT_TIMEOUT}s"
    log "Deploy script: $DEPLOY_SCRIPT"
    
    PID_FILE="/tmp/dms-monitor.pid"
    echo $$ > "$PID_FILE"
    
    trap "stop_monitor" SIGINT SIGTERM
    
    while true; do
        # Check all tracked instances
        for instance_file in "$LAST_HEARTBEAT_FILE".*; do
            if [ -f "$instance_file" ]; then
                instance_id=$(basename "$instance_file" | sed "s/$(basename "$LAST_HEARTBEAT_FILE")\.//")
                
                if ! check_timeout "$instance_id"; then
                    trigger_deploy "No heartbeat from $instance_id for ${HEARTBEAT_TIMEOUT}s"
                fi
            fi
        done
        
        sleep 60  # Check every minute
    done
}

# Stop monitor
stop_monitor() {
    log "🛑 Stopping monitor service..."
    rm -f /tmp/dms-monitor.pid
    exit 0
}

# Simulate failure (for testing)
simulate_failure() {
    log "🧪 Simulating failure (for testing)..."
    
    # Set last heartbeat to 1 hour ago
    echo "$(($(date +%s) - 3600))" > "$LAST_HEARTBEAT_FILE.test-instance"
    
    log "✅ Simulated old heartbeat for test-instance"
    log "💡 Run 'check' to see timeout detection"
}

# Manual check
manual_check() {
    log "🔍 Manual check..."
    
    local triggered=false
    
    for instance_file in "$LAST_HEARTBEAT_FILE".*; do
        if [ -f "$instance_file" ]; then
            instance_id=$(basename "$instance_file" | sed "s/$(basename "$LAST_HEARTBEAT_FILE")\.//")
            
            if ! check_timeout "$instance_id"; then
                triggered=true
            fi
        fi
    done
    
    if [ "$triggered" = false ]; then
        log "✅ All instances healthy"
    fi
}

# Show status
show_status() {
    echo "📊 Dead Man's Switch - Monitor Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ -f /tmp/dms-monitor.pid ]; then
        pid=$(cat /tmp/dms-monitor.pid)
        if ps -p $pid > /dev/null 2>&1; then
            echo "Status: ✅ Running (PID: $pid)"
        else
            echo "Status: ❌ Not running (stale PID)"
        fi
    else
        echo "Status: ❌ Not running"
    fi
    
    echo ""
    echo "Configuration:"
    echo "  Timeout: ${HEARTBEAT_TIMEOUT}s"
    echo "  Deploy script: $DEPLOY_SCRIPT"
    echo "  Notify: $NOTIFY_CHANNELS"
    echo ""
    
    echo "Tracked Instances:"
    for instance_file in "$LAST_HEARTBEAT_FILE".*; do
        if [ -f "$instance_file" ]; then
            instance_id=$(basename "$instance_file" | sed "s/$(basename "$LAST_HEARTBEAT_FILE")\.//")
            last_hb=$(cat "$instance_file")
            elapsed=$(($(date +%s) - last_hb))
            echo "  - $instance_id: ${elapsed}s ago"
        fi
    done
    
    echo ""
    echo "Recent Logs:"
    tail -10 "$LOG_FILE" 2>/dev/null || echo "No logs"
}

# Show help
show_help() {
    echo "🔍 Dead Man's Switch - Monitor"
    echo ""
    echo "Usage: $0 <action>"
    echo ""
    echo "Actions:"
    echo "  start           - Start monitor service"
    echo "  stop            - Stop monitor"
    echo "  check           - Manual timeout check"
    echo "  simulate-failure - Simulate heartbeat failure (test)"
    echo "  status          - Show status"
    echo "  logs            - View logs"
    echo "  help            - Show this help"
    echo ""
    echo "Config: $CONFIG_FILE"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 simulate-failure"
    echo "  $0 check"
}

# Main
case "$ACTION" in
    start)          start_monitor ;;
    stop)           stop_monitor ;;
    check)          manual_check ;;
    simulate-failure) simulate_failure ;;
    status)         show_status ;;
    logs)           tail -50 "$LOG_FILE" ;;
    help|*)         show_help ;;
esac
