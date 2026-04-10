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
