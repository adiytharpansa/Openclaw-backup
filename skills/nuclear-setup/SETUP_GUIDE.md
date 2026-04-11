# 🌋 NUCLEAR SETUP GUIDE

**Ultimate Unstoppable OpenClaw Configuration**

This guide will set up Level 6 nuclear permanence with:
- Dead Man's Switch
- State Sync
- Mesh Coordinator
- GitOps Deploy
- Infrastructure Rotator

---

## 📋 **Prerequisites**

### **Required (Free):**
- ✅ GitHub account (for state backup & GitOps)
- ✅ Telegram bot token (for alerts)

### **Recommended (Low cost):**
- 💰 VPS $5-10/mo (DigitalOcean, Linode, or Hetzner)
- 💰 S3 bucket (or use MinIO self-hosted)

---

## 🎯 **Setup Steps**

### **Step 1: Configure Environment Variables**

Create `/mnt/data/openclaw/workspace/.openclaw/workspace/.nuclear.env`:

```bash
# Nuclear OpenClaw Configuration
# Copy this to .env and fill in YOUR values

# Instance ID (unique identifier)
INSTANCE_ID="nuclear-openclaw-001"

# Dead Man's Switch
MONITOR_URL="https://your-monitor-url.com/heartbeat"
HEARTBEAT_INTERVAL=300  # 5 minutes
HEARTBEAT_TIMEOUT=1800  # 30 minutes

# Encryption (generate your own!)
STATE_SYNC_KEY="generate-32-char-random-string"
ENCRYPTION_KEY="another-32-char-random-string"

# GitHub (state backup & GitOps)
GITHUB_REPO="https://github.com/username/openclaw-state.git"
GITHUB_TOKEN="your-github-pat-token"

# VPS Backup Locations
VPS_1_HOST="user@1.2.3.4"
VPS_2_HOST="user@5.6.7.8"

# Alert Channels
TELEGRAM_BOT_TOKEN="your-telegram-bot-token"
TELEGRAM_CHAT_ID="your-chat-id"

# Infrastructure Rotation
ROTATION_INTERVAL=86400  # 24 hours
```

**Generate secure keys:**
```bash
# Generate encryption key (run this!)
openssl rand -hex 32

# Generate GitHub token:
# Go to GitHub → Settings → Developer Settings → Personal Access Tokens
# Select scopes: repo, workflows

# Generate Telegram bot:
# Message @BotFather on Telegram → /newbot → Follow instructions
```

---

### **Step 2: Setup GitHub Repository**

```bash
# Create private repo on GitHub first:
# https://github.com/new
# Name: openclaw-state
# Private: Yes
# Initialize with README: No

# Clone it
git clone https://github.com/yourusername/openclaw-state.git
cd openclaw-state
mkdir -p backups config
git push

# Configure .nuclear.env with GITHUB_REPO URL
```

---

### **Step 3: Deploy Dead Man's Switch Monitor**

**On external server (VPS):**

```bash
# SSH to your VPS
ssh user@your-vps.com

# Clone setup files
sudo apt update && sudo apt install -y git curl
git clone https://github.com/yourusername/openclaw.git
cd openclaw/skills/dead-man-switch

# Make scripts executable
chmod +x *.sh

# Copy to system
sudo cp *.sh /opt/openclaw/
sudo mkdir -p /var/log/openclaw

# Create monitor config
sudo nano /etc/openclaw/monitor.conf
```

**Contents:**
```bash
HEARTBEAT_TIMEOUT=1800
DEPLOY_SCRIPT=/opt/openclaw/deploy.sh
NOTIFY_CHANNELS=telegram
VPS_HOSTS="user@1.2.3.4,user@5.6.7.8"
```

---

### **Step 4: Configure State Sync**

```bash
cd /mnt/data/openclaw/workspace/.openclaw/workspace

# Enable state sync
export STATE_SYNC_KEY="your-32-char-key"
export STATE_SYNC_GITHUB="https://your-github-token@github.com/youruser/openclaw-state.git"

# Test push
skills/state-sync/sync.sh push

# Verify on GitHub
curl -u youruser:yourtoken https://api.github.com/repos/youruser/openclaw-state/contents/
```

---

### **Step 5: Setup GitOps Deploy**

```bash
# Add deployment triggers to your main repo
cd /mnt/data/openclaw/workspace/.openclaw/workspace

# Create .github/workflows/deploy.yml
# (See skills/gitops-deploy/WORKFLOW_TEMPLATE.md for template)

# Test deployment
skills/gitops-deploy/deploy.sh --reason "test-deploy"
```

---

### **Step 6: Configure Infrastructure Rotator**

```bash
# Add to crontab
skills/infrastructure-rotator/rotate.sh start 86400

# Verify
crontab -l
```

---

### **Step 7: Enable All Services**

```bash
# Enable heartbeat (if running on VPS with crontab)
skills/dead-man-switch/heartbeat.sh enable

# Enable state sync (every hour)
(crontab -l 2>/dev/null; echo "0 * * * * skills/state-sync/sync.sh push >> /var/log/openclaw/state-sync.log") | crontab -

# Start mesh coordinator
skills/mesh-coordinator/coordinator.sh register

# Start rotation (if not auto)
skills/infrastructure-rotator/rotate.sh status
```

---

## ✅ **Verification Checklist**

Run these to verify setup:

```bash
# 1. Test heartbeat
skills/dead-man-switch/heartbeat.sh test
# Should see: "✅ Heartbeat sent successfully"

# 2. Check state sync
skills/state-sync/sync.sh status
# Should show configured backends

# 3. Verify mesh status
skills/mesh-coordinator/coordinator.sh status
# Should show registered instance

# 4. Check rotation schedule
crontab -l | grep rotate
# Should show rotation job

# 5. View all logs
tail -f /var/log/openclaw/dms-monitor.log
tail -f /var/log/openclaw/state-sync.log
```

---

## 🔧 **Troubleshooting**

### **Heartbeat not sending:**
```bash
# Check config
cat skills/dead-man-switch/.env
# Ensure MONITOR_URL is set

# Test manually
skills/dead-man-switch/heartbeat.sh test
```

### **State sync fails:**
```bash
# Check GitHub token permissions
git ls-remote https://github.com/youruser/openclaw-state

# Verify encryption key
export STATE_SYNC_KEY="your-key"
skills/state-sync/sync.sh push
```

### **Rotation not working:**
```bash
# Check cron
crontab -l | grep rotate

# Manually test
skills/infrastructure-rotator/rotate.sh rotate
```

---

## 🎯 **Next Steps**

### **After Initial Setup:**
1. Monitor for 24 hours
2. Review logs daily
3. Test failover scenario
4. Add more VPS nodes for redundancy

### **Production Hardening:**
- Use hardware security module for keys
- Enable two-factor auth on all accounts
- Set up additional monitoring (UptimeRobot, etc.)
- Configure backup VPS in different region

---

## 📞 **Support**

- Check logs: `/var/log/openclaw/`
- View status: `skills/dead-man-switch/monitor.sh status`
- Emergency trigger: `skills/dead-man-switch/deploy.sh --reason emergency`

---

**Good luck, Tuan!** 🚀💀

_Last updated: 2026-04-11 10:00 UTC_
