# alert-notification

Send alerts and notifications via Telegram, Discord, Email, and other channels. Critical for monitoring and incident response.

## Alert Types

### Service Alerts
- Service down/crashed
- Service restart
- Health check failed
- Watchdog triggered

### Backup Alerts
- Backup completed
- Backup failed
- Backup storage low
- Backup verification failed

### Resource Alerts
- CPU usage high (>90%)
- RAM usage high (>90%)
- Disk usage high (>85%)
- Network issues

### Security Alerts
- Failed login attempts
- Unauthorized access
- Suspicious activity
- Certificate expiry

## Usage

### Send Alert

**Via script:**
```bash
./skills/alert-notification/alert.sh "Service Down" "OpenClaw service crashed" "critical"
```

**Priority levels:**
- `critical` - Immediate attention required
- `warning` - Needs attention soon
- `info` - Informational only

### Configure Alerts

**Edit config file:**
```bash
nano /etc/openclaw/alerts.conf
```

**Config format:**
```ini
# Alert Configuration
TELEGRAM_CHAT_ID="your_chat_id"
DISCORD_WEBHOOK="https://discord.com/api/webhooks/..."
EMAIL_RECIPIENT="admin@example.com"

# Thresholds
CPU_THRESHOLD=90
RAM_THRESHOLD=90
DISK_THRESHOLD=85

# Alert Channels
ENABLE_TELEGRAM=true
ENABLE_DISCORD=false
ENABLE_EMAIL=true
```

### Alert Templates

**Service Down:**
```
🚨 CRITICAL ALERT

Service: OpenClaw
Status: DOWN
Time: 2026-04-11 09:40 UTC
Host: server-01

Action: Auto-restart initiated
```

**Backup Failed:**
```
⚠️  WARNING ALERT

Backup: Daily Backup
Status: FAILED
Time: 2026-04-11 02:05 UTC
Error: Disk space full

Action: Manual intervention required
```

**Daily Status:**
```
📊 Daily Status Report

Uptime: 99.9%
Backups: ✅ Success
Health Checks: ✅ All passed
Resources: ✅ Normal

No issues in last 24h
```

## Integration

### With System Manager
```bash
# Add to watchdog.sh
if ! systemctl is-active openclaw; then
    ./skills/alert-notification/alert.sh "Service Down" "OpenClaw not responding" "critical"
fi
```

### With Health Check
```bash
# Add to health-check.sh
if [ "$HEALTH_STATUS" != "OK" ]; then
    ./skills/alert-notification/alert.sh "Health Check Failed" "$HEALTH_STATUS" "warning"
fi
```

### With Backup
```bash
# Add to auto-backup.sh
if [ "$BACKUP_STATUS" != "SUCCESS" ]; then
    ./skills/alert-notification/alert.sh "Backup Failed" "$BACKUP_ERROR" "critical"
fi
```

## API Usage

**Send via curl:**
```bash
curl -X POST http://localhost:8080/alert \
  -H "Content-Type: application/json" \
  -d '{"title":"Service Down","message":"OpenClaw crashed","priority":"critical"}'
```

## Best Practices

1. **Don't spam** - Only alert on real issues
2. **Use priorities** - Critical vs warning vs info
3. **Include context** - What, when, where, why
4. **Action items** - What should recipient do?
5. **Test regularly** - Verify alerts are working

## Related Skills

- `system-manager` - Systemd & cron
- `log-manager` - Log viewing & search
- `resource-monitor` - Resource monitoring
