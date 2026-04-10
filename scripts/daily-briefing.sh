#!/bin/bash
# Daily Briefing Script
# Run this to get a complete daily briefing

echo "🌅 Daily Briefing - $(date)"
echo "================================"
echo ""

# Weather
echo "🌤️  Weather:"
curl -s "wttr.in/?format=3" 2>/dev/null || echo "Weather unavailable"
echo ""

# Check emails (if himalaya configured)
echo "📧 Email Status:"
if command -v himalaya &> /dev/null; then
    himalaya mailbox inbox --limit 5 2>/dev/null || echo "No new emails or not configured"
else
    echo "Himalaya not configured"
fi
echo ""

# Git status
echo "💻 Git Status:"
cd /mnt/data/openclaw/workspace/.openclaw/workspace
git status --short 2>/dev/null | head -5 || echo "Not a git repo"
echo ""

# System info
echo "🖥️  System:"
echo "Uptime: $(uptime -p 2>/dev/null || echo 'N/A')"
echo "Memory: $(free -h 2>/dev/null | grep Mem | awk '{print $3"/"$2}' || echo 'N/A')"
echo ""

echo "================================"
echo "Have a great day! 🚀"
