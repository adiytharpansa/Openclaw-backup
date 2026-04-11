#!/bin/bash
# manage-cron.sh - Manage cron jobs safely

ACTION="${1:-list}"
CRON_FILE="${2:-}"

BACKUP_DIR="/tmp/cron-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p "$BACKUP_DIR"

case "$ACTION" in
    list)
        echo "📋 Current Cron Jobs:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        if command -v crontab &> /dev/null; then
            crontab -l 2>&1 || echo "No cron jobs configured"
        else
            echo "❌ crontab not available (sandbox environment)"
        fi
        ;;
    
    backup)
        echo "💾 Backing up current crontab..."
        if command -v crontab &> /dev/null; then
            crontab -l > "$BACKUP_DIR/crontab-backup-$TIMESTAMP.txt" 2>&1
            echo "✅ Backup saved to: $BACKUP_DIR/crontab-backup-$TIMESTAMP.txt"
        else
            echo "❌ crontab not available"
        fi
        ;;
    
    add)
        if [ -z "$CRON_FILE" ]; then
            echo "❌ Usage: $0 add <cron-file>"
            exit 1
        fi
        if [ ! -f "$CRON_FILE" ]; then
            echo "❌ File not found: $CRON_FILE"
            exit 1
        fi
        echo "📝 Adding cron jobs from: $CRON_FILE"
        # Backup first
        crontab -l > "$BACKUP_DIR/crontab-before-add-$TIMESTAMP.txt" 2>&1
        # Install new crontab
        crontab "$CRON_FILE"
        echo "✅ Cron jobs installed"
        ;;
    
    remove)
        echo "⚠️  Removing ALL cron jobs..."
        crontab -r 2>&1
        echo "✅ All cron jobs removed"
        ;;
    
    validate)
        if [ -z "$CRON_FILE" ]; then
            echo "❌ Usage: $0 validate <cron-file>"
            exit 1
        fi
        echo "🔍 Validating cron file: $CRON_FILE"
        # Basic validation - check for 5 fields + command
        while IFS= read -r line; do
            # Skip comments and empty lines
            [[ "$line" =~ ^#.*$ ]] && continue
            [[ -z "$line" ]] && continue
            
            # Check if line has at least 6 fields (5 time fields + command)
            FIELD_COUNT=$(echo "$line" | awk '{print NF}')
            if [ "$FIELD_COUNT" -lt 6 ]; then
                echo "❌ Invalid cron line: $line"
                exit 1
            fi
        done < "$CRON_FILE"
        echo "✅ Cron file is valid"
        ;;
    
    *)
        echo "Usage: $0 {list|backup|add|remove|validate} [cron-file]"
        echo ""
        echo "Actions:"
        echo "  list      - List current cron jobs"
        echo "  backup    - Backup current crontab"
        echo "  add       - Add cron jobs from file"
        echo "  remove    - Remove all cron jobs"
        echo "  validate  - Validate cron file syntax"
        exit 1
        ;;
esac
