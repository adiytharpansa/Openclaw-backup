#!/bin/bash
# AUTO-CONFIG.sh - Automated Nuclear Setup Script

ACTION="${1:-interactive}"

SCRIPT_DIR="$(dirname "$0")"
WORKSPACE_DIR="$SCRIPT_DIR/../../"
CONFIG_FILE="$WORKSPACE_DIR/.nuclear.env"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Interactive setup
interactive_setup() {
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log "🌋 NUCLEAR SETUP - Interactive Mode"
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "This wizard will configure all nuclear skills."
    echo "Have your GitHub token and Telegram bot token ready."
    echo ""
    
    # Generate random keys
    log "🔑 Generating encryption keys..."
    STATE_SYNC_KEY=$(openssl rand -hex 32)
    ENCRYPTION_KEY=$(openssl rand -hex 32)
    
    echo ""
    echo "🔐 Generated encryption keys:"
    echo "  STATE_SYNC_KEY: $STATE_SYNC_KEY"
    echo "  ENCRYPTION_KEY: $ENCRYPTION_KEY"
    echo "  ⚠️  IMPORTANT: Save these keys! You'll need them."
    echo ""
    read -p "Press Enter when saved..."
    
    # Get GitHub info
    echo ""
    echo "📦 GitHub Configuration"
    read -p "GitHub username: " GITHUB_USER
    read -p "Repository name (e.g., openclaw-state): " GITHUB_REPO_NAME
    read -sp "GitHub Personal Access Token: " GITHUB_TOKEN
    echo ""
    
    GITHUB_REPO="https://${GITHUB_TOKEN}@github.com/${GITHUB_USER}/${GITHUB_REPO_NAME}.git"
    
    # Get Telegram info
    echo ""
    echo "📱 Telegram Configuration"
    read -sp "Telegram Bot Token: " TELEGRAM_BOT_TOKEN
    echo ""
    read -p "Telegram Chat ID: " TELEGRAM_CHAT_ID
    
    # Get VPS info
    echo ""
    echo "🖥️  VPS Configuration"
    read -p "Primary VPS host (e.g., user@1.2.3.4): " VPS_HOST
    read -p "Secondary VPS host (e.g., user@5.6.7.8): " VPS_HOST_2
    
    # Generate instance ID
    INSTANCE_ID="nuclear-$(hostname)-$(date +%Y%m%d)"
    
    # Create config file
    log "💾 Creating configuration file..."
    
    cat > "$CONFIG_FILE" << EOF
# Nuclear OpenClaw Configuration
# Generated: $(date)
# DO NOT COMMIT THIS FILE TO GIT

# Instance ID
INSTANCE_ID="$INSTANCE_ID"

# Dead Man's Switch
MONITOR_URL=""  # Set your external monitor URL
HEARTBEAT_INTERVAL=300
HEARTBEAT_TIMEOUT=1800

# Encryption Keys (SAVE THESE!)
STATE_SYNC_KEY="$STATE_SYNC_KEY"
ENCRYPTION_KEY="$ENCRYPTION_KEY"

# GitHub (State backup & GitOps)
GITHUB_REPO="$GITHUB_REPO"

# VPS Locations
VPS_HOST="$VPS_HOST"
VPS_HOST_2="$VPS_HOST_2"

# Alert Channels
TELEGRAM_BOT_TOKEN="$TELEGRAM_BOT_TOKEN"
TELEGRAM_CHAT_ID="$TELEGRAM_CHAT_ID"

# Infrastructure Rotation
ROTATION_INTERVAL=86400
EOF

    log "✅ Config file created: $CONFIG_FILE"
    
    # Create GitHub repo if doesn't exist
    echo ""
    log "📦 Checking GitHub repository..."
    
    if ! curl -s -u "$GITHUB_USER:$GITHUB_TOKEN" \
        "https://api.github.com/repos/$GITHUB_USER/$GITHUB_REPO_NAME" > /dev/null 2>&1; then
        
        log "Repository not found, creating..."
        curl -s -u "$GITHUB_USER:$GITHUB_TOKEN" \
            -X POST "https://api.github.com/user/repos" \
            -d "{\"name\":\"$GITHUB_REPO_NAME\",\"private\":true}"
        
        if [ $? -eq 0 ]; then
            log "✅ GitHub repository created: $GITHUB_USER/$GITHUB_REPO_NAME"
        else
            log "❌ Failed to create GitHub repository"
        fi
    else
        log "✅ Repository exists: $GITHUB_USER/$GITHUB_REPO_NAME"
    fi
    
    # Setup state sync
    echo ""
    log "⚙️  Configuring state sync..."
    export STATE_SYNC_KEY
    export STATE_SYNC_GITHUB="$GITHUB_REPO"
    
    # Initialize git repo if needed
    cd "$WORKSPACE_DIR"
    if [ ! -f "MEMORY.md" ]; then
        log "⚠️  No workspace found, skipping state backup"
    else
        log "✅ Workspace found, state sync ready"
    fi
    
    # Enable services
    echo ""
    log "🚀 Enabling services..."
    
    # Add to crontab (if available)
    if command -v crontab &> /dev/null; then
        # Add state sync (hourly)
        if ! crontab -l 2>/dev/null | grep -q "state-sync.sh"; then
            (crontab -l 2>/dev/null; echo "0 * * * * cd $WORKSPACE_DIR && skills/state-sync/sync.sh push >> /var/log/openclaw/state-sync.log 2>&1") | crontab -
            log "✅ State sync added to crontab (hourly)"
        fi
        
        # Add rotation (daily)
        if ! crontab -l 2>/dev/null | grep -q "rotate.sh"; then
            (crontab -l 2>/dev/null; echo "0 */24 * * * cd $WORKSPACE_DIR && skills/infrastructure-rotator/rotate.sh rotate >> /var/log/openclaw/rotation.log 2>&1") | crontab -
            log "✅ Infrastructure rotation added to crontab (daily)"
        fi
    else
        log "⚠️  crontab not available, add manual startup commands"
    fi
    
    echo ""
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log "✅ SETUP COMPLETE!"
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📋 Next Steps:"
    echo ""
    echo "1. Review config: cat $CONFIG_FILE"
    echo ""
    echo "2. Setup external monitor (recommended):"
    echo "   - Deploy monitor to VPS:"
    echo "     ssh $VPS_HOST 'git clone https://github.com/youruser/openclaw.git'"
    echo "     ssh $VPS_HOST 'skills/dead-man-switch/monitor.sh start'"
    echo ""
    echo "3. Test heartbeat:"
    echo "   skills/dead-man-switch/heartbeat.sh test"
    echo ""
    echo "4. Check mesh status:"
    echo "   skills/mesh-coordinator/coordinator.sh status"
    echo ""
    echo "5. View setup guide:"
    echo "   cat $SCRIPT_DIR/SETUP_GUIDE.md"
    echo ""
    log "💡 Remember to save this file: $CONFIG_FILE"
    log "⚠️  DO NOT commit .nuclear.env to git!"
    echo ""
}

