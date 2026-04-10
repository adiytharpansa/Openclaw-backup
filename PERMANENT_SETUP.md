# 🚀 OpenClaw Permanent Setup Guide

_Make OpenClaw permanently active, fast, and optimized_

---

## ⚡ QUICK START (One Command)

```bash
cd /mnt/data/openclaw/workspace/.openclaw/workspace
sudo ./scripts/ACTIVATE.sh
```

**Done!** OpenClaw is now:
- ✅ Permanently active
- ✅ Auto-start on boot
- ✅ Health-monitored
- ✅ Auto-backed up
- ✅ Performance optimized
- ✅ Watchdog protected

---

## 📋 WHAT THE SCRIPT DOES

### 1. **Systemd Service** 🔄
```
- Installs openclaw.service
- Enables auto-start on boot
- Starts the service immediately
- Auto-restart on failure
```

### 2. **Cron Jobs** ⏰
```
*/5 * * * *  → Health check (every 5 min)
* * * * *    → Watchdog (every 1 min)
0 2 * * *    → Auto-backup (daily at 2 AM)
0 3 * * 0    → Optimization (weekly on Sunday)
```

### 3. **Log Management** 📝
```
Creates:
- /var/log/openclaw/
- /var/log/openclaw/health/
- /var/log/openclaw/backup/
- /var/log/openclaw/watchdog/
- /var/log/openclaw/performance/
```

### 4. **Backup Storage** 💾
```
Creates:
- /mnt/backups/openclaw/
- Auto-cleanup after 30 days
- Compressed backups
```

### 5. **Performance Optimization** ⚡
```
Configures:
- Memory caching (512MB)
- CPU parallel processing (4 workers)
- Disk SSD optimization
- Network connection pooling
- Response compression
```

### 6. **Fast Start Cache** 🚀
```
Creates:
- .cache/skills/
- .cache/configs/
- .cache/responses/
- Pre-loads common operations
```

### 7. **Auto-Restart Protection** 🛡️
```
Sets up:
- Restart counter
- Last restart tracking
- Restart loop prevention
```

### 8. **Verification** ✅
```
Checks:
- Service status
- Cron jobs
- Directories
- Scripts executable
```

---

## 🔧 MANUAL SETUP (Step by Step)

If you prefer manual setup:

### Step 1: Install Systemd Service
```bash
sudo cp scripts/openclaw.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable openclaw
sudo systemctl start openclaw
```

### Step 2: Install Cron Jobs
```bash
crontab -e
# Add:
*/5 * * * * /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/health-check.sh
* * * * * /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/watchdog.sh
0 2 * * * /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/auto-backup.sh
0 3 * * 0 /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/optimize.sh
```

### Step 3: Create Directories
```bash
sudo mkdir -p /var/log/openclaw
sudo mkdir -p /mnt/backups/openclaw
sudo chown -R $USER:$USER /var/log/openclaw
sudo chown -R $USER:$USER /mnt/backups/openclaw
```

### Step 4: Make Scripts Executable
```bash
chmod +x scripts/*.sh
```

### Step 5: Verify
```bash
sudo systemctl status openclaw
crontab -l
ls -la /var/log/openclaw
ls -la /mnt/backups/openclaw
```

---

## 📊 PERFORMANCE CONFIGURATION

### Fast Mode Config
Location: `config/fast-mode.json`

**Key Settings:**
- Response streaming: ✅ Enabled
- Memory cache: 512MB
- CPU workers: 4
- Connection pool: 100
- Response compression: ✅ Enabled

### Performance Targets
| Metric | Target |
|--------|--------|
| Response time | <100ms |
| Throughput | 100 req/s |
| Error rate | <0.1% |
| Uptime | 99.9% |

---

## 🛠️ USEFUL COMMANDS

### Service Management
```bash
# Check status
sudo systemctl status openclaw

# Restart
sudo systemctl restart openclaw

# Stop
sudo systemctl stop openclaw

# View logs (real-time)
sudo journalctl -u openclaw -f

# View last 100 lines
sudo journalctl -u openclaw -n 100
```

### Cron Management
```bash
# View cron jobs
crontab -l

# Edit cron jobs
crontab -e

# Remove all cron jobs
crontab -r
```

