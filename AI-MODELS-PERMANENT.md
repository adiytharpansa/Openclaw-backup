# 🤖 AI Models - Permanent Setup

**Setup permanen untuk open-source AI models di OpenClaw!**

---

## 🎯 **Overview**

Script ini akan **otomatis setup semua AI models** yang dibutuhkan:

- ✅ Install Ollama
- ✅ Download models terbaik 2026
- ✅ Setup auto-start service
- ✅ Sync state ke GitHub
- ✅ Ready untuk production

---

## 🚀 **ONE-COMMAND SETUP**

```bash
cd /mnt/data/openclaw/workspace/.openclaw/workspace
sudo ./scripts/SETUP-AI-MODELS.sh
```

**That's it!** Script akan:

1. Install Ollama
2. Detect hardware (RAM)
3. Download models yang sesuai
4. Create systemd service
5. Sync ke GitHub

---

## 📊 **Models yang Diinstall (Auto-Detect)**

| Hardware | Models |
|----------|--------|
| **8GB RAM** | llama3.2:8b, qwen2.5:7b, mistral:7b |
| **16GB RAM** | llama3.2:8b, qwen2.5-coder:14b, deepseek-r1:14b |
| **32GB RAM** | llama3.3:70b, qwen2.5-coder:14b, deepseek-r1:32b |
| **64GB RAM** | llama3.3:70b, qwen3.5:latest, deepseek-r1:32b, gemma3:27b |

---

## 📁 **File Structure**

```
.openclaw/workspace/
├── scripts/
│   └── SETUP-AI-MODELS.sh      # One-command setup
├── .ai/
│   ├── models-config.json      # Model configuration
│   └── state/
│       └── models.json         # Deployment state
└── skills/
    └── ai-mesh-deployer/
        ├── deploy.sh
        ├── setup-models.sh
        ├── mesh-coordinator.sh
        └── self-improvement.sh
```

---

## 🔧 **Manual Setup (Optional)**

### **Install Ollama**
```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### **Pull Models Manual**
```bash
# Lightweight (8GB)
ollama pull llama3.2:8b
ollama pull qwen2.5:7b
ollama pull mistral:7b

# Standard (16GB)
ollama pull qwen2.5-coder:14b
ollama pull deepseek-r1:14b

# Full (32GB+)
ollama pull llama3.3:70b
ollama pull qwen3.5:latest
```

### **Verify**
```bash
ollama list
```

---

## ⚙️ **Configuration**

Edit `.ai/models-config.json`:

```json
{
  "best_overall": "llama3.3:70b",
  "best_lightweight": "llama3.2:8b",
  "best_coding": "qwen2.5-coder:14b",
  "best_reasoning": "deepseek-r1:14b",
  "best_multilingual": "qwen2.5:7b",
  "target_hardware": "16gb",
  "auto_setup": true
}
```

---

## 🔄 **Auto-Start Service**

Setup creates systemd service:

```bash
# Check status
sudo systemctl status openclaw-ollama

# Restart
sudo systemctl restart openclaw-ollama

# Logs
sudo journalctl -u openclaw-ollama -f
```

---

## 📦 **GitHub Sync**

State otomatis sync ke GitHub:

```bash
# Manual sync
cd /mnt/data/openclaw/workspace/.openclaw/workspace
git add .ai/
git commit -m "🤖 Update AI models"
git push
```

---

## 🎯 **Usage Examples**

### **Run Model**
```bash
ollama run llama3.2:8b "Hello!"
```

### **API Access**
```bash
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2:8b",
  "prompt": "Hello!"
}'
```

### **With OpenClaw**
```bash
skills/ai-mesh-deployer/orchestrate.sh run "Analyze this code" auto
```

---

## 🔍 **Monitoring**

### **Check Installed**
```bash
skills/ai-mesh-deployer/setup-models.sh installed
```

### **Check Status**
```bash
ollama list
```

### **Check Service**
```bash
sudo systemctl status openclaw-ollama
```

---

## 🛠️ **Troubleshooting**

### **Ollama not starting**
```bash
sudo systemctl restart ollama
sudo journalctl -u ollama -f
```

### **Model download failed**
```bash
# Retry
ollama pull <model-name>

# Or use mirror
OLLAMA_HOST=https://mirror.ollama.com ollama pull <model-name>
```

### **Out of disk space**
```bash
# Remove unused models
ollama rm <model-name>

# Check disk usage
du -sh ~/.ollama/models
```

---

## 📊 **Performance Benchmarks**

| Model | Size | Speed (tok/s) | Use Case |
|-------|------|---------------|----------|
| llama3.2:8b | 4.9GB | 100+ | General |
| qwen2.5:7b | 4.5GB | 90+ | Multilingual |
| mistral:7b | 4.1GB | 120+ | Speed |
| qwen2.5-coder:14b | 9.0GB | 60+ | Coding |
| deepseek-r1:14b | 9.0GB | 50+ | Reasoning |
| llama3.3:70b | 40GB | 20+ | Best overall |

---

## ✅ **Setup Checklist**

- [ ] Run `SETUP-AI-MODELS.sh`
- [ ] Verify `ollama list`
- [ ] Test `ollama run llama3.2:8b`
- [ ] Check service status
- [ ] Verify GitHub sync

---

## 🎊 **Status**

```
╔══════════════════════════════════════════╗
║   AI MODELS - PERMANENT SETUP            ║
╠══════════════════════════════════════════╣
║  Script:           ✅ READY              ║
║  Config:           ✅ READY              ║
║  Auto-Detect:      ✅ READY              ║
║  GitHub Sync:      ✅ READY              ║
║  Systemd Service:  ✅ READY              ║
╠══════════════════════════════════════════╣
║  STATUS: ✅ DEPLOY TO SERVER!            ║
╚══════════════════════════════════════════╝
```

---

**Setup script siap deploy ke server manapun!** 🚀🤖

_Last updated: 2026-04-11_
