# 🔔 Notification System

_Push notifications for important events_

---

## 📬 Notification Types

### Priority Levels
| Level | Color | Use Case | Channels |
|-------|-------|----------|----------|
| **Critical** | 🔴 | System failures, security alerts | All channels |
| **High** | 🟠 | Urgent emails, CI failures | Telegram, Email |
| **Medium** | 🟡 | Calendar reminders, mentions | Telegram |
| **Low** | 🟢 | Daily summaries, updates | Email only |

---

## 🎯 Triggers

### Email Notifications
```
Trigger: New email received
Conditions:
  - From: important contacts
  - Subject contains: urgent, asap, important
  - Has attachment
Action: Send push notification
```

### Calendar Reminders
```
Trigger: Event starting soon
Conditions:
  - Event starts in: 15 minutes
  - Event starts in: 1 hour
Action: Send reminder with event details
```

### CI/CD Alerts
```
Trigger: Build status change
Conditions:
  - Build failed
  - Build succeeded (after failure)
  - Deployment completed
Action: Notify with build details + link
```

### Mention Notifications
```
Trigger: User mentioned
Conditions:
  - Discord/Slack mention
  - GitHub @mention
  - Twitter mention
Action: Send notification with context
```

### Weather Alerts
```
Trigger: Severe weather
Conditions:
  - Rain probability > 80%
  - Temperature extreme (<5°C or >35°C)
  - Storm warning
Action: Send weather alert
```

### Security Alerts
```
Trigger: Security event
Conditions:
  - Failed login attempt (5+)
  - Config change detected
  - Unusual activity
Action: IMMEDIATE notification + audit log
```

---

## 📱 Delivery Channels

### Telegram (Primary)
```yaml
enabled: true
chat_id: "6023537487"
format: markdown
silent: false
```

### Email (Secondary)
```yaml
enabled: true
address: "user@example.com"
format: html
batch: true  # Batch low-priority notifications
```

### Push (Optional)
```yaml
enabled: false  # Configure if needed
service: "pushover"  # or "pushbullet"
api_key: "from-1password"
```

### Discord/Slack (Optional)
```yaml
enabled: false  # Configure if needed
webhook_url: "from-1password"
channel: "#notifications"
```

---

## ⚙️ Configuration

### Quiet Hours
```json
{
  "enabled": true,
  "start": "23:00",
  "end": "08:00",
  "timezone": "Asia/Jakarta",
  "exceptions": ["critical", "security"]
}
```

### Notification Preferences
```json
{
  "email": {
    "enabled": true,
    "priority": ["high", "critical"],
    "batchLowPriority": true,
    "batchInterval": "1h"
  },
  "telegram": {
    "enabled": true,
    "priority": ["medium", "high", "critical"],
    "silent": false
  },
  "push": {
    "enabled": false,
    "priority": ["critical"]
  }
}
```

### Rate Limiting
```json
{
  "maxPerHour": 20,
  "maxPerDay": 100,
  "cooldownAfterBurst": 300,
  "digestAfterLimit": true
}
```

---

## 📝 Templates

### Email Template
```markdown
Subject: [PRIORITY] {title}

Hi there,

{message}

**Details:**
- Time: {timestamp}
- Source: {source}
- Priority: {priority}

[View Details]({link})

---
Clawd Notification System
```

### Telegram Template
```markdown
🔔 *{title}*

{message}

_Time: {timestamp}_
_Source: {source}_

[Details]({link})
```

### Critical Alert Template
```markdown
🚨 **CRITICAL ALERT** 🚨

{title}

{message}

**Immediate action required!**

_Time: {timestamp}_
_Impact: {impact}_
```

---

## 🔧 Setup Commands

### Test Notification
```bash
# Send test notification
./notifications/send.sh --test --priority medium
```

### Configure Channels
```bash
# Setup Telegram
./notifications/setup-telegram.sh

# Setup Email
./notifications/setup-email.sh

# Setup Push
./notifications/setup-push.sh
```

### Manage Preferences
```bash
# View current settings
./notifications/config.sh --view

# Update quiet hours
./notifications/config.sh --quiet-hours 23:00-08:00

# Enable/disable channel
./notifications/config.sh --channel telegram --enable
```

---

## 📊 Notification Log

| Time | Type | Priority | Channel | Status |
|------|------|----------|---------|--------|
| - | - | - | - | - |

---

## 🚀 Quick Start

1. **Configure channels** in `notifications/config.json`
2. **Set preferences** for notification types
3. **Test** with `./notifications/send.sh --test`
4. **Enable** heartbeat integration

---

_Last updated: 2026-04-10 (Setup Complete)_
