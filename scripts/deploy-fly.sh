#!/bin/bash
# deploy-fly.sh - Deploy OpenClaw to Fly.io Free Tier

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "🪰 Fly.io Deployment Script"
log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if flyctl is installed
if ! command -v flyctl &> /dev/null; then
    log "❌ flyctl not found!"
    log "💡 Install with: curl -L https://fly.io/install.sh | sh"
    exit 1
fi

# Check if logged in
if ! flyctl auth whoami &> /dev/null; then
    log "🔐 Not logged in to Fly.io"
    log "💡 Run: flyctl auth signup"
    flyctl auth signup
    exit 1
fi

log "✅ Fly.io authenticated"

# Create app
APP_NAME="openclaw-backup-$(date +%Y%m%d)"
log "📦 Creating app: $APP_NAME"

flyctl launch --app "$APP_NAME" --no-deploy << EOF
y
$APP_NAME
sin
n
EOF

# Create fly.toml config
cat > fly.toml << 'EOF'
app = "openclaw-backup"
primary_region = "sin"

[build]
  dockerfile = "Dockerfile"

[env]
  NODE_ENV = "production"

[[mounts]]
  source = "openclaw_data"
  destination = "/data"

[[vm]]
  cpu_kind = "shared"
  cpus = 1
  memory_mb = 256

[http_service]
  internal_port = 8080
  force_https = true
  auto_stop_machines = false
  auto_start_machines = true
EOF

# Create Dockerfile
cat > Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 8080

CMD ["node", "."]
EOF

# Set secrets
log "🔐 Setting secrets..."
read -sp "Enter STATE_SYNC_KEY: " STATE_KEY
echo ""
flyctl secrets set STATE_SYNC_KEY="$STATE_KEY"

# Deploy
log "🚀 Deploying..."
flyctl deploy --detach

log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log "✅ Deployment Complete!"
log "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
log ""
log "App URL: https://$APP_NAME.fly.dev"
log "Status: flyctl status"
log "Logs: flyctl logs"
log ""
