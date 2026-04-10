#!/bin/bash
# Automation Templates
# Copy and customize these for your workflows

# === Template 1: Auto-summarize links from message ===
# Usage: Put links in $LINKS and run
# Summarizes all links using the summarize skill
auto-summarize-links() {
    local LINKS="$1"
    for link in $LINKS; do
        echo "📋 Summarizing: $link"
        # Uses: summarize CLI or web_fetch
        summarize "$link" 2>/dev/null || echo "Skipped (tool not available)"
    done
}

# === Template 2: Daily cleanup ===
# Removes old temp files, logs, etc.
daily-cleanup() {
    local MAX_AGE_DAYS="${1:-7}"
    echo "🧹 Daily cleanup (files older than $MAX_AGE_DAYS days)"
    find . -type f -mtime +"$MAX_AGE_DAYS" -name "*.tmp" -delete 2>/dev/null
    find . -type f -mtime +"$MAX_AGE_DAYS" -name "*.log" -delete 2>/dev/null
    echo "✅ Cleanup complete"
}

# === Template 3: Backup important files ===
backup-important() {
    local BACKUP_DIR="${1:-./backups}"
    echo "💾 Creating backup to $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    cp -r memory/ "$BACKUP_DIR/" 2>/dev/null
    cp *.md "$BACKUP_DIR/" 2>/dev/null
    echo "✅ Backup complete"
}

# === Template 4: Sync memory to long-term ===
# Reviews daily logs and updates MEMORY.md
sync-memory() {
    echo "🔄 Syncing daily logs to MEMORY.md"
    # Review memory/YYYY-MM-DD.md files
    # Update MEMORY.md with important learnings
    echo "✅ Memory sync complete"
}

# === Template 5: Check project health ===
project-health() {
    echo "🏥 Project Health Check"
    echo "========================"
    
    # Git status
    echo "Git Status:"
    git status --short 2>/dev/null | head -10 || echo "Not a git repo"
    
    # Pending tasks (if anything configured)
    echo ""
    echo "Pending tasks: Check YOUR project management tool"
    
    # Recent commits
    echo ""
    echo "Recent commits:"
    git log --oneline -5 2>/dev/null || echo "N/A"
    
    echo "✅ Health check complete"
}

echo "Automation templates loaded. Functions available:"
echo "  - auto-summarize-links"
echo "  - daily-cleanup"
echo "  - backup-important"
echo "  - sync-memory"
echo "  - project-health"
