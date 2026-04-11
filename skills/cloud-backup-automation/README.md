# 🌐 Cloud Backup Automation

**One-command setup for triple-redundancy cloud backup!**

## Quick Start

```bash
cd /mnt/data/openclaw/workspace/.openclaw/workspace

# Run setup & backup
./scripts/cloud-backup-auto.sh
```

## What It Does

This skill automatically backs up your OpenClaw workspace to:

1. **GitHub** - Unlimited private repos (code + version control)
2. **Telegram** - Unlimited cloud storage (files up to 2GB each)
3. **Google Drive** - 15GB free storage

**Total Cost: $0.00 forever!** 💰

## Setup (First Time Only)

1. Run the script:
   ```bash
   ./scripts/cloud-backup-auto.sh
   ```

2. It will create a `.env` file - edit it with your credentials:
   ```bash
   nano .env
   ```

3. Fill in:
   - GitHub username
   - Telegram API credentials (from https://my.telegram.org/apps)
   - Google Drive folder name (optional)

4. Run the script again - it will setup everything automatically!

## Credentials Needed

### GitHub
- Username: Your GitHub username
- Repo: Will be created automatically (private)

### Telegram
- API ID: From https://my.telegram.org/apps
- API Hash: From https://my.telegram.org/apps  
- Phone: Your Telegram number (e.g., +628123456789)

### Google Drive (Optional)
- Just run `gog auth` once to authenticate

## Features

- ✅ Automatic setup wizard
- ✅ Validates configuration
- ✅ Installs dependencies (telethon)
- ✅ Runs all 3 backups
- ✅ Shows detailed status
- ✅ Error handling
- ✅ Logging

## Manual Usage

If you prefer manual control:

```bash
# GitHub only
./scripts/github-backup.sh

# Telegram only
python3 scripts/telegram-backup.py

# Google Drive only
bash scripts/gdrive-backup.sh

# All at once
./scripts/cloud-backup-auto.sh
```

## Automation

Setup automatic backups with cron:

```bash
crontab -e

# Add:
0 * * * * /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/cloud-backup-auto.sh
```

## Storage

| Service | Free Limit |
|---------|-----------|
| GitHub | Unlimited repos |
| Telegram | Unlimited (2GB/file) |
| Google Drive | 15GB |

## Troubleshooting

**Script says "Missing configuration":**
- Edit `.env` file with your credentials
- Make sure all required fields are filled

**Telegram upload fails:**
- Check API credentials are correct
- Run `pip3 install telethon` manually

**GitHub push fails:**
- Check username and repo name
- Make sure repo exists on GitHub

**Google Drive fails:**
- Run `gog auth` to authenticate
- Check you have storage space

## Support

- Documentation: `FREE_CLOUD_BACKUP.md`
- Quick Start: `QUICK_START_FREE_BACKUP.md`
- Status Check: `./scripts/permanence-check.sh`

---

**Version:** 1.0.0  
**Created:** 2026-04-11  
**Status:** ✅ Production Ready
