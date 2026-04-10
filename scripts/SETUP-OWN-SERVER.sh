#!/bin/bash
# =============================================================================
# OPENCLAW OWN SERVER SETUP
# =============================================================================
# Complete guide to set up your own independent server
# No dependencies, no external platforms
# =============================================================================

echo "╔════════════════════════════════════════════════════╗"
echo "║   OPENCLAW OWN SERVER SETUP GUIDE                  ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

echo "=== YOUR OPTIONS ==="
echo ""
echo "1. RASPBERRY PI (Recommended)"
echo "   - Cost: \$35-50 (one-time)"
echo "   - Power: 5W continuous"
echo "   - Permanence: 100%"
echo "   - Setup time: 2 hours"
echo ""
echo "2. OLD LAPTOP/PC (FREE if you have one)"
echo "   - Cost: \$0 (reuse existing)"
echo "   - Power: 30-60W"
echo "   - Permanence: 100%"
echo "   - Setup time: 1 hour"
echo ""
echo "3. CLOUD VPS (DigitalOcean, Linode, etc.)"
echo "   - Cost: \$5-10/month"
echo "   - Power: N/A"
echo "   - Permanence: 100%"
echo "   - Setup time: 30 min"
echo ""
echo "4. CLOUDFREE TIER (Oracle, Google)"
echo "   - Cost: \$0 (free tier)"
echo "   - Power: N/A"
echo "   - Permanence: 95% (TOS limits)"
echo "   - Setup time: 1 hour"
echo ""

read -p "Which option? (1-4): " OPTION

case $OPTION in
    1)
        echo "🍓 Selecting Raspberry Pi setup..."
        echo "================================"
        ;;
    2)
        echo "💻 Selecting Old PC/Laptop setup..."
        echo "==================================="
        ;;
    3)
        echo "☁️  Selecting VPS setup..."
        echo "==============="
        ;;
    4)
        echo "🆓 Selecting Free Cloud setup..."
        echo "================"
        ;;
    *)
        echo "Invalid option"
        exit 1
        ;;
esac

echo ""
echo "📋 SETUP CHECKLIST"
echo "=================="
echo ""
echo "For ANY option, you need:"
echo "✅ Hardware (Raspberry Pi / Old PC / VPS / Free Cloud)"
echo "✅ Operating System (Ubuntu 22.04 LTS recommended)"
echo "✅ Stable internet connection"
echo "✅ Power supply (24/7)"
echo ""

echo "🛠️  SETUP STEPS (will be created in setup guide)"
echo "1. Install OS"
echo "2. Configure network"
echo "3. Install dependencies"
echo "4. Deploy OpenClaw"
echo "5. Configure systemd"
echo "6. Setup backups"
echo "7. Configure monitoring"
echo ""

echo "⏱️  Time estimate: 1-3 hours"
echo "💰 Cost: \$0 (old PC) to \$50 (Raspberry Pi) or \$5-10/month (VPS)"
echo ""

cat /mnt/data/openclaw/workspace/.openclaw/workspace/OWN-SERVER-GUIDE.md
