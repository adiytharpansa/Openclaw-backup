#!/bin/bash
# Google Drive Backup Script
# Syncs OpenClaw backups to Google Drive (15GB free)

set -e

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
BACKUP_DIR="$WORKSPACE/backups/enhanced/daily"
GDRIVE_FOLDER="OpenClaw-Backup"

echo "🚀 Google Drive Backup"
echo "====================="

# Check if gog is installed
if ! command -v gog &> /dev/null; then
    echo "❌ gog CLI not found!"
    echo "Install with: sudo apt install gog"
    exit 1
fi

# Check if authenticated
if ! gog drive about &> /dev/null; then
    echo "❌ Not authenticated with Google Drive!"
    echo ""
    echo "Setup instructions:"
    echo "1. Run: gog auth"
    echo "2. Follow browser prompts"
    echo "3. Come back and run this script again"
    exit 1
fi

echo "✅ Authenticated with Google Drive"

# Check if backup exists
LATEST_BACKUP=$(ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | head -1)
if [ -z "$LATEST_BACKUP" ]; then
    echo "❌ No backup found in $BACKUP_DIR"
    exit 1
fi

echo "📦 Found backup: $(basename $LATEST_BACKUP)"

# Create folder if not exists
echo "📁 Checking backup folder..."
if ! gog drive ls | grep -q "$GDRIVE_FOLDER"; then
    echo "Creating folder: $GDRIVE_FOLDER"
    gog drive mkdir "$GDRIVE_FOLDER"
fi

# Upload backup
echo "📤 Uploading to Google Drive..."
gog drive upload \
    --parent="$GDRIVE_FOLDER" \
    --source="$LATEST_BACKUP" \
    --name="$(basename $LATEST_BACKUP)"

echo ""
echo "✅ Google Drive backup complete!"
echo ""
echo "📊 Storage used:"
gog drive about | grep -E "(Used|Total|Free)"
