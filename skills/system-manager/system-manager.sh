#!/bin/bash
# system-manager.sh - Main entry point for system management

ACTION="${1:-help}"
shift

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$ACTION" in
    status)
        "$SCRIPT_DIR/scripts/check-service.sh" "$@"
        ;;
    
    cron)
        "$SCRIPT_DIR/scripts/manage-cron.sh" "$@"
        ;;
    
    create-service)
        "$SCRIPT_DIR/scripts/create-service.sh" "$@"
        ;;
    
    activate)
        echo "🚀 Activating OpenClaw Permanent Setup"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        
        # Check if running as root
        if [ "$EUID" -ne 0 ]; then
            echo "⚠️  Please run as root (sudo)"
            exit 1
        fi
        
        # Check systemctl
        if ! command -v systemctl &> /dev/null; then
            echo "❌ systemctl not available"
            echo "💡 This environment doesn't support systemd"
            exit 1
        fi
        
        # Check crontab
        if ! command -v crontab &> /dev/null; then
            echo "❌ crontab not available"
            echo "💡 Cron is required for scheduled tasks"
            exit 1
        fi
        
        echo "✅ System requirements met!"
        echo ""
        
        # Create service
        echo "📝 Creating systemd service..."
        "$SCRIPT_DIR/scripts/create-service.sh" openclaw "OpenClaw AI Assistant"
        
        # Start service
        echo ""
        echo "🚀 Starting OpenClaw service..."
        systemctl start openclaw
        systemctl status openclaw --no-pager | head -15
        
        # Setup cron jobs
        echo ""
        echo "⏰ Setting up cron jobs..."
        
        CRON_FILE="/tmp/openclaw-cron-$$.txt"
        cat > "$CRON_FILE" << EOF
# OpenClaw Automated Tasks
# Health check every 5 minutes
*/5 * * * * $SCRIPT_DIR/../health-check.sh >> /var/log/openclaw/health.log 2>&1

# Watchdog every 1 minute
* * * * * $SCRIPT_DIR/../watchdog.sh >> /var/log/openclaw/watchdog.log 2>&1

# Daily backup at 2 AM
0 2 * * * $SCRIPT_DIR/../auto-backup.sh >> /var/log/openclaw/backup.log 2>&1

# Weekly optimization on Sunday at 3 AM
0 3 * * 0 $SCRIPT_DIR/../optimize.sh >> /var/log/openclaw/optimize.log 2>&1
EOF
        
        "$SCRIPT_DIR/scripts/manage-cron.sh" validate "$CRON_FILE"
        "$SCRIPT_DIR/scripts/manage-cron.sh" add "$CRON_FILE"
        
        rm -f "$CRON_FILE"
        
        echo ""
        echo "✅ Activation complete!"
        echo ""
        echo "📊 Verify with:"
        echo "  systemctl status openclaw"
        echo "  crontab -l"
        echo "  journalctl -u openclaw -f"
        ;;
    
    help|*)
        echo "🤖 System Manager - OpenClaw"
        echo ""
        echo "Usage: $0 <action> [options]"
        echo ""
        echo "Actions:"
        echo "  status [service]     - Check service status (default: openclaw)"
        echo "  cron <action> [file] - Manage cron jobs (list|backup|add|remove|validate)"
        echo "  create-service       - Create systemd service file"
        echo "  activate             - Full permanent activation (requires root)"
        echo "  help                 - Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 status openclaw"
        echo "  $0 cron list"
        echo "  $0 cron backup"
        echo "  $0 activate"
        ;;
esac
