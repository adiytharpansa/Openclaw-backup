#!/bin/bash
# =============================================================================
# OPENCLAW AUTO-RESTART
# =============================================================================
# Run this once at the start of your session
# It will keep OpenClaw running for hours
# =============================================================================

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
LOG_FILE="$WORKSPACE/.local/logs/auto-restart.log"

cd "$WORKSPACE"

echo "🚀 OpenClaw Auto-Restart Service"
echo "================================="
echo ""

# Function to restart if needed
restart_if_needed() {
    if ! ./bin/clawd status 2>&1 | grep -q "RUNNING"; then
        echo "[$(date '+%H:%M:%S')] ⚠️  Not running, starting..." | tee -a "$LOG_FILE"
        ./bin/clawd start >> "$LOG_FILE" 2>&1
        sleep 2
        echo "[$(date '+%H:%M:%S')] ✅ Started!" | tee -a "$LOG_FILE"
    else
        echo "[$(date '+%H:%M:%S')] ✅ Already running" | tee -a "$LOG_FILE"
    fi
}

# Initial start
restart_if_needed

echo ""
echo "✅ Auto-restart active!"
echo "   Checking every 60 seconds..."
echo "   Logs: $LOG_FILE"
echo ""
echo "This will keep OpenClaw running for hours."
echo "You can disconnect and come back anytime."
echo ""

# Main loop
while true; do
    sleep 60
    restart_if_needed
done
