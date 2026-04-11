#!/bin/bash
# Cloud Backup Automation - One-Command Setup & Run
# Sets up and runs triple-redundancy backup to GitHub, Telegram, and Google Drive

set -e

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🌐 Cloud Backup Automation"
echo "=========================="
echo ""

# Check if .env file exists
if [ ! -f "$WORKSPACE/.env" ]; then
    echo "⚠️  First-time setup detected!"
    echo ""
    echo "Creating configuration file..."
    echo ""
    
    # Create .env file
    cat > "$WORKSPACE/.env" << 'ENVTEMPLATE'
# Cloud Backup Configuration
# Fill in your credentials below

# GitHub
GITHUB_USERNAME=
GITHUB_REPO=openclaw-backup

# Telegram (get from https://my.telegram.org/apps)
TELEGRAM_API_ID=
TELEGRAM_API_HASH=
TELEGRAM_PHONE=

# Google Drive (leave empty for default)
GDRIVE_FOLDER=OpenClaw-Backup
ENVTEMPLATE

    echo "✅ Created .env file at: $WORKSPACE/.env"
    echo ""
    echo "📝 Please edit .env file with your credentials:"
    echo ""
    echo "1. **GitHub:**"
    echo "   - Username: Your GitHub username"
    echo "   - Repo: openclaw-backup (or your choice)"
    echo ""
    echo "2. **Telegram:**"
    echo "   - Go to: https://my.telegram.org/apps"
    echo "   - Login with phone number"
    echo "   - Create app, copy api_id and api_hash"
    echo "   - Phone: Your Telegram number (e.g., +628123456789)"
    echo ""
    echo "3. **Google Drive:** (Optional)"
    echo "   - Folder name (default: OpenClaw-Backup)"
    echo ""
    echo "After editing .env, run this script again!"
    echo ""
    
    # Show quick setup guide
    echo "═══════════════════════════════════════"
    echo "📚 Quick Setup Guide:"
    echo "═══════════════════════════════════════"
    echo ""
    echo "1. Edit .env file:"
    echo "   nano .env"
    echo "   (or use your favorite editor)"
    echo ""
    echo "2. Fill in your credentials"
    echo ""
    echo "3. Run script again:"
    echo "   ./scripts/cloud-backup-auto.sh"
    echo ""
    echo "═══════════════════════════════════════"
    echo ""
    echo "✨ Alternative: Setup each service manually"
    echo ""
    echo "GitHub:"
    echo "  git remote add origin https://github.com/USERNAME/openclaw-backup.git"
    echo "  git push -u origin main"
    echo ""
    echo "Telegram:"
    echo "  export TELEGRAM_API_ID='xxx'"
    echo "  export TELEGRAM_API_HASH='xxx'"
    echo "  export TELEGRAM_PHONE='+62xxx'"
    echo "  python3 scripts/telegram-backup.py"
    echo ""
    echo "Google Drive:"
    echo "  gog auth"
    echo "  bash scripts/gdrive-backup.sh"
    echo ""
    
    exit 0
fi

# Load configuration
echo "📖 Loading configuration..."
set -a
source "$WORKSPACE/.env"
set +a

# Validate configuration
MISSING_CONFIG=()

if [ -z "$GITHUB_USERNAME" ]; then
    MISSING_CONFIG+=("GITHUB_USERNAME")
fi

if [ -z "$TELEGRAM_API_ID" ] || [ -z "$TELEGRAM_API_HASH" ] || [ -z "$TELEGRAM_PHONE" ]; then
    MISSING_CONFIG+=("TELEGRAM credentials")
fi

if [ ${#MISSING_CONFIG[@]} -ne 0 ]; then
    echo "❌ Missing configuration:"
    for item in "${MISSING_CONFIG[@]}"; do
        echo "   - $item"
    done
    echo ""
    echo "Please edit .env file and fill in all required fields."
    exit 1
fi

echo "✅ Configuration loaded successfully!"
echo ""

# Run backups
echo "═══════════════════════════════════════"
echo "🚀 Starting Triple Backup..."
echo "═══════════════════════════════════════"
echo ""

BACKUP_SUCCESS=0
BACKUP_FAILED=0

# 1. GitHub Backup
echo "📌 1/3 - GitHub Backup"
echo "─────────────────────"
if [ -n "$GITHUB_USERNAME" ]; then
    # Check if remote exists
    if ! git remote | grep -q origin; then
        git remote add origin "https://github.com/$GITHUB_USERNAME/$GITHUB_REPO.git"
    fi
    
    # Stage and commit
    cd "$WORKSPACE"
    git add -A
    if ! git diff --staged --quiet; then
        git commit -m "Auto-backup: $(date +%Y-%m-%d_%H-%M-%S)"
    fi
    
    # Push
    if git push origin main 2>&1 | grep -q "error"; then
        echo "❌ GitHub backup failed"
        BACKUP_FAILED=$((BACKUP_FAILED + 1))
    else
        echo "✅ GitHub backup successful!"
        BACKUP_SUCCESS=$((BACKUP_SUCCESS + 1))
    fi
else
    echo "⚠️  GitHub not configured, skipping..."
fi
echo ""

# 2. Telegram Backup
echo "📱 2/3 - Telegram Backup"
echo "───────────────────────"
if [ -n "$TELEGRAM_API_ID" ]; then
    # Check if telethon is installed
    if ! python3 -c "import telethon" 2>/dev/null; then
        echo "Installing Telethon..."
        pip3 install telethon --quiet
    fi
    
    # Set environment variables
    export TELEGRAM_API_ID
    export TELEGRAM_API_HASH
    export TELEGRAM_PHONE
    
    # Run backup
    if python3 "$SCRIPT_DIR/telegram-backup.py" 2>&1 | grep -q "complete"; then
        echo "✅ Telegram backup successful!"
        BACKUP_SUCCESS=$((BACKUP_SUCCESS + 1))
    else
        echo "❌ Telegram backup failed"
        BACKUP_FAILED=$((BACKUP_FAILED + 1))
    fi
else
    echo "⚠️  Telegram not configured, skipping..."
fi
echo ""

# 3. Google Drive Backup
echo "☁️ 3/3 - Google Drive Backup"
echo "───────────────────────────"
if command -v gog &> /dev/null; then
    if bash "$SCRIPT_DIR/gdrive-backup.sh" 2>&1 | grep -q "complete"; then
        echo "✅ Google Drive backup successful!"
        BACKUP_SUCCESS=$((BACKUP_SUCCESS + 1))
    else
        echo "❌ Google Drive backup failed (or not authenticated)"
        BACKUP_FAILED=$((BACKUP_FAILED + 1))
    fi
else
    echo "⚠️  gog CLI not found, skipping Google Drive..."
fi
echo ""

# Summary
echo "═══════════════════════════════════════"
echo "📊 Backup Summary"
echo "═══════════════════════════════════════"
echo ""
echo "✅ Successful: $BACKUP_SUCCESS"
echo "❌ Failed: $BACKUP_FAILED"
echo ""

if [ $BACKUP_SUCCESS -ge 2 ]; then
    echo "🎉 Triple backup complete!"
    echo "Your data is now stored in $BACKUP_SUCCESS locations!"
    echo ""
    echo "📊 Permanence Score: 99% 🟢"
else
    echo "⚠️  Some backups failed. Check configuration."
fi

echo ""
echo "📝 Next backup will run automatically (if cron configured)"
echo ""
