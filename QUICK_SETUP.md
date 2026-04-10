# 🚀 Quick Setup Guide - OpenClaw Production

_5 minutes to stable, permanent OpenClaw_

---

## ⚡ FASTEST SETUP (One Command)

```bash
# Clone/copy workspace to your server
cd /mnt/data/openclaw/workspace/.openclaw/workspace

# Run installation script
sudo ./scripts/INSTALL.sh
```

**Done!** ✅ OpenClaw is now:
- Auto-starting on boot
- Health-checked every 5 minutes
- Backed up daily
- Monitored 24/7

---

## 📋 MANUAL SETUP (Step by Step)

### Step 1: Install Systemd Service

```bash
# Copy service file
sudo cp scripts/openclaw.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload
```

### Step 2: Enable Auto-Start

```bash
# Enable on boot
sudo systemctl enable openclaw

# Start now
sudo systemctl start openclaw

# Verify
sudo systemctl status openclaw
```

### Step 3: Setup Health Monitoring

```bash
# Make scripts executable
chmod +x scripts/health-check.sh
chmod +x scripts/watchdog.sh
chmod +x scripts/auto-backup.sh

# Add to crontab
crontab -e

# Add these lines:
*/5 * * * * /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/health-check.sh
* * * * * /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/watchdog.sh
0 2 * * * /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/auto-backup.sh
```

### Step 4: Create Directories

```bash
# Create backup directory
sudo mkdir -p /mnt/backups/openclaw
sudo chown node:node /mnt/backups/openclaw

# Create log directory
sudo mkdir -p /var/log/openclaw
sudo chown node:node /var/log/openclaw
```

### Step 5: Verify Everything

```bash
# Check service
sudo systemctl status openclaw

# Check health
./scripts/health-check.sh

# Test backup
./scripts/auto-backup.sh

# View logs
sudo journalctl -u openclaw -f
```

---

## 🔧 USEFUL COMMANDS

### Service Management
```bash
sudo systemctl start openclaw      # Start
sudo systemctl stop openclaw       # Stop
sudo systemctl restart openclaw    # Restart
sudo systemctl status openclaw     # Status
sudo systemctl enable openclaw     # Enable auto-start
sudo systemctl disable openclaw    # Disable auto-start
```

### Logs
```bash
sudo journalctl -u openclaw -f           # Real-time logs
sudo journalctl -u openclaw -n 100       # Last 100 lines
sudo journalctl -u openclaw --since today  # Today's logs
```

### Health & Monitoring
```bash
./scripts/health-check.sh          # Run health check
./scripts/watchdog.sh              # Run watchdog
./scripts/auto-backup.sh           # Run backup
crontab -l                         # View cron jobs
```

### Backups
```bash
ls -lht /mnt/backups/openclaw/     # List backups
tar -tzf /mnt/backups/openclaw/backup_*.tar.gz  # View backup contents
```

---

## 🚨 TROUBLESHOOTING

### Service Won't Start
```bash
# Check status
sudo systemctl status openclaw

# View recent logs
sudo journalctl -u openclaw -n 50

# Test configuration
sudo systemd-analyze verify /etc/systemd/system/openclaw.service

# Check file permissions
ls -la /etc/systemd/system/openclaw.service
```

### Health Check Failing
```bash
# Run manually
./scripts/health-check.sh

# Check logs
cat /var/log/openclaw-health.log

# Verify service is running
sudo systemctl is-active openclaw
```

### Backup Failing
```bash
# Check disk space
df -h /mnt/backups

# Check permissions
ls -la /mnt/backups/openclaw

# Run manually
./scripts/auto-backup.sh
```

### Too Many Restarts
```bash
# Check watchdog log
cat /var/log/openclaw-watchdog.log

# Check restart count
cat /var/log/openclaw-restarts.log

# Manual intervention needed if >5 restarts in 5 min
```

---

## 📊 MONITORING

### Quick Status Check
```bash
# Service status
systemctl is-active openclaw

# Uptime
systemctl show openclaw | grep ActiveEnterTimestamp

# Memory usage
systemctl show openclaw | grep Memory

# CPU usage
systemctl show openclaw | grep CPU
```

### Dashboard (Optional)
Setup Grafana + Prometheus for visual monitoring:
- CPU/Memory usage
- Request rate
- Error rate
- Session count

---

## 🔄 UPDATES

### Manual Update
```bash
# Stop service
sudo systemctl stop openclaw

# Update code
cd /mnt/data/openclaw/workspace/.openclaw/workspace
git pull

# Install dependencies
npm install

# Restart
sudo systemctl start openclaw

# Verify
sudo systemctl status openclaw
```

### Auto-Update (Optional)
Setup automatic updates via:
- Watchtower (Docker)
- Unattended upgrades (apt)
- Custom update script

---

## 🛡️ SECURITY

### Firewall
```bash
# Allow necessary ports
sudo ufw allow 22/tcp     # SSH
sudo ufw allow 8080/tcp   # OpenClaw
sudo ufw enable
```

### Auto Security Updates
```bash
# Install unattended-upgrades
sudo apt install unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

---

## 📞 SUPPORT

If you encounter issues:

1. **Check logs first**
   ```bash
   sudo journalctl -u openclaw -n 100
   ```

2. **Run health check**
   ```bash
   ./scripts/health-check.sh
   ```

3. **Check documentation**
   - OPENCLAW_STABILITY.md
   - https://docs.openclaw.ai

4. **Community support**
   - Discord: https://discord.com/invite/clawd

---

**Setup Time:** ~5 minutes  
**Status:** Production Ready ✅  
**Last Updated:** 2026-04-10
