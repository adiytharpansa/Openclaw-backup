# dashboard

Web-based status dashboard for OpenClaw. Real-time monitoring accessible via browser.

## Features

### Status Overview
- Service health (green/red indicator)
- Uptime tracking
- Last health check time
- Current version

### Resource Metrics
- CPU usage (real-time graph)
- RAM usage (real-time graph)
- Disk usage (progress bar)
- Network I/O

### Recent Activity
- Last 10 health checks
- Recent alerts
- Backup status
- Service restarts

### Quick Actions
- Restart service
- Run health check
- Trigger backup
- View logs

## Access

### Start Dashboard

**Run dashboard server:**
```bash
./skills/dashboard/dashboard.sh start
```

**Default port:** 8080

**Access URL:** http://localhost:8080

### Stop Dashboard

```bash
./skills/dashboard/dashboard.sh stop
```

### Check Status

```bash
./skills/dashboard/dashboard.sh status
```

## Pages

### `/` - Main Dashboard
Real-time status overview with all metrics.

### `/health` - Health Status
Detailed health check results and history.

### `/logs` - Log Viewer
View and search recent logs.

### `/alerts` - Alert History
List of recent alerts and notifications.

### `/backups` - Backup Status
Backup history, sizes, and verification.

### `/settings` - Configuration
Adjust thresholds, notifications, etc.

## API Endpoints

**Get current status:**
```bash
curl http://localhost:8080/api/status
```

**Get resource metrics:**
```bash
curl http://localhost:8080/api/resources
```

**Get recent alerts:**
```bash
curl http://localhost:8080/api/alerts
```

**Trigger health check:**
```bash
curl -X POST http://localhost:8080/api/health-check
```

## Customization

### Theme

Edit `dashboard/static/style.css` to customize:
- Colors
- Fonts
- Layout
- Dark/light mode

### Refresh Rate

Default: 5 seconds

Edit `dashboard/index.html`:
```javascript
const REFRESH_INTERVAL = 5000; // milliseconds
```

### Port

Default: 8080

Set environment variable:
```bash
export DASHBOARD_PORT=3000
./skills/dashboard/dashboard.sh start
```

## Integration

### With Alert System
Dashboard shows alerts from `alert-notification` skill.

### With Resource Monitor
Dashboard uses `resource-monitor` for metrics.

### With Log Manager
Dashboard embeds log viewer from `log-manager`.

## Security

### Authentication (Optional)

Enable basic auth:
```bash
export DASHBOARD_AUTH=true
export DASHBOARD_USER=admin
export DASHBOARD_PASS=securepassword
```

### Firewall

Allow port 8080:
```bash
ufw allow 8080/tcp
```

### HTTPS (Production)

Use reverse proxy (nginx):
```nginx
server {
    listen 443 ssl;
    server_name dashboard.example.com;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    location / {
        proxy_pass http://localhost:8080;
    }
}
```

## Examples

**Start dashboard:**
```bash
./skills/dashboard/dashboard.sh start
```

**Check if running:**
```bash
./skills/dashboard/dashboard.sh status
```

**View in browser:**
Open http://localhost:8080

**Stop dashboard:**
```bash
./skills/dashboard/dashboard.sh stop
```

## Screenshots

### Main Dashboard
```
╔══════════════════════════════════════════╗
║       OpenClaw Status Dashboard          ║
╠══════════════════════════════════════════╣
║  Service: ✅ Running    Uptime: 5d 3h    ║
║                                          ║
║  CPU:    [████████░░] 45%               ║
║  RAM:    [██████████] 62%               ║
║  Disk:   [██████░░░░] 38%               ║
║                                          ║
║  Recent Alerts: 0                        ║
║  Last Backup: 2 hours ago ✅            ║
║  Last Health Check: 1 min ago ✅        ║
╚══════════════════════════════════════════╝
```

## Related Skills

- `resource-monitor` - Resource metrics
- `log-manager` - Log viewing
- `alert-notification` - Alert system
- `system-manager` - Service control
