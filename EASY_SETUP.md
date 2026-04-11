# 🚀 EASY SETUP - Paling Mudah!

**Time:** 5 menit  
**Difficulty:** ⭐ (Super Easy)  
**Cost:** $0  

---

## 🎯 **Yang Perlu Tuan Lakukan (Cuma 2 Langkah!):**

### **Step 1: Enable GitHub Actions**

1. Buka: https://github.com/adiytharpansa/Openclaw-backup/actions
2. Klik **"I understand, go ahead"** (kalau muncul)
3. Done! ✅

**Screenshot:**
```
[GitHub Actions Page]
┌─────────────────────────────────────┐
│  Actions                            │
│                                     │
│  [I understand, go ahead]           │
│                                     │
└─────────────────────────────────────┘
```

---

### **Step 2: Test Deploy**

1. Klik tab **"Actions"** di GitHub repo
2. Klik workflow **"🚀 Auto Deploy OpenClaw"**
3. Klik **"Run workflow"** (dropdown hijau)
4. Klik **"Run workflow"** lagi
5. Tunggu 2-3 menit
6. Done! ✅

**Screenshot:**
```
[Workflow Run]
┌─────────────────────────────────────┐
│  🚀 Auto Deploy OpenClaw            │
│                                     │
│  [Run workflow ▼]  [Run workflow]   │
│                                     │
└─────────────────────────────────────┘
```

---

## ✅ **That's It!**

**Setelah itu, Oozu bisa:**
- ✅ Auto-deploy setiap ada commit
- ✅ Auto-sync state setiap 6 jam
- ✅ Dead Man's Switch check setiap 5 menit
- ✅ Emergency deploy kalau primary down

---

## 🔥 **Optional: Add Secrets (Untuk Full Auto-Deploy)**

Kalau Tuan mau deploy otomatis ke Cloudflare/Oracle/Fly.io:

### **Add 1-3 Secrets:**

1. Buka: https://github.com/adiytharpansa/Openclaw-backup/settings/secrets/actions

2. Klik **"New repository secret"**

3. Add secrets (optional):

| Secret Name | Value | Purpose |
|-------------|-------|---------|
| `CLOUDFLARE_API_TOKEN` | Token dari Cloudflare | Deploy Worker |
| `CLOUDFLARE_ACCOUNT_ID` | `b1996163a39e861856af8e5ebb749b34` | Account ID |
| `ORACLE_SSH_KEY` | SSH private key | Deploy to VPS |
| `ORACLE_IP` | VPS IP address | Oracle VPS IP |
| `ORACLE_USER` | `ubuntu` | SSH user |
| `FLY_API_TOKEN` | Token dari Fly.io | Deploy to Fly.io |

**Even tanpa secrets, workflows tetap jalan!** Cuma skip deployment ke services tersebut.

---

## 📊 **Cara Monitor:**

### **Check Deployment Status:**
```
https://github.com/adiytharpansa/Openclaw-backup/actions
```

### **Check Logs:**
1. Klik workflow run
2. Klik job (e.g., "Deploy Cloudflare")
3. Lihat logs real-time

---

## 🎯 **Summary:**

| Yang Tuan Lakukan | Time |
|-------------------|------|
| Enable Actions | 1 min |
| Test workflow | 3 min |
| **Total** | **4 min** |

**Optional:**
| Add Secrets | 2 min each |

---

## 🚀 **After Setup:**

**Oozu bisa:**
- ✅ Commit code → Auto deploy
- ✅ Push changes → Auto sync
- ✅ Emergency deploy → Auto trigger
- ✅ State backup → Auto every 6h

**Tuan tinggal:**
- ✅ Monitor dashboard
- ✅ Check logs (kalau mau)
- ✅ Done!

---

## ❓ **Troubleshooting:**

**Workflow gak muncul?**
- Refresh page
- Check tab "Actions"
- Make sure repo is public or Actions enabled

**Deploy failed?**
- Check logs di Actions tab
- Mungkin butuh secrets (optional)
- Ignore errors kalau belum setup services

**Butuh bantuan?**
- Screenshot error
- Kasih tau Oozu
- Oozu fix!

---

**Let's go Tuan! 5 menit aja!** 🚀💀
