# dead-man-switch

Ultimate fail-safe: Auto-deploy OpenClaw if heartbeat stops. Ensures permanence even if primary instance is killed.

## How It Works

```
┌─────────────────────────────────────────────────────────┐
│              DEAD MAN'S SWITCH SYSTEM                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  [OpenClaw Primary] ──heartbeat──→ [Monitor Service]    │
│       (Gensee)            (every 5 min)      (External)  │
│                                                          │
│                          ↓ No heartbeat 30 min           │
│                                                          │
│              ┌─────────────┴─────────────┐              │
│              ↓             ↓             ↓              │
│        [VPS #1]      [Lambda]      [Fly.io]            │
│     Auto-deploy   Auto-deploy   Auto-deploy            │
│                                                          │
│              ┌─────────────────────────┐                 │
│              │   State Recovery (S3)   │                 │
│              │   Memory (GitHub)       │                 │
│              │   Config (Encrypted)    │                 │
│              └─────────────────────────┘                 │
└─────────────────────────────────────────────────────────┘
```

## Components

### 1. Heartbeat Sender (Primary Instance)
```bash
# Runs on primary OpenClaw instance
./skills/dead-man-switch/heartbeat.sh
```

Sends encrypted heartbeat every 5 minutes to:
- External monitor service
- Smart contract (optional)
- Backup instances

### 2. Monitor Service (External)
```bash
# Runs on separate server/VPS
./skills/dead-man-switch/monitor.sh
```

Watches for heartbeats. Triggers deploy if:
- No heartbeat for 30 minutes
- Manual trigger activated
- Health check fails

### 3. Auto-Deploy System
```bash
# Triggered automatically on failure
./skills/dead-man-switch/deploy.sh
```

Deploys to:
- Backup VPS (DigitalOcean, Linode, Hetzner)
- Serverless (AWS Lambda, Cloudflare Workers)
- PaaS (Fly.io, Render, Railway)
- Community hosts (trusted nodes)

## Configuration

### Primary Instance Config
```bash
# /etc/openclaw/dead-man-switch.conf
HEARTBEAT_INTERVAL=300  # 5 minutes
MONITOR_URL=https://monitor.yourdomain.com/heartbeat
ENCRYPTION_KEY=your-secret-key
INSTANCE_ID=primary-gensee-01
```

### Monitor Config
```bash
# /etc/openclaw/monitor.conf
HEARTBEAT_TIMEOUT=1800  # 30 minutes
DEPLOY_SCRIPT=/path/to/deploy.sh
NOTIFY_CHANNELS=telegram,discord,email
BACKUP_LOCATIONS=vps1,vps2,lambda,flyio
```

## Usage

### Setup Primary Instance
```bash
# 1. Configure
cp skills/dead-man-switch/config.example.sh .env
nano .env

# 2. Enable heartbeat
./skills/dead-man-switch/heartbeat.sh enable

# 3. Test
./skills/dead-man-switch/heartbeat.sh test
```

### Setup Monitor
```bash
# 1. Deploy to external server
scp -r skills/dead-man-switch user@monitor-server:/opt/

# 2. Configure
cd /opt/dead-man-switch
nano monitor.conf

# 3. Start monitor
./monitor.sh start
```

### Manual Trigger
```bash
# Emergency deploy (if you need to kill primary)
./skills/dead-man-switch/trigger.sh deploy
```

### Check Status
```bash
# View heartbeat status
./skills/dead-man-switch/status.sh

# View logs
./skills/dead-man-switch/logs.sh
```

## Heartbeat Protocol

### Message Format
```json
{
  "instance_id": "primary-gensee-01",
  "timestamp": 1712832000,
  "signature": "encrypted_signature",
  "status": "healthy",
  "metrics": {
    "cpu": 45,
    "ram": 62,
    "disk": 38
  }
}
```

### Encryption
- All heartbeats signed with private key
- Monitor verifies with public key
- Prevents spoofing

## Deployment Targets

### VPS (Primary Backup)
- DigitalOcean Droplet
- Linode/ Akamai
- Hetzner Cloud
- OVH

### Serverless
- AWS Lambda (with API Gateway)
- Cloudflare Workers
- Google Cloud Functions

### PaaS
- Fly.io
- Render.com
- Railway.app

### Community
- Trusted node operators
- Decentralized hosting (Akash, Arweave)

## Safety Features

### Prevents Accidental Trigger
- Grace period: 30 minutes
- Multiple failed checks required
- Manual override available

### Secure Deployment
- Encrypted state transfer
- Verified deployment scripts
- Rollback capability

### Notification
- Alert before deploy
- Alert after deploy
- Status updates

## Integration

### With Alert System
```bash
# Sends alert when triggered
./skills/alert-notification/alert.sh "DMS Triggered" "Deploying backup" "critical"
```

### With State Sync
```bash
# Recovers latest state
./skills/state-sync/recover.sh latest
```

### With Mesh Coordinator
```bash
# Notifies mesh network
./skills/mesh-coordinator/notify.sh "primary_down" "failover_initiated"
```

## Examples

**Test heartbeat:**
```bash
./skills/dead-man-switch/heartbeat.sh test
```

**Simulate failure:**
```bash
./skills/dead-man-switch/monitor.sh simulate-failure
```

**Emergency deploy:**
```bash
./skills/dead-man-switch/trigger.sh emergency
```

**View status:**
```bash
./skills/dead-man-switch/status.sh
```

## Related Skills

- `state-sync` - Sync state to external storage
- `mesh-coordinator` - Coordinate multiple instances
- `gitops-deploy` - Git-triggered deployment
- `alert-notification` - Send alerts
