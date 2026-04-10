#!/bin/bash
# =============================================================================
# OPENCLAW EXECUTABLE BUILD - AUTOMATED
# =============================================================================
# Build standalone executable that runs anywhere
# Run this on your local machine (not in sandbox)
# =============================================================================

set -e

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
DEPLOY_DIR="$WORKSPACE/deploy"

echo "╔════════════════════════════════════════════════════╗"
echo "║   OPENCLAW EXECUTABLE BUILD 📦                     ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# Check if PyInstaller is installed
if ! command -v pyinstaller &> /dev/null; then
    echo "📦 Installing PyInstaller..."
    pip3 install pyinstaller
fi

echo "✅ PyInstaller found: $(pyinstaller --version)"
echo ""

# Change to deploy directory
cd "$DEPLOY_DIR"

echo "🔨 Building executable..."
echo ""

# Build executable
pyinstaller --onefile --name openclaw main.py \
    --add-data "browser-runtime:browser-runtime" \
    --hidden-import http.server \
    2>&1 | tail -20

echo ""
echo "╔════════════════════════════════════════════════════╗"
echo "║   BUILD COMPLETE! 🎉                               ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# Check if build was successful
if [ -f "dist/openclaw" ] || [ -f "dist/openclaw.exe" ]; then
    echo "✅ Executable created successfully!"
    echo ""
    echo "📦 Location:"
    if [ -f "dist/openclaw" ]; then
        echo "   Linux/Mac: $DEPLOY_DIR/dist/openclaw"
        ls -lh dist/openclaw
    fi
    if [ -f "dist/openclaw.exe" ]; then
        echo "   Windows: $DEPLOY_DIR/dist/openclaw.exe"
        ls -lh dist/openclaw.exe
    fi
    echo ""
    echo "🚀 Run it:"
    echo "   ./dist/openclaw"
    echo ""
    echo "📱 Or copy to USB drive for portability!"
    echo ""
else
    echo "❌ Build failed! Check errors above."
    exit 1
fi
