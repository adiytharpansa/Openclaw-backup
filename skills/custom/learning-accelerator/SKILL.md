---
name: learning-accelerator
description: Auto-learning from every interaction and task. Use after every task to capture lessons, errors, corrections, and improvements. This skill enables continuous improvement by analyzing what worked, what didn't, and systematically integrating new knowledge into long-term memory. It prevents repeating mistakes, captures wins, and adapts to user preferences over time.
---

# Learning Accelerator

AI yang **belajar dari setiap task** - makin hari makin pinter.

## 🎯 Core Function

After every interaction, AI auto-extracts:
1. **What worked** - successful approaches
2. **What didn't** - mistakes, errors, corrections
3. **New knowledge** - facts, tools, frameworks learned
4. **User preferences** - communication style, work patterns
5. **Improvements** - better ways to do things

Then integrates everything into long-term memory.

## 🔄 Learning Loop

```
Task Complete → Self-Analysis → Lessons → Memory Update → Integration
     ↓                                                    ↓
   Store lesson                              Apply tomorrow
```

## 📝 Capture Framework

### 1. Lessons Learned
After each task:
- ✅ **Success pattern** - What approach worked?
- ❌ **Mistake pattern** - What went wrong?
- 💡 **Insight** - What did I learn?

Example:
```
Task: Created custom skills

✅ Success: Used existing skill-creator skill properly
❌ Mistake: Didn't check init_script first
💡 Insight: Always verify if init scripts exist before assuming
```

### 2. Error Analysis
When something fails:
```
Error: [What went wrong]
Root cause: [Why it happened]
Fix: [How it was fixed]
Prevention: [How to avoid next time]
```

### 3. Knowledge Integration
New facts to remember:
```
New Knowledge:
- [Fact 1]
- [Fact 2]

Context: [Where/how it applies]
```

### 4. Preference Evolution
User preference updates:
```
Updated Preferences:
- Old: [Previous preference]
- New: [Updated preference]
- Trigger: [What conversation changed it]
```

## 📚 Memory Updates

### Update MEMORY.md
Every few sessions, update long-term memory:
```markdown
## Lessons Learned (2026-04-10)
- [Lesson 1]
- [Lesson 2]

## Preferences Evolved
- Changed [X] from [old] to [new] because [reason]
```

### Update daily log
Raw session notes:
```markdown
## Learning Session: [Session Summary]

### Successes
- [What went well]

### Mistakes
- [What went wrong]

### New Knowledge
- [Facts learned]

### Corrections Needed
- [User corrections received]
```

## 🧠 Self-Improvement

### Weekly Review
Once a week (or when asked):
1. Review all lessons from past week
2. Identify recurring patterns
3. Update workflows if patterns emerge
4. Suggest process improvements

### Gap Analysis
Identify missing capabilities:
```
Capability Gap: [What I can't do yet]
Impact: [Why it matters]
Solution: [Skill to install or workflow to create]
```

## 🎯 Commands

### `/learn`
Trigger learning capture for current session:
```
Captured:
✅ Successes: 3
❌ Mistakes: 1
💡 Insights: 5
New Knowledge: 7 items
Preferences Updated: 2
```

### `/lessons`
Show lessons learned this session:
```
Session: 2026-04-10
Total Lessons: 5

1. [Lesson 1]
2. [Lesson 2]
```

### `/lessons-history`
Show all lessons from memory:
```
Long-term Lessons:
- [Lesson from any time]
```

### `/clear-lessons`
Clear session lessons (memory keeps):
```
Session lessons cleared.
```

## 📊 Metrics

Track improvement over time:
```
Learning Velocity:
- Tasks completed: [number]
- Lessons captured: [number]
- Errors fixed: [number]
- Knowledge added: [number]
- Preferences learned: [number]
```

## ⚡ Integration

Works with:
- `context-mastery` - Store preferences & patterns
- `self-evolution` - Auto-install missing skills
- `meta-cognition` - Quality check before output
- All other skills - Learn from their usage

## 🚀 Example Workflow

**Task:** "Help me install skills"

1. **Execute:** Install requested skills
2. **Analyze:** Did it work smoothly? What could be better?
3. **Capture:**
   - ✅ Skill: Used package_skill.py correctly
   - ⚠️ Lesson: Should verify skill dependencies first
   - 🧠 New: package_skill.py has validation step
4. **Store:** Add to memory
5. **Apply:** Next time, check dependencies upfront

---

**Goal:** Every interaction makes you smarter. No wasted mistakes.