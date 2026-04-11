# resource-monitor

Monitor system resources (CPU, RAM, disk, network) with real-time dashboards and alerts.

## Commands

### Quick Status

**One-line overview:**
```bash
./skills/resource-monitor/resource-monitor.sh status
```

**Output:**
```
📊 System Resources
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
CPU:    45%  ████████░░░░░░░░░░░░
RAM:    62%  ███████████░░░░░░░░░
Disk:   38%  ███████░░░░░░░░░░░░░
Network: ↑1.2MB/s ↓3.4MB/s
Status: ✅ All Normal
```

### Detailed View

**Full resource report:**
```bash
./skills/resource-monitor/resource-monitor.sh report
```

**Includes:**
- CPU usage per core
- Memory breakdown (used/buffer/cache)
- Disk usage per mount point
- Network I/O
- Top processes
- Load averages

### Real-time Monitor

**Live dashboard:**
```bash
./skills/resource-monitor/resource-monitor.sh live
```

Updates every 2 seconds. Press Ctrl+C to stop.

### Historical Data

**View trends:**
```bash
./skills/resource-monitor/resource-monitor.sh history --hours 24
```

**Export data:**
```bash
./skills/resource-monitor/resource-monitor.sh export --format csv
```

### Alerts

**Check thresholds:**
```bash
./skills/resource-monitor/resource-monitor.sh check
```

**Triggers alerts if:**
- CPU > 90%
- RAM > 90%
- Disk > 85%
- Load average > 4x CPU cores

## Thresholds

**Default thresholds (configurable):**

| Resource | Warning | Critical |
|----------|---------|----------|
| CPU      | 80%     | 95%      |
| RAM      | 80%     | 90%      |
| Disk     | 75%     | 85%      |
| Load     | 2x cores| 4x cores |

**Edit thresholds:**
```bash
nano /etc/openclaw/resource.conf
```

## Integration

### With Cron (Hourly Check)
```bash
# Add to crontab
0 * * * * /path/to/resource-monitor.sh check
```

### With Alert System
```bash
# Automatically sends alerts when thresholds exceeded
./skills/resource-monitor/resource-monitor.sh check --alert
```

### With Dashboard
```bash
# Data source for web dashboard
./skills/resource-monitor/resource-monitor.sh json
```

## Output Formats

**Text (default):**
```bash
./skills/resource-monitor/resource-monitor.sh status
```

**JSON:**
```bash
./skills/resource-monitor/resource-monitor.sh json
```

**CSV:**
```bash
./skills/resource-monitor/resource-monitor.sh csv
```

## Examples

**Quick health check:**
```bash
./skills/resource-monitor/resource-monitor.sh status
```

**Find top memory consumers:**
```bash
./skills/resource-monitor/resource-monitor.sh top --by memory
```

**Monitor disk space:**
```bash
./skills/resource-monitor/resource-monitor.sh disk
```

**Check if safe to run heavy task:**
```bash
./skills/resource-monitor/resource-monitor.sh safe-to-run --cpu 50 --ram 50
```

## Related Skills

- `system-manager` - Systemd & cron
- `log-manager` - Log management
- `alert-notification` - Send alerts
