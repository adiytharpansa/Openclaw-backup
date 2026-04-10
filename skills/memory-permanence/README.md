# Memory Permanence Skill

🧠 **Ultimate Memory & Permanence System**

Skill ini bikin AI benar-benar **ingat semua hal penting** dan **tidak pernah lupa**. Setiap interaksi, preference, learning, dan decision akan tersimpan permanent dan bisa di-retrieve kapan aja.

## ✨ Features

### 1. Multi-Layer Memory System
```
MEMORY.md                    ← Long-term curated memory
memory/YYYY-MM-DD.md         ← Daily raw logs
memory/permanent/*.md        ← Permanent knowledge
memory/skills/*.md           ← Skill-specific learnings
memory/relationships/*.md    ← User context
```

### 2. Auto-Trigger Patterns
AI otomatis save memory ketika user bilang:
- "Ingat ini", "Jangan lupa"
- "Gue prefer...", "Aku suka..."
- "Turns out...", "Belajar..."
- "Deadline...", "Project..."

### 3. Git Integration
Semua perubahan otomatis:
- ✅ Git add -A
- ✅ Git commit
- ✅ Git push

### 4. Priority System
- **High priority** → Save ke long-term MEMORY.md
- **Normal priority** → Save ke daily log

## 🚀 Usage

### Save Memory
```bash
# Save dengan kategori & priority
./scripts/memory-permanence.sh save "User prefers dark mode" "preferences" "high"

# Save learning
./scripts/memory-permanence.sh save "Async/await faster for I/O" "learnings" "normal"

# Save project deadline
./scripts/memory-permanence.sh save "Project deadline tomorrow" "projects" "high"
```

### Search Memory
```bash
# Search semua memori
./scripts/memory-permanence.sh search "API keys"

# Search kategori tertentu
./scripts/memory-permanence.sh search "preferences" "all"
```

### Get Recent Memories
```bash
# Last 10 memories
./scripts/memory-permanence.sh recent

# Last 5 memories
./scripts/memory-permanence.sh recent 5
```

### Consolidate Daily to Long-Term
```bash
# Review pending items
./scripts/memory-permanence.sh review

# Auto consolidate from specific date
./scripts/memory-permanence.sh consolidate 2026-04-10 --auto

# Consolidate date range
./scripts/memory-permanence.sh consolidate 2026-04-10 2026-04-10 --auto
```

### Check Memory Health
```bash
./scripts/memory-permanence.sh health
```

### Get Category Memories
```bash
# Get all preferences
./scripts/memory-permanence.sh category preferences

# Get technical learnings
./scripts/memory-permanence.sh category technical
```

### Update Skill Documentation
```bash
./scripts/memory-permanence.sh update-skill github "New workflow: gh pr create for PRs"
```

## 🔧 Integration

### Auto-Trigger with Python
```python
import subprocess

def check_memory_triggers(text):
    """Check if text should trigger memory save"""
    result = subprocess.run([
        'python3', 'scripts/memory-trigger-check.py', text
    ], capture_output=True, text=True)
    
    if "detected" in result.stdout:
        # Trigger memory save
        subprocess.run([
            './scripts/memory-permanence.sh', 
            'save', text, 'general', 'normal'
        ])
```

### Integration with HEARTBEAT
Add to HEARTBEAT.md:
```markdown
### 🧠 Memory Check (Every Heartbeat)
- Review new learnings from last 24h
- Consolidate important items to MEMORY.md
- Update skill documentation if needed
- Git commit all changes
```

## 📁 File Structure
```
memory-permanence/
├── SKILL.md              # This file
├── memory/
│   ├── permanent/
│   │   └── user-profile.md
│   ├── skills/
│   ├── relationships/
│   ├── projects/
│   └── YYYY-MM-DD.md     # Daily logs
└── scripts/
    ├── memory-permanence.sh    # Main script
    ├── memory-trigger-check.py # Trigger detection
    └── memory-triggers.json    # Trigger patterns
```

## 🎯 Use Cases

### 1. User Preferences
```
User: "Gue prefer Bahasa Indonesia selalu"
AI: [Auto-save to MEMORY.md]
    → Category: preferences
    → Priority: high
    → Git commit
    → Response: "✅ Disimpen! Gue bakal selalu pake Bahasa Indonesia sama lo"
```

### 2. Technical Learnings
```
User: "Turns out Docker compose lebih cepat buat local dev"
AI: [Auto-save]
    → Category: learnings
    → Priority: normal
    → Links to Docker skill documentation
```

### 3. Project Deadlines
```
User: "Deadline project besok jam 5 sore"
AI: [Auto-save]
    → Category: projects
    → Priority: high
    → Sets reminder
    → Adds to calendar
```

## 📊 Memory Health Metrics
```json
{
  "totalMemories": 150,
  "thisSession": 12,
  "recallAccuracy": 0.95,
  "userCorrections": 2,
  "categories": {
    "preferences": 25,
    "technical": 45,
    "projects": 30,
    "learnings": 50
  }
}
```

## ⚠️ Important Notes

1. **Never save sensitive data** (passwords, API keys) - use 1password instead
2. **Always confirm** high-priority saves
3. **Review monthly** and prune outdated memories
4. **Keep daily logs raw**, long-term curated
5. **Use tags** for cross-referencing: #preference #technical #project

## 🔄 Memory Flow

```
User Input → Trigger Check → Pattern Match
                                    ↓
                        [Match Found?]
                          /           \
                        Yes           No
                        ↓              ↓
              Save to Memory     No Action
              Git Commit         (Stay silent)
              Confirm to User
```

## 💡 Best Practices

1. **Be selective** - Only save meaningful information
2. **Tag appropriately** - Use categories for easy filtering
3. **Review regularly** - Check pending consolidations
4. **Link to skills** - Connect learnings to relevant documentation
5. **Respect privacy** - Never save sensitive info

---

**Created:** 2026-04-10  
**Author:** Clawd for Sanz  
**Status:** ✅ Active & Production Ready
