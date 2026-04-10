#!/bin/bash
# =============================================================================
# OPENCLAW KEEP-ALIVE SCRIPT
# =============================================================================
# Keeps OpenClaw running even if session disconnects
# Run this in background before you leave
# =============================================================================

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
LOG_FILE="$WORKSPACE/.local/logs/keepalive.log"
PID_FILE="$WORKSPACE/.local/openclaw.pid"

cd "$WORKSPACE"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "🚀 OpenClaw Keep-Alive Started"

# Function to check and restart OpenClaw
check_and_restart() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p $PID > /dev/null; then
            log "✅ OpenClaw running (PID: $PID)"
            return 0
        else
            log "⚠️  Process dead, restarting..."
            rm "$PID_FILE"
        fi
    else
        log "⚠️  No PID file, starting..."
    fi
    
    # Start OpenClaw
    ./bin/clawd start >> "$LOG_FILE" 2>&1
    sleep 2
    
    if [ -f "$PID_FILE" ]; then
        log "✅ OpenClaw restarted successfully"
    else
        log "❌ Failed to start OpenClaw"
    fi
}

# Main loop - check every 30 seconds
while true; do
    check_and_restart
    sleep 30
done
