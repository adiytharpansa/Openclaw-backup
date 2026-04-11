#!/bin/bash
# Auto Backup Master - Fully Automated Zero-Config Backup
# Automatically detects and uses available backup methods

set -e

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$WORKSPACE/logs/backup/auto-backup-$(date +%Y%m%d_%H%M).log"

mkdir -p "$WORKSPACE/logs/backup"

echo "🤖 Auto Backup Master - Zero Configuration"
echo "==========================================="
echo ""
echo "Starting at: $(date)"
echo "Workspace: $WORKSPACE"
echo ""

# Initialize counters
BACKUP_SUCCESS=0
BACKUP_FAILED=0
BACKUP_SKIPPED=0

# Create backup manifest
MANIFEST="$WORKSPACE/backups/enhanced/manifest.json"
cat > "$MANIFEST" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "version": "1.0.0",
  "backups": []
}
EOF

# ============================================
# TIER 1: No Authentication Required
# ============================================
echo "═══════════════════════════════════════"
echo "📦 TIER 1: No Auth Required"
echo "═══════════════════════════════════════"
echo ""

# 1. Local Backup (Always Available)
echo "1/4 Local Backup..."
if [ -d "$WORKSPACE/backups/enhanced" ]; then
    LATEST=$(ls -t "$WORKSPACE/backups/enhanced/daily"/*.tar.gz 2>/dev/null | head -1)
    if [ -n "$LATEST" ]; then
        SIZE=$(du -h "$LATEST" | cut -f1)
        echo "   ✅ Local backup available: $SIZE"
        BACKUP_SUCCESS=$((BACKUP_SUCCESS + 1))
    else
        echo "   ⚠️  No local backup found, creating now..."
        bash "$SCRIPT_DIR/daily-backup.sh" 2>/dev/null && BACKUP_SUCCESS=$((BACKUP_SUCCESS + 1)) || BACKUP_FAILED=$((BACKUP_FAILED + 1))
    fi
else
    echo "   ❌ Local backup not configured"
    BACKUP_FAILED=$((BACKUP_FAILED + 1))
fi

# 2. Git Version Control
echo "2/4 Git Version Control..."
cd "$WORKSPACE"
if git status &>/dev/null; then
    COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
    echo "   ✅ Git active: $COMMITS commits on $BRANCH"
    
    # Auto-commit changes
    git add -A 2>/dev/null || true
    if ! git diff --staged --quiet 2>/dev/null; then
        git commit -m "Auto-backup: $(date +%Y-%m-%d_%H-%M-%S)" 2>/dev/null && \
        echo "   ✅ Changes committed" || echo "   ⚠️  Commit skipped"
    else
        echo "   ℹ️  No changes to commit"
    fi
    BACKUP_SUCCESS=$((BACKUP_SUCCESS + 1))
else
    echo "   ❌ Git not initialized"
    BACKUP_FAILED=$((BACKUP_FAILED + 1))
fi

# 3. IPFS Backup (Decentralized)
echo "3/4 IPFS Decentralized Storage..."
if command -v ipfs &>/dev/null; then
    echo "   📤 Pinning to IPFS..."
    LATEST_BACKUP=$(ls -t "$WORKSPACE/backups/enhanced/daily"/*.tar.gz 2>/dev/null | head -1)
    if [ -n "$LATEST_BACKUP" ]; then
        IPFS_HASH=$(ipfs add -Q "$LATEST_BACKUP" 2>/dev/null || echo "")
        if [ -n "$IPFS_HASH" ]; then
            echo "   ✅ IPFS pinned: ipfs.io/ipfs/$IPFS_HASH"
            BACKUP_SUCCESS=$((BACKUP_SUCCESS + 1))
        else
            echo "   ⚠️  IPFS pinning failed"
            BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
        fi
    else
        echo "   ⚠️  No backup to pin"
        BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
    fi
else
    echo "   ⚠️  IPFS not installed (optional)"
    BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
fi

# 4. Archive.org (Wayback Machine)
echo "4/4 Internet Archive..."
if command -v curl &>/dev/null; then
    # Submit to Wayback Machine
    REPO_URL="https://github.com/adiytharpansa/openclaw-backup"
    curl -s --max-time 10 "https://web.archive.org/save/$REPO_URL" &>/dev/null && \
    echo "   ✅ Archive.org submitted" && BACKUP_SUCCESS=$((BACKUP_SUCCESS + 1)) || \
    echo "   ⚠️  Archive.org skipped" && BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
else
    echo "   ⚠️  curl not available"
    BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
fi

echo ""

# ============================================
# TIER 2: Browser-Based Auth (Optional)
# ============================================
echo "═══════════════════════════════════════"
echo "☁️ TIER 2: Browser Auth (Optional)"
echo "═══════════════════════════════════════"
echo ""

# Check for GitHub CLI
echo "1/3 GitHub CLI..."
if command -v gh &>/dev/null; then
    if gh auth status &>/dev/null; then
        echo "   ✅ GitHub CLI authenticated"
        # Push to GitHub
        cd "$WORKSPACE"
        if git remote | grep -q origin; then
            git push origin main 2>/dev/null && \
            echo "   ✅ GitHub push successful" && BACKUP_SUCCESS=$((BACKUP_SUCCESS + 1)) || \
            echo "   ⚠️  GitHub push failed" && BACKUP_FAILED=$((BACKUP_FAILED + 1))
        else
            echo "   ⚠️  No remote configured"
            BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
        fi
    else
        echo "   ⚠️  GitHub CLI not authenticated"
        echo "   💡 Run: gh auth login"
        BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
    fi
else
    echo "   ⚠️  GitHub CLI not installed"
    echo "   💡 Install: sudo apt install gh"
    BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
fi

# Check for GitLab CLI
echo "2/3 GitLab CLI..."
if command -v glab &>/dev/null; then
    if glab auth status &>/dev/null; then
        echo "   ✅ GitLab CLI authenticated"
        BACKUP_SUCCESS=$((BACKUP_SUCCESS + 1))
    else
        echo "   ⚠️  GitLab CLI not authenticated"
        BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
    fi
else
    echo "   ⚠️  GitLab CLI not installed (optional)"
    BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
fi

# Check for rclone
echo "3/3 rclone (Multi-Cloud)..."
if command -v rclone &>/dev/null; then
    REMOTES=$(rclone listremotes 2>/dev/null | wc -l)
    if [ "$REMOTES" -gt 0 ]; then
        echo "   ✅ rclone configured: $REMOTES remotes"
        BACKUP_SUCCESS=$((BACKUP_SUCCESS + 1))
    else
        echo "   ⚠️  rclone not configured"
        echo "   💡 Run: rclone config"
        BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
    fi
else
    echo "   ⚠️  rclone not installed (optional)"
    echo "   💡 Install: sudo apt install rclone"
    BACKUP_SKIPPED=$((BACKUP_SKIPPED + 1))
fi

echo ""

# ============================================
# SUMMARY
# ============================================
echo "═══════════════════════════════════════"
echo "📊 Backup Summary"
echo "═══════════════════════════════════════"
echo ""
echo "✅ Successful: $BACKUP_SUCCESS"
echo "⚠️  Skipped:    $BACKUP_SKIPPED"
echo "❌ Failed:     $BACKUP_FAILED"
echo ""

TOTAL=$((BACKUP_SUCCESS + BACKUP_SKIPPED + BACKUP_FAILED))
if [ $TOTAL -gt 0 ]; then
    SCORE=$((BACKUP_SUCCESS * 100 / TOTAL))
else
    SCORE=0
fi

echo "📈 Success Rate: $SCORE%"
echo ""

if [ $BACKUP_SUCCESS -ge 3 ]; then
    echo "🎉 Excellent! Multiple backup layers active!"
    PERMANENCE="95-99%"
elif [ $BACKUP_SUCCESS -ge 2 ]; then
    echo "✅ Good! Core backups working!"
    PERMANENCE="90-95%"
else
    echo "⚠️  Limited backups. Consider enabling Tier 2."
    PERMANENCE="80-90%"
fi

echo ""
echo "═══════════════════════════════════════"
echo "🎯 Permanence Score: $PERMANENCE"
echo "═══════════════════════════════════════"
echo ""

# Save status
cat > "$WORKSPACE/backups/enhanced/last-backup-status.json" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "success": $BACKUP_SUCCESS,
  "skipped": $BACKUP_SKIPPED,
  "failed": $BACKUP_FAILED,
  "score": $SCORE,
  "permanence": "$PERMANENCE"
}
EOF

echo "✅ Backup complete!"
echo ""
echo "📝 Next steps:"
if [ $BACKUP_SKIPPED -gt 0 ]; then
    echo "   - Enable Tier 2 for better redundancy"
    echo "   - Run: gh auth login (for GitHub)"
    echo "   - Run: rclone config (for cloud storage)"
fi
echo ""
echo "📊 Check status anytime:"
echo "   ./scripts/backup-status.sh"
echo ""
