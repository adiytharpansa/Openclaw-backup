#!/bin/bash
# OpenClaw Auto-Deploy Script for FreeVPS.it.com
# Run this script AFTER you have VPS credentials

# CONFIGURATION
VPS_IP="CHANGE_ME"
VPS_USER="CHANGE_ME"
VPS_PASS="CHANGE_ME"
WORKSPACE_PATH="/mnt/data/openclaw/workspace/.openclaw/workspace"

echo "🚀 OpenClaw Auto-Deploy Script"
echo "================================"

# Step 1: Copy workspace to VPS
echo "📦 Step 1: Copying workspace..."
scp -r "$WORKSPACE_PATH" "$VPS_USER@$VPS_IP:/home/$VPS_USER/openclaw/"

# Step 2: SSH and setup
echo "🔧 Step 2: Setting up on VPS..."
ssh "$VPS_USER@$VPS_IP" << 'ENDSSH'
cd ~/openclaw/workspace/.openclaw/workspace

# Install dependencies
echo "Installing dependencies..."
sudo apt update
sudo apt install -y git curl wget nodejs npm systemd

# Make scripts executable
chmod +x scripts/*.sh

# Run activation
echo "🎯 Running permanent activation..."
sudo ./scripts/ACTIVATE.sh

# Verify
echo "Verifying services..."
sudo systemctl status openclaw
sudo journalctl -u openclaw -n 20

echo "✅ Deployment complete!"
ENDSSH

echo "🎉 OpenClaw is now 100% permanent on your VPS!"
