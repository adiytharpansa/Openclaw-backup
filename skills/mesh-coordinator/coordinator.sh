#!/bin/bash
# coordinator.sh - Mesh network coordinator

ACTION="${1:-help}"
SCRIPT_DIR="$(dirname "$0")"
MESH_STATE="/tmp/openclaw-mesh.json"
PEERS_FILE="/tmp/openclaw-peers.txt"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Register this instance
register_instance() {
    local instance_id="${MESH_INSTANCE_ID:-node-$(hostname)}"
    local instance_url="${MESH_URL:-http://localhost:8080}"
    
    log "📍 Registering instance: $instance_id"
    
    # Add to peers file
    echo "$instance_id|$instance_url|$(date +%s)|active" >> "$PEERS_FILE"
    
    log "✅ Registered: $instance_id"
}

# Discover peers
discover_peers() {
    log "🔍 Discovering peers..."
    
    if [ ! -f "$PEERS_FILE" ]; then
        log "⚠️  No peers file found"
        return 1
    fi
    
    echo "Active Peers:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    while IFS='|' read -r id url timestamp status; do
        age=$(($(date +%s) - timestamp))
        if [ "$age" -lt 300 ]; then  # 5 min timeout
            echo "  ✅ $id - $url (${age}s ago)"
        else
            echo "  ⚠️  $id - $url (stale: ${age}s)"
        fi
    done < "$PEERS_FILE"
}

# Check peer health
check_peer_health() {
    log "🏥 Checking peer health..."
    
    while IFS='|' read -r id url timestamp status; do
        response=$(curl -s -o /dev/null -w "%{http_code}" "$url/health" 2>/dev/null)
        
        if [ "$response" = "200" ]; then
            log "  ✅ $id: healthy"
        else
            log "  ❌ $id: unreachable"
        fi
    done < "$PEERS_FILE"
}

# Broadcast message
broadcast() {
    local message="$1"
    
    log "📢 Broadcasting: $message"
    
    while IFS='|' read -r id url timestamp status; do
        curl -s -X POST "$url/api/message" \
            -H "Content-Type: application/json" \
            -d "{\"message\": \"$message\"}" \
            2>/dev/null && log "  ✅ Sent to $id"
    done < "$PEERS_FILE"
}

# Elect leader
elect_leader() {
    log "👑 Electing leader..."
    
    # Simple: first active node becomes leader
    while IFS='|' read -r id url timestamp status; do
        age=$(($(date +%s) - timestamp))
        if [ "$age" -lt 300 ]; then
            log "✅ Leader: $id"
            echo "$id" > /tmp/openclaw-leader.txt
            return 0
        fi
    done < "$PEERS_FILE"
    
    log "❌ No active nodes for leader"
    return 1
}

# Show status
show_status() {
    echo "🕸️  Mesh Coordinator Status"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ -f /tmp/openclaw-leader.txt ]; then
        echo "Leader: $(cat /tmp/openclaw-leader.txt)"
    else
        echo "Leader: None"
    fi
    
    echo ""
    discover_peers
}

# Help
show_help() {
    echo "🕸️  Mesh Coordinator"
    echo ""
    echo "Usage: $0 <action>"
    echo ""
    echo "Actions:"
    echo "  register  - Register this instance"
    echo "  discover  - Discover peers"
    echo "  health    - Check peer health"
    echo "  broadcast <msg> - Broadcast message"
    echo "  elect     - Elect leader"
    echo "  status    - Show status"
    echo "  help      - Show this help"
}

case "$ACTION" in
    register) register_instance ;;
    discover) discover_peers ;;
    health) check_peer_health ;;
    broadcast) broadcast "$2" ;;
    elect) elect_leader ;;
    status) show_status ;;
    help|*) show_help ;;
esac
