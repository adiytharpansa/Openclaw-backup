#!/bin/bash
WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
BACKUP_DIR="$WORKSPACE/backups/enhanced/hourly"
TIMESTAMP=$(date +%Y%m%d_%H%M)

# Git commit
cd "$WORKSPACE"
git add -A
git commit -m "Hourly backup $TIMESTAMP" || echo "No changes"

# Create compressed backup
tar -czf "$BACKUP_DIR/backup_$TIMESTAMP.tar.gz" \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='*.log' \
    --exclude='backups/' \
    -C "$WORKSPACE" .

# Keep only last 24 hourly backups
ls -t "$BACKUP_DIR"/*.tar.gz 2>/dev/null | tail -n +25 | xargs -r rm

echo "✅ Hourly backup complete: backup_$TIMESTAMP.tar.gz"
