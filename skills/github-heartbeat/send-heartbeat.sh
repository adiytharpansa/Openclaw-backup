#!/bin/bash
# send-heartbeat.sh - Send heartbeat to GitHub

SCRIPT_DIR="$(dirname "$0")"
WORKSPACE_DIR="$SCRIPT_DIR/../../"
HEARTBEAT_FILE="$WORKSPACE_DIR/.heartbeat"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Send heartbeat
send_heartbeat() {
    log "💓 Sending heartbeat..."
    
    # Update local heartbeat file
    date +%s > "$HEARTBEAT_FILE"
    
    # Commit and push to GitHub
    cd "$WORKSPACE_DIR"
    
    git config --local user.email "openclaw@local"
    git config --local user.name "OpenClaw Heartbeat"
    
    git add .heartbeat
    git commit -m "💓 Heartbeat $(date '+%Y-%m-%d %H:%M:%S')" || true
    git push || true
    
    log "✅ Heartbeat sent"
}

# Check status
check_status() {
    if [ -f "$HEARTBEAT_FILE" ]; then
        LAST_BEAT=$(cat "$HEARTBEAT_FILE")
        CURRENT=$(date +%s)
        DIFF=$((CURRENT - LAST_BEAT))
        
        echo "Last heartbeat: $((DIFF))s ago"
        
        if [ "$DIFF" -gt 1800 ]; then
            echo "Status: ❌ No heartbeat for >30 min"
        else
            echo "Status: ✅ Alive"
        fi
    else
        echo "Status: ⚠️  No heartbeat file"
    fi
}

# Enable auto-heartbeat (every 5 min)
enable() {
    log "🚀 Enabling auto-heartbeat (every 5 min)..."
    
    if command -v crontab &> /dev/null; then
        # Remove old entries
        crontab -l 2>/dev/null | grep -v "send-heartbeat.sh" | crontab -
        
        # Add new entry
        (crontab -l 2>/dev/null; echo "*/5 * * * * $SCRIPT_DIR/send-heartbeat.sh >> /tmp/heartbeat.log 2>&1") | crontab -
        
        log "✅ Auto-heartbeat enabled"
    else
        log "⚠️  crontab not available"
        log "💡 Run manually: $SCRIPT_DIR/send-heartbeat.sh"
    fi
}

# Disable auto-heartbeat
disable() {
    log "🛑 Disabling auto-heartbeat..."
    
    if command -v crontab &> /dev/null; then
        crontab -l 2>/dev/null | grep -v "send-heartbeat.sh" | crontab -
        log "✅ Auto-heartbeat disabled"
    fi
}

# Help
show_help() {
    echo "💓 GitHub Heartbeat"
    echo ""
    echo "Usage: $0 <action>"
    echo ""
    echo "Actions:"
    echo "  send     - Send heartbeat now"
    echo "  enable   - Enable auto-heartbeat (every 5 min)"
    echo "  disable  - Disable auto-heartbeat"
    echo "  status   - Check heartbeat status"
    echo "  help     - Show this help"
}

# Main
case "$1" in
    send) send_heartbeat ;;
    enable) enable ;;
    disable) disable ;;
    status) check_status ;;
    help|*) show_help ;;
esac
