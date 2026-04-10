# 🛡️ OpenClaw Stability & Permanence Guide

_Make OpenClaw stable, reliable, and always available_

---

## 🎯 **STABILITY PILLARS**

1. **Auto-Start** - Starts automatically on boot
2. **Health Monitoring** - Detects & fixes issues
3. **Error Recovery** - Auto-restart on failures
4. **Resource Management** - Prevents overload
5. **Backup & Recovery** - Never lose data
6. **Logging** - Debug issues quickly
7. **Updates** - Stay current without breaking

---

## 1️⃣ **AUTO-START ON BOOT**

### Systemd Service (Linux)

Create `/etc/systemd/system/openclaw.service`:

```ini
[Unit]
Description=OpenClaw AI Assistant
After=network.target
Wants=network-online.target

[Service]
Type=simple
User=node
WorkingDirectory=/mnt/data/openclaw/workspace/.openclaw/workspace
ExecStart=/usr/bin/node /path/to/openclaw/index.js
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
SyslogIdentifier=openclaw

# Environment
Environment="NODE_ENV=production"
Environment="WORKSPACE=/mnt/data/openclaw/workspace/.openclaw/workspace"

# Resource limits
LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
```

**Commands:**
```bash
# Enable auto-start
sudo systemctl enable openclaw

# Start now
sudo systemctl start openclaw

# Check status
sudo systemctl status openclaw

# View logs
sudo journalctl -u openclaw -f

# Restart
sudo systemctl restart openclaw
```

### Docker Auto-Restart

If using Docker:

```yaml
# docker-compose.yml
services:
  openclaw:
    image: openclaw/latest
    restart: unless-stopped
    # or: restart: always
```

---

## 2️⃣ **HEALTH MONITORING**

### Health Check Script

Create `scripts/health-check.sh`:

```bash
#!/bin/bash
# Health check for OpenClaw

HEALTH_FILE="/tmp/openclaw-health"
TIMESTAMP=$(date +%s)

# Check if process is running
if pgrep -f "openclaw" > /dev/null; then
    echo "OK - Process running" > $HEALTH_FILE
    exit 0
else
    echo "CRITICAL - Process not running" > $HEALTH_FILE
    
    # Try to restart
    echo "Attempting restart..."
    sudo systemctl restart openclaw
    
    sleep 10
    
    if pgrep -f "openclaw" > /dev/null; then
        echo "OK - Restarted successfully" > $HEALTH_FILE
        exit 0
    else
        echo "CRITICAL - Restart failed" > $HEALTH_FILE
        exit 1
    fi
fi
```

### Cron Job for Health Check

```bash
# Add to crontab (crontab -e)
*/5 * * * * /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/health-check.sh
```

---

## 3️⃣ **ERROR RECOVERY**

### Auto-Restart Configuration

**Systemd** (already in service file above):
```ini
Restart=always
RestartSec=10
```

**Docker**:
```yaml
restart: on-failure:5
# or
restart: always
```

### Watchdog Script

Create `scripts/watchdog.sh`:

```bash
#!/bin/bash
# Watchdog for OpenClaw

LOG_FILE="/var/log/openclaw-watchdog.log"
MAX_RESTARTS=5
RESTART_WINDOW=300  # 5 minutes

restart_count=0
current_time=$(date +%s)

# Count restarts in window
recent_restarts=$(grep -c "RESTART" /var/log/openclaw-restart.log 2>/dev/null || echo 0)

if [ $recent_restarts -gt $MAX_RESTARTS ]; then
    echo "$(date): Too many restarts, manual intervention needed" >> $LOG_FILE
    exit 1
fi

# Check and restart if needed
if ! pgrep -f "openclaw" > /dev/null; then
    echo "$(date): Process not found, restarting..." >> $LOG_FILE
    sudo systemctl restart openclaw
    echo "$(date): RESTART" >> /var/log/openclaw-restart.log
fi
```

---

## 4️⃣ **RESOURCE MANAGEMENT**

### Memory Limits

**Systemd**:
```ini
[Service]
MemoryMax=2G
MemoryHigh=1536M
```

**Docker**:
```yaml
services:
  openclaw:
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 1G
```

### CPU Limits

