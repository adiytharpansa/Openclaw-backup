#!/bin/bash
# =============================================================================
# OPENCLAW LOCAL DEPLOYMENT (NO SUDO REQUIRED)
# =============================================================================
# Deploy OpenClaw permanently in current environment
# No root/sudo access needed!
# =============================================================================

set -e

echo "🚀 OpenClaw Local Deployment"
echo "============================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Workspace path
WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
SCRIPTS_DIR="$WORKSPACE/scripts"
CONFIG_DIR="$WORKSPACE/config"
LOCAL_BIN="$WORKSPACE/bin"

# =============================================================================
# 1. CREATE LOCAL BIN DIRECTORY
# =============================================================================
echo -e "${BLUE}[1/7]${NC} Creating local bin directory..."

mkdir -p "$LOCAL_BIN"
mkdir -p "$WORKSPACE/.local"
mkdir -p "$WORKSPACE/.local/bin"
mkdir -p "$WORKSPACE/.local/lib"
mkdir -p "$WORKSPACE/.local/logs"

echo -e "${GREEN}✓ Local directories created${NC}"

# =============================================================================
# 2. CREATE LAUNCHER SCRIPTS
# =============================================================================
echo -e "\n${BLUE}[2/7]${NC} Creating launcher scripts..."

# Main launcher
cat > "$LOCAL_BIN/openclaw" <<'EOF'
#!/bin/bash
# OpenClaw Launcher
WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
cd "$WORKSPACE"
exec python3 -m openclaw "$@"
EOF

chmod +x "$LOCAL_BIN/openclaw"

# Quick start launcher
cat > "$LOCAL_BIN/clawd" <<'EOF'
#!/bin/bash
# OpenClaw Quick Start
WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
cd "$WORKSPACE"

case "$1" in
    start)
        echo "🚀 Starting OpenClaw..."
        python3 -m openclaw start
        ;;
    stop)
        echo "🛑 Stopping OpenClaw..."
        python3 -m openclaw stop
        ;;
    status)
        echo "📊 OpenClaw Status"
        python3 -m openclaw status
        ;;
    restart)
        echo "🔄 Restarting OpenClaw..."
        python3 -m openclaw stop
        sleep 2
        python3 -m openclaw start
        ;;
    logs)
        echo "📋 Showing logs..."
        tail -f "$WORKSPACE/.local/logs/openclaw.log"
        ;;
    *)
        echo "Usage: clawd {start|stop|status|restart|logs}"
        exit 1
        ;;
esac
EOF

chmod +x "$LOCAL_BIN/clawd"

echo -e "${GREEN}✓ Launcher scripts created${NC}"

# =============================================================================
# 3. CREATE AUTO-START CONFIG
# =============================================================================
echo -e "\n${BLUE}[3/7]${NC} Creating auto-start config..."

# Create .bashrc snippet
cat > "$WORKSPACE/.local/bashrc_snippet" <<'EOF'
# OpenClaw Auto-Start
export OPENCLAW_WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
export PATH="$OPENCLAW_WORKSPACE/bin:$PATH"
alias claw='cd $OPENCLAW_WORKSPACE'
alias clawd='$OPENCLAW_WORKSPACE/bin/clawd'
EOF

echo -e "${GREEN}✓ Auto-start config created${NC}"
echo -e "${YELLOW}ℹ Add to your ~/.bashrc:${NC}"
echo -e "   cat $WORKSPACE/.local/bashrc_snippet >> ~/.bashrc"

# =============================================================================
# 4. CREATE BACKGROUND RUNNER
# =============================================================================
echo -e "\n${BLUE}[4/7]${NC} Creating background runner..."

cat > "$SCRIPTS_DIR/run-background.sh" <<'EOF'
#!/bin/bash
# Run OpenClaw in background
WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
LOG_FILE="$WORKSPACE/.local/logs/openclaw.log"
PID_FILE="$WORKSPACE/.local/openclaw.pid"

cd "$WORKSPACE"

# Check if already running
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null; then
        echo "OpenClaw already running (PID: $PID)"
        exit 0
    fi
fi

# Start in background
echo "Starting OpenClaw in background..."
nohup python3 -m openclaw run > "$LOG_FILE" 2>&1 &
echo $! > "$PID_FILE"

echo "✓ OpenClaw started (PID: $(cat $PID_FILE))"
echo "Logs: $LOG_FILE"
EOF

chmod +x "$SCRIPTS_DIR/run-background.sh"

echo -e "${GREEN}✓ Background runner created${NC}"

# =============================================================================
# 5. CREATE STOP SCRIPT
# =============================================================================
echo -e "\n${BLUE}[5/7]${NC} Creating stop script..."

cat > "$SCRIPTS_DIR/stop.sh" <<'EOF'
#!/bin/bash
# Stop OpenClaw
WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
PID_FILE="$WORKSPACE/.local/openclaw.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null; then
        echo "Stopping OpenClaw (PID: $PID)..."
        kill $PID
        rm "$PID_FILE"
        echo "✓ OpenClaw stopped"
    else
        echo "OpenClaw not running (stale PID file)"
        rm "$PID_FILE"
    fi
