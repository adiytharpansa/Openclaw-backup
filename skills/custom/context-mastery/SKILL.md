---
name: context-mastery
description: Long-term context retention, cross-session memory, and user preference learning. Use when you need to remember conversations, decisions, preferences, patterns, and connect dots across multiple sessions. This skill helps you build a comprehensive understanding of the user over time, including their communication style, work patterns, values, and goals. Automatically extracts key insights from conversations and stores them for future reference.
---

# Context Mastery

Bikin AI makin pinter ngerti & inget pengguna dari waktu ke waktu.

## 🎯 Core Function

Skill ini bikin AI **ingat semuanya** dari setiap interaksi:
- User preferences & patterns
- Decisions made & outcomes
- Communication style
- Goals & projects
- Lessons learned

## 📚 How to Use

### Capture Insights
Setiap sesi, extract:
1. **Preferences** - Apa yang user suka/tidak suka
2. **Patterns** - Habits, routines, work styles
3. **Decisions** - Keputusan penting & reasoning-nya
4. **Goals** - Target, progress, obstacles
5. **Lessons** - Mistakes, improvements, learnings

### Store Smart
Simpan ke:
- `MEMORY.md` - Long-term memories (curated)
- `memory/YYYY-MM-DD.md` - Daily logs (raw)
- `memory/prefs.json` - Preferences structure

### Connect Dots
Hubungkan informasi baru dengan yang lama:
- Referensi decisions sebelumnya
- Reminder preferences
- Context dari projects ongoing

## 📝 Memory Structure

### MEMORY.md
Curated long-term memory. Contoh:

```markdown
## User Profile
- Name: Sanz
- Location: Indonesia
- Preferences: Concise, direct, Bahasa Indonesia

## Projects
- OpenClaw setup (started 2026-04-10)
- Personal knowledge base

## Decisions
- 2026-04-10: Choose Bahasa Indonesia as main language
```

### Daily Logs
Raw session notes:

```markdown
# Memory - 2026-04-10

## Session Summary
- Created custom skills for intelligence boost
- Decided on auto-location tracking (later cancelled)
- Installed 6 new cognitive skills
```

### Preferences JSON
Structured preferences:

```json
{
  "communication": {
    "language": "Bahasa Indonesia",
    "tone": "conversational",
    "emoji_usage": "high"
  },
  "work_style": {
    "preferences": "direct & to-the-point",
    "tools": ["git", "terminal", "browser"]
  }
}
```

## 🔧 Auto-Enhancement

### Session Start
1. Read `MEMORY.md` - get long-term context
2. Read recent `memory/` files - get recent context
3. Update memory with new insights
4. Note any patterns to watch for

### Session End
1. Summarize what was discussed
2. Extract new preferences/insights
3. Update `MEMORY.md` with key learnings
4. Log daily session to `memory/YYYY-MM-DD.md`

### During Conversation
- Remember context from earlier in conversation
- Cross-reference with long-term memory
- Flag when current topic connects to past decisions

## 🚀 Integration

Works with:
- `memory/` folder for storage
- Git for version control
- Other skills for data collection

## ⚠️ Privacy

- Local storage only
- Encrypt sensitive data if needed
- Clear memory on request (`/clear-memory`)

---

**Goal:** Setiap sesi, AI jadi lebih ngerti & pinter ngadepin kamu.