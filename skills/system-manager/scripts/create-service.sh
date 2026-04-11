#!/bin/bash
# create-service.sh - Create systemd service file

SERVICE_NAME="${1:-openclaw}"
SERVICE_DESC="${2:-OpenClaw AI Assistant}"
WORK_DIR="${3:-/mnt/data/openclaw/workspace/.openclaw/workspace}"
EXEC_START="${4:-/usr/bin/node /app/packages/cli/dist/index.js}"
USER_NAME="${5:-node}"

SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"

echo "🔧 Creating systemd service: $SERVICE_NAME"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "⚠️  Please run as root (sudo)"
    exit 1
fi

# Check if systemctl is available
if ! command -v systemctl &> /dev/null; then
    echo "❌ systemctl not available (sandbox environment)"
    echo "💡 This script should be run on a server with systemd"
    exit 1
fi

# Create service file
cat > "$SERVICE_FILE" << EOF
[Unit]
Description=$SERVICE_DESC
After=network.target

[Service]
Type=simple
User=$USER_NAME
WorkingDirectory=$WORK_DIR
ExecStart=$EXEC_START
Restart=on-failure
RestartSec=5
Environment=NODE_ENV=production

# Security hardening
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=$WORK_DIR

[Install]
WantedBy=multi-user.target
EOF

echo "✅ Service file created: $SERVICE_FILE"

# Reload systemd
echo "🔄 Reloading systemd daemon..."
systemctl daemon-reload

# Enable service
echo "⚡ Enabling service (auto-start on boot)..."
systemctl enable "$SERVICE_NAME"

echo ""
echo "✅ Service created successfully!"
echo ""
echo "📋 Next steps:"
echo "  sudo systemctl start $SERVICE_NAME"
echo "  sudo systemctl status $SERVICE_NAME"
echo "  sudo journalctl -u $SERVICE_NAME -f"
