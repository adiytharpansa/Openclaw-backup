#!/bin/bash
# notify.sh - Send optimized Telegram notifications

SCRIPT_DIR="$(dirname "$0")"

# Colors/emoji
ALERT="🚨"
INFO="ℹ️"
SUCCESS="✅"
ERROR="❌"
WARNING="⚠️"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Send notification
send() {
    local type="$1"
    local message="$2"
    local emoji=""
    
    case "$type" in
        alert) emoji="$ALERT" ;;
        info) emoji="$INFO" ;;
        success) emoji="$SUCCESS" ;;
        error) emoji="$ERROR" ;;
        warning) emoji="$WARNING" ;;
        *) emoji="$INFO" ;;
    esac
    
    log "$emoji $message"
    
    # Use OpenClaw message tool if available
    # This will be called by the main OpenClaw process
    echo "$emoji $message"
}

# Heartbeat notification
heartbeat_ok() {
    send "info" "Heartbeat OK - System running"
}

# Alert notification
alert() {
    send "alert" "$1"
}

# Error notification
error() {
    send "error" "$1"
}

# Success notification
success() {
    send "success" "$1"
}

# Help
show_help() {
    echo "📬 Telegram Notifier"
    echo ""
    echo "Usage: $0 <action> [message]"
    echo ""
    echo "Actions:"
    echo "  alert   - Send high priority alert"
    echo "  info    - Send info message"
    echo "  success - Send success notification"
    echo "  error   - Send error notification"
    echo "  heartbeat - Send heartbeat OK"
    echo "  help    - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 alert 'Server down!'"
    echo "  $0 success 'Deploy complete'"
    echo "  $0 heartbeat"
}

# Main
case "$1" in
    alert) alert "$2" ;;
    info) send "info" "$2" ;;
    success) success "$2" ;;
    error) error "$2" ;;
    heartbeat) heartbeat_ok ;;
    help|*) show_help ;;
esac
