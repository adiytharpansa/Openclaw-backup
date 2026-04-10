#!/bin/bash
# =============================================================================
# OPENCLAW QUICK START
# =============================================================================
# Run this when you come back to restart OpenClaw
# =============================================================================

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"

cd "$WORKSPACE"

echo "🚀 OpenClaw Quick Start"
echo "======================"
echo ""

# Check if already running
if ./bin/clawd status 2>&1 | grep -q "RUNNING"; then
    echo "✅ OpenClaw is already running!"
    ./bin/clawd status
    exit 0
fi

echo "⚠️  OpenClaw not running, starting..."
echo ""

# Start OpenClaw
./bin/clawd start

echo ""
echo "✅ OpenClaw started!"
echo ""
echo "Quick commands:"
echo "  ./bin/clawd status  - Check status"
echo "  ./bin/clawd logs    - View logs"
echo "  ./bin/clawd stop    - Stop service"
echo ""
