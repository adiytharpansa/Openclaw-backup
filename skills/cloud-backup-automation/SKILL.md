# 🌐 Cloud Backup Automation Skill

Automated triple-redundancy backup to GitHub, Telegram, and Google Drive - 100% FREE, no credit card required!

## Features

- ✅ **GitHub Backup** - Unlimited private repos
- ✅ **Telegram Backup** - Unlimited cloud storage (2GB/file)
- ✅ **Google Drive Backup** - 15GB free storage
- ✅ **Auto-Scheduling** - Hourly, daily, or manual
- ✅ **Zero Configuration** - Simple setup wizard
- ✅ **Cost: $0.00** - Forever free!

## Installation

This skill is already installed! Just run the setup:

```bash
cd /mnt/data/openclaw/workspace/.openclaw/workspace
./scripts/cloud-backup-auto.sh
```

## Quick Setup (Interactive)

The setup wizard will guide you through:

1. **GitHub Setup** (2 min)
   - Create account (if needed)
   - Create private repo
   - Auto-configure git remote

2. **Telegram Setup** (1 min)
   - Get API credentials
   - Auto-install dependencies
   - Test unlimited upload

3. **Google Drive Setup** (1 min)
   - Authenticate with Google
   - Create backup folder
   - Test upload

Total time: **~5 minutes**

## Usage

### Run All Backups
```bash
./scripts/cloud-backup-auto.sh
```

### Run Individual Backup
```bash
# GitHub only
./scripts/github-backup.sh

# Telegram only
python3 scripts/telegram-backup.py

# Google Drive only
bash scripts/gdrive-backup.sh
```

### Check Status
```bash
./scripts/permanence-check.sh
```

## Configuration

Create `.env` file in workspace root:

```bash
# GitHub
GITHUB_USERNAME=your_username
GITHUB_REPO=openclaw-backup

# Telegram
TELEGRAM_API_ID=your_api_id
TELEGRAM_API_HASH=your_api_hash
TELEGRAM_PHONE=+62xxx

# Google Drive (auto-authenticated via gog CLI)
GDRIVE_FOLDER=OpenClaw-Backup
```

## Automation

Setup cron jobs for automatic backups:

```bash
# Edit crontab
crontab -e

# Add these lines:
0 * * * * cd /mnt/data/openclaw/workspace/.openclaw/workspace && ./scripts/github-backup.sh
0 2 * * * cd /mnt/data/openclaw/workspace/.openclaw/workspace && python3 scripts/telegram-backup.py
0 3 * * * cd /mnt/data/openclaw/workspace/.openclaw/workspace && bash scripts/gdrive-backup.sh
```

## Storage Limits

| Service | Free Limit | Notes |
|---------|-----------|-------|
| GitHub | Unlimited repos | 500MB LFS free |
| Telegram | Unlimited total | 2GB per file |
| Google Drive | 15GB | Shared with Gmail |

## Troubleshooting

### GitHub Push Fails
```bash
# Check remote URL
git remote -v

# Update if needed
git remote set-url origin https://github.com/USERNAME/REPO.git

# Test push
git push origin main
```

### Telegram Upload Fails
```bash
# Check credentials
export TELEGRAM_API_ID='xxx'
export TELEGRAM_API_HASH='xxx'
export TELEGRAM_PHONE='+62xxx'

# Reinstall telethon
pip3 install --upgrade telethon
```

### Google Drive Auth Fails
```bash
# Re-authenticate
gog auth

# Check storage
gog drive about
```

## Benefits

- **99% Permanence** - Triple redundancy
- **Zero Cost** - All services free
- **No Credit Card** - Never required
- **Unlimited Storage** - Telegram has no limits
- **Version Control** - GitHub tracks every change
- **Disaster Recovery** - Ready to deploy anywhere

## Support

For issues or questions:
1. Check logs in `logs/backup/`
2. Run `./scripts/permanence-check.sh`
3. Review documentation in `FREE_CLOUD_BACKUP.md`

---

**Created:** 2026-04-11  
**Version:** 1.0.0  
**Status:** ✅ Production Ready
