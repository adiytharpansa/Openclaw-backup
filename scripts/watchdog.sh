#!/bin/bash
# OpenClaw Watchdog Script
# Monitors restart frequency and prevents restart loops

set -e

LOG_FILE="/var/log/openclaw-watchdog.log"
RESTART_LOG="/var/log/openclaw-restarts.log"
MAX_RESTARTS=5
RESTART_WINDOW=300  # 5 minutes in seconds

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> $LOG_FILE
}

# Count restarts in the window
count_recent_restarts() {
    current_time=$(date +%s)
    window_start=$((current_time - RESTART_WINDOW))
    
    if [ ! -f $RESTART_LOG ]; then
        echo 0
        return
    fi
    
    count=0
    while read -r timestamp; do
        if [ $timestamp -ge $window_start ]; then
            count=$((count + 1))
        fi
    done < $RESTART_LOG
    
    echo $count
}

# Log a restart event
log_restart() {
    echo $(date +%s) >> $RESTART_LOG
    
    # Keep restart log manageable (last 100 entries)
    if [ $(wc -l < $RESTART_LOG) -gt 100 ]; then
        tail -100 $RESTART_LOG > $RESTART_LOG.tmp
        mv $RESTART_LOG.tmp $RESTART_LOG
    fi
}

# Main watchdog loop
main() {
    log "Watchdog starting..."
    
    recent=$(count_recent_restarts)
    log "Recent restarts in window: $recent / $MAX_RESTARTS"
    
    if [ $recent -ge $MAX_RESTARTS ]; then
        log "⚠️  ALERT: Too many restarts! Manual intervention needed."
        log "Service will NOT be auto-restarted."
        
        # Send alert (customize for your notification system)
        # curl -X POST "https://your-alert-service.com/webhook" \
        #   -d "message=OpenClaw restart loop detected"
        
        echo "CRITICAL - Restart loop detected, manual intervention required"
        exit 1
    fi
    
    # Check if service needs restart
    if ! systemctl is-active --quiet openclaw; then
        log "Service is down, attempting restart..."
        
        systemctl start openclaw
        
        if systemctl is-active --quiet openclaw; then
            log "✓ Service restarted successfully"
            log_restart
            echo "OK - OpenClaw restarted"
            exit 0
        else
            log "✗ Service failed to restart"
            echo "CRITICAL - OpenClaw failed to restart"
            exit 1
        fi
    else
        log "✓ Service is running normally"
        echo "OK - OpenClaw is healthy"
        exit 0
    fi
}

main "$@"
