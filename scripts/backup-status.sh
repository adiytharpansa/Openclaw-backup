#!/bin/bash
# Backup Status Checker - Quick overview of all backup systems

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"

echo "🔍 Backup Status Overview"
echo "========================"
echo ""

# Local Backups
echo "📦 Local Backups:"
HOURLY_COUNT=$(ls -1 "$WORKSPACE/backups/enhanced/hourly"/*.tar.gz 2>/dev/null | wc -l)
DAILY_COUNT=$(ls -1 "$WORKSPACE/backups/enhanced/daily"/*.tar.gz 2>/dev/null | wc -l)
echo "   Hourly: $HOURLY_COUNT backups"
echo "   Daily:  $DAILY_COUNT backups"

# Disaster Recovery
if [ -f "$WORKSPACE/disaster-recovery/latest-backup.tar.gz" ]; then
    SIZE=$(du -h "$WORKSPACE/disaster-recovery/latest-backup.tar.gz" | cut -f1)
    echo "   🛡️  Disaster Recovery: $SIZE ✅"
else
    echo "   🛡️  Disaster Recovery: MISSING ❌"
fi

# Git
echo ""
echo "📝 Git Version Control:"
cd "$WORKSPACE"
if git status &>/dev/null; then
    COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo "0")
    BRANCH=$(git branch --show-current 2>/dev/null || echo "main")
    REMOTE=$(git remote get-url origin 2>/dev/null || echo "none")
    echo "   Commits: $COMMITS"
    echo "   Branch:  $BRANCH"
    echo "   Remote:  $REMOTE"
    
    # Check if remote is reachable
    if git ls-remote origin &>/dev/null; then
        echo "   Status:  ✅ Synced"
    else
        echo "   Status:  ⚠️  Not synced (needs auth)"
    fi
else
    echo "   ❌ Not initialized"
fi

# GitHub CLI
echo ""
echo "☁️ Cloud Services:"
if command -v gh &>/dev/null; then
    if gh auth status &>/dev/null; then
        echo "   GitHub CLI: ✅ Authenticated"
    else
        echo "   GitHub CLI: ⚠️  Not authenticated (run: gh auth login)"
    fi
else
    echo "   GitHub CLI: ❌ Not installed"
fi

# IPFS
if command -v ipfs &>/dev/null; then
    echo "   IPFS: ✅ Available"
else
    echo "   IPFS: ❌ Not installed"
fi

# rclone
if command -v rclone &>/dev/null; then
    REMOTES=$(rclone listremotes 2>/dev/null | wc -l)
    echo "   rclone: ✅ $REMOTES remotes"
else
    echo "   rclone: ❌ Not installed"
fi

# Last backup status
echo ""
echo "📊 Last Backup Status:"
if [ -f "$WORKSPACE/backups/enhanced/last-backup-status.json" ]; then
    cat "$WORKSPACE/backups/enhanced/last-backup-status.json" | grep -E '"(timestamp|success|score|permanence)"' | sed 's/[{},"]//g' | sed 's/^/   /'
else
    echo "   No status file found"
fi

# Calculate overall score
echo ""
echo "═══════════════════════════════════════"
echo "🎯 Overall Permanence Assessment"
echo "═══════════════════════════════════════"

SCORE=0
[ $HOURLY_COUNT -gt 0 ] && SCORE=$((SCORE + 15))
[ $DAILY_COUNT -gt 0 ] && SCORE=$((SCORE + 15))
[ -f "$WORKSPACE/disaster-recovery/latest-backup.tar.gz" ] && SCORE=$((SCORE + 20))
[ $COMMITS -gt 0 ] && SCORE=$((SCORE + 20))
command -v gh &>/dev/null && gh auth status &>/dev/null && SCORE=$((SCORE + 15))
command -v rclone &>/dev/null && SCORE=$((SCORE + 15))

echo ""
echo "   Score: $SCORE/100"

if [ $SCORE -ge 90 ]; then
    echo "   Status: 🟢 EXCELLENT"
elif [ $SCORE -ge 70 ]; then
    echo "   Status: 🟡 GOOD"
elif [ $SCORE -ge 50 ]; then
    echo "   Status: 🟠 FAIR"
else
    echo "   Status: 🔴 NEEDS IMPROVEMENT"
fi

echo ""
echo "💡 Recommendations:"
[ $HOURLY_COUNT -eq 0 ] && echo "   - Enable hourly backups"
[ $DAILY_COUNT -eq 0 ] && echo "   - Enable daily backups"
[ ! -f "$WORKSPACE/disaster-recovery/latest-backup.tar.gz" ] && echo "   - Create disaster recovery package"
! command -v gh &>/dev/null && echo "   - Install GitHub CLI for cloud backup"
! command -v rclone &>/dev/null && echo "   - Install rclone for multi-cloud backup"
[ $SCORE -ge 90 ] && echo "   - Perfect! Nothing to improve!"

echo ""
