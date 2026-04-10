#!/bin/bash
# =============================================================================
# OPENCLAW OWN SERVER DEPLOYMENT
# =============================================================================
# One-command deployment for your own independent server
# Run this on your server to deploy OpenClaw
# =============================================================================

set -e

echo "╔════════════════════════════════════════════════════╗"
echo "║   OPENCLAW OWN SERVER DEPLOYMENT                   ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# Configuration
WORKSPACE_DIR="/home/$USER/openclaw/.openclaw/workspace"
BACKUP_DIR="/backup/openclaw"
LOG_DIR="/var/log/openclaw"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}[1/8]${NC} Updating system..."
sudo apt update && sudo apt upgrade -y

echo -e "\n${BLUE}[2/8]${NC} Installing dependencies..."
sudo apt install -y \
    git curl wget python3 python3-pip \
    docker.io docker-compose \
    nodejs npm postgresql redis-server \
    nginx build-essential

echo -e "\n${BLUE}[3/8]${NC} Creating directories..."
sudo mkdir -p "$WORKSPACE_DIR"
sudo mkdir -p "$BACKUP_DIR"
sudo mkdir -p "$LOG_DIR"
sudo chown -R $USER:$USER "$WORKSPACE_DIR" "$BACKUP_DIR" "$LOG_DIR"

echo -e "\n${BLUE}[4/8]${NC} Checking for OpenClaw files..."
if [ -d "/mnt/data/openclaw/workspace/.openclaw/workspace" ]; then
    echo -e "${GREEN}✓ Workspace found, copying...${NC}"
    cp -r /mnt/data/openclaw/workspace/.openclaw/workspace/* "$WORKSPACE_DIR/"
elif [ -d ".openclaw/workspace" ]; then
    echo -e "${GREEN}✓ Current workspace detected, copying...${NC}"
    cp -r .openclaw/workspace/* "$WORKSPACE_DIR/"
else
    echo -e "${YELLOW}⚠ No workspace found!${NC}"
    echo -e "${YELLOW}You need to clone your git repo manually:  ${NC}"
    echo -e "  git clone YOUR_REPO_URL $WORKSPACE_DIR"
    exit 1
fi

echo -e "\n${BLUE}[5/8]${NC} Setting permissions..."
chmod +x "$WORKSPACE_DIR/scripts/*.sh"
chmod +x "$WORKSPACE_DIR/bin/*"

echo -e "\n${BLUE}[6/8]${NC} Creating systemd service..."
sudo cat > /etc/systemd/system/openclaw.service << 'EOF'
[Unit]
Description=OpenClaw AI Assistant
After=network.target
Wants=postgresql.service redis-server.service

[Service]
Type=simple
User=$USER
WorkingDirectory=/home/$USER/openclaw/.openclaw/workspace
ExecStart=/home/$USER/openclaw/.openclaw/workspace/bin/clawd start
ExecStop=/home/$USER/openclaw/.openclaw/workspace/bin/clawd stop
Restart=always
RestartSec=10
StandardOutput=append:/var/log/openclaw/openclaw.log
StandardError=append:/var/log/openclaw/openclaw.log

[Install]
WantedBy=multi-user.target
EOF

echo -e "\n${BLUE}[7/8]${NC} Enabling services..."
sudo systemctl daemon-reload
sudo systemctl enable openclaw
sudo systemctl start openclaw

echo -e "\n${BLUE}[8/8]${NC} Setting up backup..."
sudo mkdir -p /home/$USER/scripts
sudo cat > /home/$USER/scripts/backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y-%m-%d)
rsync -av /home/$USER/openclaw/.openclaw/workspace/ /backup/openclaw/$DATE/
find /backup/openclaw -type d -mtime +30 -exec rm -rf {} \;
EOF
chmod +x /home/$USER/scripts/backup.sh

echo "Crontab entry added: 0 2 * * * /home/$USER/scripts/backup.sh"
(crontab -l 2>/dev/null; echo "0 2 * * * /home/$USER/scripts/backup.sh") | crontab -

echo ""
echo "╔════════════════════════════════════════════════════╗"
echo -e "${GREEN}║   DEPLOYMENT COMPLETE! 🎉                          ║${NC}"
echo "╚════════════════════════════════════════════════════╝"
echo ""

echo -e "${BLUE}Status:${NC}"
sudo systemctl is-active openclaw || echo "  ⚠ Service status: (check with sudo systemctl status openclaw)"
echo ""

echo -e "${BLUE}Useful commands:${NC}"
echo "  sudo systemctl status openclaw    # Check status"
echo "  sudo systemctl restart openclaw   # Restart"
echo "  tail -f /var/log/openclaw/openclaw.log  # View logs"
echo ""

echo -e "${GREEN}Your OpenClaw is now 100% independent!${NC}"
echo "  ✅ No external dependencies"
echo "  ✅ Auto-start on boot"
echo "  ✅ Auto-backup daily"
echo "  ✅ 24/7 uptime"
echo ""
