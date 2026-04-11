# 🚀 DEPLOY ALL - Complete Free Permanence Setup

**Status:** Ready to Deploy  
**Cost:** $0/month  
**Time:** 30 minutes total  

---

## 📋 **Checklist Deployment**

### **✅ Sudah Selesai:**
- [x] GitHub repo created & synced
- [x] Encryption keys generated
- [x] All nuclear skills created
- [x] Deployment scripts ready
- [x] Cloudflare account created

### **⏳ Tinggal Deploy:**

| Service | Time | Status |
|---------|------|--------|
| Cloudflare Worker | 5 min | ⏳ Manual |
| Oracle Cloud VPS | 15 min | ⏳ Script ready |
| Fly.io VM | 10 min | ⏳ Script ready |

---

## 🔥 **DEPLOY SEKARANG (Step-by-Step)**

### **1️⃣ Cloudflare Worker (5 min)**

**URL:** https://dash.cloudflare.com/b1996163a39e861856af8e5ebb749b34/workers-and-pages

**Steps:**
1. Create Worker → `openclaw-monitor`
2. Quick Edit → Paste code dari `skills/free-permanence/cloudflare-worker.js`
3. Add KV → `HEARTBEATS` namespace
4. Save & Deploy
5. Test: https://openclaw-monitor.silviftpearl.workers.dev/health

**✅ Done when:** See "Monitor Active"

---

### **2️⃣ Oracle Cloud VPS (15 min)**

**Sign up:** https://www.oracle.com/cloud/free/

**After signup:**
```bash
# Get VPS IP from Oracle Console
export ORACLE_IP="your-vps-ip"

# Run deployment script
cd /mnt/data/openclaw/workspace/.openclaw/workspace
./scripts/deploy-oracle.sh
```

**Script akan:**
- ✅ SSH to VPS
- ✅ Install Node.js & dependencies
- ✅ Clone GitHub repo
- ✅ Setup systemd service
- ✅ Start OpenClaw

**✅ Done when:** `sudo systemctl status openclaw` shows "active (running)"

---

### **3️⃣ Fly.io VM (10 min)**

**Sign up:** https://fly.io/app/sign-up

**After signup:**
```bash
# Install flyctl
curl -L https://fly.io/install.sh | sh

# Login
flyctl auth signup

# Deploy
cd /mnt/data/openclaw/workspace/.openclaw/workspace
./scripts/deploy-fly.sh
```

**Script akan:**
- ✅ Create Fly.io app
- ✅ Create Dockerfile
- ✅ Deploy OpenClaw
- ✅ Setup secrets

**✅ Done when:** `flyctl status` shows app running

---

## 🎯 **Verification**

### **Test All Services:**

```bash
# 1. Test Cloudflare Worker
curl https://openclaw-monitor.silviftpearl.workers.dev/health
# Should return: "Monitor Active"

# 2. Test Oracle VPS
ssh ubuntu@YOUR_ORACLE_IP "systemctl status openclaw"
# Should show: "active (running)"

# 3. Test Fly.io
flyctl status --app openclaw-backup
# Should show: 1 machine running

# 4. Test Heartbeat
curl -X POST "https://openclaw-monitor.silviftpearl.workers.dev/heartbeat" \
  -H "Content-Type: application/json" \
  -d '{"instance_id":"oracle-001","status":"healthy"}'
# Should return: "OK"

# 5. Check GitHub Sync
git log --oneline -5
# Should show latest commits
```

---

## 📊 **Final Architecture**

```
┌─────────────────────────────────────────────────┐
│           FREE PERMANENCE STACK                  │
├─────────────────────────────────────────────────┤
│                                                  │
│  [Primary]                                       │
│  Gensee Crate (Current)                         │
│       ↓ heartbeat (5 min)                        │
│  [Monitor]                                       │
│  Cloudflare Worker ✅                            │
│       ↓ timeout detection                        │
│  [Backups]                                       │
│  ├─ Oracle Cloud VPS (4 OCPU, 24GB, 200GB)      │
│  ├─ Fly.io VM (256MB)                           │
│  └─ GitHub (State backup)                       │
│                                                  │
│  Cost: $0/month                                 │
│  Uptime: ~99.9%                                 │
│                                                  │
└─────────────────────────────────────────────────┘
```

---

## 🆘 **Troubleshooting**

### **Cloudflare Worker not responding:**
```
1. Check Worker is deployed
2. Verify KV namespace bound
3. Check URL: https://openclaw-monitor.silviftpearl.workers.dev/health
```

### **Oracle VPS SSH failed:**
```
1. Check VPS is running (Oracle Console)
2. Verify SSH key added
3. Check security list allows port 22
4. Try: ssh -v ubuntu@YOUR_IP
```

### **Fly.io deployment failed:**
```
1. Check logged in: flyctl auth whoami
2. Check org: flyctl orgs list
3. Try: flyctl launch --new-org
```

---

## 🎊 **After All Deployed:**

1. **Update `.free.env`** with all URLs
2. **Test failover** (kill one instance, verify others running)
3. **Monitor for 24h**
4. **Celebrate!** 🎉

---

**Let's deploy, Tuan!** 🚀💀
