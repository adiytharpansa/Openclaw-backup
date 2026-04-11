#!/bin/bash
# rotate.sh - Infrastructure rotation

ACTION="${1:-help}"
SCRIPT_DIR="$(dirname "$0")"
ROTATION_STATE="/tmp/openclaw-rotation.json"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Get current primary
get_current_primary() {
    cat /tmp/openclaw-primary.txt 2>/dev/null || echo "gensee"
}

# Set new primary
set_primary() {
    local target="$1"
    echo "$target" > /tmp/openclaw-primary.txt
    log "✅ New primary: $target"
}

# Rotate to next infrastructure
rotate() {
    local current=$(get_current_primary)
    
    log "🔄 Rotating infrastructure..."
    log "  Current: $current"
    
    # Simple rotation order
    case "$current" in
        gensee)
            log "  → Rotating to: vps-1"
            set_primary "vps-1"
            ;;
        vps-1)
            log "  → Rotating to: fly-io"
            set_primary "fly-io"
            ;;
        fly-io)
            log "  → Rotating to: lambda"
            set_primary "lambda"
            ;;
        lambda)
            log "  → Rotating to: vps-2"
            set_primary "vps-2"
            ;;
        vps-2)
            log "  → Rotating to: gensee"
            set_primary "gensee"
            ;;
        *)
            log "  → Rotating to: gensee (default)"
            set_primary "gensee"
            ;;
    esac
    
    # Trigger state sync
    log "📦 Syncing state..."
    "$SCRIPT_DIR/../state-sync/sync.sh" push 2>/dev/null || true
    
    log "✅ Rotation complete"
}

# Force rotation
force_rotate() {
    log "🚨 FORCED ROTATION"
    rotate
}

# Start auto-rotation
start_rotation() {
    local interval="${2:-86400}"  # Default 24 hours
    
    log "🚀 Starting auto-rotation (interval: ${interval}s)"
    
    # Add to cron
    if command -v crontab &> /dev/null; then
        (crontab -l 2>/dev/null; echo "0 */24 * * * $SCRIPT_DIR/rotate.sh rotate") | crontab -
        log "✅ Auto-rotation added to cron"
    else
        log "⚠️  crontab not available"
    fi
}

# Stop auto-rotation
stop_rotation() {
    log "🛑 Stopping auto-rotation..."
    
    if command -v crontab &> /dev/null; then
        crontab -l 2>/dev/null | grep -v "rotate.sh" | crontab -
        log "✅ Auto-rotation removed from cron"
    fi
}

# Show status
show_status() {
    echo "🔄 Infrastructure Rotator Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Current Primary: $(get_current_primary)"
    echo ""
    echo "Rotation Order:"
    echo "  gensee → vps-1 → fly-io → lambda → vps-2 → (loop)"
}

# Help
show_help() {
    echo "🔄 Infrastructure Rotator"
    echo ""
    echo "Usage: $0 <action>"
    echo ""
    echo "Actions:"
    echo "  rotate  - Rotate to next infrastructure"
    echo "  force   - Force immediate rotation"
    echo "  start   - Start auto-rotation"
    echo "  stop    - Stop auto-rotation"
    echo "  status  - Show status"
    echo "  help    - Show this help"
}

case "$ACTION" in
    rotate) rotate ;;
    force) force_rotate ;;
    start) start_rotation "$@" ;;
    stop) stop_rotation ;;
    status) show_status ;;
    help|*) show_help ;;
esac
