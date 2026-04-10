#!/bin/bash
# =============================================================================
# OPENCLAW BROWSER DEPLOYMENT - AUTOMATED
# =============================================================================
# This script prepares everything for GitHub Pages deployment
# User only needs to: 1) Create repo, 2) Push files, 3) Enable Pages
# =============================================================================

set -e

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
BROWSER_DIR="$WORKSPACE/deploy/browser-runtime"
OUTPUT_DIR="$WORKSPACE/deploy/github-upload"

echo "╔════════════════════════════════════════════════════╗"
echo "║   OPENCLAW BROWSER DEPLOYMENT PREP 🌐              ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# Create output directory
echo "📁 Preparing deployment files..."
mkdir -p "$OUTPUT_DIR"

# Copy browser files
echo "   Copying browser files..."
cp "$BROWSER_DIR/index.html" "$OUTPUT_DIR/"
cp "$BROWSER_DIR/sw.js" "$OUTPUT_DIR/"

# Create README for GitHub
cat > "$OUTPUT_DIR/README.md" << 'EOF'
# 🚀 OpenClaw - Independent Runtime

**85 Skills. 100% Independent. Zero Dependencies.**

## Features

- ✅ 85 AI Skills
- ✅ Browser-based
- ✅ No server needed
- ✅ FREE hosting
- ✅ Works offline
- ✅ Mobile friendly

## Access

Open in any browser: `index.html`

## Deployment

This repository contains OpenClaw browser runtime.

### Enable GitHub Pages:
1. Settings → Pages
2. Source: Deploy from branch
3. Branch: main
4. Save

### Access at:
https://YOUR_USERNAME.github.io/openclaw/

## What is OpenClaw?

OpenClaw is an AI assistant with 85+ skills including:
- Research & Analysis
- Content Creation
- Automation
- Productivity Tools
- And more!

## License

MIT License

---

**Built for maximum independence** 🚀
EOF

# Create .gitignore
cat > "$OUTPUT_DIR/.gitignore" << 'EOF'
# Logs
*.log

# OS files
.DS_Store
Thumbs.db

# Editor files
.vscode/
.idea/
*.swp
EOF

# Create deployment instructions
cat > "$OUTPUT_DIR/DEPLOY-INSTRUCTIONS.md" << 'EOF'
# 🚀 Quick Deploy Instructions

## Step 1: Create GitHub Repository

1. Go to: https://github.com/new
2. Repository name: `openclaw`
3. Make it Public
4. Click "Create repository"

## Step 2: Upload Files

### Option A: Using Git (Recommended)

```bash
# Clone your new repo
git clone https://github.com/YOUR_USERNAME/openclaw.git
cd openclaw

# Copy all files from this folder
cp /path/to/github-upload/* .

# Commit and push
git add .
git commit -m "Deploy OpenClaw browser runtime"
git push origin main
```

### Option B: Using GitHub Web UI

1. In your GitHub repo, click "uploading an existing file"
2. Drag & drop all files from this folder
3. Click "Commit changes"

## Step 3: Enable GitHub Pages

1. Go to Settings → Pages
2. Source: "Deploy from a branch"
3. Branch: "main"
4. Folder: "/" (root)
5. Click "Save"

## Step 4: Done! 🎉

Wait 2-3 minutes, then access:
```
https://YOUR_USERNAME.github.io/openclaw/
```

Replace YOUR_USERNAME with your GitHub username!

## Troubleshooting

**Site not loading?**
- Wait 2-3 minutes for GitHub Pages to build
- Check Settings → Pages is enabled
- Verify files are in main branch

**404 Error?**
- Make sure index.html is in root folder
- Check GitHub Pages is enabled
- Try hard refresh (Ctrl+Shift+R)

---

**Need help?** Check README.md or open an issue!
EOF

echo ""
echo "✅ Deployment files prepared!"
echo ""
echo "📁 Files location: $OUTPUT_DIR"
echo ""
echo "📋 Files prepared:"
ls -la "$OUTPUT_DIR"
echo ""
echo "╔════════════════════════════════════════════════════╗"
echo "║   NEXT STEPS (USER ACTION NEEDED)                  ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""
echo "1️⃣  Create GitHub Repository:"
echo "   👉 https://github.com/new"
echo "   - Name: openclaw"
echo "   - Public"
echo ""
echo "2️⃣  Upload Files:"
echo "   Copy all files from:"
echo "   $OUTPUT_DIR"
echo ""
echo "   OR run these commands:"
echo "   cd $OUTPUT_DIR"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Deploy OpenClaw'"
echo "   git remote add origin https://github.com/YOUR_USERNAME/openclaw.git"
echo "   git push -u origin main"
echo ""
echo "3️⃣  Enable GitHub Pages:"
echo "   Settings → Pages → Deploy from main → Save"
echo ""
echo "4️⃣  Access:"
echo "   https://YOUR_USERNAME.github.io/openclaw/"
echo ""
echo "📋 Full instructions: $OUTPUT_DIR/DEPLOY-INSTRUCTIONS.md"
echo ""
echo "✅ Ready to deploy!"
echo ""
