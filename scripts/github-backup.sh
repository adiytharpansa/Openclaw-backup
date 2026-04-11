#!/bin/bash
# GitHub Auto-Backup Script
# Pushes workspace to GitHub private repo automatically

set -e

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
BACKUP_REPO="https://github.com/YOUR_USERNAME/openclaw-backup.git"

echo "🚀 GitHub Auto-Backup"
echo "===================="

cd "$WORKSPACE"

# Check if remote exists
if ! git remote | grep -q origin; then
    echo "⚠️  GitHub remote not configured!"
    echo "Please update script with your GitHub username and run:"
    echo "git remote add origin $BACKUP_REPO"
    exit 1
fi

# Stage all changes
git add -A

# Commit if there are changes
if ! git diff --staged --quiet; then
    TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
    git commit -m "Auto-backup: $TIMESTAMP"
    echo "✅ Changes committed"
else
    echo "ℹ️  No changes to commit"
fi

# Push to GitHub
echo "📤 Pushing to GitHub..."
if git push origin main 2>&1 | grep -q "error"; then
    echo "❌ Push failed. Check credentials."
    exit 1
else
    echo "✅ Pushed to GitHub successfully!"
fi

# Show status
echo ""
echo "📊 GitHub Backup Status:"
git status --short
echo ""
echo "✅ GitHub backup complete!"
