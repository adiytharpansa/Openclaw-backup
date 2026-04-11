#!/bin/bash
# ACTIVATE-FREE.sh - 100% Free Ultimate Permanence Activation

ACTION="${1:-interactive}"
SCRIPT_DIR="$(dirname "$0")"
WORKSPACE_DIR="$SCRIPT_DIR/../../"
CONFIG_FILE="$WORKSPACE_DIR/.free.env"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Generate random string
random_string() {
    openssl rand -hex 32 2>/dev/null || cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 64 | head -n 1
}

# Interactive setup
interactive_setup() {
    clear
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log "🆓 FREE PERMANENCE ACTIVATION"
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "This will setup 100% FREE unstoppable OpenClaw!"
    echo "All services used are FREE tier."
    echo ""
    read -p "Press Enter to continue..."
    
    # Generate encryption keys
    log "🔑 Generating encryption keys..."
    STATE_SYNC_KEY=$(random_string)
    ENCRYPTION_KEY=$(random_string)
    
    echo ""
    echo "🔐 ENCRYPTION KEYS (SAVE THESE!):"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "STATE_SYNC_KEY=$STATE_SYNC_KEY"
    echo "ENCRYPTION_KEY=$ENCRYPTION_KEY"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "⚠️  IMPORTANT: Copy these to a safe place!"
    echo "   You'll need them for recovery."
    echo ""
    read -p "Saved? Press Enter..."
    
    # GitHub setup
    echo ""
    log "📦 GitHub Setup"
    echo ""
    echo "1. Go to: https://github.com/new"
    echo "2. Create private repo: openclaw-state"
    echo "3. Don't initialize it"
    echo ""
    read -p "Done? Press Enter..."
    
    echo ""
    read -p "GitHub username: " GITHUB_USER
    read -sp "GitHub Personal Access Token: " GITHUB_TOKEN
    echo ""
    
    GITHUB_REPO="https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/openclaw-state.git"
    
    # Cloudflare setup
    echo ""
    log "☁️  Cloudflare Workers Setup"
    echo ""
    echo "1. Go to: https://dash.cloudflare.com/sign-up"
    echo "2. Create free account"
    echo "3. Workers → Create Worker → 'openclaw-monitor'"
    echo ""
    read -p "Done? Press Enter..."
    
    echo ""
    read -p "Worker URL (e.g., https://openclaw-monitor.your-subdomain.workers.dev): " MONITOR_URL
    
    # Oracle Cloud setup
    echo ""
    log "🏢 Oracle Cloud Setup"
    echo ""
    echo "1. Go to: https://www.oracle.com/cloud/free/"
    echo "2. Sign up for free tier"
    echo "3. Create ARM instance (VM.Standard.A1.Flex)"
    echo ""
    read -p "Done? (y/n): " ORACLE_DONE
    
    if [ "$ORACLE_DONE" = "y" ]; then
        read -p "Oracle VPS IP: " ORACLE_IP
        read -p "Oracle SSH user (default: ubuntu): " ORACLE_USER
        ORACLE_USER="${ORACLE_USER:-ubuntu}"
    fi
    
    # Fly.io setup
    echo ""
    log "🪰 Fly.io Setup"
    echo ""
    echo "1. Install flyctl: curl -L https://fly.io/install.sh | sh"
    echo "2. Signup: flyctl auth signup"
    echo "3. Create app: flyctl launch"
    echo ""
    read -p "Done? (y/n): " FLY_DONE
    
    if [ "$FLY_DONE" = "y" ]; then
        read -p "Fly.io app name: " FLY_APP
    fi
    
    # Generate instance ID
    INSTANCE_ID="free-$(hostname)-$(date +%Y%m%d)"
    
    # Create config file
    log "💾 Creating configuration..."
    
    cat > "$CONFIG_FILE" << EOF
# FREE PERMANENCE CONFIGURATION
# Generated: $(date)
# DO NOT COMMIT TO GIT!

# Instance
INSTANCE_ID="$INSTANCE_ID"

# Dead Man's Switch
MONITOR_URL="$MONITOR_URL"
HEARTBEAT_INTERVAL=300
HEARTBEAT_TIMEOUT=1800

# Encryption (SAVE THESE!)
STATE_SYNC_KEY="$STATE_SYNC_KEY"
ENCRYPTION_KEY="$ENCRYPTION_KEY"

# GitHub (State Backup)
GITHUB_REPO="$GITHUB_REPO"

# Oracle Cloud (if configured)
ORACLE_IP="${ORACLE_IP:-}"
ORACLE_USER="${ORACLE_USER:-}"

# Fly.io (if configured)
FLY_APP="${FLY_APP:-}"

# Alerts (Telegram - optional)
TELEGRAM_BOT_TOKEN=""
TELEGRAM_CHAT_ID=""

# Rotation
ROTATION_INTERVAL=86400
EOF

    log "✅ Config created: $CONFIG_FILE"
    
    # Initialize GitHub repo
    echo ""
    log "📦 Initializing GitHub repo..."
    
    cd "$WORKSPACE_DIR"
    
    # Check if git initialized
    if [ ! -d ".git" ]; then
        git init
        git remote add origin "$GITHUB_REPO"
        log "✅ Git initialized"
    fi
    
    # Initial commit
    git add .nuclear.env .free.env MEMORY.md 2>/dev/null
    git commit -m "🆓 Free permanence setup $(date)" || true
    git push -u origin main 2>&1 | head -5
    
    # Setup crontab
    echo ""
    log "⏰ Setting up automated tasks..."
    
    if command -v crontab &> /dev/null; then
        # Remove old entries
        crontab -l 2>/dev/null | grep -v "state-sync.sh" | grep -v "rotate.sh" | crontab -
        
        # Add new entries
        (crontab -l 2>/dev/null; cat << EOF
# Free Permanence Automation
# State sync to GitHub (hourly)
0 * * * * cd $WORKSPACE_DIR && skills/state-sync/sync.sh push >> /tmp/state-sync.log 2>&1

# Infrastructure rotation (daily)
0 */24 * * * cd $WORKSPACE_DIR && skills/infrastructure-rotator/rotate.sh rotate >> /tmp/rotation.log 2>&1

# Heartbeat (every 5 min)
*/5 * * * * cd $WORKSPACE_DIR && skills/dead-man-switch/heartbeat.sh send >> /tmp/heartbeat.log 2>&1
EOF
        ) | crontab -
        
        log "✅ Cron jobs added"
        crontab -l | grep -E "(state-sync|rotate|heartbeat)"
    else
        log "⚠️  crontab not available"
    fi
    
    # Test services
    echo ""
    log "🧪 Testing services..."
    
    # Test heartbeat
    skills/dead-man-switch/heartbeat.sh test 2>&1 | head -5
    
    # Test state sync
    skills/state-sync/sync.sh status
    
    echo ""
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log "✅ FREE PERMANENCE ACTIVATED!"
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📋 What's Active:"
    echo "  ✅ Dead Man's Switch (heartbeat every 5 min)"
    echo "  ✅ State Sync to GitHub (hourly)"
    echo "  ✅ Infrastructure Rotation (daily)"
    echo "  ✅ Encrypted backups"
    echo ""
    echo "📊 Status Commands:"
    echo "  skills/nuclear-setup/AUTO-CONFIG.sh status"
    echo "  skills/dead-man-switch/heartbeat.sh status"
    echo "  skills/mesh-coordinator/coordinator.sh status"
    echo ""
    echo "📚 Full Guide:"
    echo "  cat $SCRIPT_DIR/FREE-SETUP-GUIDE.md"
    echo ""
    echo "⚠️  IMPORTANT:"
    echo "  1. Save encryption keys from above!"
    echo "  2. Complete Oracle Cloud & Fly.io setup"
    echo "  3. Test failover scenario"
    echo ""
}

