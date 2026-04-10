# memory-permanence Skill

## Deskripsi
Skill ultimate untuk meningkatkan ingatan AI, permanence knowledge, dan integrasi semua skills yang ada. Membuat AI benar-benar belajar dari setiap interaksi dan tidak pernah lupa hal penting.

## Kapan Digunakan
- User meminta AI untuk "ingat ini" atau "jangan lupa"
- Setelah pembelajaran penting atau insight baru
- Ketika perlu consolidate knowledge dari multiple sessions
- Untuk maintain continuity across conversations
- Ketika user ingin memastikan sesuatu tersimpan permanent

## Fitur Utama

### 1. Multi-Layer Memory System
```
├── MEMORY.md (long-term curated)
├── memory/YYYY-MM-DD.md (daily logs)
├── memory/permanent/*.md (permanent knowledge)
├── memory/skills/*.md (skill learnings)
└── memory/relationships/*.md (user context)
```

### 2. Auto-Save Triggers
- User explicitly says "remember this"
- Important decisions made
- New skills learned
- Preferences discovered
- Errors/corrections encountered
- Project milestones

### 3. Knowledge Integration
- Cross-reference new info with existing memory
- Update related skill documentation
- Create bidirectional links between concepts
- Tag and categorize for easy retrieval

### 4. Permanence Enforcement
- Git commit after every significant change
- Backup to multiple locations
- Version history tracking
- Rollback capability

## Commands

### Save Memory
```bash
# Save something to memory
/memory save "User prefers dark mode for all apps" --category preferences

# Save with priority
/memory save "API key expires 2026-12-31" --priority high --category credentials

# Save learning from session
/memory save "Learned: Python async is faster for I/O bound tasks" --category technical
```

### Retrieve Memory
```bash
# Search memory
/memory search "API keys"

# Get recent memories
/memory recent --limit 10

# Get by category
/memory get --category preferences
```

### Consolidate Knowledge
```bash
# Merge daily logs into long-term memory
/memory consolidate --from 2026-04-10 --to 2026-04-10

# Review and curate
/memory review --pending
```

### Skill Integration
```bash
# Link learning to specific skill
/memory link --skill github --note "Use gh pr create for new PRs"

# Update skill documentation
/memory update-skill --skill github --add "New workflow for code review"
```

## Implementation

### Main Script: `memory-permanence.sh`

```bash
#!/bin/bash

MEMORY_DIR="/mnt/data/openclaw/workspace/.openclaw/workspace/memory"
LONG_TERM="/mnt/data/openclaw/workspace/.openclaw/workspace/MEMORY.md"
GIT_DIR="/mnt/data/openclaw/workspace/.openclaw/workspace"

# Save to memory
save_memory() {
    local content="$1"
    local category="${2:-general}"
    local priority="${3:-normal}"
    local timestamp=$(date -u +"%Y-%m-%d %H:%M UTC")
    
    # Append to daily log
    echo "- [$timestamp] **$category**: $content" >> "$MEMORY_DIR/$(date +%Y-%m-%d).md"
    
    # If high priority, also add to long-term
    if [ "$priority" = "high" ]; then
        echo "- **$category**: $content (Added: $timestamp)" >> "$LONG_TERM"
    fi
    
    # Git commit
    cd "$GIT_DIR"
    git add -A
    git commit -m "Memory: $content"
    git push
    
    echo "✅ Memory saved: $content"
}

# Search memory
search_memory() {
    local query="$1"
    grep -r "$query" "$MEMORY_DIR" "$LONG_TERM" --include="*.md"
}

# Consolidate daily to long-term
consolidate() {
    local from_date="$1"
    local to_date="${2:-$from_date}"
    
    # Review daily logs and extract important items
    echo "🔍 Reviewing memories from $from_date to $to_date..."
    
    # Auto-extract items marked with **
    grep -h "\*\*" "$MEMORY_DIR"/$from_date*.md | sort -u
    
    echo "Review complete. Add to MEMORY.md manually or with --auto flag"
}

# Main command handler
case "$1" in
    save)
        save_memory "$2" "$3" "$4"
        ;;
    search)
        search_memory "$2"
        ;;
    consolidate)
        consolidate "$2" "$3"
        ;;
    *)
        echo "Usage: memory-permanence {save|search|consolidate} [args]"
        ;;
esac
```

