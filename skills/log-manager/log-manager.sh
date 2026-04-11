#!/bin/bash
# log-manager.sh - Manage and view logs

ACTION="${1:-help}"
LOG_TYPE="${2:-all}"
LOG_DIR="/var/log/openclaw"

# Fallback log dir for sandbox
if [ ! -d "$LOG_DIR" ]; then
    LOG_DIR="/tmp/openclaw-logs"
    mkdir -p "$LOG_DIR" 2>/dev/null
fi

case "$ACTION" in
    tail)
        echo "📊 Tailing logs (Ctrl+C to stop):"
        case "$LOG_TYPE" in
            health)  tail -f "$LOG_DIR/health.log" 2>/dev/null || echo "Log not found" ;;
            watchdog) tail -f "$LOG_DIR/watchdog.log" 2>/dev/null || echo "Log not found" ;;
            backup)  tail -f "$LOG_DIR/backup.log" 2>/dev/null || echo "Log not found" ;;
            all)     tail -f "$LOG_DIR"/*.log 2>/dev/null || echo "No logs found" ;;
            *)       tail -f "$LOG_DIR/$LOG_TYPE" 2>/dev/null || echo "Log not found" ;;
        esac
        ;;
    
    view)
        LINES="${3:-100}"
        echo "📋 Last $LINES lines:"
        case "$LOG_TYPE" in
            health)  tail -n "$LINES" "$LOG_DIR/health.log" 2>/dev/null ;;
            watchdog) tail -n "$LINES" "$LOG_DIR/watchdog.log" 2>/dev/null ;;
            backup)  tail -n "$LINES" "$LOG_DIR/backup.log" 2>/dev/null ;;
            all)
                for log in "$LOG_DIR"/*.log; do
                    [ -f "$log" ] && echo "=== $log ===" && tail -n "$LINES" "$log"
                done
                ;;
            *)       tail -n "$LINES" "$LOG_DIR/$LOG_TYPE" 2>/dev/null ;;
        esac
        ;;
    
    search)
        PATTERN="${3:-ERROR}"
        echo "🔍 Searching for: $PATTERN"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        grep -i "$PATTERN" "$LOG_DIR"/*.log 2>/dev/null | tail -50 || echo "No matches found"
        ;;
    
    export)
        OUTPUT="/tmp/logs-export-$(date +%Y%m%d_%H%M%S).txt"
        echo "💾 Exporting logs to: $OUTPUT"
        {
            echo "=== OpenClaw Log Export ==="
            echo "Date: $(date)"
            echo ""
            for log in "$LOG_DIR"/*.log; do
                [ -f "$log" ] && echo "=== $log ===" && tail -n 500 "$log"
            done
        } > "$OUTPUT"
        echo "✅ Exported to: $OUTPUT"
        ;;
    
    size)
        echo "📊 Log Sizes:"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        du -sh "$LOG_DIR"/* 2>/dev/null || echo "No logs found"
        echo ""
        echo "Total:"
        du -sh "$LOG_DIR" 2>/dev/null
        ;;
    
    clean)
        echo "🧹 Cleaning old logs (>30 days)..."
        find "$LOG_DIR" -name "*.log.*.gz" -mtime +30 -delete 2>/dev/null
        find "$LOG_DIR" -name "*.old" -mtime +7 -delete 2>/dev/null
        echo "✅ Cleanup complete"
        ;;
    
    help|*)
        echo "📋 Log Manager - OpenClaw"
        echo ""
        echo "Usage: $0 <action> [log-type] [options]"
        echo ""
        echo "Actions:"
        echo "  tail [type]     - Tail logs real-time (health|watchdog|backup|all)"
        echo "  view [type] [n] - View last N lines (default: 100)"
        echo "  search <pattern> - Search logs for pattern"
        echo "  export          - Export logs to file"
        echo "  size            - Show log sizes"
        echo "  clean           - Remove old logs"
        echo "  help            - Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 tail health"
        echo "  $0 view watchdog 50"
        echo "  $0 search ERROR"
        echo "  $0 export"
        ;;
esac
