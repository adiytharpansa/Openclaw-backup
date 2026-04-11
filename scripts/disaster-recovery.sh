#!/bin/bash
# Deploy OpenClaw to any Ubuntu server in 5 minutes

echo "🚀 OpenClaw Disaster Recovery"
echo "============================"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo)"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
apt update
apt install -y git curl wget nodejs npm systemd cron

# Clone/setup workspace
TARGET_DIR="/mnt/data/openclaw/workspace"
if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Target directory exists, skipping clone"
else
    echo "📁 Creating workspace..."
    mkdir -p "$TARGET_DIR"
    # User should copy backup.tar.gz here manually or via SCP
fi

# Activate
cd "$TARGET_DIR/.openclaw/workspace"
if [ -f "scripts/ACTIVATE.sh" ]; then
    echo "🎯 Running activation..."
    chmod +x scripts/*.sh
    ./scripts/ACTIVATE.sh
    echo "✅ Disaster recovery complete!"
else
    echo "❌ ACTIVATE.sh not found. Manual setup required."
    exit 1
fi
