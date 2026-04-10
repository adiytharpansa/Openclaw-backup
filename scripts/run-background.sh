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
