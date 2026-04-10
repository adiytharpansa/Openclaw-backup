#!/bin/bash
# OpenClaw Uninstall Script
# Removes all OpenClaw services and configs

set -e

echo "╔════════════════════════════════════════╗"
echo "║   OpenClaw Uninstall                   ║"
echo "╚════════════════════════════════════════╝"
echo ""

RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (sudo ./UNINSTALL.sh)"
    exit 1
fi

echo "This will remove:"
echo "  - Systemd service"
echo "  - Cron jobs"
echo "  - Log files"
echo "  - Backup files"
echo ""
echo -n "Are you sure? (yes/no): "
read confirm

if [ "$confirm" != "yes" ]; then
    echo "Uninstall cancelled"
    exit 0
fi

# Stop service
log_warn "Stopping OpenClaw service..."
systemctl stop openclaw || true
systemctl disable openclaw || true

# Remove systemd service
log_warn "Removing systemd service..."
rm -f /etc/systemd/system/openclaw.service
systemctl daemon-reload

# Remove cron jobs
log_warn "Removing cron jobs..."
(crontab -l 2>/dev/null || echo "") | grep -v "openclaw" | crontab -

# Remove logs
log_warn "Removing log files..."
rm -rf /var/log/openclaw

# Remove backups (optional - comment out to keep)
log_warn "Removing backup files..."
rm -rf /mnt/backups/openclaw

echo ""
echo "✓ OpenClaw uninstalled successfully"
echo ""
echo "Note: Workspace files preserved at:"
echo "  /mnt/data/openclaw/workspace/.openclaw/workspace"
echo ""
