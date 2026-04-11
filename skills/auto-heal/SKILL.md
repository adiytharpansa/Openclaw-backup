# auto-heal

Automatic problem detection and self-healing for OpenClaw. Goes beyond simple restarts to diagnose and fix root causes.

## Healing Capabilities

### 1. Service Recovery

**Detect:**
- Service not running
- Service crashed
- Service unresponsive
- High error rate in logs

**Actions:**
- Restart service
- Clear stale PID files
- Reset service state
- Rollback to last known good config

### 2. Disk Space Recovery

**Detect:**
- Disk usage > 90%
- Log files too large
- Old backups consuming space
- Temp files not cleaned

**Actions:**
- Rotate/clear old logs
- Remove temp files
- Clean package cache
- Archive old backups

### 3. Memory Recovery

**Detect:**
- RAM usage > 95%
- Memory leaks
- Zombie processes
- Cache bloat

**Actions:**
- Clear system caches
- Kill zombie processes
- Restart memory-heavy services
- Trigger garbage collection

### 4. Configuration Recovery

**Detect:**
- Invalid config syntax
- Missing config files
- Permission issues
- Corrupted configs

**Actions:**
- Restore from backup config
- Fix permissions
- Validate config syntax
- Reload service

### 5. Network Recovery

**Detect:**
- Connection timeouts
- DNS resolution failures
- Port binding issues
- Network interface down

**Actions:**
- Restart network services
- Clear DNS cache
- Rebind ports
- Reset network stack

## Usage

### Manual Heal

**Run full diagnostic:**
```bash
./skills/auto-heal/auto-heal.sh diagnose
```

**Auto-fix all issues:**
```bash
./skills/auto-heal/auto-heal.sh heal
```

**Specific heal:**
```bash
./skills/auto-heal/auto-heal.sh heal disk
./skills/auto-heal/auto-heal.sh heal memory
./skills/auto-heal/auto-heal.sh heal service
```

### Automatic Healing

**Enable auto-heal:**
```bash
./skills/auto-heal/auto-heal.sh enable
```

**Disable auto-heal:**
```bash
./skills/auto-heal/auto-heal.sh disable
```

**Check status:**
```bash
./skills/auto-heal/auto-heal.sh status
```

## Integration

### With Watchdog
```bash
# Add to watchdog.sh
if ! is_openclaw_healthy; then
    ./skills/auto-heal/auto-heal.sh heal service
fi
```

### With Health Check
```bash
# Add to health-check.sh
HEALTH=$(./skills/auto-heal/auto-heal.sh diagnose --json)
if [ "$HEALTH" != "healthy" ]; then
    ./skills/auto-heal/auto-heal.sh heal
fi
```

### With Cron
```bash
# Run heal check every hour
0 * * * * /path/to/auto-heal.sh check --auto
```

## Healing Reports

**View heal log:**
```bash
cat /var/log/openclaw/heal.log
```

**Recent heals:**
```bash
./skills/auto-heal/auto-heal.sh history
```

**Export report:**
```bash
./skills/auto-heal/auto-heal.sh report
```

## Safety Features

### Before Healing
1. ✅ Create backup/snapshot
2. ✅ Log current state
3. ✅ Check if safe to proceed
4. ✅ Notify if critical

### After Healing
1. ✅ Verify fix worked
2. ✅ Log what was done
3. ✅ Send notification
4. ✅ Update health status

### Rollback
If healing fails:
1. Restore from backup
2. Alert admin
3. Mark for manual review

## Examples

**Diagnose current state:**
```bash
./skills/auto-heal/auto-heal.sh diagnose
```

Output:
```
🔍 Auto-Heal Diagnostic
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Service:  ✅ Running
Disk:     ⚠️  87% (Warning)
Memory:   ✅ 62% OK
Logs:     ⚠️  Large files detected
Config:   ✅ Valid

Issues Found: 2
- Disk usage high (87%)
- Log files > 100MB

Recommendation: Run 'heal disk' and 'heal logs'
```

**Auto-fix:**
```bash
./skills/auto-heal/auto-heal.sh heal
```

Output:
```
🏥 Auto-Heal Running
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[1/3] Cleaning old logs...
      ✅ Freed 234MB

[2/3] Clearing temp files...
      ✅ Freed 45MB

[3/3] Rotating large logs...
      ✅ Rotated 3 files

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Healing Complete
Freed: 279MB
Issues Resolved: 2/2
```

## Related Skills

- `system-manager` - Systemd & cron
- `resource-monitor` - Resource monitoring
- `log-manager` - Log management
- `alert-notification` - Alerts