# Quick setup (non-interactive, uses .env)
quick_setup() {
    log "⚡ Quick setup (non-interactive)"
    
    # Check if config exists
    if [ ! -f "$CONFIG_FILE" ]; then
        log "❌ Config file not found: $CONFIG_FILE"
        log "💡 Run: $0 interactive"
        exit 1
    fi
    
    # Load config
    source "$CONFIG_FILE"
    
    # Enable state sync
    log "✅ State sync configured"
    export STATE_SYNC_KEY
    export STATE_SYNC_GITHUB
    
    # Enable services
    log "🚀 Starting services..."
    
    # Add to crontab
    if command -v crontab &> /dev/null; then
        crontab -l 2>/dev/null | grep -v "state-sync.sh" | grep -v "rotate.sh" | crontab -
        
        (crontab -l 2>/dev/null; echo "0 * * * * cd $WORKSPACE_DIR && skills/state-sync/sync.sh push >> /var/log/openclaw/state-sync.log 2>&1") | crontab -
        (crontab -l 2>/dev/null; echo "0 */24 * * * cd $WORKSPACE_DIR && skills/infrastructure-rotator/rotate.sh rotate >> /var/log/openclaw/rotation.log 2>&1") | crontab -
        
        log "✅ Services enabled via cron"
    fi
    
    log "✅ Quick setup complete"
    log "📋 Run: skills/dead-man-switch/heartbeat.sh enable"
}

# Show help
show_help() {
    echo "🌋 Nuclear Setup - Automated Configuration"
    echo ""
    echo "Usage: $0 <action>"
    echo ""
    echo "Actions:"
    echo "  interactive  - Interactive setup wizard (recommended)"
    echo "  quick        - Quick setup using existing config"
    echo "  status       - Check current setup status"
    echo "  help         - Show this help"
    echo ""
    echo "Config file: $CONFIG_FILE"
    echo ""
    echo "Examples:"
    echo "  $0 interactive"
    echo "  $0 quick"
}

# Check status
check_status() {
    echo "📊 Nuclear Setup Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ -f "$CONFIG_FILE" ]; then
        log "✅ Config file exists"
        
        # Check loaded values
        source "$CONFIG_FILE"
        
        echo ""
        echo "Instance ID: $INSTANCE_ID"
        echo "GitHub Repo: ${GITHUB_REPO:-Not configured}"
        echo "VPS Hosts: ${VPS_HOST:-Not configured}"
        echo ""
        echo "Encryption: $([ -n "$STATE_SYNC_KEY" ] && echo "✅ Enabled" || echo "❌ Disabled")"
        echo ""
        
        # Check crontab
        if command -v crontab &> /dev/null; then
            echo "Cron Jobs:"
            crontab -l 2>/dev/null | grep -E "(state-sync|rotate)" || echo "  None configured"
        fi
        
        # Check mesh registration
        if [ -f "/tmp/openclaw-peers.txt" ]; then
            echo "Mesh: ✅ Registered"
        else
            echo "Mesh: ❌ Not registered"
        fi
    else
        log "❌ Config file not found"
        echo ""
        echo "💡 Run: $0 interactive"
    fi
}

case "$ACTION" in
    interactive) interactive_setup ;;
    quick) quick_setup ;;
    status) check_status ;;
    help|*) show_help ;;
esac
