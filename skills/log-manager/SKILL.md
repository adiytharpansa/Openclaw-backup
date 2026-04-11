# log-manager

View, search, tail, and manage system logs. Essential for debugging and monitoring.

## Commands

### View Logs

**Tail logs (real-time):**
```bash
tail -f /var/log/openclaw/health.log
tail -f /var/log/openclaw/watchdog.log
tail -f /var/log/openclaw/backup.log
```

**View recent logs:**
```bash
tail -n 100 /var/log/openclaw/health.log
journalctl -u openclaw -n 100 --no-pager
```

**View full logs:**
```bash
cat /var/log/openclaw/health.log
less /var/log/openclaw/watchdog.log
```

### Search Logs

**Search by keyword:**
```bash
grep "ERROR" /var/log/openclaw/*.log
grep -i "failed" /var/log/openclaw/health.log
grep -C 3 "crash" /var/log/openclaw/*.log  # Context 3 lines
```

**Search with date:**
```bash
grep "2026-04-11" /var/log/openclaw/health.log
```

**Advanced search:**
```bash
grep -E "ERROR|CRITICAL|FATAL" /var/log/openclaw/*.log
awk '/ERROR/,/END/' /var/log/openclaw/health.log
```

### Export Logs

**Export to file:**
```bash
tail -n 1000 /var/log/openclaw/health.log > /tmp/health-export.log
```

**Export with timestamp:**
```bash
journalctl -u openclaw --since "2026-04-11" > /tmp/openclaw-logs.txt
```

### Log Rotation

**Check log sizes:**
```bash
ls -lh /var/log/openclaw/
du -sh /var/log/openclaw/
```

**Rotate logs manually:**
```bash
logrotate -f /etc/logrotate.d/openclaw
```

**Clear old logs:**
```bash
find /var/log/openclaw/ -name "*.log.*.gz" -mtime +30 -delete
```

## Usage Examples

**Check for errors in last hour:**
```bash
grep "ERROR" /var/log/openclaw/*.log | tail -50
```

**Monitor health logs:**
```bash
./skills/log-manager/log-manager.sh tail health
```

**Search for backup failures:**
```bash
./skills/log-manager/log-manager.sh search "backup failed"
```

**Export today's logs:**
```bash
./skills/log-manager/log-manager.sh export today
```

## Log Locations

- Health logs: `/var/log/openclaw/health.log`
- Watchdog logs: `/var/log/openclaw/watchdog.log`
- Backup logs: `/var/log/openclaw/backup.log`
- Optimize logs: `/var/log/openclaw/optimize.log`
- System logs: `journalctl -u openclaw`

## Related Skills

- `system-manager` - Systemd & cron management
- `alert-notification` - Send alerts on log events
- `resource-monitor` - Monitor system resources