**Systemd**:
```ini
[Service]
CPUQuota=80%
```

**Docker**:
```yaml
services:
  openclaw:
    deploy:
      resources:
        limits:
          cpus: '2.0'
```

### Disk Space Monitoring

Create `scripts/disk-monitor.sh`:

```bash
#!/bin/bash
# Monitor disk space

THRESHOLD=85
WORKSPACE="/mnt/data/openclaw/workspace"

usage=$(df $WORKSPACE | tail -1 | awk '{print $5}' | sed 's/%//')

if [ $usage -gt $THRESHOLD ]; then
    echo "WARNING: Disk usage at ${usage}%"
    # Send notification
    # Clean old logs
    # Alert admin
fi
```

---

## 5️⃣ **BACKUP & RECOVERY**

### Automated Backup Script

Create `scripts/auto-backup.sh`:

```bash
#!/bin/bash
# Automated backup for OpenClaw

BACKUP_DIR="/mnt/backups/openclaw"
DATE=$(date +%Y%m%d_%H%M%S)
WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"

# Create backup
mkdir -p $BACKUP_DIR
tar -czf $BACKUP_DIR/backup_$DATE.tar.gz \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='backups' \
    $WORKSPACE

# Keep only last 30 days
find $BACKUP_DIR -name "backup_*.tar.gz" -mtime +30 -delete

echo "Backup completed: backup_$DATE.tar.gz"
```

### Cron for Auto-Backup

```bash
# Daily backup at 2 AM
0 2 * * * /mnt/data/openclaw/workspace/.openclaw/workspace/scripts/auto-backup.sh
```

### Database Backup (if using PostgreSQL)

```bash
#!/bin/bash
# Database backup

pg_dump -U clawd clawdb > /mnt/backups/db_$(date +%Y%m%d_%H%M%S).sql
```

---

## 6️⃣ **LOGGING**

### Centralized Logging

**Systemd Journal**:
```bash
# View logs
sudo journalctl -u openclaw -f

# Last 100 lines
sudo journalctl -u openclaw -n 100

# Since boot
sudo journalctl -u openclaw -b
```

### Log Rotation

Create `/etc/logrotate.d/openclaw`:

```
/var/log/openclaw/*.log {
    daily
    rotate 30
    compress
    delaycompress
    missingok
    notifempty
    create 0640 node node
    postrotate
        systemctl reload openclaw > /dev/null 2>&1 || true
    endscript
}
```

### Application Logging

In OpenClaw config:

```javascript
{
  logging: {
    level: 'info',  // debug, info, warn, error
    format: 'json',
    output: '/var/log/openclaw/app.log',
    maxFiles: '30d',
    maxSize: '100m'
  }
}
```

---

## 7️⃣ **UPDATES WITHOUT DOWNTIME**

### Blue-Green Deployment

```bash
#!/bin/bash
# Zero-downtime update

# 1. Download new version
wget https://github.com/openclaw/openclaw/releases/latest/download/openclaw.tar.gz

# 2. Extract to staging
tar -xzf openclaw.tar.gz -C /opt/openclaw-staging

# 3. Run tests
cd /opt/openclaw-staging && npm test

# 4. Swap versions
systemctl stop openclaw
rm -rf /opt/openclaw-current
mv /opt/openclaw-staging /opt/openclaw-current
systemctl start openclaw

# 5. Health check
sleep 10
if curl -f http://localhost:8080/health; then
    echo "Update successful"
else
    echo "Update failed, rolling back"
    # Rollback logic
fi
```

### Auto-Update Script

Create `scripts/auto-update.sh`:

```bash
#!/bin/bash
# Auto-update OpenClaw

CURRENT_VERSION=$(openclaw --version)
LATEST_VERSION=$(curl -s https://api.github.com/repos/openclaw/openclaw/releases/latest | jq -r .tag_name)

if [ "$CURRENT_VERSION" != "$LATEST_VERSION" ]; then
    echo "Update available: $CURRENT_VERSION → $LATEST_VERSION"
    
    # Download and update
    # (include update logic here)
    
    # Restart service
    sudo systemctl restart openclaw
    
    # Verify
    if systemctl is-active --quiet openclaw; then
        echo "Update successful"
    else
        echo "Update failed, rolling back"
        # Rollback logic
    fi
fi
```

