#!/bin/bash
# deploy-oracle.sh - Deploy OpenClaw to Oracle Cloud Always Free VPS

# Configuration
ORACLE_USER="${ORACLE_USER:-ubuntu}"
ORACLE_IP="${ORACLE_IP:-}"
SSH_KEY="${SSH_KEY:-~/.ssh/id_rsa}"
REPO_URL="https://github.com/adiytharpansa/Openclaw-backup.git"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Check if IP is provided
if [ -z "$ORACLE_IP" ]; then
    echo "📋 Oracle Cloud Deployment Script"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "This script deploys OpenClaw to Oracle Cloud Always Free VPS"
    echo ""
    echo "Usage:"
    echo "  export ORACLE_IP='your-vps-ip'"
    echo "  export ORACLE_USER='ubuntu'  # optional"
    echo "  ./scripts/deploy-oracle.sh"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    read -p "Enter your Oracle VPS IP: " ORACLE_IP
    export ORACLE_IP
fi

log "🚀 Starting Oracle Cloud Deployment..."
log "Target: $ORACLE_USER@$ORACLE_IP"

# Test SSH connection
log "🔑 Testing SSH connection..."
ssh -o StrictHostKeyChecking=no -o ConnectTimeout=10 "$ORACLE_USER@$ORACLE_IP" "echo 'SSH OK'" > /dev/null 2>&1

if [ $? -ne 0 ]; then
    log "❌ SSH connection failed!"
    log "💡 Make sure:"
    log "   1. VPS is running"
    log "   2. SSH key is added to Oracle Cloud"
    log "   3. Port 22 is open in security list"
    exit 1
fi

log "✅ SSH connection successful"

# Deploy OpenClaw
log "📦 Deploying OpenClaw..."

ssh "$ORACLE_USER@$ORACLE_IP" << 'ENDSSH'
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install git
sudo apt-get install -y git

# Clone repo
cd /home/ubuntu
git clone https://github.com/adiytharpansa/Openclaw-backup.git
cd Openclaw-backup

# Install dependencies
npm install

# Copy config
cp .free.env .env

# Create systemd service
sudo bash -c 'cat > /etc/systemd/system/openclaw.service << EOF
[Unit]
Description=OpenClaw AI Assistant
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/Openclaw-backup
ExecStart=/usr/bin/node .
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF'

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable openclaw
sudo systemctl start openclaw

# Check status
sudo systemctl status openclaw --no-pager

log "✅ OpenClaw deployed!"
ENDSSH

log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log "✅ Deployment Complete!"
log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log ""
log "Service Status:"
log "  sudo systemctl status openclaw"
log ""
log "Logs:"
log "  sudo journalctl -u openclaw -f"
log ""
log "Restart:"
log "  sudo systemctl restart openclaw"
log ""
