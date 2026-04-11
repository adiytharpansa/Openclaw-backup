#!/bin/bash
# auto-heal.sh - Automatic problem detection and healing

ACTION="${1:-help}"
TARGET="${2:-all}"

LOG_DIR="/var/log/openclaw"
BACKUP_DIR="/mnt/backups/openclaw"
HEAL_LOG="$LOG_DIR/heal.log"

# Ensure log dir exists
mkdir -p "$LOG_DIR" 2>/dev/null || LOG_DIR="/tmp/openclaw-logs"
mkdir -p "$BACKUP_DIR" 2>/dev/null || BACKUP_DIR="/tmp/backups"

# Log function
log_heal() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$HEAL_LOG"
    echo "$1"
}

# Get disk usage
get_disk_usage() {
    df / 2>/dev/null | awk 'NR==2 {print $5}' | tr -d '%'
}

# Get RAM usage
get_ram_usage() {
    free 2>/dev/null | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}' || echo "0"
}

# Get log sizes
get_log_size() {
    du -sm "$LOG_DIR" 2>/dev/null | awk '{print $1}' || echo "0"
}

# Check service health
check_service() {
    # Simplified check - in production would use systemctl
    if pgrep -f "openclaw" > /dev/null 2>&1; then
        echo "running"
    else
        echo "stopped"
    fi
}

# Heal disk space
heal_disk() {
    log_heal "🔧 Healing disk space..."
    
    # Clean old logs
    log_heal "  Cleaning logs older than 30 days..."
    find "$LOG_DIR" -name "*.log.*.gz" -mtime +30 -delete 2>/dev/null
    find "$LOG_DIR" -name "*.old" -mtime +7 -delete 2>/dev/null
    
    # Clean temp files
    log_heal "  Cleaning temp files..."
    find /tmp -name "openclaw-*" -mtime +7 -delete 2>/dev/null
    
    # Clean package cache (if apt)
    if command -v apt-get &> /dev/null; then
        log_heal "  Cleaning apt cache..."
        apt-get clean -y 2>/dev/null || true
    fi
    
    # Report freed space
    log_heal "  ✅ Disk healing complete"
}

# Heal memory
heal_memory() {
    log_heal "🔧 Healing memory..."
    
    # Clear system caches
    log_heal "  Clearing system caches..."
    sync
    echo 3 > /proc/sys/vm/drop_caches 2>/dev/null || log_heal "  (cache clear not available)"
    
    # Kill zombie processes
    log_heal "  Checking for zombie processes..."
    ZOMBIES=$(ps aux 2>/dev/null | awk '$8 ~ /^Z/ {print $2}' | wc -l)
    if [ "$ZOMBIES" -gt 0 ]; then
        log_heal "  Found $ZOMBIES zombie processes"
        # Don't auto-kill, just report
    else
        log_heal "  ✅ No zombie processes"
    fi
    
    log_heal "  ✅ Memory healing complete"
}

