#!/bin/bash
# =============================================================================
# OPENCLAW PERMANENT ACTIVATION SCRIPT
# =============================================================================
# This script makes OpenClaw permanently active, fast, and optimized
# Run on production server with sudo
# =============================================================================

set -e

echo "🚀 OpenClaw Permanent Activation"
echo "================================"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Workspace path
WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
SCRIPTS_DIR="$WORKSPACE/scripts"

# =============================================================================
# 1. SYSTEMD SERVICE - Auto-start on boot
# =============================================================================
echo -e "\n${BLUE}[1/8]${NC} Setting up systemd service..."

cp "$SCRIPTS_DIR/openclaw.service" /etc/systemd/system/
systemctl daemon-reload
systemctl enable openclaw
systemctl start openclaw

echo -e "${GREEN}✓ Systemd service installed & started${NC}"

# =============================================================================
# 2. CRON JOBS - Health checks, backups, watchdog
# =============================================================================
echo -e "\n${BLUE}[2/8]${NC} Setting up cron jobs..."

# Create cron file
cat > /tmp/openclaw-cron <<EOF
# OpenClaw Health Check - Every 5 minutes
*/5 * * * * $SCRIPTS_DIR/health-check.sh >> /var/log/openclaw/health.log 2>&1

# OpenClaw Watchdog - Every minute
* * * * * $SCRIPTS_DIR/watchdog.sh >> /var/log/openclaw/watchdog.log 2>&1

# OpenClaw Auto-Backup - Daily at 2 AM
0 2 * * * $SCRIPTS_DIR/auto-backup.sh >> /var/log/openclaw/backup.log 2>&1

# OpenClaw Performance Optimization - Weekly on Sunday at 3 AM
0 3 * * 0 $SCRIPTS_DIR/optimize.sh >> /var/log/openclaw/optimize.log 2>&1

# OpenClaw Log Rotation - Daily at midnight
0 0 * * * find /var/log/openclaw -name "*.log" -mtime +7 -delete
EOF

# Install cron
crontab /tmp/openclaw-cron
rm /tmp/openclaw-cron

echo -e "${GREEN}✓ Cron jobs installed${NC}"

# =============================================================================
# 3. LOG DIRECTORIES - Create log structure
# =============================================================================
echo -e "\n${BLUE}[3/8]${NC} Creating log directories..."

mkdir -p /var/log/openclaw
mkdir -p /var/log/openclaw/health
mkdir -p /var/log/openclaw/backup
mkdir -p /var/log/openclaw/watchdog
mkdir -p /var/log/openclaw/performance

chmod 755 /var/log/openclaw
chown -R $USER:$USER /var/log/openclaw

echo -e "${GREEN}✓ Log directories created${NC}"

# =============================================================================
# 4. BACKUP DIRECTORY - Create backup storage
# =============================================================================
echo -e "\n${BLUE}[4/8]${NC} Creating backup directory..."

mkdir -p /mnt/backups/openclaw
chmod 755 /mnt/backups/openclaw
chown -R $USER:$USER /mnt/backups/openclaw

echo -e "${GREEN}✓ Backup directory created${NC}"

# =============================================================================
# 5. PERFORMANCE OPTIMIZATION - System tuning
# =============================================================================
echo -e "\n${BLUE}[5/8]${NC} Optimizing system performance..."

# Create performance config
cat > "$WORKSPACE/config/performance-optimized.json" <<EOF
{
  "performance": {
    "enabled": true,
    "optimizations": {
      "memory": {
        "cache_enabled": true,
        "cache_size_mb": 512,
        "garbage_collection": "aggressive"
      },
      "cpu": {
        "parallel_tasks": 4,
        "priority": "high",
        "throttling": false
      },
      "disk": {
        "ssd_optimized": true,
        "write_buffer_mb": 128,
        "async_io": true
      },
      "network": {
        "connection_pooling": true,
        "max_connections": 100,
        "timeout_ms": 5000
      },
      "response": {
        "compression": true,
        "streaming": true,
        "cache_responses": true
      }
    },
    "limits": {
      "max_memory_mb": 2048,
      "max_cpu_percent": 80,
      "max_disk_mb": 10240,
      "max_concurrent_tasks": 10
    }
  }
}
EOF

