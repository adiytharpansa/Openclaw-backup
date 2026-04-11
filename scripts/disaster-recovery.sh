#!/bin/bash
# Deploy OpenClaw to any Ubuntu server in 5 minutes

echo "🚀 OpenClaw Disaster Recovery"
echo "============================"

# Check if backup exists
if [ ! -f "$HOME/latest-backup.tar.gz" ] && [ ! -f "/tmp/latest-backup.tar.gz" ]; then
    echo "❌ No backup found. Copy latest-backup.tar.gz to /tmp/ first."
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
apt update
apt install -y git curl wget nodejs npm systemd cron

# Clone/setup workspace
TARGET_DIR="/mnt/data/openclaw/workspace"
mkdir -p "$TARGET_DIR"

# Extract backup
echo "📁 Extracting backup..."
tar -xzf "$HOME/latest-backup.tar.gz" -C "$TARGET_DIR" || \
tar -xzf "/tmp/latest-backup.tar.gz" -C "$TARGET_DIR"

# Activate
cd "$TARGET_DIR/.openclaw/workspace"
if [ -f "scripts/ACTIVATE.sh" ]; then
    echo "🎯 Running activation..."
    chmod +x scripts/*.sh
    bash scripts/ACTIVATE.sh || echo "ACTIVATE.sh requires sudo"
    echo "✅ Disaster recovery complete!"
else
    echo "❌ ACTIVATE.sh not found. Manual setup required."
    exit 1
fi
