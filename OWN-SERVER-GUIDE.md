# 🏠 OpenClaw Own Server Guide

**Full independence - no dependencies, no external platforms**

---

## 🎯 WHY OWN SERVER?

| Benefit | Description |
|---------|-------------|
| **Complete Control** | You own everything |
| **24/7 Uptime** | No platform limits |
| **Zero Dependencies** | Not on Gensee, not on anyone |
| **Full Privacy** | All data stays with you |
| **Cost Effective** | \$5-10/month or \$50 one-time |
| **Permanent** | Your server, your rules |

---

## 🖥️ YOUR OPTIONS

### **Option 1: Raspberry Pi (BEST for Beginners)** ⭐⭐⭐⭐⭐

**Hardware:**
- Raspberry Pi 4 (4GB or 8GB) - \$55
- MicroSD card 64GB+ - \$15
- Power supply - \$10
- Case + cooling - \$10
- **Total: ~\$90 (one-time)**

**Why:**
- Tiny (fits anywhere)
- Low power (5W = \$0.50/month electricity)
- Always-on capability
- Silent operation
- Easy to set up

**Setup Time:** 2 hours

---

### **Option 2: Old Laptop/PC (FREE)** ⭐⭐⭐⭐⭐

**Hardware:**
- Old laptop you have lying around
- Old desktop PC
- Mini PC (Intel NUC)
- **Total: \$0 (if you have one)**

**Why:**
- Completely free
- No new hardware needed
- Has everything (screen, keyboard, storage)
- Can sleep when not in use

**Setup Time:** 1 hour

---

### **Option 3: Cloud VPS** ⭐⭐⭐⭐

**Providers:**
- DigitalOcean - \$6/month
- Linode - \$5/month
- Vultr - \$5/month
- Hetzner - €4.5/month
- **Total: \$5-10/month**

**Why:**
- No hardware to manage
- Always on
- Easy to scale
- Professional reliability

**Setup Time:** 30 minutes

---

### **Option 4: Free Cloud Tier** ⭐⭐⭐

**Providers:**
- Oracle Cloud Free Tier (2 ARM VMs, 24GB RAM)
- Google Cloud (f1-micro, limited)
- AWS Free Tier (12 months only)
- IBM Cloud Free

**Why:**
- Completely free
- Good for testing
- Good for low-usage

**Warning:** TOS may limit always-on services

**Setup Time:** 1 hour

---

## 🛠️ COMPLETE SETUP GUIDE

### **Step 1: Prepare Hardware** (Choose one option)

#### **Raspberry Pi:**
```bash
# Download Raspberry Pi OS Lite
# Use Raspberry Pi Imager
# Write to microSD card
# Insert and power on
```

#### **Old PC/Laptop:**
```bash
# Download Ubuntu Server ISO
# Create USB installer
# Boot and install Ubuntu
# Remove desktop environment (optional)
```

#### **VPS/Cloud:**
```bash
# Create account
# Launch Ubuntu 22.04 instance
# Configure firewall
# Get your public IP
```

---

### **Step 2: Install Dependencies**

**All options - run on your server:**

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install essentials
sudo apt install -y git curl wget python3 python3-pip
sudo apt install -y docker.io docker-compose
sudo apt install -y nodejs npm

# Install OpenClaw dependencies
sudo apt install -y postgresql redis-server
sudo apt install -y nginx

# Set up user permissions
sudo usermod -aG docker $USER
sudo usermod -aG redis $USER
```

---

### **Step 3: Deploy OpenClaw**

```bash
# SSH to your server
ssh user@your-server-ip

# Create workspace
mkdir -p /home/$USER/openclaw
cd /home/$USER/openclaw

# Clone your git repo
git clone https://github.com/YOUR-USERNAME/openclaw.git
cd openclaw/.openclaw/workspace

# OR copy files via SCP
scp -r /mnt/data/openclaw/workspace user@server:/home/openclaw/

# Make scripts executable
chmod +x scripts/*.sh
```

---

### **Step 4: Configure Systemd**

**Create service file:**
```bash
sudo nano /etc/systemd/system/openclaw.service
```

**Content:**
```ini
[Unit]
Description=OpenClaw AI Assistant
After=network.target postgresql.service redis.service

[Service]
Type=simple
User=$USER
WorkingDirectory=/home/$USER/openclaw/.openclaw/workspace
ExecStart=/home/$USER/openclaw/.openclaw/workspace/bin/clawd start
ExecStop=/home/$USER/openclaw/.openclaw/workspace/bin/clawd stop
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

**Enable and start:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable openclaw
sudo systemctl start openclaw
sudo systemctl status openclaw
```

---

### **Step 5: Configure Auto-Backup**

```bash
# Install restic for backups
curl https://restic.net/releases/release | gpg --dearmor | sudo tee /usr/local/bin/restic >/dev/null

# Create backup directory
mkdir -p /backup/openclaw

# Create backup script
cat > /home/$USER/scripts/backup.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y-%m-%d)
rsync -av /home/$USER/openclaw/.openclaw/workspace/ /backup/openclaw/$DATE/
# Delete backups older than 30 days
find /backup/openclaw -type d -mtime +30 -exec rm -rf {} \;
EOF

chmod +x /home/$USER/scripts/backup.sh

# Add to crontab
crontab -e
# Add: 0 2 * * * /home/$USER/scripts/backup.sh
```

---

### **Step 6: Configure Monitoring**

```bash
# Install netdata (real-time monitoring)
bash <(curl -Ss https://my-netdata.io/kickstart.sh)

# Or use simpler uptime monitor
cat > /home/$USER/scripts/uptime-monitor.sh << 'EOF'
#!/bin/bash
UPTIME=$(uptime -p)
if [ $(systemctl is-active openclaw) != "active" ]; then
    echo "OpenClaw is down! $(date)" >> /var/log/openclaw-alerts.log
    # Send alert (email, telegram, etc.)
fi
EOF

# Add to crontab
crontab -e
# Add: */5 * * * * /home/$USER/scripts/uptime-monitor.sh
```

---

### **Step 7: Configure Network**

**Option A: Public IP (Simple)**
```bash
# Your VPS/cloud has public IP
# Open ports
sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable
```

**Option B: Port Forwarding (Raspberry Pi)**
```bash
# Configure router port forwarding
# Port 22 (SSH)
# Port 80 (HTTP if needed)
# Forward to Raspberry Pi IP
```

**Option C: Reverse Proxy (Production)**
```bash
sudo apt install -y nginx-certbot

