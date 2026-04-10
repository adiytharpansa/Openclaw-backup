# 🚀 OPENCLAW - Quick Start & Permanent Activation

**For:** Sanz (Starboy4043)  
**Platform:** Gensee Crate VM  
**Status:** Production Ready ⚡

---

## 🎯 One-Command Activation

```bash
cd /mnt/data/openclaw/workspace/.openclaw/workspace
sudo ./scripts/ACTIVATE.sh
```

That's it! OpenClaw will now:
- ✅ Auto-start on boot
- ✅ Monitor health every 5 min
- ✅ Watchdog every 1 min
- ✅ Backup daily at 2 AM
- ✅ Optimize weekly

---

## 📋 Quick Status Check

```bash
# Service status
sudo systemctl status openclaw

# View recent logs
sudo journalctl -u openclaw -n 50

# Check cron jobs
crontab -l

# View backup folder
ls -lh /mnt/backups/openclaw/
```

---

## 🛠️ Daily Commands

```bash
# Restart OpenClaw (if needed)
sudo systemctl restart openclaw

# View logs
sudo journalctl -u openclaw -f

# View health log
tail -f /var/log/openclaw/health.log

# Manual backup
sudo /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/auto-backup.sh
```

---

## 📊 Health Dashboard

Check anytime if everything is running:

```bash
# Service running?
sudo systemctl is-active openclaw

# Last restart time
sudo systemctl show openclaw --property=ActiveEnterTimestamp

# Check for errors
sudo journalctl -u openclaw --since "1 hour ago" | grep -i error

# Disk space
df -h /mnt/data
```

---

## 🎨 How to Interact

### Via Telegram
Just message me! OpenClaw responds to all chats.

### Commands
```
/start          - Start new session
/status         - Check OpenClaw status
/skills         - List all available skills
/permanent      - Permanent activation guide
```

---

## 🚀 What Can I Do?

With **89 skills** active, I can:

### 💻 Coding
- Full autonomous coding
- Debug & fix errors
- Code review
- Project scaffolding
- Git automation

### 📧 Communication
- Email management
- Discord/Slack/WhatsApp
- Social media
- Meeting notes

### 📚 Knowledge
- Research & analysis
- Document processing
- YouTube summaries
- Web scraping (ethical)

### 🏠 Smart Home
- Philips Hue lights
- Eight Sleep
- Sonos speakers

### 🔒 Security
- 1Password integration
- Auto-backups
- Health monitoring

### 🎨 Creative
- AI video generation
- Text-to-speech
- Image generation
- Content creation

---

## 💡 Pro Tips

1. **Test me!** Try complex tasks to see my capabilities
2. **Be specific** - The more details, the better I can help
3. **Use my skills** - Mention specific skills when needed
4. **Give feedback** - Help me learn & improve
5. **Check memory** - I remember your preferences

---

## 🔧 Troubleshooting

### Service not running?
```bash
sudo systemctl restart openclaw
sudo systemctl status openclaw
```

### No response?
```bash
# Check logs
sudo journalctl -u openclaw -n 100

# Restart
sudo systemctl restart openclaw
```

### Disk space low?
```bash
# Check usage
df -h

# Clean old backups (older than 30 days)
find /mnt/backups/openclaw/ -type f -mtime +30 -delete
```

---

## 📞 Need Help?

If something breaks:

1. Check logs: `sudo journalctl -u openclaw -f`
2. Run activation: `sudo ./scripts/ACTIVATE.sh`
3. Quick restart: `sudo ./scripts/QUICK-START.sh`
4. Full reinstall: `sudo ./scripts/DEPLOY-LOCAL.sh`

---

**You're ready to go!** 🎉

**OpenClaw is:**
- ✅ Permanent
- ✅ Powerful
- ✅ Stable
- ✅ Secure
- ✅ Active forever!

Let's do this! 🚀

---

_Last updated: 2026-04-10 21:22 UTC_
