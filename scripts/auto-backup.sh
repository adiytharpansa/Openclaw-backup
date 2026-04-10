#!/bin/bash
# OpenClaw Automated Backup Script
# Run daily via cron

set -e

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
BACKUP_DIR="/mnt/backups/openclaw"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Create backup directory
mkdir -p $BACKUP_DIR

log "Starting backup..."
log "Workspace: $WORKSPACE"
log "Backup location: $BACKUP_DIR"

# Create backup filename
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.tar.gz"

# Create compressed backup
# Exclude large/unnecessary directories
tar -czf $BACKUP_FILE \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='backups' \
    --exclude='*.log' \
    --exclude='tmp' \
    --exclude='cache' \
    -C $(dirname $WORKSPACE) \
    $(basename $WORKSPACE)

# Check backup was created
if [ -f $BACKUP_FILE ]; then
    BACKUP_SIZE=$(du -h $BACKUP_FILE | cut -f1)
    log "✓ Backup created: $BACKUP_FILE ($BACKUP_SIZE)"
else
    log "✗ Backup failed!"
    exit 1
fi

# Cleanup old backups
log "Cleaning up backups older than $RETENTION_DAYS days..."
OLD_BACKUPS=$(find $BACKUP_DIR -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -type f)

if [ ! -z "$OLD_BACKUPS" ]; then
    echo "$OLD_BACKUPS" | xargs rm -f
    log "✓ Old backups removed"
else
    log "✓ No old backups to remove"
fi

# List current backups
log "Current backups:"
ls -lht $BACKUP_DIR/backup_*.tar.gz | head -10

log "✓ Backup completed successfully"

# Optional: Upload to cloud storage
# Uncomment if using S3, GCS, etc.
# aws s3 cp $BACKUP_FILE s3://your-bucket/openclaw-backups/
# log "✓ Backup uploaded to cloud"

exit 0
