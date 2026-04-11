# 🤖 Auto Backup Master

**Fully Automated Backup - Zero Configuration!**

## Quick Start

```bash
cd /mnt/data/openclaw/workspace/.openclaw/workspace
./scripts/auto-backup-master.sh
```

That's it! The script will automatically:
- ✅ Detect available backup methods
- ✅ Use what's available without credentials
- ✅ Skip what needs auth (with helpful tips)
- ✅ Give you a complete status report

## What It Does

### Tier 1: Works Immediately (No Auth)
- ✅ Local hourly/daily backups
- ✅ Git version control
- ✅ IPFS decentralized storage (if installed)
- ✅ Internet Archive (Wayback Machine)

### Tier 2: Optional Browser Auth
- ☑️ GitHub (via `gh auth login`)
- ☑️ GitLab (via `glab auth login`)
- ☑️ Multi-cloud via rclone

## Features

| Feature | Tier 1 | Tier 2 |
|---------|--------|--------|
| **Setup Time** | 0 min | 2 min |
| **Credentials** | None | Browser auth |
| **Storage** | Local + IPFS | GitHub/GitLab/Cloud |
| **Permanence** | 95% | 99% |

## Status Check

```bash
./scripts/backup-status.sh
```

Shows:
- Backup counts
- Git status
- Cloud services
- Overall score
- Recommendations

## Automation

Setup automatic backups:

```bash
# Edit crontab
crontab -e

# Add these lines:
0 * * * * /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/auto-backup-master.sh --tier1
0 2 * * * /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/daily-backup.sh
```

## Logs

Backup logs are saved to:
```
logs/backup/auto-backup-YYYYMMDD_HHMM.log
```

## Troubleshooting

**"No backups found"**
- Run once to create initial backup
- Check `backups/enhanced/` directory

**"Git not initialized"**
- Run: `git init`
- Run: `git add -A && git commit -m "Initial"`

**"IPFS not available"**
- Optional feature, skip or install: `sudo apt install ipfs`

## Benefits

- ✅ **Zero Config** - Just run it
- ✅ **Progressive** - Gets better with more auth
- ✅ **Resilient** - Continues on failures
- ✅ **Transparent** - Clear status reporting
- ✅ **Free** - All methods are free

---

**Version:** 1.0.0  
**Created:** 2026-04-11  
**Status:** ✅ Ready to Use
