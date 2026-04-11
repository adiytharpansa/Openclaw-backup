#!/bin/bash
# resource-monitor.sh - Monitor system resources

ACTION="${1:-status}"

# Get CPU usage
get_cpu() {
    if command -v top &> /dev/null; then
        top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1
    else
        echo "0"
    fi
}

# Get RAM usage
get_ram() {
    if command -v free &> /dev/null; then
        free | awk '/Mem:/ {printf "%.1f", $3/$2 * 100}'
    else
        echo "0"
    fi
}

# Get disk usage
get_disk() {
    df -h / 2>/dev/null | awk 'NR==2 {print $5}' | tr -d '%'
}

# Get load average
get_load() {
    if [ -f /proc/loadavg ]; then
        cat /proc/loadavg | awk '{print $1}'
    else
        echo "0.00"
    fi
}

# Get network I/O
get_network() {
    if command -v ip &> /dev/null; then
        # Simplified - just show interface stats
        echo "N/A"
    else
        echo "N/A"
    fi
}

# Draw progress bar
draw_bar() {
    local percent=$1
    local width=20
    local filled=$(echo "$percent * $width / 100" | bc 2>/dev/null || echo "0")
    local empty=$((width - filled))
    
    printf "█%.0s" $(seq 1 $filled 2>/dev/null) 2>/dev/null || true
    printf "░%.0s" $(seq 1 $empty 2>/dev/null) 2>/dev/null || true
}

# Status view
show_status() {
    CPU=$(get_cpu)
    RAM=$(get_ram)
    DISK=$(get_disk)
    LOAD=$(get_load)
    
    # Determine status
    STATUS="✅ All Normal"
    STATUS_EMOJI="✅"
    
    if (( $(echo "$CPU > 90" | bc -l 2>/dev/null || echo 0) )); then
        STATUS="🔴 CPU Critical"
        STATUS_EMOJI="🔴"
    elif (( $(echo "$RAM > 90" | bc -l 2>/dev/null || echo 0) )); then
        STATUS="🔴 RAM Critical"
        STATUS_EMOJI="🔴"
    elif (( $(echo "$DISK > 85" | bc -l 2>/dev/null || echo 0) )); then
        STATUS="🔴 Disk Critical"
        STATUS_EMOJI="🔴"
    elif (( $(echo "$CPU > 80" | bc -l 2>/dev/null || echo 0) )) || \
         (( $(echo "$RAM > 80" | bc -l 2>/dev/null || echo 0) )) || \
         (( $(echo "$DISK > 75" | bc -l 2>/dev/null || echo 0) )); then
        STATUS="⚠️  Warning"
        STATUS_EMOJI="⚠️"
    fi
    
    echo "📊 System Resources"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf "CPU:    %5s%%  " "$CPU"
    draw_bar "${CPU%.*}"
    echo ""
    
    printf "RAM:    %5s%%  " "$RAM"
    draw_bar "${RAM%.*}"
    echo ""
    
    printf "Disk:   %5s%%  " "$DISK"
    draw_bar "$DISK"
    echo ""
    
    printf "Load:   %5s  " "$LOAD"
    echo ""
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Status: $STATUS_EMOJI $STATUS"
}

# Detailed report
show_report() {
    echo "📊 Detailed Resource Report"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Time: $(date)"
    echo "Host: $(hostname 2>/dev/null || echo 'unknown')"
    echo ""
    
    echo "💾 Memory:"
    free -h 2>/dev/null || echo "Not available"
    echo ""
    
    echo "💿 Disk Usage:"
    df -h 2>/dev/null | head -10 || echo "Not available"
    echo ""
    
    echo "🖥️  CPU Info:"
    if [ -f /proc/cpuinfo ]; then
        grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2
        echo "Cores: $(grep -c processor /proc/cpuinfo)"
    fi
    echo ""
    
    echo "📈 Top Processes (by CPU):"
    ps aux --sort=-%cpu 2>/dev/null | head -6 || echo "Not available"
    echo ""
    
    echo "📈 Top Processes (by RAM):"
    ps aux --sort=-%mem 2>/dev/null | head -6 || echo "Not available"
}

# Live monitor
show_live() {
    echo "📊 Live Resource Monitor (Ctrl+C to stop)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    while true; do
        clear
        show_status
        echo ""
        echo "Updated: $(date '+%H:%M:%S')"
        sleep 2
    done
}

# Check thresholds
check_thresholds() {
    CPU=$(get_cpu)
    RAM=$(get_ram)
    DISK=$(get_disk)
    
    ALERTS=()
    
    # CPU check
    if (( $(echo "$CPU > 95" | bc -l 2>/dev/null || echo 0) )); then
        ALERTS+=("🔴 CPU CRITICAL: ${CPU}%")
    elif (( $(echo "$CPU > 80" | bc -l 2>/dev/null || echo 0) )); then
        ALERTS+=("⚠️  CPU Warning: ${CPU}%")
    fi
    
    # RAM check
    if (( $(echo "$RAM > 90" | bc -l 2>/dev/null || echo 0) )); then
        ALERTS+=("🔴 RAM CRITICAL: ${RAM}%")
    elif (( $(echo "$RAM > 80" | bc -l 2>/dev/null || echo 0) )); then
        ALERTS+=("⚠️  RAM Warning: ${RAM}%")
    fi
    
    # Disk check
    if (( $(echo "$DISK > 85" | bc -l 2>/dev/null || echo 0) )); then
        ALERTS+=("🔴 Disk CRITICAL: ${DISK}%")
    elif (( $(echo "$DISK > 75" | bc -l 2>/dev/null || echo 0) )); then
        ALERTS+=("⚠️  Disk Warning: ${DISK}%")
    fi
    
    if [ ${#ALERTS[@]} -eq 0 ]; then
        echo "✅ All resources normal"
        exit 0
    else
        echo "🚨 Resource Alerts:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        for alert in "${ALERTS[@]}"; do
            echo "$alert"
        done
        
        # Send alert if requested
        if [ "${2:-}" = "--alert" ]; then
            SCRIPT_DIR="$(dirname "$0")"
            for alert in "${ALERTS[@]}"; do
                "$SCRIPT_DIR/../alert-notification/alert.sh" "Resource Alert" "$alert" "warning"
            done
        fi
        
        exit 1
    fi
}

# JSON output
output_json() {
    CPU=$(get_cpu)
    RAM=$(get_ram)
    DISK=$(get_disk)
    LOAD=$(get_load)
    
    cat <<EOF
{
  "timestamp": "$(date -Iseconds)",
  "cpu_percent": $CPU,
  "ram_percent": $RAM,
  "disk_percent": $DISK,
  "load_average": $LOAD
}
EOF
}

# Help
show_help() {
    echo "📊 Resource Monitor - OpenClaw"
    echo ""
    echo "Usage: $0 <action>"
    echo ""
    echo "Actions:"
    echo "  status   - Quick status overview"
    echo "  report   - Detailed resource report"
    echo "  live     - Real-time monitor (Ctrl+C to stop)"
    echo "  check    - Check thresholds (exit 1 if exceeded)"
    echo "  json     - Output as JSON"
    echo "  help     - Show this help"
    echo ""
    echo "Examples:"
    echo "  $0 status"
    echo "  $0 check --alert"
    echo "  $0 json"
}

# Main
case "$ACTION" in
    status)  show_status ;;
    report)  show_report ;;
    live)    show_live ;;
    check)   check_thresholds "$@" ;;
    json)    output_json ;;
    help|*)  show_help ;;
esac
