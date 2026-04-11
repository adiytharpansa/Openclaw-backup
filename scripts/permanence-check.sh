#!/bin/bash
echo "🔍 OpenClaw Permanence Status"
echo "============================"

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"

# Check systemd
if systemctl is-active --quiet openclaw 2>/dev/null; then
    echo "✅ Systemd Service: ACTIVE"
else
    echo "❌ Systemd Service: INACTIVE"
fi

# Check cron jobs
if crontab -l 2>/dev/null | grep -q "openclaw"; then
    echo "✅ Cron Jobs: CONFIGURED"
else
    echo "❌ Cron Jobs: NOT CONFIGURED"
fi

# Check backups
BACKUP_COUNT=$(ls -1 /mnt/backups/openclaw/enhanced/daily/*.tar.gz 2>/dev/null | wc -l)
echo "📦 Daily Backups: $BACKUP_COUNT available"

# Check Git
cd "$WORKSPACE"
if [ -d ".git" ]; then
    LAST_COMMIT=$(git log -1 --format="%h %s" 2>/dev/null || echo "No commits")
    echo "✅ Git Version Control: ACTIVE"
    echo "   Last commit: $LAST_COMMIT"
else
    echo "❌ Git Version Control: NOT INITIALIZED"
fi

# Check health monitoring
if [ -f "/etc/systemd/system/openclaw.service" ]; then
    echo "✅ Auto-Start: CONFIGURED"
else
    echo "❌ Auto-Start: NOT CONFIGURED"
fi

echo ""
echo "📊 Permanence Score Calculation..."
SCORE=0
systemctl is-active --quiet openclaw 2>/dev/null && SCORE=$((SCORE+25))
crontab -l 2>/dev/null | grep -q "openclaw" && SCORE=$((SCORE+25))
[ "$BACKUP_COUNT" -gt 0 ] && SCORE=$((SCORE+25))
[ -d ".git" ] && SCORE=$((SCORE+25))

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
