# HEARTBEAT.md - Proactive Checks

_Check these 2-4 times per day during heartbeats_

## Daily Checks (Rotate Through)

### 📧 Email (Himalaya/Gog)
- Check unread emails (last 24h)
- Flag urgent messages
- Summarize if >5 unread

### 📅 Calendar (Gog)
- Events in next 24-48 hours
- Prep needed? (meetings, deadlines)

### 🌤️ Weather
- Check if user might go out
- Alert for severe weather

### 📬 Notifications
- Discord/Slack mentions
- GitHub notifications (if configured)

### 📊 Project Check-ins
- Git status on active repos
- CI/CD pipeline status
- Pending PRs/issues

---

## Tracking

Track last check times in: `memory/heartbeat-state.json`

**Rotation Schedule:**
- Morning (08:00 UTC): Email + Calendar
- Afternoon (14:00 UTC): Weather + Notifications  
- Evening (20:00 UTC): Project check-ins

---

## When to Alert User

✅ **DO alert when:**
- Urgent email arrived
- Event starting in <2h
- Severe weather warning
- Critical CI failure
- Direct mention/notification

❌ **DON'T alert when:**
- Late night (23:00-08:00 UTC) unless critical
- Nothing new since last check
- Just checked <30 min ago

---

## Default Response

If nothing needs attention:
```
HEARTBEAT_OK
```

If something needs attention:
```
🚨 [Brief alert message]
- Details...
- Action needed: ...
```