### Log Management
```bash
# View health logs
tail -f /var/log/openclaw/health.log

# View backup logs
tail -f /var/log/openclaw/backup.log

# View watchdog logs
tail -f /var/log/openclaw/watchdog.log

# Clean old logs
find /var/log/openclaw -name "*.log" -mtime +30 -delete
```

### Backup Management
```bash
# List backups
ls -lht /mnt/backups/openclaw/

# Restore from backup
tar -xzf /mnt/backups/openclaw/backup-YYYY-MM-DD.tar.gz -C /target/path

# Manual backup
./scripts/auto-backup.sh
```

### Performance Monitoring
```bash
# View performance metrics
cat .cache/performance.json

# Check disk usage
df -h

# Check memory usage
free -h

# View optimization log
tail -f /var/log/openclaw/optimize.log
```

---

## 🔍 TROUBLESHOOTING

### Service Won't Start
```bash
# Check logs
sudo journalctl -u openclaw -n 50

# Try manual start
sudo systemctl start openclaw

# Check config
cat /etc/systemd/system/openclaw.service
```

### Cron Jobs Not Running
```bash
# Verify cron is running
sudo systemctl status cron

# Check cron logs
grep CRON /var/log/syslog

# Test script manually
./scripts/health-check.sh
```

### High Memory Usage
```bash
# Check memory
free -h

# Clear cache
echo 3 | sudo tee /proc/sys/vm/drop_caches

# Restart service
sudo systemctl restart openclaw
```

### Disk Space Low
```bash
# Check disk usage
df -h

# Clean old logs
find /var/log/openclaw -name "*.log" -mtime +30 -delete

# Clean old backups
find /mnt/backups/openclaw -name "*.tar.gz" -mtime +30 -delete

# Clean cache
rm -rf .cache/*
```

---

## 📈 MONITORING DASHBOARD

### Create monitoring script:
```bash
#!/bin/bash
# monitoring.sh

echo "=== OpenClaw Status ==="
echo ""
echo "Service:"
sudo systemctl is-active openclaw
echo ""
echo "Uptime:"
sudo systemctl show openclaw --property=ActiveEnterTimestamp
echo ""
echo "Memory:"
free -h | grep Mem
echo ""
echo "Disk:"
df -h /mnt/data
echo ""
echo "Recent Backups:"
ls -lht /mnt/backups/openclaw/ | head -5
echo ""
echo "Last Health Check:"
cat /var/log/openclaw/health.log | tail -3
```

---

## 🎯 OPTIMIZATION TIPS

### Daily
- Check health logs
- Monitor disk space
- Verify backups

### Weekly
- Run optimization script
- Review performance metrics
- Clean old logs

### Monthly
- Review all logs
- Update skills
- Backup verification
- Performance tuning

---

## ✅ VERIFICATION CHECKLIST

After setup, verify:

- [ ] Service is running: `systemctl is-active openclaw`
- [ ] Auto-start enabled: `systemctl is-enabled openclaw`
- [ ] Cron jobs installed: `crontab -l`
- [ ] Logs directory exists: `ls /var/log/openclaw`
- [ ] Backups directory exists: `ls /mnt/backups/openclaw`
- [ ] Scripts executable: `ls -la scripts/*.sh`
- [ ] Performance config: `cat config/fast-mode.json`
- [ ] Cache directory: `ls .cache/`

---

## 🎉 SUCCESS!

When everything is working:

```
╔════════════════════════════════════════════════════╗
║   OPENCLAW PERMANENT ACTIVATION COMPLETE! 🚀       ║
╚════════════════════════════════════════════════════╝

Status:
  • Systemd service: Active ✅
  • Auto-start on boot: Enabled ✅
  • Health checks: Every 5 min ✅
  • Auto-backup: Daily at 2 AM ✅
  • Watchdog: Every 1 min ✅
  • Performance: Optimized ✅
  • Cache: Enabled ✅

OpenClaw is now PERMANENT, FAST & OPTIMIZED!
```

---

**Next Steps:**
1. Run `sudo ./scripts/ACTIVATE.sh`
2. Verify with checklist above
3. Start using OpenClaw!
4. Monitor performance weekly
5. Enjoy your permanent AI assistant! 🎉

---

_Last updated: 2026-04-10_
**Version:** 1.0.0
**Status:** Production Ready ✅