else
    echo "OpenClaw not running (no PID file)"
fi
EOF

chmod +x "$SCRIPTS_DIR/stop.sh"

echo -e "${GREEN}✓ Stop script created${NC}"

# =============================================================================
# 6. SETUP LOCAL CRON (IF AVAILABLE)
# =============================================================================
echo -e "\n${BLUE}[6/7]${NC} Setting up local cron..."

# Check if crontab is available
if command -v crontab &> /dev/null; then
    # Create cron jobs (without sudo)
    (crontab -l 2>/dev/null; echo "# OpenClaw Health Check") | crontab -
    (crontab -l 2>/dev/null; echo "*/5 * * * * $SCRIPTS_DIR/health-check.sh >> $WORKSPACE/.local/logs/health.log 2>&1") | crontab -
    (crontab -l 2>/dev/null; echo "0 2 * * * $SCRIPTS_DIR/auto-backup.sh >> $WORKSPACE/.local/logs/backup.log 2>&1") | crontab -
    (crontab -l 2>/dev/null; echo "* * * * * $SCRIPTS_DIR/watchdog.sh >> $WORKSPACE/.local/logs/watchdog.log 2>&1") | crontab -
    
    echo -e "${GREEN}✓ Cron jobs installed${NC}"
else
    echo -e "${YELLOW}⚠ Crontab not available - using internal scheduler${NC}"
    
    # Create internal scheduler config
    cat > "$CONFIG_DIR/scheduler.json" <<'EOFCONFIG'
{
  "scheduler": {
    "enabled": true,
    "tasks": [
      {
        "name": "health_check",
        "interval_minutes": 5,
        "script": "scripts/health-check.sh"
      },
      {
        "name": "watchdog",
        "interval_minutes": 1,
        "script": "scripts/watchdog.sh"
      },
      {
        "name": "auto_backup",
        "interval_minutes": 1440,
        "script": "scripts/auto-backup.sh",
        "time": "02:00"
      },
      {
        "name": "optimize",
        "interval_minutes": 10080,
        "script": "scripts/optimize.sh",
        "day": "sunday",
        "time": "03:00"
      }
    ]
  }
}
EOFCONFIG
fi

# =============================================================================
# 7. VERIFY INSTALLATION
# =============================================================================
echo -e "\n${BLUE}[7/7]${NC} Verifying installation..."

echo ""
echo -e "${PURPLE}=== Installation Summary ===${NC}"
echo ""

# Check launcher
if [ -x "$LOCAL_BIN/clawd" ]; then
    echo -e "${GREEN}✓ Launcher: $LOCAL_BIN/clawd${NC}"
else
    echo -e "${RED}✗ Launcher not found${NC}"
fi

# Check scripts
for script in run-background.sh stop.sh health-check.sh watchdog.sh auto-backup.sh; do
    if [ -x "$SCRIPTS_DIR/$script" ]; then
        echo -e "${GREEN}✓ Script: $script${NC}"
    else
        echo -e "${YELLOW}⚠ Script: $script (not executable)${NC}"
    fi
done

# Check directories
for dir in .local .local/bin .local/logs .local/lib bin; do
    if [ -d "$WORKSPACE/$dir" ]; then
        echo -e "${GREEN}✓ Directory: $dir${NC}"
    else
        echo -e "${YELLOW}⚠ Directory: $dir (missing)${NC}"
    fi
done

# Check config
if [ -f "$CONFIG_DIR/scheduler.json" ]; then
    echo -e "${GREEN}✓ Scheduler config created${NC}"
fi

if [ -f "$WORKSPACE/.local/bashrc_snippet" ]; then
    echo -e "${GREEN}✓ Bashrc snippet created${NC}"
fi

# =============================================================================
# COMPLETE
# =============================================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   OPENCLAW LOCAL DEPLOYMENT COMPLETE! 🚀           ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Next Steps:${NC}"
echo ""
echo "1. Add to ~/.bashrc (for easy access):"
echo -e "   ${YELLOW}cat $WORKSPACE/.local/bashrc_snippet >> ~/.bashrc${NC}"
echo -e "   ${YELLOW}source ~/.bashrc${NC}"
echo ""
echo "2. Start OpenClaw:"
echo -e "   ${YELLOW}clawd start${NC}"
echo -e "   ${YELLOW}# OR${NC}"
echo -e "   ${YELLOW}$SCRIPTS_DIR/run-background.sh${NC}"
echo ""
echo "3. Check status:"
echo -e "   ${YELLOW}clawd status${NC}"
echo ""
echo "4. View logs:"
echo -e "   ${YELLOW}clawd logs${NC}"
echo ""
echo "5. Stop OpenClaw:"
echo -e "   ${YELLOW}clawd stop${NC}"
echo ""
echo -e "${GREEN}OpenClaw is now READY in your local environment! 🎉${NC}"
echo ""
