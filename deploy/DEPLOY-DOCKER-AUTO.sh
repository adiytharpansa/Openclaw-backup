#!/bin/bash
# =============================================================================
# OPENCLAW DOCKER DEPLOYMENT - AUTOMATED
# =============================================================================
# Build and run Docker container
# Run this on your server (not in sandbox)
# =============================================================================

set -e

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
DEPLOY_DIR="$WORKSPACE/deploy"

echo "╔════════════════════════════════════════════════════╗"
echo "║   OPENCLAW DOCKER DEPLOYMENT 🐳                    ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not installed!"
    echo ""
    echo "Install Docker:"
    echo "  sudo apt update"
    echo "  sudo apt install -y docker.io docker-compose"
    echo "  sudo systemctl start docker"
    echo ""
    exit 1
fi

echo "✅ Docker found: $(docker --version)"
echo ""

# Change to deploy directory
cd "$DEPLOY_DIR"

echo "🐳 Building Docker image..."
echo ""

docker build -t openclaw:latest .

echo ""
echo "╔════════════════════════════════════════════════════╗"
echo "║   IMAGE BUILT! 🎉                                  ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

echo "🚀 Starting container..."
echo ""

# Stop existing container if running
docker stop openclaw 2>/dev/null || true
docker rm openclaw 2>/dev/null || true

# Run container
docker run -d \
    --name openclaw \
    -p 3000:3000 \
    --restart unless-stopped \
    openclaw:latest

echo ""
echo "✅ Container started!"
echo ""
echo "╔════════════════════════════════════════════════════╗"
echo "║   DEPLOYMENT COMPLETE! 🎉                          ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""
echo "🌐 Access OpenClaw:"
echo "   http://localhost:3000"
echo ""
echo "📊 Container Status:"
docker ps --filter name=openclaw --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "🔧 Useful Commands:"
echo "   docker logs openclaw     # View logs"
echo "   docker stop openclaw     # Stop container"
echo "   docker start openclaw    # Start container"
echo "   docker restart openclaw  # Restart container"
echo "   docker rm openclaw       # Remove container"
echo ""
echo "📋 Or use docker-compose:"
echo "   docker-compose up -d     # Start"
echo "   docker-compose down      # Stop"
echo "   docker-compose logs -f   # View logs"
echo ""
