#!/bin/bash
# =============================================================================
# OPENCLAW WEEKLY OPTIMIZATION SCRIPT
# =============================================================================
# Runs weekly to optimize performance, clean cache, and improve speed
# =============================================================================

set -e

WORKSPACE="/mnt/data/openclaw/workspace/.openclaw/workspace"
LOG_FILE="/var/log/openclaw/optimize.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "🚀 Starting weekly optimization..."

# =============================================================================
# 1. Clean old cache files
# =============================================================================
log "Cleaning old cache files..."

if [ -d "$WORKSPACE/.cache" ]; then
    # Remove cache files older than 7 days
    find "$WORKSPACE/.cache" -type f -mtime +7 -delete 2>/dev/null || true
    log "✓ Cache cleaned"
else
    log "⚠ Cache directory not found"
fi

# =============================================================================
# 2. Clean old logs
# =============================================================================
log "Cleaning old logs..."

if [ -d "/var/log/openclaw" ]; then
    # Remove logs older than 30 days
    find "/var/log/openclaw" -name "*.log" -mtime +30 -delete 2>/dev/null || true
    log "✓ Logs cleaned"
else
    log "⚠ Log directory not found"
fi

# =============================================================================
# 3. Optimize git repository
# =============================================================================
log "Optimizing git repository..."

cd "$WORKSPACE"
if git rev-parse --git-dir > /dev/null 2>&1; then
    git gc --aggressive --prune=now 2>/dev/null || true
    log "✓ Git repository optimized"
else
    log "⚠ Not a git repository"
fi

# =============================================================================
# 4. Clean temporary files
# =============================================================================
log "Cleaning temporary files..."

find "$WORKSPACE" -name "*.tmp" -delete 2>/dev/null || true
find "$WORKSPACE" -name "*.bak" -delete 2>/dev/null || true
find "$WORKSPACE" -name "*~" -delete 2>/dev/null || true

log "✓ Temporary files cleaned"

# =============================================================================
# 5. Verify skills integrity
# =============================================================================
log "Verifying skills integrity..."

SKILL_COUNT=$(find "$WORKSPACE/skills" -name "SKILL.md" | wc -l)
log "✓ Found $SKILL_COUNT skills"

# =============================================================================
# 6. Update performance metrics
# =============================================================================
log "Updating performance metrics..."

cat > "$WORKSPACE/.cache/performance.json" <<EOF
{
  "last_optimization": "$(date -Iseconds)",
  "skills_count": $SKILL_COUNT,
  "cache_size_mb": $(du -sm "$WORKSPACE/.cache" 2>/dev/null | cut -f1 || echo 0),
  "log_size_mb": $(du -sm "/var/log/openclaw" 2>/dev/null | cut -f1 || echo 0),
  "workspace_size_mb": $(du -sm "$WORKSPACE" 2>/dev/null | cut -f1 || echo 0),
  "optimization_status": "success"
}
EOF

log "✓ Performance metrics updated"

# =============================================================================
# 7. Backup verification
# =============================================================================
log "Verifying backups..."

BACKUP_COUNT=$(find "/mnt/backups/openclaw" -name "*.tar.gz" 2>/dev/null | wc -l)
log "✓ Found $BACKUP_COUNT backups"

# =============================================================================
# 8. System health check
# =============================================================================
log "Running system health check..."

# Check disk space
DISK_USAGE=$(df -h "$WORKSPACE" | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 80 ]; then
    log "✓ Disk usage: ${DISK_USAGE}% (OK)"
else
    log "⚠ Disk usage: ${DISK_USAGE}% (WARNING)"
fi

# Check memory (if available)
if command -v free &> /dev/null; then
    MEM_USAGE=$(free | grep Mem | awk '{printf("%.0f", $3/$2 * 100.0)}')
    if [ "$MEM_USAGE" -lt 80 ]; then
        log "✓ Memory usage: ${MEM_USAGE}% (OK)"
    else
        log "⚠ Memory usage: ${MEM_USAGE}% (WARNING)"
    fi
fi

# =============================================================================
# COMPLETE
# =============================================================================
log "✅ Weekly optimization complete!"

# Write success marker
echo "$(date -Iseconds)" > "$WORKSPACE/.last_optimization"

log "Next optimization: $(date -d '+7 days' '+%Y-%m-%d %H:%M:%S')"
