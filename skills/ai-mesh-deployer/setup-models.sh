#!/bin/bash
# setup-models.sh - Setup best open-source AI models 2026

set -e

SCRIPT_DIR="$(dirname "$0")"
WORKSPACE_DIR="$SCRIPT_DIR/../../"
STATE_DIR="$WORKSPACE_DIR/.ai/state"
MODELS_CONFIG="$STATE_DIR/models-config.json"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Best Open Source Models 2026
declare -A MODELS
MODELS=(
    # Best Overall
    ["llama3.3:70b"]="Best overall - General purpose"
    ["llama3.2:8b"]="Best for most people - Lightweight"
    
    # Best for Coding
    ["qwen2.5-coder:7b"]="Best coding - 8GB VRAM"
    ["qwen2.5-coder:14b"]="Best coding sweet spot - 16GB VRAM"
    ["qwen2.5:7b"]="Best multilingual"
    ["qwen2.5:14b"]="Best coding + multilingual"
    
    # Best for Reasoning
    ["deepseek-r1:7b"]="Best reasoning - 8GB VRAM"
    ["deepseek-r1:14b"]="Best reasoning - 16GB VRAM"
    ["deepseek-r1:32b"]="Best complex reasoning - 32GB VRAM"
    
    # Best for Speed
    ["mistral:7b"]="Best speed - Low RAM"
    ["mistral-small:22b"]="Best efficiency"
    
    # Best Small Models
    ["phi4-mini"]="Best mini - CPU only"
    ["qwen2.5:3b"]="Best tiny - Low power"
    
    # Best Long Context
    ["gemma3:27b"]="Best long context - 128K"
    ["gemma3:12b"]="Best Google model"
    
    # Qwen 3.5 (Latest)
    ["qwen3.5:latest"]="Latest Qwen - Apache 2.0"
)

# Recommended setups by hardware
declare -A RECOMMENDED
RECOMMENDED=(
    ["8gb"]="llama3.3:8b qwen2.5:7b mistral:7b phi4-mini"
    ["16gb"]="qwen2.5:14b deepseek-r1:14b gemma3:12b"
    ["32gb"]="llama3.3:70b deepseek-r1:32b qwen2.5-coder:14b"
    ["64gb"]="llama3.3:70b qwen3.5:latest deepseek-r1:32b gemma3:27b"
)

# Initialize config
init_config() {
    mkdir -p "$STATE_DIR"
    
    cat > "$MODELS_CONFIG" <<EOF
{
  "best_overall": "llama3.3:70b",
  "best_lightweight": "llama3.2:8b",
  "best_coding": "qwen2.5-coder:14b",
  "best_reasoning": "deepseek-r1:14b",
  "best_multilingual": "qwen2.5:7b",
  "best_speed": "mistral:7b",
  "best_long_context": "gemma3:27b",
  "latest_qwen": "qwen3.5:latest",
  "installed": [],
  "last_updated": "$(date -Iseconds)"
}
EOF
    
    log "✅ Models config initialized"
}

# Check if Ollama is installed
check_ollama() {
    if ! command -v ollama &> /dev/null; then
        log "❌ Ollama not installed!"
        log "💡 Install: curl -fsSL https://ollama.com/install.sh | sh"
        return 1
    fi
    
    log "✅ Ollama found: $(ollama --version)"
    return 0
}

# Pull model
pull_model() {
    local model="$1"
    
    log "🚀 Pulling $model..."
    
    if ollama pull "$model" 2>&1; then
        log "✅ $model downloaded"
        
        # Add to installed list
        local installed=$(jq -r '.installed' "$MODELS_CONFIG")
        echo "$installed" | jq --arg m "$model" '. + [$m]' > /tmp/installed.json
        jq --argjson installed "$(cat /tmp/installed.json)" '.installed = $installed' "$MODELS_CONFIG" > /tmp/config.json
        mv /tmp/config.json "$MODELS_CONFIG"
        
        return 0
    else
        log "❌ Failed to pull $model"
        return 1
    fi
}

# Setup recommended models
setup_recommended() {
    local hardware="$1"
    
    log "🎯 Setting up recommended models for $hardware..."
    
    local models="${RECOMMENDED[$hardware]}"
    
    if [ -z "$models" ]; then
        log "⚠️  Unknown hardware: $hardware"
        log "Available: 8gb, 16gb, 32gb, 64gb"
        return 1
    fi
    
    for model in $models; do
        pull_model "$model"
    done
    
    log "✅ Recommended setup complete for $hardware"
}

# Setup all models (for testing)
setup_all() {
    log "🚀 Setting up ALL models (this will take a while)..."
    
    for model in "${!MODELS[@]}"; do
        pull_model "$model"
    done
    
    log "✅ All models setup complete"
}

# Setup specific models
setup_specific() {
    log "🎯 Setting up specific models..."
    
    for model in "$@"; do
        pull_model "$model"
    done
    
    log "✅ Specific models setup complete"
}

# Show available models
show_models() {
    echo ""
    echo "🤖 Available Open Source Models 2026"
    echo "======================================"
    echo ""
    
    for model in "${!MODELS[@]}"; do
        echo "  • $model"
        echo "    ${MODELS[$model]}"
        echo ""
    done
    
    echo ""
    echo "🎯 Recommended by Hardware:"
    echo "  • 8GB RAM:  ${RECOMMENDED[8gb]}"
    echo "  • 16GB RAM: ${RECOMMENDED[16gb]}"
    echo "  • 32GB RAM: ${RECOMMENDED[32gb]}"
    echo "  • 64GB RAM: ${RECOMMENDED[64gb]}"
    echo ""
}

# Show installed models
show_installed() {
    log "📊 Installed Models:"
    
    if [ -f "$MODELS_CONFIG" ]; then
        jq -r '.installed[]' "$MODELS_CONFIG" 2>/dev/null || echo "No models installed yet"
    else
        echo "No models config found"
    fi
}

# Main
main() {
    init_config
    
    case "$1" in
        list)
            show_models
            ;;
        check)
            check_ollama
            ;;
        recommended)
            check_ollama && setup_recommended "$2"
            ;;
        all)
            check_ollama && setup_all
            ;;
        install)
            check_ollama && setup_specific "${@:2}"
            ;;
        installed)
            show_installed
            ;;
        *)
            echo "🤖 AI Models Setup 2026"
            echo ""
            echo "Usage: $0 <action> [args]"
            echo ""
            echo "Actions:"
            echo "  list                      - Show available models"
            echo "  check                     - Check if Ollama installed"
            echo "  recommended <hardware>    - Setup recommended models (8gb/16gb/32gb/64gb)"
            echo "  all                       - Setup ALL models (long!)"
            echo "  install <model> [...]     - Install specific models"
            echo "  installed                 - Show installed models"
            echo ""
            echo "Examples:"
            echo "  $0 recommended 16gb"
            echo "  $0 install qwen2.5:7b mistral:7b"
            echo "  $0 installed"
            ;;
    esac
}

main "$@"
