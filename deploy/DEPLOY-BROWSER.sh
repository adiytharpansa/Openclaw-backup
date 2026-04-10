#!/bin/bash
# =============================================================================
# OPENCLAW BROWSER DEPLOYMENT
# =============================================================================
# Deploy OpenClaw to GitHub Pages for browser-based independent runtime
# FREE hosting, zero dependencies, accessible from anywhere
# =============================================================================

set -e

echo "╔════════════════════════════════════════════════════╗"
echo "║   OPENCLAW BROWSER DEPLOYMENT 🌐                   ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# Configuration
BROWSER_DIR="/mnt/data/openclaw/workspace/.openclaw/workspace/deploy/browser-runtime"
GITHUB_USER="${GITHUB_USER:-your-username}"
REPO_NAME="${REPO_NAME:-openclaw}"

echo "📁 Browser runtime location: $BROWSER_DIR"
echo ""

# Check if files exist
if [ ! -f "$BROWSER_DIR/index.html" ]; then
    echo "❌ Error: index.html not found in $BROWSER_DIR"
    exit 1
fi

echo "✅ Browser runtime files found"
echo ""

# Instructions
echo "╔════════════════════════════════════════════════════╗"
echo "║   DEPLOYMENT INSTRUCTIONS                          ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""
echo "Follow these steps to deploy to GitHub Pages:"
echo ""
echo "1️⃣  Create GitHub Repository"
echo "   - Go to https://github.com/new"
echo "   - Repository name: openclaw (or your choice)"
echo "   - Make it Public"
echo "   - Click 'Create repository'"
echo ""
echo "2️⃣  Clone Repository"
echo "   cd /tmp"
echo "   git clone https://github.com/$GITHUB_USER/$REPO_NAME.git"
echo "   cd $REPO_NAME"
echo ""
echo "3️⃣  Copy Browser Files"
echo "   cp -r $BROWSER_DIR/* ."
echo ""
echo "4️⃣  Commit & Push"
echo "   git add ."
echo "   git commit -m 'Deploy OpenClaw browser runtime'"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "5️⃣  Enable GitHub Pages"
echo "   - Go to: https://github.com/$GITHUB_USER/$REPO_NAME/settings/pages"
echo "   - Source: Deploy from branch"
echo "   - Branch: main"
echo "   - Folder: / (root)"
echo "   - Click Save"
echo ""
echo "6️⃣  Access Your OpenClaw!"
echo "   - Wait 2-3 minutes for deployment"
echo "   - Access at: https://$GITHUB_USER.github.io/$REPO_NAME/"
echo ""
echo "╔════════════════════════════════════════════════════╗"
echo "║   ALTERNATIVE: One-Command Deploy                  ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""
echo "If you have GitHub CLI (gh) installed:"
echo ""
echo "   cd $BROWSER_DIR"
echo "   gh repo create $REPO_NAME --public --source=. --push"
echo "   # Then enable Pages in settings"
echo ""
echo "╔════════════════════════════════════════════════════╗"
echo "║   RESULT                                           ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""
echo "✅ FREE hosting forever"
echo "✅ Accessible from any browser"
echo "✅ No server needed"
echo "✅ Zero dependencies"
echo "✅ Works on mobile"
echo "✅ Offline capable (Service Worker)"
echo "✅ 100% independent"
echo ""
echo "Your OpenClaw will be available at:"
echo "🌐 https://$GITHUB_USER.github.io/$REPO_NAME/"
echo ""
echo "Ready to deploy? Follow the steps above! 🚀"
echo ""
