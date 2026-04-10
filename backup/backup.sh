#!/bin/bash
# Automated Backup System
# Backup workspace to local and cloud storage

set -e

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
BACKUP_DIR="$WORKSPACE/backups"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30
RETENTION_COUNT=10

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║        AUTOMATED BACKUP SYSTEM         ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create temp backup folder
TEMP_BACKUP="$BACKUP_DIR/temp_$DATE"
mkdir -p "$TEMP_BACKUP"

echo -e "${YELLOW}📦 Backing up directories...${NC}"

# Backup critical directories
cp -r "$WORKSPACE/memory/" "$TEMP_BACKUP/" 2>/dev/null && echo "  ✅ memory/"
cp -r "$WORKSPACE/knowledge/" "$TEMP_BACKUP/" 2>/dev/null && echo "  ✅ knowledge/"
cp -r "$WORKSPACE/config/" "$TEMP_BACKUP/" 2>/dev/null && echo "  ✅ config/"
cp -r "$WORKSPACE/templates/" "$TEMP_BACKUP/" 2>/dev/null && echo "  ✅ templates/"
cp -r "$WORKSPACE/scripts/" "$TEMP_BACKUP/" 2>/dev/null && echo "  ✅ scripts/"
cp -r "$WORKSPACE/cli/" "$TEMP_BACKUP/" 2>/dev/null && echo "  ✅ cli/"

# Backup root files
cp "$WORKSPACE"/*.md "$TEMP_BACKUP/" 2>/dev/null && echo "  ✅ *.md files"

# Create compressed archive
echo ""
echo -e "${YELLOW}🗜️  Creating compressed archive...${NC}"
cd "$BACKUP_DIR"
tar -czf "backup_$DATE.tar.gz" "temp_$DATE" 2>/dev/null
rm -rf "temp_$DATE"

ARCHIVE_SIZE=$(du -h "backup_$DATE.tar.gz" | cut -f1)
echo -e "${GREEN}✅ Backup created: backup_$DATE.tar.gz ($ARCHIVE_SIZE)${NC}"

# Cleanup old backups
echo ""
echo -e "${YELLOW}🧹 Cleaning old backups...${NC}"

# Keep only last N backups
cd "$BACKUP_DIR"
BACKUP_COUNT=$(ls -1 backup_*.tar.gz 2>/dev/null | wc -l)
if [ "$BACKUP_COUNT" -gt "$RETENTION_COUNT" ]; then
    REMOVE_COUNT=$((BACKUP_COUNT - RETENTION_COUNT))
    ls -t backup_*.tar.gz | tail -n "$REMOVE_COUNT" | xargs rm -f
    echo -e "${GREEN}✅ Removed $REMOVE_COUNT old backup(s)${NC}"
else
    echo "  ℹ️  No old backups to remove"
fi

# Remove backups older than RETENTION_DAYS
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete 2>/dev/null
echo -e "${GREEN}✅ Removed backups older than $RETENTION_DAYS days${NC}"

# Optional: Upload to cloud (commented out - configure as needed)
# echo ""
# echo -e "${YELLOW}☁️  Uploading to cloud storage...${NC}"
# aws s3 cp "backup_$DATE.tar.gz" "s3://your-bucket/backups/" 2>/dev/null && echo "  ✅ Uploaded to S3"
# rclone copy "backup_$DATE.tar.gz" "remote:backups/" 2>/dev/null && echo "  ✅ Uploaded via rclone"

# Generate backup manifest
echo ""
echo -e "${YELLOW}📋 Generating backup manifest...${NC}"
cat > "$BACKUP_DIR/manifest.json" << EOF
{
  "lastBackup": "$(date -Iseconds)",
  "backupFile": "backup_$DATE.tar.gz",
  "size": "$ARCHIVE_SIZE",
  "retention": {
    "count": $RETENTION_COUNT,
    "days": $RETENTION_DAYS
  },
  "contents": [
    "memory/",
    "knowledge/",
    "config/",
    "templates/",
    "scripts/",
    "cli/",
    "*.md files"
  ]
}
EOF
echo -e "${GREEN}✅ Manifest updated${NC}"

# Summary
echo ""
echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║            BACKUP COMPLETE             ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Location:${NC} $BACKUP_DIR/backup_$DATE.tar.gz"
echo -e "${GREEN}Size:${NC} $ARCHIVE_SIZE"
echo -e "${GREEN}Retention:${NC} $RETENTION_COUNT backups / $RETENTION_DAYS days"
echo ""

# List recent backups
echo -e "${YELLOW}Recent backups:${NC}"
ls -lht "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | head -5
