#!/bin/bash
# deploy.sh - Auto-deploy OpenClaw to backup locations

REASON="${2:-manual}"
SCRIPT_DIR="$(dirname "$0")"
STATE_DIR="/tmp/openclaw-state"
DEPLOY_LOG="/var/log/openclaw/dms-deploy.log"

# Ensure log dir
mkdir -p "$(dirname "$DEPLOY_LOG")" 2>/dev/null || DEPLOY_LOG="/tmp/dms-deploy.log"

# Deployment targets (configure in .env or here)
VPS_HOSTS="${VPS_HOSTS:-}"
LAMBDA_FUNCTION="${LAMBDA_FUNCTION:-}"
FLY_APP="${FLY_APP:-}"
GITHUB_REPO="${GITHUB_REPO:-}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$DEPLOY_LOG"
}

# Deploy to VPS via SSH
deploy_vps() {
    local host="$1"
    local user="${2:-root}"
    
    log "🚀 Deploying to VPS: $user@$host"
    
    if [ -z "$host" ]; then
        log "⚠️  No VPS host configured"
        return 1
    fi
    
    # SSH deploy command
    ssh -o StrictHostKeyChecking=no "$user@$host" << 'EOF'
        cd /opt/openclaw || mkdir -p /opt/openclaw
        git pull || echo "Git not configured"
        ./scripts/ACTIVATE.sh || echo "Activation script not found"
        systemctl restart openclaw || echo "Systemd not available"
EOF
    
    if [ $? -eq 0 ]; then
        log "✅ VPS deployment successful"
        return 0
    else
        log "❌ VPS deployment failed"
        return 1
    fi
}

# Deploy to AWS Lambda
deploy_lambda() {
    log "🚀 Deploying to AWS Lambda: $LAMBDA_FUNCTION"
    
    if [ -z "$LAMBDA_FUNCTION" ]; then
        log "⚠️  No Lambda function configured"
        return 1
    fi
    
    # Package code
    cd "$SCRIPT_DIR/../../"
    zip -r /tmp/openclaw-lambda.zip . -x "*.git*" "*.env" "node_modules/*"
    
    # Deploy via AWS CLI
    if command -v aws &> /dev/null; then
        aws lambda update-function-code \
            --function-name "$LAMBDA_FUNCTION" \
            --zip-file fileb:///tmp/openclaw-lambda.zip
        
        if [ $? -eq 0 ]; then
            log "✅ Lambda deployment successful"
            return 0
        fi
    else
        log "⚠️  AWS CLI not installed"
    fi
    
    return 1
}

# Deploy to Fly.io
deploy_fly() {
    log "🚀 Deploying to Fly.io: $FLY_APP"
    
    if [ -z "$FLY_APP" ]; then
        log "⚠️  No Fly.io app configured"
        return 1
    fi
    
    if command -v flyctl &> /dev/null; then
        cd "$SCRIPT_DIR/../../"
        flyctl deploy --app "$FLY_APP" --detach
        
        if [ $? -eq 0 ]; then
            log "✅ Fly.io deployment successful"
            return 0
        fi
    else
        log "⚠️  flyctl not installed"
    fi
    
    return 1
}

# Deploy via GitOps (push to repo, CI/CD handles rest)
deploy_gitops() {
    log "🚀 Deploying via GitOps: $GITHUB_REPO"
    
    if [ -z "$GITHUB_REPO" ]; then
        log "⚠️  No GitHub repo configured"
        return 1
    fi
    
    cd "$SCRIPT_DIR/../../"
    
    # Create deployment trigger file
    echo "Auto-deploy triggered: $(date)" > .auto-deploy-trigger
    git add .auto-deploy-trigger
    git commit -m "🚨 AUTO-DEPLOY: $REASON" || true
    git push origin main
    
    if [ $? -eq 0 ]; then
        log "✅ GitOps deployment triggered"
        return 0
    else
        log "⚠️  Git push failed (may need credentials)"
        return 1
    fi
}

# Save state for recovery
save_state() {
    log "💾 Saving state for recovery..."
    
    mkdir -p "$STATE_DIR"
    
    # Copy critical files
    cp -r "$SCRIPT_DIR/../../MEMORY.md" "$STATE_DIR/" 2>/dev/null
    cp -r "$SCRIPT_DIR/../../memory/" "$STATE_DIR/" 2>/dev/null
    cp -r "$SCRIPT_DIR/../../.env" "$STATE_DIR/" 2>/dev/null
    
    # Compress
    cd /tmp
    tar -czf openclaw-state-$(date +%Y%m%d_%H%M%S).tar.gz openclaw-state/
    
    log "✅ State saved to /tmp/openclaw-state-*.tar.gz"
}

# Main deployment
main() {
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log "🚨 DEAD MAN'S SWITCH - AUTO-DEPLOY"
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log "Reason: $REASON"
    log "Timestamp: $(date)"
    
    # Save state first
    save_state
    
    # Deploy to all configured targets
    DEPLOYED=0
    FAILED=0
    
    # VPS deployment
    if [ -n "$VPS_HOSTS" ]; then
        IFS=',' read -ra HOSTS <<< "$VPS_HOSTS"
        for host in "${HOSTS[@]}"; do
            deploy_vps "$host"
            [ $? -eq 0 ] && ((DEPLOYED++)) || ((FAILED++))
        done
    fi
    
    # Lambda deployment
    if [ -n "$LAMBDA_FUNCTION" ]; then
        deploy_lambda
        [ $? -eq 0 ] && ((DEPLOYED++)) || ((FAILED++))
    fi
    
    # Fly.io deployment
    if [ -n "$FLY_APP" ]; then
        deploy_fly
        [ $? -eq 0 ] && ((DEPLOYED++)) || ((FAILED++))
    fi
    
    # GitOps deployment
    if [ -n "$GITHUB_REPO" ]; then
        deploy_gitops
        [ $? -eq 0 ] && ((DEPLOYED++)) || ((FAILED++))
    fi
    
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    log "Deployment Summary:"
    log "  Successful: $DEPLOYED"
    log "  Failed: $FAILED"
    log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ $DEPLOYED -gt 0 ]; then
        log "✅ Auto-deploy complete!"
        exit 0
    else
        log "❌ All deployments failed!"
        exit 1
    fi
}

# Run
main
