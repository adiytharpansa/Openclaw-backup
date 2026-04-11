#!/bin/bash
# dashboard.sh - OpenClaw Status Dashboard

ACTION="${1:-help}"
PORT="${PORT:-8080}"
DASHBOARD_DIR="$(dirname "$0")"
STATIC_DIR="$DASHBOARD_DIR/static"

# Create static dir if needed
mkdir -p "$STATIC_DIR" 2>/dev/null

# Generate HTML dashboard
generate_html() {
    cat <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OpenClaw Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #1a1a2e;
            color: #eee;
            padding: 20px;
        }
        .container { max-width: 1200px; margin: 0 auto; }
        header {
            background: #16213e;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        h1 { color: #00d4ff; margin-bottom: 5px; }
        .subtitle { color: #888; }
        
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .card {
            background: #16213e;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.3);
        }
        .card h2 {
            color: #00d4ff;
            margin-bottom: 15px;
            font-size: 18px;
        }
        
        .metric {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #2a2a4a;
        }
        .metric:last-child { border-bottom: none; }
        .metric-name { color: #aaa; }
        .metric-value {
            font-weight: bold;
            font-size: 20px;
        }
        
        .progress-bar {
            background: #2a2a4a;
            border-radius: 10px;
            height: 20px;
            margin: 10px 0;
            overflow: hidden;
        }
        .progress-fill {
            height: 100%;
            border-radius: 10px;
            transition: width 0.5s;
        }
        .fill-green { background: #00ff88; }
        .fill-yellow { background: #ffcc00; }
        .fill-red { background: #ff4444; }
        
        .status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: bold;
        }
        .status-ok { background: #00ff88; color: #000; }
        .status-warning { background: #ffcc00; color: #000; }
        .status-error { background: #ff4444; color: #000; }
        
        .log-viewer {
            background: #0d0d1a;
            padding: 15px;
            border-radius: 5px;
            font-family: monospace;
            max-height: 300px;
            overflow-y: auto;
            white-space: pre-wrap;
        }
        
        button {
            background: #00d4ff;
            color: #000;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            margin: 5px;
        }
        button:hover { background: #00a8cc; }
        
        .last-update {
            text-align: right;
            color: #666;
            font-size: 12px;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>🤖 OpenClaw Dashboard</h1>
            <p class="subtitle">Status & Monitoring</p>
        </header>
        
        <div class="grid">
            <div class="card">
                <h2>📊 Service Status</h2>
                <div class="metric">
                    <span class="metric-name">Status</span>
                    <span class="metric-value status status-ok">Running</span>
                </div>
                <div class="metric">
                    <span class="metric-name">Uptime</span>
                    <span class="metric-value">--</span>
                </div>
                <div class="metric">
                    <span class="metric-name">Version</span>
                    <span class="metric-value">1.0.0</span>
                </div>
            </div>
            
            <div class="card">
                <h2>💾 System Resources</h2>
                <div class="metric">
                    <span class="metric-name">CPU</span>
                    <span class="metric-value" id="cpu-val">--</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill fill-green" id="cpu-bar" style="width: 0%"></div>
                </div>
                <div class="metric">
                    <span class="metric-name">RAM</span>
                    <span class="metric-value" id="ram-val">--</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill fill-green" id="ram-bar" style="width: 0%"></div>
                </div>
                <div class="metric">
                    <span class="metric-name">Disk</span>
                    <span class="metric-value" id="disk-val">--</span>
                </div>
                <div class="progress-bar">
                    <div class="progress-fill fill-green" id="disk-bar" style="width: 0%"></div>
                </div>
            </div>
            
            <div class="card">
                <h2>🔔 Recent Activity</h2>
                <div class="metric">
                    <span class="metric-name">Last Health Check</span>
                    <span class="metric-value status status-ok">OK</span>
                </div>
                <div class="metric">
                    <span class="metric-name">Last Backup</span>
                    <span class="metric-value">--</span>
                </div>
                <div class="metric">
                    <span class="metric-name">Alerts (24h)</span>
                    <span class="metric-value" id="alert-count">0</span>
                </div>
            </div>
            
            <div class="card">
                <h2>⚡ Quick Actions</h2>
                <button onclick="healthCheck()">Run Health Check</button>
                <button onclick="refreshData()">Refresh</button>
            </div>
        </div>
        
        <div class="card">
            <h2>📋 Recent Logs</h2>
            <div class="log-viewer" id="logs">Loading...</div>
        </div>
        
        <p class="last-update">Last updated: <span id="last-update">--</span></p>
    </div>
    
    <script>
        const REFRESH_INTERVAL = 5000;
        
        async function fetchData() {
            try {
                // Fetch resource data
                const resources = await fetch('/api/resources').then(r => r.json());
                
                // Update CPU
                const cpu = resources.cpu || 0;
                document.getElementById('cpu-val').textContent = cpu + '%';
                updateBar('cpu-bar', cpu);
                
                // Update RAM
                const ram = resources.ram || 0;
                document.getElementById('ram-val').textContent = ram + '%';
                updateBar('ram-bar', ram);
                
                // Update Disk
                const disk = resources.disk || 0;
                document.getElementById('disk-val').textContent = disk + '%';
                updateBar('disk-bar', disk);
                
                // Update alerts
                document.getElementById('alert-count').textContent = resources.alerts || 0;
                
            } catch (error) {
                console.error('Error fetching data:', error);
            }
        }
        
        function updateBar(elementId, percent) {
            const bar = document.getElementById(elementId);
            bar.style.width = percent + '%';
            
            // Change color based on threshold
            if (percent > 90) {
                bar.className = 'progress-fill fill-red';
            } else if (percent > 75) {
                bar.className = 'progress-fill fill-yellow';
            } else {
                bar.className = 'progress-fill fill-green';
            }
        }
        
        async function healthCheck() {
            try {
                await fetch('/api/health-check', { method: 'POST' });
                alert('Health check triggered!');
                refreshData();
            } catch (error) {
                console.error('Health check failed:', error);
            }
        }
        
        function refreshData() {
            document.getElementById('last-update').textContent = new Date().toLocaleString();
            fetchData();
        }
        
        // Initial load
        refreshData();
        
        // Auto-refresh
        setInterval(fetchData, REFRESH_INTERVAL);
    </script>
</body>
</html>
EOF
}

# Start dashboard server
start_dashboard() {
    echo "🚀 Starting OpenClaw Dashboard..."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Generate index.html
    generate_html > "$STATIC_DIR/index.html"
    
    # Check if python is available
    if command -v python3 &> /dev/null; then
        echo "💡 Using Python HTTP server"
        echo ""
        echo "Dashboard URL: http://localhost:$PORT"
        echo "Press Ctrl+C to stop"
        echo ""
        python3 -m http.server "$PORT" --directory "$STATIC_DIR"
    elif command -v python &> /dev/null; then
        echo "💡 Using Python 2 HTTP server"
        echo ""
        echo "Dashboard URL: http://localhost:$PORT"
        echo "Press Ctrl+C to stop"
        echo ""
        python -m SimpleHTTPServer "$PORT"
    else
        echo "⚠️  No Python found"
        echo "💡 Install Python and run again:"
        echo "  apt install python3"
        echo ""
        echo "Dashboard files generated at: $STATIC_DIR"
        echo "Open: $STATIC_DIR/index.html"
    fi
}

# Stop dashboard
stop_dashboard() {
    echo "🛑 Stopping Dashboard..."
    if pgrep -f "python.*http.server" > /dev/null; then
        pkill -f "python.*http.server"
        echo "✅ Dashboard stopped"
    else
        echo "ℹ️  Dashboard not running"
    fi
}

# Check status
check_status() {
    if pgrep -f "python.*http.server" > /dev/null; then
        echo "✅ Dashboard is running"
        echo "URL: http://localhost:$PORT"
    else
        echo "❌ Dashboard is not running"
        echo "Start with: $0 start"
    fi
}

# Show help
show_help() {
    echo "📊 OpenClaw Dashboard"
    echo ""
    echo "Usage: $0 <action>"
    echo ""
    echo "Actions:"
    echo "  start   - Start dashboard server"
    echo "  stop    - Stop dashboard server"
    echo "  status  - Check dashboard status"
    echo "  help    - Show this help"
    echo ""
    echo "Environment Variables:"
    echo "  PORT    - Server port (default: 8080)"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  PORT=3000 $0 start"
    echo "  $0 status"
}

# Main
case "$ACTION" in
    start)  start_dashboard ;;
    stop)   stop_dashboard ;;
    status) check_status ;;
    help|*) show_help ;;
esac
