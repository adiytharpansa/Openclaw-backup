# system-manager

Manage Linux systemd services and cron jobs. Use for service control, scheduling, and system automation.

## Commands

### Systemd Services

**Check service status:**
```bash
systemctl status <service-name>
systemctl is-active <service-name>
systemctl is-enabled <service-name>
```

**Control services:**
```bash
systemctl start <service-name>
systemctl stop <service-name>
systemctl restart <service-name>
systemctl reload <service-name>
```

**Enable/disable on boot:**
```bash
systemctl enable <service-name>
systemctl disable <service-name>
```

**View logs:**
```bash
journalctl -u <service-name> -n 50
journalctl -u <service-name> -f
```

**List services:**
```bash
systemctl list-units --type=service --all
systemctl list-unit-files --type=service
```

### Cron Jobs

**View crontab:**
```bash
crontab -l
```

**Edit crontab:**
```bash
crontab -e
```

**Install crontab from file:**
```bash
crontab /path/to/cronfile
```

**Remove all cron jobs:**
```bash
crontab -r
```

### Service File Creation

**Create new systemd service:**
```bash
cat > /etc/systemd/system/<service-name>.service << EOF
[Unit]
Description=Service Description
After=network.target

[Service]
Type=simple
User=<username>
WorkingDirectory=/path/to/workdir
ExecStart=/path/to/command
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable <service-name>
systemctl start <service-name>
```

## Cron Syntax

```
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of week (0 - 6)
# │ │ │ │ │
# * * * * * command to execute
```

**Examples:**
```bash
# Every 5 minutes
*/5 * * * * /path/to/script.sh

# Every hour at :30
30 * * * * /path/to/script.sh

# Daily at 2 AM
0 2 * * * /path/to/script.sh

# Weekly on Sunday at 3 AM
0 3 * * 0 /path/to/script.sh

# Monthly on 1st at midnight
0 0 1 * * /path/to/script.sh
```

## Safety Rules

1. **Always check if service exists** before starting/stopping
2. **Validate cron syntax** before installing
3. **Backup existing crontab** before making changes
4. **Test services manually** before enabling as systemd
5. **Log all changes** to `/var/log/openclaw/sysadmin.log`

## Usage Examples

**Check if OpenClaw service is running:**
```bash
systemctl status openclaw
```

**Enable OpenClaw to start on boot:**
```bash
systemctl enable openclaw
```

**Add health check cron job:**
```bash
(crontab -l 2>/dev/null; echo "*/5 * * * * /path/to/health-check.sh") | crontab -
```

**View OpenClaw logs:**
```bash
journalctl -u openclaw -n 100 --no-pager
```

## Environment Notes

- **Gensee Crate (Sandbox):** Systemd NOT available - scripts ready but can't activate
- **Real Linux Server (VPS/Local):** Full systemd & cron support
- **Deployment:** Use `scripts/ACTIVATE.sh` on production servers with systemd

## Related Scripts

- `scripts/ACTIVATE.sh` - Full permanent activation
- `scripts/health-check.sh` - Health monitoring
- `scripts/watchdog.sh` - Auto-restart protection
- `scripts/auto-backup.sh` - Daily backups
- `scripts/optimize.sh` - Weekly optimization
