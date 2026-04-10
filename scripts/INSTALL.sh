#!/bin/bash
# OpenClaw Production Installation Script
# Run this on your production server

set -e

echo "╔════════════════════════════════════════╗"
echo "║   OpenClaw Production Setup            ║"
echo "╚════════════════════════════════════════╝"
echo ""

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
SCRIPTS_DIR="$WORKSPACE/scripts"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    log_error "Please run as root (sudo ./INSTALL.sh)"
    exit 1
fi

# Step 1: Install systemd service
log_info "Step 1/6: Installing systemd service..."
cp $SCRIPTS_DIR/openclaw.service /etc/systemd/system/
systemctl daemon-reload
log_info "✓ Systemd service installed"

# Step 2: Enable auto-start
log_info "Step 2/6: Enabling auto-start..."
systemctl enable openclaw
log_info "✓ Auto-start enabled"

# Step 3: Setup log directory
log_info "Step 3/6: Setting up logging..."
mkdir -p /var/log/openclaw
chown node:node /var/log/openclaw
log_info "✓ Log directory created"

# Step 4: Setup backup directory
log_info "Step 4/6: Setting up backup directory..."
mkdir -p /mnt/backups/openclaw
chown node:node /mnt/backups/openclaw
log_info "✓ Backup directory created"

# Step 5: Setup health check cron
log_info "Step 5/6: Setting up health check..."
chmod +x $SCRIPTS_DIR/health-check.sh
chmod +x $SCRIPTS_DIR/watchdog.sh
chmod +x $SCRIPTS_DIR/auto-backup.sh

# Create crontab for root
(crontab -l 2>/dev/null || echo "") | grep -v "openclaw" > /tmp/cron_temp
echo "" >> /tmp/cron_temp
echo "# OpenClaw Health Check (every 5 min)" >> /tmp/cron_temp
echo "*/5 * * * * $SCRIPTS_DIR/health-check.sh" >> /tmp/cron_temp
echo "" >> /tmp/cron_temp
echo "# OpenClaw Watchdog (every 1 min)" >> /tmp/cron_temp
echo "* * * * * $SCRIPTS_DIR/watchdog.sh" >> /tmp/cron_temp
echo "" >> /tmp/cron_temp
echo "# OpenClaw Auto Backup (daily at 2 AM)" >> /tmp/cron_temp
echo "0 2 * * * $SCRIPTS_DIR/auto-backup.sh" >> /tmp/cron_temp

crontab /tmp/cron_temp
rm /tmp/cron_temp
log_info "✓ Cron jobs installed"

# Step 6: Start service
log_info "Step 6/6: Starting OpenClaw service..."
systemctl start openclaw

# Verify
sleep 5
if systemctl is-active --quiet openclaw; then
    log_info "✓ OpenClaw started successfully!"
else
    log_error "✗ OpenClaw failed to start"
    log_info "Check logs: journalctl -u openclaw -n 50"
    exit 1
fi

echo ""
echo "╔════════════════════════════════════════╗"
echo "║   Installation Complete! ✅            ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "OpenClaw is now:"
echo "  ✓ Auto-starting on boot"
echo "  ✓ Health-checked every 5 minutes"
echo "  ✓ Backed up daily at 2 AM"
echo "  ✓ Monitored by watchdog"
echo ""
echo "Useful commands:"
echo "  systemctl status openclaw     - Check status"
echo "  journalctl -u openclaw -f     - View logs"
echo "  systemctl restart openclaw    - Restart"
echo "  crontab -l                    - View cron jobs"
echo ""
echo "Backup location: /mnt/backups/openclaw/"
echo "Logs: /var/log/openclaw/"
echo ""