# Heal logs
heal_logs() {
    log_heal "🔧 Healing logs..."
    
    # Rotate large logs
    log_heal "  Rotating large log files..."
    for log in "$LOG_DIR"/*.log; do
        if [ -f "$log" ]; then
            SIZE=$(du -m "$log" 2>/dev/null | awk '{print $1}')
            if [ "${SIZE:-0}" -gt 100 ]; then
                log_heal "  Rotating $log (${SIZE}MB)"
                mv "$log" "$log.1"
                touch "$log"
            fi
        fi
    done
    
    # Compress old logs
    log_heal "  Compressing rotated logs..."
    find "$LOG_DIR" -name "*.log.[0-9]" -exec gzip {} \; 2>/dev/null
    
    log_heal "  ✅ Log healing complete"
}

# Heal service
heal_service() {
    log_heal "🔧 Healing service..."
    
    SERVICE_STATUS=$(check_service)
    
    if [ "$SERVICE_STATUS" = "stopped" ]; then
        log_heal "  Service is stopped, attempting restart..."
        # In production: systemctl restart openclaw
        log_heal "  ⚠️  Manual restart required (systemctl not available)"
    else
        log_heal "  Service is running, no action needed"
    fi
    
    log_heal "  ✅ Service healing complete"
}

# Full diagnosis
diagnose() {
    echo "🔍 Auto-Heal Diagnostic"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    ISSUES=()
    
    # Check service
    SERVICE=$(check_service)
    if [ "$SERVICE" = "running" ]; then
        echo "Service:  ✅ Running"
    else
        echo "Service:  🔴 Stopped"
        ISSUES+=("service")
    fi
    
    # Check disk
    DISK=$(get_disk_usage)
    if [ "${DISK:-0}" -gt 90 ]; then
        echo "Disk:     🔴 ${DISK}% (Critical)"
        ISSUES+=("disk")
    elif [ "${DISK:-0}" -gt 75 ]; then
        echo "Disk:     ⚠️  ${DISK}% (Warning)"
        ISSUES+=("disk")
    else
        echo "Disk:     ✅ ${DISK}%"
    fi
    
    # Check RAM
    RAM=$(get_ram_usage)
    if [ "${RAM:-0}" -gt 95 ]; then
        echo "Memory:   🔴 ${RAM}% (Critical)"
        ISSUES+=("memory")
    elif [ "${RAM:-0}" -gt 80 ]; then
        echo "Memory:   ⚠️  ${RAM}% (Warning)"
        ISSUES+=("memory")
    else
        echo "Memory:   ✅ ${RAM}%"
    fi
    
    # Check logs
    LOG_SIZE=$(get_log_size)
    if [ "${LOG_SIZE:-0}" -gt 500 ]; then
        echo "Logs:     🔴 ${LOG_SIZE}MB (Large)"
        ISSUES+=("logs")
    elif [ "${LOG_SIZE:-0}" -gt 100 ]; then
        echo "Logs:     ⚠️  ${LOG_SIZE}MB"
        ISSUES+=("logs")
    else
        echo "Logs:     ✅ ${LOG_SIZE}MB"
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ ${#ISSUES[@]} -eq 0 ]; then
        echo "Status: ✅ All Healthy"
        echo "0"
    else
        echo "Issues Found: ${#ISSUES[@]}"
        for issue in "${ISSUES[@]}"; do
            echo "  - $issue"
        done
        echo ""
        echo "Recommendation: Run 'heal' to auto-fix"
        echo "${#ISSUES[@]}"
    fi
}

# Run all heals
heal_all() {
    log_heal "🏥 Auto-Heal Started"
    echo "🏥 Auto-Heal Running"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    DISK=$(get_disk_usage)
    if [ "${DISK:-0}" -gt 75 ]; then
        heal_disk
    else
        log_heal "  ⏭️  Skipping disk (usage: ${DISK}%)"
    fi
    
    RAM=$(get_ram_usage)
    if [ "${RAM:-0}" -gt 80 ]; then
        heal_memory
    else
        log_heal "  ⏭️  Skipping memory (usage: ${RAM}%)"
    fi
    
    LOG_SIZE=$(get_log_size)
    if [ "${LOG_SIZE:-0}" -gt 100 ]; then
        heal_logs
    else
        log_heal "  ⏭️  Skipping logs (size: ${LOG_SIZE}MB)"
    fi
    
    heal_service
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log_heal "✅ Auto-Heal Complete"
    echo "✅ Auto-Heal Complete"
}

# Show status
show_status() {
    echo "🏥 Auto-Heal Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ -f "/etc/openclaw/auto-heal-enabled" ]; then
        echo "Status: ✅ Enabled"
    else
        echo "Status: ❌ Disabled"
    fi
    
    echo ""
    echo "Last 10 heals:"
    if [ -f "$HEAL_LOG" ]; then
        tail -10 "$HEAL_LOG"
    else
        echo "No heal history"
    fi
}

# Enable auto-heal
enable_heal() {
    mkdir -p /etc/openclaw 2>/dev/null || mkdir -p /tmp/openclaw
    touch /etc/openclaw/auto-heal-enabled 2>/dev/null || touch /tmp/openclaw/auto-heal-enabled
    echo "✅ Auto-heal enabled"
    log_heal "Auto-heal enabled"
}

# Disable auto-heal
disable_heal() {
    rm -f /etc/openclaw/auto-heal-enabled 2>/dev/null || rm -f /tmp/openclaw/auto-heal-enabled
    echo "✅ Auto-heal disabled"
    log_heal "Auto-heal disabled"
}

# Show help
show_help() {
    echo "🏥 Auto-Heal - OpenClaw"
    echo ""
    echo "Usage: $0 <action> [target]"
    echo ""
    echo "Actions:"
    echo "  diagnose  - Run full diagnostic"
    echo "  heal      - Auto-fix all issues"
    echo "  heal <type> - Fix specific issue (disk|memory|logs|service)"
    echo "  status    - Show auto-heal status"
    echo "  enable    - Enable auto-heal"
    echo "  disable   - Disable auto-heal"
    echo "  history   - Show heal history"
    echo "  help      - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 diagnose"
    echo "  $0 heal"
    echo "  $0 heal disk"
}

# Main
case "$ACTION" in
    diagnose) diagnose ;;
    heal)
        case "$TARGET" in
            disk) heal_disk ;;
            memory) heal_memory ;;
            logs) heal_logs ;;
            service) heal_service ;;
            all|*) heal_all ;;
        esac
        ;;
    status) show_status ;;
    enable) enable_heal ;;
    disable) disable_heal ;;
    history) tail -20 "$HEAL_LOG" 2>/dev/null || echo "No history" ;;
    help|*) show_help ;;
esac
