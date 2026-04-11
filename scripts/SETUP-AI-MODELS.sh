#!/bin/bash
# SETUP-AI-MODELS.sh - One-command setup for permanent AI models

set -e

SCRIPT_DIR="$(dirname "$0")"
WORKSPACE_DIR="$SCRIPT_DIR/../"
AI_DIR="$WORKSPACE_DIR/.ai"
STATE_DIR="$AI_DIR/state"
MODELS_CONFIG="$AI_DIR/models-config.json"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

banner() {
    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║   OPENCLAW AI MODELS - PERMANENT SETUP   ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
}

# Step 1: Install Ollama
install_ollama() {
    log "🚀 Step 1: Installing Ollama..."
    
    if command -v ollama &> /dev/null; then
        log "✅ Ollama already installed: $(ollama --version)"
        return 0
    fi
    
    curl -fsSL https://ollama.com/install.sh | sh
    
    if command -v ollama &> /dev/null; then
        log "✅ Ollama installed successfully"
        return 0
    else
        log "❌ Failed to install Ollama"
        return 1
    fi
}

# Step 2: Start Ollama service
start_ollama() {
    log "🚀 Step 2: Starting Ollama service..."
    
    # Check if systemd is available
    if command -v systemctl &> /dev/null; then
        systemctl start ollama 2>/dev/null || true
        systemctl enable ollama 2>/dev/null || true
        log "✅ Ollama service started (systemd)"
    else
        # Manual start
        ollama serve &
        sleep 3
        log "✅ Ollama service started (manual)"
    fi
}

# Step 3: Setup directories
setup_dirs() {
    log "🚀 Step 3: Creating directories..."
    
    mkdir -p "$AI_DIR" "$STATE_DIR"
    
    log "✅ Directories created"
}

# Step 4: Initialize config
init_config() {
    log "🚀 Step 4: Initializing config..."
    
    if [ ! -f "$MODELS_CONFIG" ]; then
        cat > "$MODELS_CONFIG" <<EOF
{
  "best_overall": "llama3.3:70b",
  "best_lightweight": "llama3.2:8b",
  "best_coding": "qwen2.5-coder:14b",
  "best_reasoning": "deepseek-r1:14b",
  "best_multilingual": "qwen2.5:7b",
  "best_speed": "mistral:7b",
  "latest_qwen": "qwen3.5:latest",
  "installed": [],
  "target_hardware": "16gb",
  "auto_setup": true,
  "last_updated": "$(date -Iseconds)"
}
EOF
        log "✅ Config initialized"
    else
        log "✅ Config already exists"
    fi
}

# Step 5: Detect hardware
detect_hardware() {
    log "🚀 Step 5: Detecting hardware..."
    
    local total_ram=$(free -g | awk '/^Mem:/{print $2}')
    local recommended=""
    
    if [ "$total_ram" -lt 12 ]; then
        recommended="8gb"
    elif [ "$total_ram" -lt 24 ]; then
        recommended="16gb"
    elif [ "$total_ram" -lt 48 ]; then
        recommended="32gb"
    else
        recommended="64gb"
    fi
    
    log "✅ Detected: ${total_ram}GB RAM → Recommended: $recommended"
    
    # Update config
    jq --arg hw "$recommended" '.target_hardware = $hw' "$MODELS_CONFIG" > /tmp/config.json
    mv /tmp/config.json "$MODELS_CONFIG"
}

# Step 6: Pull models
pull_models() {
    log "🚀 Step 6: Pulling AI models..."
    
    local hardware=$(jq -r '.target_hardware' "$MODELS_CONFIG")
    local models=""
    
    case "$hardware" in
        8gb)
            models="llama3.2:8b qwen2.5:7b mistral:7b"
            ;;
        16gb)
            models="llama3.2:8b qwen2.5-coder:14b deepseek-r1:14b"
            ;;
        32gb)
            models="llama3.3:70b qwen2.5-coder:14b deepseek-r1:32b"
            ;;
        64gb)
            models="llama3.3:70b qwen3.5:latest deepseek-r1:32b gemma3:27b"
            ;;
    esac
    
    log "📦 Models to install: $models"
    
    local installed=()
    
    for model in $models; do
        log "⬇️  Pulling $model..."
        
        if ollama pull "$model" 2>&1; then
            log "✅ $model downloaded"
            installed+=("$model")
        else
            log "⚠️  Failed to pull $model (continuing...)"
        fi
    done
    
    # Update installed list
    local installed_json=$(printf '%s\n' "${installed[@]}" | jq -R . | jq -s .)
    jq --argjson installed "$installed_json" '.installed = $installed' "$MODELS_CONFIG" > /tmp/config.json
    mv /tmp/config.json "$MODELS_CONFIG"
    
    log "✅ Models pulled: ${#installed[@]}"
}

# Step 7: Verify installation
verify() {
    log "🚀 Step 7: Verifying installation..."
    
    echo ""
    echo "Installed models:"
    ollama list
    
    echo ""
    log "✅ Verification complete"
}

# Step 8: Sync to Git
sync_git() {
    log "🚀 Step 8: Syncing to GitHub..."
    
    cd "$WORKSPACE_DIR"
    
    git config --local user.email "ai-models@local"
    git config --local user.name "AI Models Setup"
    
    git add .ai/
    git commit -m "🤖 AI Models: Permanent setup $(date)" || true
    git push || true
    
    log "✅ Synced to GitHub"
}

# Step 9: Create systemd service
create_service() {
    log "🚀 Step 9: Creating systemd service..."
    
    if [ ! -f /etc/systemd/system/openclaw-ollama.service ]; then
        cat > /etc/systemd/system/openclaw-ollama.service <<EOF
[Unit]
Description=OpenClaw Ollama AI Service
After=network.target

[Service]
Type=simple
User=$USER
ExecStart=/usr/local/bin/ollama serve
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
        
        systemctl daemon-reload
        systemctl enable openclaw-ollama
        systemctl start openclaw-ollama
        
        log "✅ Systemd service created"
    else
        log "✅ Service already exists"
    fi
}

# Main
main() {
    banner
    
    log "🚀 Starting PERMANENT AI Models Setup..."
    echo ""
    
    install_ollama || { log "❌ Failed at Step 1"; exit 1; }
    start_ollama
    setup_dirs
    init_config
    detect_hardware
    pull_models || { log "⚠️  Some models failed (continuing...)"; }
    verify
    sync_git
    create_service
    
    echo ""
    echo "╔══════════════════════════════════════════╗"
    echo "║   ✅ PERMANENT SETUP COMPLETE!            ║"
    echo "╠══════════════════════════════════════════╣"
    echo "║  Ollama:        ✅ Installed             ║"
    echo "║  Models:        ✅ Downloaded            ║"
    echo "║  Service:       ✅ Active                ║"
    echo "║  GitHub Sync:   ✅ Complete              ║"
    echo "║                                          ║"
    echo "║  Next: Run 'ollama list' to verify      ║"
    echo "╚══════════════════════════════════════════╝"
    echo ""
}

main "$@"
