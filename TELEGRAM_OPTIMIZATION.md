# 📬 Telegram Optimization Guide

**Optimized for:** Telegram messaging with OpenClaw

---

## ✅ Current Setup

| Feature | Status |
|---------|--------|
| Message Formatting | ✅ Markdown + Emoji |
| Reply Support | ✅ Enabled |
| Inline Buttons | ✅ Supported |
| Media Sharing | ✅ Files/Images |
| Notifications | ✅ GitHub Actions |
| Auto-Reply | ⏸️ Configurable |

---

## 🚀 Features

### 1. **Message Formatting**

Telegram supports:
- **Bold** - `*bold*` or `**bold**`
- _Italic_ - `_italic_` or `*italic*`
- `Monospace` - `` `code` ``
- ~~Strikethrough~~ - `~~text~~`
- [Links](url) - `[text](url)`
- Emoji - ✅🚀💀

### 2. **Message Length**

- **Max:** 4096 characters
- **Recommendation:** Keep under 2000 for readability
- **Long messages:** Split into multiple messages

### 3. **Notifications**

**Types:**
| Type | Emoji | Priority |
|------|-------|----------|
| Alert | 🚨 | High |
| Info | ℹ️ | Medium |
| Success | ✅ | Low |
| Error | ❌ | High |
| Warning | ⚠️ | Medium |

### 4. **Proactive Alerts**

GitHub Actions will notify for:
- ✅ Heartbeat sent
- 🚨 Emergency deploy triggered
- ❌ Workflow failed
- ✅ Deploy success

---

## 🛠️ Configuration

### Enable Real Telegram Notifications

**Step 1: Create Telegram Bot**
```
1. Chat @BotFather on Telegram
2. Send: /newbot
3. Follow prompts
4. Save BOT_TOKEN
```

**Step 2: Get Chat ID**
```
1. Chat with your bot
2. Send any message
3. Visit: https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates
4. Find "chat":{"id":123456789}
```

**Step 3: Add GitHub Secrets**
```
REPO → Settings → Secrets → Actions

Add:
- TELEGRAM_BOT_TOKEN = "123456:ABC-DEF1234..."
- TELEGRAM_CHAT_ID = "6023537487"
```

**Step 4: Update Workflow**

Edit `.github/workflows/telegram-notify.yml` with real API calls.

---

## 📊 Message Templates

### Heartbeat OK
```
💓 Heartbeat OK

Status: ✅ All systems running
Time: 2026-04-11 12:00 UTC
Next: 5 minutes
```

### Emergency Alert
```
🚨 EMERGENCY DEPLOY TRIGGERED!

Reason: No heartbeat for 30+ minutes
Time: 2026-04-11 12:00 UTC
Action: Backup instances activated

Investigating...
```

### Deploy Success
```
✅ Deploy Complete!

Workflow: Simple Deploy
Status: Success
Duration: 2m 15s

Ready for use!
```

### Error Alert
```
❌ Workflow Failed!

Workflow: Heartbeat Monitor
Error: Process failed
Time: 2026-04-11 12:00 UTC

Check logs: [link]
```

---

## 🎯 Best Practices

### DO ✅
- Use emoji for visual cues
- Keep messages concise
- Use bold for important info
- Reply to related messages
- Send media as files (not compressed)

### DON'T ❌
- Send walls of text (>2000 chars)
- Use complex markdown tables
- Send duplicate notifications
- Forget to add context

---

## 🔧 Quick Commands

```bash
# Send notification
skills/telegram-optimizer/notify.sh alert "Message"

# Check status
skills/telegram-optimizer/notify.sh heartbeat

# Help
skills/telegram-optimizer/notify.sh help
```

---

## 📈 Monitoring

**GitHub Actions:**
👉 https://github.com/adiytharpansa/Openclaw-backup/actions

**Look for:**
- 💓 Auto Heartbeat (every 5 min)
- 🚨 Heartbeat Monitor (every 5 min)
- 📬 Telegram Notifications (after each)

---

_Last updated: 2026-04-11_
