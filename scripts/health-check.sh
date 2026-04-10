#!/bin/bash
# OpenClaw Health Check Script
# Run every 5 minutes via cron

set -e

SERVICE_NAME="openclaw"
LOG_FILE="/var/log/openclaw-health.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

log() {
    echo "[$TIMESTAMP] $1" >> $LOG_FILE
}

# Check if systemd service is active
check_service() {
    if systemctl is-active --quiet $SERVICE_NAME; then
        return 0
    else
        return 1
    fi
}

# Check if process is responding
check_responding() {
    # Try to ping the service (adjust port as needed)
    if curl -sf http://localhost:8080/health > /dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Main health check
main() {
    log "Starting health check..."
    
    if check_service; then
        log "✓ Service is running"
        
        if check_responding; then
            log "✓ Service is responding"
            echo "OK - OpenClaw is healthy"
            exit 0
        else
            log "⚠ Service running but not responding"
            log "Attempting restart..."
            
            sudo systemctl restart $SERVICE_NAME
            
            sleep 10
            
            if check_responding; then
                log "✓ Restart successful"
                echo "OK - OpenClaw restarted successfully"
                exit 0
            else
                log "✗ Restart failed"
                echo "CRITICAL - OpenClaw not responding after restart"
                exit 1
            fi
        fi
    else
        log "✗ Service is not running"
        log "Attempting to start..."
        
        sudo systemctl start $SERVICE_NAME
        
        sleep 10
        
        if check_service && check_responding; then
            log "✓ Start successful"
            echo "OK - OpenClaw started successfully"
            exit 0
        else
            log "✗ Start failed"
            echo "CRITICAL - OpenClaw failed to start"
            exit 1
        fi
    fi
}

main "$@"