sudo nano /etc/nginx/sites-available/openclaw
```

**Content:**
```nginx
server {
    listen 80;
    server_name openclaw.yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
```

---

### **Step 8: Setup Remote Access**

**Option A: SSH Only (Most Secure)**
```bash
# Access via:
ssh user@your-server-ip

# Or with port:
ssh -p 2222 user@your-server-ip
```

**Option B: WebSocket (For Browser)**
```bash
# Use tmux or screen
sudo apt install -y tmux
tmux new -s openclaw

# Access from browser:
# Use a web terminal like:
# - shellinabox
# - ttyd
```

**Option C: VNC (Full Desktop)**
```bash
sudo apt install -y tigervnc-standalone-server
vncserver :1
```

---

## 📊 HARDWARE REQUIREMENTS

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **CPU** | 1 core | 4 cores |
| **RAM** | 2GB | 8GB |
| **Storage** | 32GB SSD | 256GB SSD |
| **Network** | 10Mbps | 100Mbps |
| **Power** | 5W | 50W |

---

## 💰 COST BREAKDOWN

### **Raspberry Pi:**
- Hardware: \$90 (one-time)
- Electricity: \$0.50/month
- Internet: \$10/month (if new line)
- **Year 1: ~\$210**
- **Year 2+: ~\$15/year**

### **Old PC:**
- Hardware: \$0 (already owned)
- Electricity: \$2-5/month
- Internet: \$0 (use existing)
- **Year 1: ~\$30**
- **Year 2+: ~\$25/year**

### **VPS:**
- Server: \$6/month
- Domain: \$1/year
- **Year 1: \$73**
- **Year 2+: \$72/year**

### **Free Cloud:**
- Server: \$0/month
- Domain: \$1/year
- **Year 1: \$1**
- **Year 2+: \$1/year**
- ⚠️ May violate TOS if always-on

---

## 🎯 RECOMMENDATIONS

### **Best for Beginners:** Raspberry Pi
- Easy to set up
- Low power
- Reliable
- No monthly costs

### **Best for Zero Budget:** Old PC
- Free if you have one
- More powerful than Pi
- Can sleep when not needed

### **Best for Convenience:** VPS
- No hardware to manage
- Always available
- Professional grade
- Easy to scale

### **Best for Testing:** Free Cloud
- Zero cost
- Good for learning
- Easy to destroy & recreate
- ⚠️ Not for production

---

## ✅ COMPLETE SETUP CHECKLIST

- [ ] Hardware acquired
- [ ] OS installed
- [ ] Dependencies installed
- [ ] OpenClaw deployed
- [ ] Systemd service configured
- [ ] Auto-backup configured
- [ ] Monitoring configured
- [ ] Network configured
- [ ] Remote access configured
- [ ] Backup tested
- [ ] Uptime verified
- [ ] Security hardened

---

## 🔒 SECURITY HARDENING

```bash
# 1. SSH Hardening
sudo nano /etc/ssh/sshd_config
# Change: PermitRootLogin no
# Change: PasswordAuthentication no
# Change: Port 2222 (or custom)
sudo systemctl restart sshd

# 2. Firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

# 3. Fail2Ban
sudo apt install -y fail2ban
sudo systemctl enable fail2ban

# 4. Auto-updates
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades
```

---

## 🎉 CONCLUSION

**With your own server, you get:**
- ✅ 100% Independence
- ✅ No external dependencies
- ✅ 24/7 Uptime
- ✅ Full Privacy
- ✅ Complete Control
- ✅ Cost Effective
- ✅ Permanent Solution

**Your OpenClaw, Your Rules, Your Server!** 🚀

---

**Next Steps:**
1. Choose your option (Raspberry Pi / Old PC / VPS / Free)
2. Get hardware (if needed)
3. Follow step-by-step guide above
4. Done! 100% independent!

---

_Last updated: 2026-04-10_  
**Version:** 1.0.0  
**Status:** Ready to deploy ✅