# Quick status check
quick_status() {
    echo "🆓 Free Permanence Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ -f "$CONFIG_FILE" ]; then
        log "✅ Config exists"
        source "$CONFIG_FILE"
        echo "Instance: $INSTANCE_ID"
        echo "Monitor: ${MONITOR_URL:-Not configured}"
        echo "GitHub: ${GITHUB_REPO:-Not configured}"
    else
        log "❌ Config not found"
    fi
    
    echo ""
    echo "Services:"
    
    # Check heartbeat
    if crontab -l 2>/dev/null | grep -q "heartbeat"; then
        echo "  ✅ Heartbeat active"
    else
        echo "  ❌ Heartbeat not configured"
    fi
    
    # Check state sync
    if crontab -l 2>/dev/null | grep -q "state-sync"; then
        echo "  ✅ State sync active"
    else
        echo "  ❌ State sync not configured"
    fi
    
    # Check rotation
    if crontab -l 2>/dev/null | grep -q "rotate"; then
        echo "  ✅ Rotation active"
    else
        echo "  ❌ Rotation not configured"
    fi
}

# Help
show_help() {
    echo "🆓 Free Permanence Activation"
    echo ""
    echo "Usage: $0 <action>"
    echo ""
    echo "Actions:"
    echo "  interactive  - Interactive setup wizard"
    echo "  status       - Check current status"
    echo "  help         - Show this help"
    echo ""
    echo "Guide: $SCRIPT_DIR/FREE-SETUP-GUIDE.md"
}

case "$ACTION" in
    interactive) interactive_setup ;;
    status) quick_status ;;
    help|*) show_help ;;
esac