### Integration with OpenClaw

Add to HEARTBEAT.md:
```markdown
### 🧠 Memory Check (Every Heartbeat)
- Review new learnings from last 24h
- Consolidate important items to MEMORY.md
- Update skill documentation if needed
- Git commit all changes
```

### Auto-Trigger Rules

Create `memory-permanence.triggers`:
```yaml
triggers:
  - pattern: "ingat ini"
    action: save_memory
    priority: high
    
  - pattern: "jangan lupa"
    action: save_memory
    priority: high
    
  - pattern: "remember this"
    action: save_memory
    priority: high
    
  - pattern: "I prefer"
    action: save_memory
    category: preferences
    
  - pattern: "I like"
    action: save_memory
    category: preferences
    
  - pattern: "I don't like"
    action: save_memory
    category: preferences
    
  - pattern: "always"
    action: save_memory
    category: rules
    
  - pattern: "never"
    action: save_memory
    category: rules
    
  - pattern: "learned that"
    action: save_memory
    category: learnings
    
  - pattern: "turns out"
    action: save_memory
    category: learnings
```

## Usage Examples

### Example 1: Save User Preference
```
User: "Ingat, gue selalu prefer dark mode"
AI: [Triggers memory-permanence]
    → Saves to MEMORY.md under preferences
    → Git commit
    → Confirms to user
```

### Example 2: Save Technical Learning
```
User: "Turns out async/await lebih cepat untuk I/O"
AI: [Triggers memory-permanence]
    → Saves to memory/technical/2026-04-10.md
    → Links to relevant skills
    → Updates skill documentation if applicable
```

### Example 3: Save Project Context
```
User: "Project ini deadline nya minggu depan"
AI: [Triggers memory-permanence]
    → Saves with high priority
    → Adds to calendar integration
    → Sets reminder
```

## Memory Structure

### `/memory/permanent/`
- `user-profile.md` - Core user info
- `preferences.md` - All user preferences
- `rules.md` - Rules and constraints
- `projects.md` - Active projects
- `skills.md` - Skill learnings
- `relationships.md` - People context

### `/memory/skills/`
- `github.md` - GitHub workflow learnings
- `coding.md` - Coding patterns
- `research.md` - Research techniques
- etc.

### `/memory/relationships/`
- `contacts.md` - People we interact with
- `teams.md` - Team contexts
- `organizations.md` - Company/org info

## Quality Checks

Before saving:
1. ✅ Is this actually important?
2. ✅ Is this accurate?
3. ✅ Where should this be stored?
4. ✅ Does this conflict with existing memory?
5. ✅ Should this trigger any actions?

After saving:
1. ✅ Git committed?
2. ✅ Backed up?
3. ✅ Linked to related knowledge?
4. ✅ User confirmed?

## Metrics

Track memory effectiveness:
```json
{
  "totalMemories": 150,
  "thisSession": 12,
  "recallAccuracy": 0.95,
  "userCorrections": 2,
  "lastConsolidation": "2026-04-10T20:00:00Z",
  "categories": {
    "preferences": 25,
    "technical": 45,
    "projects": 30,
    "learnings": 50
  }
}
```

## Integration Points

- **context-mastery**: Share long-term memory
- **learning-accelerator**: Share learnings
- **meta-cognition**: Quality check memories
- **self-evolution**: Use memories for improvement
- **All skills**: Read/write skill-specific memories

## Notes

- Never save sensitive data (passwords, keys)
- Always confirm high-priority saves
- Review and prune outdated memories monthly
- Keep daily logs raw, long-term curated
- Use tags for cross-referencing: #preference #technical #project

---

**Version:** 1.0  
**Created:** 2026-04-10  
**Author:** Clawd for Sanz  
**Status:** Active