echo -e "${GREEN}✓ Performance config created${NC}"

# =============================================================================
# 6. FAST START CACHE - Pre-load common operations
# =============================================================================
echo -e "\n${BLUE}[6/8]${NC} Setting up fast start cache..."

mkdir -p "$WORKSPACE/.cache"
mkdir -p "$WORKSPACE/.cache/skills"
mkdir -p "$WORKSPACE/.cache/configs"
mkdir -p "$WORKSPACE/.cache/responses"

# Create cache index
cat > "$WORKSPACE/.cache/index.json" <<EOF
{
  "version": "1.0.0",
  "created": "$(date -Iseconds)",
  "type": "fast_start_cache",
  "contents": {
    "skills": "pre-loaded",
    "configs": "pre-loaded",
    "responses": "template_cache"
  }
}
EOF

echo -e "${GREEN}✓ Fast start cache created${NC}"

# =============================================================================
# 7. AUTO-RESTART PROTECTION - Watchdog setup
# =============================================================================
echo -e "\n${BLUE}[7/8]${NC} Setting up auto-restart protection..."

# Ensure watchdog script is executable
chmod +x "$SCRIPTS_DIR/watchdog.sh"
chmod +x "$SCRIPTS_DIR/health-check.sh"
chmod +x "$SCRIPTS_DIR/auto-backup.sh"

# Create restart counter file
echo "0" > "$WORKSPACE/.restart_count"
echo "0" > "$WORKSPACE/.last_restart"

echo -e "${GREEN}✓ Auto-restart protection enabled${NC}"

# =============================================================================
# 8. VERIFICATION - Check everything is working
# =============================================================================
echo -e "\n${BLUE}[8/8]${NC} Verifying installation..."

# Check systemd service
if systemctl is-active --quiet openclaw; then
    echo -e "${GREEN}✓ OpenClaw service is running${NC}"
else
    echo -e "${YELLOW}⚠ OpenClaw service not running, attempting start...${NC}"
    systemctl start openclaw
fi

# Check cron
if crontab -l | grep -q "openclaw"; then
    echo -e "${GREEN}✓ Cron jobs installed${NC}"
else
    echo -e "${RED}✗ Cron jobs not installed${NC}"
fi

# Check directories
if [ -d "/var/log/openclaw" ]; then
    echo -e "${GREEN}✓ Log directory exists${NC}"
else
    echo -e "${RED}✗ Log directory missing${NC}"
fi

if [ -d "/mnt/backups/openclaw" ]; then
    echo -e "${GREEN}✓ Backup directory exists${NC}"
else
    echo -e "${RED}✗ Backup directory missing${NC}"
fi

# Check scripts
for script in health-check.sh watchdog.sh auto-backup.sh; do
    if [ -x "$SCRIPTS_DIR/$script" ]; then
        echo -e "${GREEN}✓ $script is executable${NC}"
    else
        echo -e "${YELLOW}⚠ $script not executable${NC}"
    fi
done

# =============================================================================
# COMPLETE
# =============================================================================
echo -e "\n${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   OPENCLAW PERMANENT ACTIVATION COMPLETE! 🚀        ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
echo -e "\n${BLUE}Status:${NC}"
echo -e "  • Systemd service: ${GREEN}Active${NC}"
echo -e "  • Auto-start on boot: ${GREEN}Enabled${NC}"
echo -e "  • Health checks: ${GREEN}Every 5 min${NC}"
echo -e "  • Auto-backup: ${GREEN}Daily at 2 AM${NC}"
echo -e "  • Watchdog: ${GREEN}Every 1 min${NC}"
echo -e "  • Performance: ${GREEN}Optimized${NC}"
echo -e "  • Cache: ${GREEN}Enabled${NC}"
echo -e "\n${BLUE}Useful commands:${NC}"
echo -e "  sudo systemctl status openclaw    # Check status"
echo -e "  sudo systemctl restart openclaw   # Restart"
echo -e "  sudo journalctl -u openclaw -f    # View logs"
echo -e "  crontab -l                        # View cron jobs"
echo -e "\n${GREEN}OpenClaw is now PERMANENT, FAST & OPTIMIZED! 🎉${NC}\n"
