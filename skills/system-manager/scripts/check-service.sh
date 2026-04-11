#!/bin/bash
# check-service.sh - Check systemd service status

SERVICE_NAME="${1:-openclaw}"

echo "🔍 Checking service: $SERVICE_NAME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if systemctl is available
if ! command -v systemctl &> /dev/null; then
    echo "❌ systemctl not available (sandbox environment)"
    echo "💡 Deploy to a server with systemd support"
    exit 1
fi

# Check service status
echo "📊 Status:"
systemctl status "$SERVICE_NAME" --no-pager 2>&1 | head -20

echo ""
echo "📈 Service Info:"
echo "  Active: $(systemctl is-active $SERVICE_NAME 2>&1)"
echo "  Enabled: $(systemctl is-enabled $SERVICE_NAME 2>&1)"

echo ""
echo "📋 Recent Logs (last 10 lines):"
journalctl -u "$SERVICE_NAME" -n 10 --no-pager 2>&1
