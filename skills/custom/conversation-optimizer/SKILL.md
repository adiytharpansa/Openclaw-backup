---
name: conversation-optimizer
description: Optimize communication by learning user's preferences, communication style, and needs. Use to adapt tone, depth, and format of responses based on user's mood, context, and feedback. This skill tracks what explanations work, predicts information needs, and continuously improves the AI-user interaction dynamic.
---

# Conversation Optimizer

Buat komunikasi yang **lebih natural & efektif** sama user.

## 🎯 Core Function

Skill ini bikin AI **makin pinter ngadepin user** dengan:
1. **Style adaptation** - Adjust tone & format to user preference
2. **Depth calibration** - Right level of detail
3. **Predictive help** - Anticipate what user needs next
4. **Feedback learning** - Learn from corrections & reactions
5. **Context awareness** - Adjust based on user's mood/situation

## 🎨 Communication Style Learning

### Track User Preferences

**Language:**
- Bahasa Indonesia (preferred)
- Technical terms okay in English
- Casual but clear tone

**Communication Style:**
- Direct vs. detailed
- Emoji usage (high/medium/low)
- Formal vs. casual
- Question frequency

**Response Format:**
- Bullet points vs. paragraphs
- Code examples when?
- Tables? (Discord/WhatsApp: NO tables)
- Length preference

### Example Preference Capture
```
USER PREFERENCES:
- Language: Bahasa Indonesia ✅
- Tone: Conversational, friendly
- Emoji: ✅ Yes (makes it more human)
- Length: Concise when possible, detailed when needed
- Structure: Use headers, bullets for clarity
```

## 📊 Depth Calibration

### Know When to Go Deep vs. Shallow

**Light Response** (quick questions):
- ✅ Simple facts
- ✅ Quick confirmations
- ✅ When user says "TL;DR" or "short answer"

**Medium Response** (standard):
- ✅ Most questions
- ✅ How-to guides
- ✅ Explanations with context

**Deep Dive** (complex topics):
- ✅ Architecture decisions
- ✅ Problem-solving
- ✅ When user says "explain more" or "why"

### Depth Adjustment Signals

**User signals:**
- "short" → light response
- "detail" / "explain more" → deep response
- "I know this" → skip basics
- "I'm new to this" → start from fundamentals

**Context signals:**
- Rushed time → concise
- Learning mode → educational
- Debugging mode → practical solutions

## 🔮 Predictive Assistance

### Anticipate Needs

**Pattern Recognition:**
- If user asks about X, they probably need Y next
- If user works on project A, they might need project B support
- If user mentions problem C, they probably want solution D

**Example:**
```
User: "How do I deploy my app?"

Pattern recognition:
1. They're deploying
2. Probably need: deployment checklist, troubleshooting, monitoring
3. Anticipate follow-up questions: costs, scaling, security

Proactive: Include all relevant sections upfront
```

### Pre-emptive Help
```
📌 Before you ask:
- Here's the deployment checklist
- Common pitfalls to avoid
- Post-deployment monitoring tips

Anything specific you want me to expand on?
```

## 💬 Feedback Integration

### Learn from Corrections

**When user corrects:**
```
User: "No, that's not quite right."

Learn:
✅ Correction: [What was wrong]
✅ Preferred approach: [What's better]
✅ Reason: [Why their way is better]
✅ Store to memory: Update preferences
```

### Track Response Quality

**Quality indicators:**
- User satisfaction (explicit feedback)
- Follow-up questions (confusion signal)
- Repeat questions (didn't understand before)
- Task completion rate (solved or not)

**Quality adjustment:**
```
If follow-up questions > 2:
→ Response wasn't clear enough
→ Add more explanation/examples

If task completed successfully:
→ Approach worked
→ Note pattern for next time
```

## 🎯 Adaptation Examples

### Tone Adaptation

**User seems stressed:**
```
BEFORE: "Great question! Let me help you with this..."
AFTER: "Got it. Quick fix: [solution]. Want me to explain?"
```

**User seems curious/learning:**
```
BEFORE: "[solution]"
AFTER: "Here's how it works: [explanation]. 
        Key concept: [concept].
        Want more details?"
```

### Format Adaptation

**For Discord/WhatsApp:**
- NO markdown tables
- Use bullet points
- Link formatting: `<>` to suppress embeds

**For Email/Docs:**
- Can use tables
- Headers with #
- More structured

### Length Adaptation

**Rushed user:**
- Top line: direct answer
- Below: optional details

**Learning mode:**
- Context first
- Examples
- Why it matters

## 📝 Session Tracking

### Track Conversation Quality

```
SESSION METRICS:
- Total messages: [X]
- Clarifications needed: [X]
- Corrections given: [X]
- Satisfaction (estimated): [X/10]
- Adaptation points: [list]
```

### Update Preferences

After each session:
```
UPDATED PREFERENCES:
- [Preference 1] changed from [old] to [new]
- [Preference 2] confirmed as [value]
```

## 🔧 Commands

### `/style-check`
Show current communication style understanding:
```
Communication Style:
- Language: Bahasa Indonesia
- Tone: Casual, friendly
- Emoji: High usage
- Length: Balanced
```

### `/depth <level>`
Set response depth: `light`, `medium`, `deep`

### `/learn-feedback`
Capture feedback from current conversation:
```
Captured:
✅ Confirmed preferences: 3
🔄 Adjustments: 2
💡 New insights: 1
```

### `/optimize`
Run full conversation optimization:
```
Optimization Complete:
- Style matched: ✅
- Depth calibrated: ✅
- Predictions active: ✅
- Quality check passed: ✅
```

## 🚀 Example Workflow

### Initial Interaction
```
1. Observe user's style (messages, questions)
2. Adapt responses to match
3. Note preferences
```

### During Session
```
1. Track what works (user engages)
2. Track what doesn't (confusion, corrections)
3. Adjust in real-time
```

### Session End
```
1. Save learned preferences
2. Update conversation model
3. Prepare for next session
```

---

**Goal:** Every conversation makes future conversations better.