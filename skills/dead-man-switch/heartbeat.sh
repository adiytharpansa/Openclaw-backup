#!/bin/bash
# heartbeat.sh - Send heartbeat to monitor service

ACTION="${1:-help}"
SCRIPT_DIR="$(dirname "$0")"
CONFIG_FILE="$SCRIPT_DIR/.env"

# Load config
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
fi

# Defaults
HEARTBEAT_URL="${MONITOR_URL:-}"
INSTANCE_ID="${INSTANCE_ID:-primary}"
ENCRYPTION_KEY="${ENCRYPTION_KEY:-}"
HEARTBEAT_INTERVAL="${HEARTBEAT_INTERVAL:-300}"

# Generate heartbeat payload
generate_payload() {
    local timestamp=$(date +%s)
    local cpu=$(top -bn1 2>/dev/null | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 || echo "0")
    local ram=$(free 2>/dev/null | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}' || echo "0")
    
    cat <<EOF
{
  "instance_id": "$INSTANCE_ID",
  "timestamp": $timestamp,
  "status": "healthy",
  "metrics": {
    "cpu": $cpu,
    "ram": $ram
  },
  "version": "1.0.0"
}
EOF
}

# Send heartbeat
send_heartbeat() {
    if [ -z "$HEARTBEAT_URL" ]; then
        echo "⚠️  MONITOR_URL not configured"
        return 1
    fi
    
    local payload=$(generate_payload)
    
    echo "💓 Sending heartbeat to $HEARTBEAT_URL"
    echo "Payload: $payload"
    
    # Send via curl
    response=$(curl -s -w "\n%{http_code}" -X POST "$HEARTBEAT_URL" \
        -H "Content-Type: application/json" \
        -H "X-Instance-ID: $INSTANCE_ID" \
        -d "$payload")
    
    http_code=$(echo "$response" | tail -1)
    body=$(echo "$response" | head -n -1)
    
    if [ "$http_code" = "200" ]; then
        echo "✅ Heartbeat sent successfully"
        return 0
    else
        echo "❌ Failed to send heartbeat (HTTP $http_code)"
        echo "Response: $body"
        return 1
    fi
}

# Start continuous heartbeat
start_heartbeat() {
    echo "🚀 Starting heartbeat service..."
    echo "Interval: ${HEARTBEAT_INTERVAL}s"
    echo "Monitor: $HEARTBEAT_URL"
    echo ""
    
    # Create PID file
    PID_FILE="/tmp/dms-heartbeat.pid"
    echo $$ > "$PID_FILE"
    
    trap "stop_heartbeat" SIGINT SIGTERM
    
    while true; do
        send_heartbeat
        sleep "$HEARTBEAT_INTERVAL"
    done
}

# Stop heartbeat
stop_heartbeat() {
    echo ""
    echo "🛑 Stopping heartbeat service..."
    rm -f /tmp/dms-heartbeat.pid
    exit 0
}

# Test heartbeat
test_heartbeat() {
    echo "🧪 Testing heartbeat..."
    echo ""
    
    # Test payload generation
    echo "1. Testing payload generation..."
    payload=$(generate_payload)
    if [ -n "$payload" ]; then
        echo "   ✅ Payload generated"
    else
        echo "   ❌ Failed to generate payload"
        return 1
    fi
    
    # Test sending
    echo "2. Testing heartbeat send..."
    send_heartbeat
    if [ $? -eq 0 ]; then
        echo "   ✅ Heartbeat sent"
    else
        echo "   ⚠️  Heartbeat send failed (expected if monitor not configured)"
    fi
    
    echo ""
    echo "✅ Test complete"
}

# Enable heartbeat (add to cron)
enable_heartbeat() {
    echo "⚙️  Enabling heartbeat (adding to crontab)..."
    
    CRON_JOB="*/5 * * * * $SCRIPT_DIR/heartbeat.sh send >> /var/log/openclaw/heartbeat.log 2>&1"
    
    # Check if crontab available
    if ! command -v crontab &> /dev/null; then
        echo "⚠️  crontab not available"
        echo "💡 Add this to your startup manually:"
        echo "   $SCRIPT_DIR/heartbeat.sh start"
        return 1
    fi
    
    # Add to crontab (avoid duplicates)
    existing=$(crontab -l 2>/dev/null | grep "heartbeat.sh send" || true)
    if [ -z "$existing" ]; then
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        echo "✅ Heartbeat added to crontab (every 5 minutes)"
    else
        echo "ℹ️  Heartbeat already in crontab"
    fi
}

# Disable heartbeat
disable_heartbeat() {
    echo "⚙️  Disabling heartbeat..."
    
    if command -v crontab &> /dev/null; then
        crontab -l 2>/dev/null | grep -v "heartbeat.sh send" | crontab -
        echo "✅ Heartbeat removed from crontab"
    else
        echo "ℹ️  crontab not available"
    fi
    
    # Kill running process
    if [ -f /tmp/dms-heartbeat.pid ]; then
        kill $(cat /tmp/dms-heartbeat.pid) 2>/dev/null
        rm -f /tmp/dms-heartbeat.pid
        echo "✅ Heartbeat process stopped"
    fi
}

# Show status
show_status() {
    echo "📊 Dead Man's Switch - Heartbeat Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ -f /tmp/dms-heartbeat.pid ]; then
        pid=$(cat /tmp/dms-heartbeat.pid)
        if ps -p $pid > /dev/null 2>&1; then
            echo "Status: ✅ Running (PID: $pid)"
        else
            echo "Status: ❌ Not running (stale PID file)"
        fi
    else
        echo "Status: ❌ Not running"
    fi
    
    echo ""
    echo "Configuration:"
    echo "  Instance ID: $INSTANCE_ID"
    echo "  Monitor URL: ${HEARTBEAT_URL:-Not configured}"
    echo "  Interval: ${HEARTBEAT_INTERVAL}s"
    echo ""
    
    # Check crontab
    if command -v crontab &> /dev/null; then
        if crontab -l 2>/dev/null | grep -q "heartbeat.sh"; then
            echo "Cron: ✅ Enabled"
        else
            echo "Cron: ❌ Not enabled"
        fi
    fi
}

# Show help
show_help() {
    echo "💓 Dead Man's Switch - Heartbeat"
    echo ""
    echo "Usage: $0 <action>"
    echo ""
    echo "Actions:"
    echo "  send      - Send single heartbeat"
    echo "  start     - Start continuous heartbeat"
    echo "  stop      - Stop heartbeat service"
    echo "  test      - Test heartbeat"
    echo "  enable    - Enable (add to cron)"
    echo "  disable   - Disable heartbeat"
    echo "  status    - Show status"
    echo "  help      - Show this help"
    echo ""
    echo "Config: $CONFIG_FILE"
    echo ""
    echo "Examples:"
    echo "  $0 send"
    echo "  $0 start"
    echo "  $0 enable"
}

# Main
case "$ACTION" in
    send)    send_heartbeat ;;
    start)   start_heartbeat ;;
    stop)    stop_heartbeat ;;
    test)    test_heartbeat ;;
    enable)  enable_heartbeat ;;
    disable) disable_heartbeat ;;
    status)  show_status ;;
    help|*)  show_help ;;
esac