---

## 8️⃣ **MONITORING DASHBOARD**

### Prometheus Metrics

Export these metrics:
- `openclaw_uptime_seconds`
- `openclaw_memory_usage_bytes`
- `openclaw_requests_total`
- `openclaw_errors_total`
- `openclaw_session_count`

### Grafana Dashboard

Import dashboard with panels for:
- CPU/Memory usage
- Request rate
- Error rate
- Session count
- Response time
- Disk usage

### Alert Rules

```yaml
groups:
  - name: openclaw
    rules:
      - alert: OpenClawDown
        expr: up{job="openclaw"} == 0
        for: 1m
        annotations:
          summary: "OpenClaw is down"
          
      - alert: HighMemoryUsage
        expr: openclaw_memory_usage_bytes / 1073741824 > 1.5
        for: 5m
        annotations:
          summary: "OpenClaw memory > 1.5GB"
          
      - alert: HighErrorRate
        expr: rate(openclaw_errors_total[5m]) > 0.1
        for: 5m
        annotations:
          summary: "High error rate detected"
```

---

## 9️⃣ **NETWORK RELIABILITY**

### Connection Pooling

```javascript
// Configure connection pool
{
  connections: {
    maxPoolSize: 10,
    minPoolSize: 2,
    idleTimeout: 30000,
    acquireTimeout: 5000
  }
}
```

### Retry Logic

```javascript
// Retry configuration
{
  retries: {
    maxAttempts: 3,
    backoff: 'exponential',
    baseDelay: 1000,
    maxDelay: 30000
  }
}
```

### Heartbeat to Gateway

```javascript
// Send heartbeat every 30 seconds
setInterval(() => {
  gateway.send({ type: 'heartbeat', status: 'ok' });
}, 30000);
```

---

## 🔟 **SECURITY FOR PERMANENCE**

### Firewall Rules

```bash
# Allow only necessary ports
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 8080/tcp  # OpenClaw
sudo ufw enable
```

### Automatic Security Updates

```bash
# Enable unattended upgrades
sudo apt install unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

### Rate Limiting

```javascript
// Prevent abuse
{
  rateLimit: {
    windowMs: 15 * 60 * 1000,  // 15 minutes
    max: 100  // 100 requests per window
  }
}
```

---

## 📋 **CHECKLIST: Production-Ready OpenClaw**

### System Configuration
- [ ] Systemd service created
- [ ] Auto-start enabled
- [ ] Restart policy configured
- [ ] Resource limits set
- [ ] Log rotation configured

### Monitoring
- [ ] Health check script
- [ ] Cron job for health check
- [ ] Watchdog script
- [ ] Metrics exported
- [ ] Dashboard created
- [ ] Alerts configured

### Backup & Recovery
- [ ] Backup script created
- [ ] Auto-backup cron job
- [ ] Backup retention policy
- [ ] Recovery procedure documented
- [ ] Tested backup restoration

### Updates
- [ ] Update procedure documented
- [ ] Zero-downtime deployment
- [ ] Rollback procedure
- [ ] Auto-update (optional)

### Security
- [ ] Firewall configured
- [ ] Rate limiting enabled
- [ ] Auto security updates
- [ ] Access logging

### Documentation
- [ ] Runbook created
- [ ] Troubleshooting guide
- [ ] Contact list
- [ ] Escalation procedure

---

## 🚀 **QUICK START: Make OpenClaw Permanent**

```bash
# 1. Create systemd service
sudo nano /etc/systemd/system/openclaw.service
# (paste service config from above)

# 2. Enable and start
sudo systemctl daemon-reload
sudo systemctl enable openclaw
sudo systemctl start openclaw

# 3. Setup health check
chmod +x scripts/health-check.sh
(crontab -e)  # Add health check cron

# 4. Setup backup
chmod +x scripts/auto-backup.sh
(crontab -e)  # Add backup cron

# 5. Verify
sudo systemctl status openclaw
sudo journalctl -u openclaw -f
```

---

**Status:** Ready for Production  
**Last Updated:** 2026-04-10  
**Version:** 1.0.0
