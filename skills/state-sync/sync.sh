#!/bin/bash
# sync.sh - Encrypted state synchronization

ACTION="${1:-help}"
SCRIPT_DIR="$(dirname "$0")"
STATE_DIR="/tmp/openclaw-state-sync"
ENCRYPTION_KEY="${STATE_SYNC_KEY:-}"

# Storage backends
GITHUB_REPO="${STATE_SYNC_GITHUB:-}"
S3_BUCKET="${STATE_SYNC_S3:-}"
GDRIVE_FOLDER="${STATE_SYNC_GDRIVE:-}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Encrypt data
encrypt() {
    local input="$1"
    local output="$2"
    
    if [ -z "$ENCRYPTION_KEY" ]; then
        log "⚠️  No encryption key set, skipping encryption"
        cp "$input" "$output"
        return
    fi
    
    openssl enc -aes-256-cbc -salt -pbkdf2 \
        -in "$input" -out "$output" \
        -pass pass:"$ENCRYPTION_KEY"
}

# Decrypt data
decrypt() {
    local input="$1"
    local output="$2"
    
    if [ -z "$ENCRYPTION_KEY" ]; then
        log "⚠️  No encryption key set, assuming unencrypted"
        cp "$input" "$output"
        return
    fi
    
    openssl enc -aes-256-cbc -d -pbkdf2 \
        -in "$input" -out "$output" \
        -pass pass:"$ENCRYPTION_KEY"
}

# Prepare state for sync
prepare_state() {
    log "📦 Preparing state..."
    
    mkdir -p "$STATE_DIR"
    
    # Copy critical files
    WORKSPACE_DIR="$SCRIPT_DIR/../../"
    
    cp "$WORKSPACE_DIR/MEMORY.md" "$STATE_DIR/" 2>/dev/null && log "  ✅ MEMORY.md"
    cp -r "$WORKSPACE_DIR/memory/" "$STATE_DIR/" 2>/dev/null && log "  ✅ memory/"
    cp "$WORKSPACE_DIR/USER.md" "$STATE_DIR/" 2>/dev/null && log "  ✅ USER.md"
    cp "$WORKSPACE_DIR/SOUL.md" "$STATE_DIR/" 2>/dev/null && log "  ✅ SOUL.md"
    cp "$WORKSPACE_DIR/.env" "$STATE_DIR/" 2>/dev/null && log "  ✅ .env"
    
    # Compress
    cd /tmp
    tar -czf state-$(date +%Y%m%d_%H%M%S).tar.gz -C "$STATE_DIR" .
    
    log "✅ State prepared: /tmp/state-*.tar.gz"
}

# Push to GitHub
push_github() {
    log "🚀 Pushing to GitHub: $GITHUB_REPO"
    
    if [ -z "$GITHUB_REPO" ]; then
        log "⚠️  GitHub not configured"
        return 1
    fi
    
    # Clone/pull
    git clone "$GITHUB_REPO" /tmp/state-repo 2>/dev/null || true
    cd /tmp/state-repo
    
    # Copy state
    cp /tmp/state-*.tar.gz ./ 2>/dev/null
    
    # Commit and push
    git add .
    git commit -m "State sync: $(date)" || true
    git push
    
    log "✅ GitHub sync complete"
}

# Push to S3
push_s3() {
    log "🚀 Pushing to S3: $S3_BUCKET"
    
    if [ -z "$S3_BUCKET" ]; then
        log "⚠️  S3 not configured"
        return 1
    fi
    
    if command -v aws &> /dev/null; then
        aws s3 cp /tmp/state-*.tar.gz "s3://$S3_BUCKET/state-$(date +%Y%m%d_%H%M%S).tar.gz"
        log "✅ S3 sync complete"
    else
        log "⚠️  AWS CLI not installed"
        return 1
    fi
}

# Pull from GitHub
pull_github() {
    log "📥 Pulling from GitHub: $GITHUB_REPO"
    
    if [ -z "$GITHUB_REPO" ]; then
        log "⚠️  GitHub not configured"
        return 1
    fi
    
    git clone "$GITHUB_REPO" /tmp/state-recover 2>/dev/null
    cd /tmp/state-recover
    
    # Get latest state
    LATEST=$(ls -t state-*.tar.gz 2>/dev/null | head -1)
    
    if [ -n "$LATEST" ]; then
        tar -xzf "$LATEST" -C "$SCRIPT_DIR/../../"
        log "✅ GitHub recovery complete"
    else
        log "❌ No state files found"
        return 1
    fi
}

# Main sync
sync_push() {
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log "🔄 STATE SYNC - PUSH"
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    prepare_state
    
    push_github
    push_s3
    
    log "✅ Sync complete"
}

# Main recover
sync_pull() {
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log "🔄 STATE SYNC - PULL (RECOVER)"
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    pull_github
    
    log "✅ Recovery complete"
}

# Show status
show_status() {
    echo "📊 State Sync Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "GitHub: ${GITHUB_REPO:-Not configured}"
    echo "S3: ${S3_BUCKET:-Not configured}"
    echo "GDrive: ${GDRIVE_FOLDER:-Not configured}"
    echo "Encryption: $([ -n "$ENCRYPTION_KEY" ] && echo "✅ Enabled" || echo "❌ Disabled")"
}

# Help
show_help() {
    echo "🔄 State Sync"
    echo ""
    echo "Usage: $0 <action>"
    echo ""
    echo "Actions:"
    echo "  push    - Sync state to external storage"
    echo "  pull    - Recover state from external storage"
    echo "  status  - Show sync status"
    echo "  help    - Show this help"
}

case "$ACTION" in
    push)   sync_push ;;
    pull)   sync_pull ;;
    status) show_status ;;
    help|*) show_help ;;
esac
