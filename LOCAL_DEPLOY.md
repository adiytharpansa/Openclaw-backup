# 🚀 OpenClaw Local Deployment

_Deployed & Ready in Your Current Environment!_

---

## ✅ **DEPLOYMENT STATUS**

```
╔════════════════════════════════════════════════════╗
║   OPENCLAW LOCAL DEPLOYMENT COMPLETE! 🚀           ║
╚════════════════════════════════════════════════════╝

✓ Launcher scripts created
✓ Background runner ready
✓ Stop script ready
✓ Scheduler config created
✓ Local directories setup
✓ All permissions set
```

---

## 🎯 **QUICK START**

### **Start OpenClaw:**
```bash
cd /mnt/data/openclaw/workspace/.openclaw/workspace

# Option 1: Use launcher
./bin/clawd start

# Option 2: Use background script
./scripts/run-background.sh
```

### **Check Status:**
```bash
./bin/clawd status
```

### **View Logs:**
```bash
./bin/clawd logs
# OR
tail -f .local/logs/openclaw.log
```

### **Stop OpenClaw:**
```bash
./bin/clawd stop
# OR
./scripts/stop.sh
```

---

## 📁 **DIRECTORY STRUCTURE**

```
/mnt/data/openclaw/workspace/.openclaw/workspace/
├── bin/
│   ├── clawd          # Main launcher
│   └── openclaw       # Direct launcher
├── .local/
│   ├── bin/           # Local binaries
│   ├── lib/           # Local libraries
│   ├── logs/          # Log files
│   ├── openclaw.pid   # Process ID file
│   └── bashrc_snippet # Shell config
├── scripts/
│   ├── run-background.sh  # Start in background
│   ├── stop.sh            # Stop OpenClaw
│   ├── health-check.sh    # Health monitoring
│   ├── watchdog.sh        # Restart protection
│   └── auto-backup.sh     # Daily backup
├── config/
│   ├── fast-mode.json     # Performance config
│   └── scheduler.json     # Internal scheduler
└── [your workspace files]
```

---

## 🔧 **COMMANDS**

### **Launcher Commands:**
```bash
./bin/clawd start      # Start OpenClaw
./bin/clawd stop       # Stop OpenClaw
./bin/clawd restart    # Restart OpenClaw
./bin/clawd status     # Check status
./bin/clawd logs       # View logs (live)
```

### **Direct Scripts:**
```bash
./scripts/run-background.sh  # Start in background
./scripts/stop.sh            # Stop
./scripts/health-check.sh    # Run health check
./scripts/watchdog.sh        # Run watchdog
./scripts/auto-backup.sh     # Run backup
```

---

## ⚙️ **SCHEDULER CONFIG**

Location: `config/scheduler.json`

**Scheduled Tasks:**
```json
{
  "health_check": "Every 5 minutes",
  "watchdog": "Every 1 minute",
  "auto_backup": "Daily at 2:00 AM",
  "optimize": "Weekly on Sunday at 3:00 AM"
}
```

**Note:** Cron not available in this environment, using internal scheduler.

---

## 📊 **LOGS LOCATION**

| Log Type | Location |
|----------|----------|
| Main Log | `.local/logs/openclaw.log` |
| Health | `.local/logs/health.log` |
| Backup | `.local/logs/backup.log` |
| Watchdog | `.local/logs/watchdog.log` |

**View logs:**
```bash
# Live tail
tail -f .local/logs/openclaw.log

# Last 50 lines
tail -n 50 .local/logs/openclaw.log

# Search logs
grep "ERROR" .local/logs/openclaw.log
```

---

## 🛠️ **SETUP EASY ACCESS (Optional)**

Add to your `~/.bashrc` for easy access:

```bash
# Run this once:
cat /mnt/data/openclaw/workspace/.openclaw/workspace/.local/bashrc_snippet >> ~/.bashrc
source ~/.bashrc
```

**Then you can use:**
```bash
claw              # CD to workspace
clawd start       # Start OpenClaw
clawd status      # Check status
clawd logs        # View logs
```

---

## 🔄 **AUTO-START ON SESSION**

Since we don't have systemd in this environment, add to your shell startup:

**For bash (`~/.bashrc`):**
```bash
# Auto-start OpenClaw on session
if [ -f /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/run-background.sh ]; then
    /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/run-background.sh
fi
```

**Or create a startup script:**
```bash
cat > ~/.openclaw-autostart <<'EOF'
#!/bin/bash
cd /mnt/data/openclaw/workspace/.openclaw/workspace
./scripts/run-background.sh
EOF

chmod +x ~/.openclaw-autostart
# Add to your session startup
```

---

## 📈 **MONITORING**

### **Check if Running:**
```bash
# Method 1: Use launcher
./bin/clawd status

# Method 2: Check PID file
cat .local/openclaw.pid

# Method 3: Check process
ps aux | grep openclaw
```

### **Performance:**
```bash
# View performance config
cat config/fast-mode.json

# Check scheduler
cat config/scheduler.json

# View recent logs
tail -n 100 .local/logs/openclaw.log
```

---

## 🐛 **TROUBLESHOOTING**

### **OpenClaw Won't Start:**
```bash
# Check if already running
./bin/clawd status

# Check logs for errors
tail -n 50 .local/logs/openclaw.log

# Try manual start
python3 -m openclaw start
```

### **High Memory Usage:**
```bash
# Stop and restart
./bin/clawd stop
sleep 2
./bin/clawd start

# Clear cache
rm -rf .cache/*
```

### **Logs Growing Too Large:**
```bash
# Rotate logs manually
mv .local/logs/openclaw.log .local/logs/openclaw.log.old
./bin/clawd start  # Creates new log file

# Or cleanup old logs
find .local/logs -name "*.log" -mtime +7 -delete
```

---

## 🎯 **USAGE EXAMPLES**

### **Daily Workflow:**
```bash
# Morning - Start OpenClaw
./bin/clawd start

# Throughout day - Use via Telegram/Discord
# (OpenClaw handles messages automatically)

# Check status anytime
./bin/clawd status

# Evening - Check logs
./bin/clawd logs

# Night - Keep running (or stop if needed)
./bin/clawd stop
```

### **Weekly Maintenance:**
```bash
# Run optimization
./scripts/optimize.sh

# Check backups
ls -lht /mnt/backups/openclaw/

# Review logs
grep "ERROR" .local/logs/*.log
```

---

## ✅ **VERIFICATION CHECKLIST**

Run these to verify everything is working:

```bash
# 1. Check launcher exists
ls -la bin/clawd

# 2. Check scripts are executable
ls -la scripts/*.sh

# 3. Check directories exist
ls -la .local/

# 4. Check config files
ls -la config/*.json

# 5. Start OpenClaw
./bin/clawd start

# 6. Check status
./bin/clawd status

# 7. View logs
tail -n 20 .local/logs/openclaw.log
```

---

## 🎉 **YOU'RE READY!**

```
╔════════════════════════════════════════════════════╗
║   OPENCLAW IS READY TO USE! 🚀                     ║
╚════════════════════════════════════════════════════╝

Start: ./bin/clawd start
Status: ./bin/clawd status
Logs: ./bin/clawd logs
Stop: ./bin/clawd stop

Workspace: /mnt/data/openclaw/workspace/.openclaw/workspace
Logs: /mnt/data/openclaw/workspace/.openclaw/workspace/.local/logs
```

**No SSH needed. No sudo needed. Just works!** ✅

---

_Last updated: 2026-04-10_
**Version:** 1.0.0
**Status:** ✅ Deployed & Ready
