#!/bin/bash
echo "🔍 OpenClaw Permanence Status"
echo "============================"

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
BACKUP_DIR="$WORKSPACE/backups/enhanced"

# Check systemd
if systemctl is-active --quiet openclaw 2>/dev/null; then
    echo "✅ Systemd Service: ACTIVE"
    SYS_STATUS="active"
else
    echo "❌ Systemd Service: INACTIVE"
    SYS_STATUS="inactive"
fi

# Check cron jobs
if crontab -l 2>/dev/null | grep -q "openclaw"; then
    echo "✅ Cron Jobs: CONFIGURED"
    CRON_STATUS="yes"
else
    echo "❌ Cron Jobs: NOT CONFIGURED"
    CRON_STATUS="no"
fi

# Check backups
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR/daily"/*.tar.gz 2>/dev/null | wc -l)
echo "📦 Daily Backups: $BACKUP_COUNT available"

# Check Git
cd "$WORKSPACE"
if [ -d ".git" ]; then
    LAST_COMMIT=$(git log -1 --format="%h %s" 2>/dev/null || echo "No commits")
    echo "✅ Git Version Control: ACTIVE"
    echo "   Last commit: $LAST_COMMIT"
    GIT_STATUS="yes"
else
    echo "❌ Git Version Control: NOT INITIALIZED"
    GIT_STATUS="no"
fi

# Check backup system
if [ -f "$BACKUP_DIR/daily/latest-backup.tar.gz" ]; then
    echo "✅ Disaster Recovery Package: READY"
    DR_STATUS="yes"
else
    echo "❌ Disaster Recovery Package: MISSING"
    DR_STATUS="no"
fi

echo ""
echo "📊 Permanence Score Calculation..."
SCORE=0
[ "$SYS_STATUS" == "active" ] && SCORE=$((SCORE+25))
[ "$CRON_STATUS" == "yes" ] && SCORE=$((SCORE+25))
[ "$BACKUP_COUNT" -gt 0 ] && SCORE=$((SCORE+25))
[ "$GIT_STATUS" == "yes" ] && SCORE=$((SCORE+25))

echo "════════════════════════"
echo "🎯 PERMANENCE SCORE: $SCORE%"
echo "════════════════════════"

if [ $SCORE -ge 95 ]; then
    echo "🟢 EXCELLENT - Production ready!"
elif [ $SCORE -ge 75 ]; then
    echo "🟡 GOOD - Most systems active"
else
    echo "🔴 NEEDS WORK - Run ACTIVATE.sh"
fi
