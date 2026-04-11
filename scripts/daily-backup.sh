#!/bin/bash
WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
BACKUP_DIR="/mnt/backups/openclaw/enhanced/daily"
TIMESTAMP=$(date +%Y%m%d)

# Create full backup
tar -czf "$BACKUP_DIR/daily_$TIMESTAMP.tar.gz" \
    --exclude='node_modules' \
    --exclude='*.log' \
    -C "$WORKSPACE" .

# Create disaster recovery package
cp "$BACKUP_DIR/daily_$TIMESTAMP.tar.gz" \
   "$WORKSPACE/disaster-recovery/latest-backup.tar.gz"

# Keep only last 30 daily backups
ls -t "$BACKUP_DIR"/*.tar.gz | tail -n +31 | xargs -r rm

echo "✅ Daily backup complete: daily_$TIMESTAMP.tar.gz"
