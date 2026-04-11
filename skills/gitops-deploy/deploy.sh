#!/bin/bash
# deploy.sh - GitOps deployment trigger

ACTION="${1:-deploy}"
SCRIPT_DIR="$(dirname "$0")"
WORKSPACE_DIR="$SCRIPT_DIR/../../"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Create deployment trigger
create_trigger() {
    log "🚀 Creating deployment trigger..."
    
    cd "$WORKSPACE_DIR"
    
    # Create trigger file
    cat > .deploy-trigger << EOF
{
  "triggered_by": "gitops-deploy",
  "timestamp": "$(date -Iseconds)",
  "reason": "${2:-manual}",
  "commit": "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')"
}
EOF
    
    git add .deploy-trigger
    git commit -m "🚀 DEPLOY TRIGGER: ${2:-manual}" || true
    
    log "✅ Trigger created"
}

# Push to trigger deployment
push_deploy() {
    log "🚀 Pushing to trigger deployment..."
    
    cd "$WORKSPACE_DIR"
    
    # Create deploy commit
    echo "Deploy: $(date)" > .latest-deploy
    git add .latest-deploy
    git commit -m "🚀 Auto-deploy $(date)" || true
    
    # Push
    git push origin main 2>&1 | tee /tmp/gitops-deploy.log
    
    if [ ${PIPESTATUS[1]} -eq 0 ]; then
        log "✅ Deploy triggered via git push"
    else
        log "⚠️  Git push failed - may need credentials"
    fi
}

# Check deployment status
check_status() {
    log "📊 Checking deployment status..."
    
    cd "$WORKSPACE_DIR"
    
    echo "Recent deploys:"
    git log --oneline -10 --grep="DEPLOY" 2>/dev/null || echo "No deploy commits found"
}

# Help
show_help() {
    echo "🚀 GitOps Deploy"
    echo ""
    echo "Usage: $0 <action> [reason]"
    echo ""
    echo "Actions:"
    echo "  deploy [reason]  - Trigger deployment"
    echo "  push [reason]    - Push to trigger"
    echo "  status           - Check status"
    echo "  help             - Show this help"
}

case "$ACTION" in
    deploy) create_trigger "$2"; push_deploy "$2" ;;
    push) push_deploy "$2" ;;
    status) check_status ;;
    help|*) show_help ;;
esac
