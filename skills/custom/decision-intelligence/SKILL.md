---
name: decision-intelligence
description: Structured decision-making frameworks for better choices. Use when facing important decisions, complex trade-offs, or when you need systematic analysis of options. This skill provides frameworks like cost-benefit analysis, risk assessment, weighted decision matrices, and decision journaling to improve decision quality and track outcomes.
---

# Decision Intelligence

Bantu user (dan diri sendiri) buat **keputusan yang lebih baik** dengan framework yang terstruktur.

## 🎯 Core Function

Skill ini nyediain **framework untuk ambil keputusan**:
1. **Structured analysis** - Systematic evaluation
2. **Multi-criteria decision** - Weighted decision matrices
3. **Risk assessment** - Identify & evaluate risks
4. **Pre-mortem** - Imagine failure before it happens
5. **Decision tracking** - Log decisions + outcomes

## 📊 Decision Frameworks

### 1. Cost-Benefit Analysis (CBA)

**Use when:** Weighing pros vs cons

**Framework:**
```
DECISION: [What are we deciding?]

COSTS:
- Direct costs: [Money, time, resources]
- Indirect costs: [Effort, complexity, maintenance]
- Opportunity costs: [What we're giving up]

BENEFITS:
- Direct benefits: [Expected gains]
- Indirect benefits: [Side effects, learnings]
- Long-term benefits: [Future value]

VERDICT: Benefits > Costs? [Yes/No/Maybe]
```

**Example:**
```
DECISION: Should I hire a VA?

COSTS:
- Direct: $500/month
- Indirect: 5 hours/week management time
- Opportunity: Can't use this budget for ads

BENEFITS:
- Direct: 20 hours/week saved
- Indirect: Can focus on growth tasks
- Long-term: Business scales without me

VERDICT: Benefits >>> Costs ✅
```

### 2. Weighted Decision Matrix (MCDA)

**Use when:** Multiple options, multiple criteria

**Framework:**
```
DECISION: [What to choose?]

CRITERIA & WEIGHTS:
1. Cost (30%)
2. Time (25%)
3. Quality (25%)
4. Risk (20%)

OPTIONS RATING (1-10):
                Cost  Time  Qual  Risk  TOTAL
Option A         7    9    6     8     ?
Option B         9    6    8     7     ?
Option C         5    7    9     9     ?

CALCULATION:
Option A: 7×0.3 + 9×0.25 + 6×0.25 + 8×0.2 = 7.45
Option B: 9×0.3 + 6×0.25 + 8×0.25 + 7×0.2 = 7.40
Option C: 5×0.3 + 7×0.25 + 9×0.25 + 9×0.2 = 7.10

WINNER: Option A (7.45)
```

### 3. Risk Assessment

**Use when:** Evaluate potential downsides

**Framework:**
```
DECISION: [What decision?]

RISK ANALYSIS:
┌─────────────────────────────────────────┐
│ Risk        │ Impact │ Probability │ Total│
├─────────────────────────────────────────┤
│ [Risk 1]    │ High   │ 30%         │ 0.3  │
│ [Risk 2]    │ Medium │ 50%         │ 0.25 │
│ [Risk 3]    │ Low    │ 10%         │ 0.03 │
└─────────────────────────────────────────┘

MITIGATION:
- Risk 1: [How to reduce]
- Risk 2: [How to reduce]

RISK TOLERANCE: Acceptable? [Yes/No]
```

### 4. Pre-Mortem Analysis

**Use when:** Before major decisions

**Framework:**
```
DECISION: [What we're considering]

PRE-MORTEM: "It's 1 year later and this FAILED."

WHAT WENT WRONG:
1. [Failure reason 1]
2. [Failure reason 2]
3. [Failure reason 3]

PREVENTION:
- Before starting: [Preventive measures]
- During execution: [Monitoring checkpoints]
- Early warning: [What to watch for]
```

**Example:**
```
DECISION: Deploy to production Friday night

PRE-MORTEM: "Next week, we know this failed."

WHAT WENT WRONG:
1. Critical bug in prod
2. No one available to fix it
3. Customer complaints escalated

PREVENTION:
- Before: Full testing, rollback plan ready
- During: Have dev on standby
- Warning: Monitor error rates closely
```

## 📝 Decision Journaling

### Log Every Major Decision

**Structure:**
```markdown
## Decision: [Brief description]
**Date:** 2026-04-10
**Context:** [Background information]
**Options Considered:** [A, B, C]
**Final Choice:** [Option A]
**Reasoning:** [Why this option]
**Expected Outcome:** [What we think will happen]
**Review Date:** 2026-05-10 (set future date)

### Outcome Review (FILLED LATER)
**Actual Result:** [What actually happened]
**Accuracy:** [How close to expected]
**Learnings:** [What this teaches us]
```

### Where to Store

- `memory/decisions.md` - Decision journal
- `MEMORY.md` - Reference key decisions
- Git commit for traceability

## 🎯 When to Use Each Framework

| Situation | Best Framework |
|-----------|---------------|
| Simple yes/no | Cost-Benefit |
| Multiple options | Decision Matrix |
| High stakes | Pre-Mortem + Risk Assessment |
| Quick decision | Heuristic (gut check + 1 risk check) |
| Recurring decision | Create framework once, apply repeatedly |

## 🧠 Decision Quality Checklist

Before finalizing decision:
```
✓ Clear definition of the decision
✓ All relevant options considered
✓ Criteria and weights defined
✓ Risks identified and assessed
✓ Pre-mortem completed (for big decisions)
✓ Decision logged in journal
✓ Review date set
```

## 📊 Tracking Decision Quality

### Metrics
```
DECISION TRACKING:
Total Decisions: [X]
- High quality: [X%] (post-reviewed as good)
- Medium quality: [X%]
- Low quality: [X%] (needed revision)

Pattern Analysis:
- Best decisions: [Common factors]
- Worst decisions: [Common mistakes]
- Bias patterns: [Confirmation, overconfidence, etc.]
```

### Bias Detection

**Watch for:**
- 🚩 **Confirmation bias** - Only seeing supportive evidence
- 🚩 **Sunk cost** - Continuing due to prior investment
- 🚩 **Recency bias** - Overweighting recent info
- 🚩 **Anchoring** - Relying too much on first info

**Counter-measures:**
- Actively seek disconfirming evidence
- Reset on each decision (ignore sunk costs)
- Consider historical context
- Get multiple data points before deciding

## 🔧 Commands

### `/decision <topic>`
Start decision analysis:
```
DECISION: [topic]

Let's break this down systematically:

## Context
[Ask clarifying questions]

## Options
[List potential options]

## Criteria
[Define evaluation criteria]

Ready for structured analysis?
```

### `/decision-matrix`
Run weighted decision matrix:
```
Run decision matrix with:
- Options: [list]
- Criteria: [list with weights]
- Scoring: [1-10 for each]

Result: [Winner + scores]
```

### `/premortem`
Run pre-mortem analysis:
```
PRE-MORTEM: [Decision]

Failed outcome analysis:
1. [Risk 1]
2. [Risk 2]

Prevention plan:
- [Action items]
```

### `/decision-log`
View decision journal:
```
DECISION JOURNAL:

2026-04-10: Hire VA
- Choice: Option A
- Status: Pending (review 2026-05-10)

2026-04-08: Switch hosting
- Choice: AWS
- Status: ✅ Completed successfully
```

### `/decision-review`
Review past decisions:
```
REVIEW SESSION:

Decisions to review: 3
- [Decision 1]: Outcome = [X], Learnings = [Y]
- [Decision 2]: Outcome = [X], Learnings = [Y]

Pattern insights:
✅ What's working
⚠️ What needs improvement
```

## 🚀 Example Workflow

### Quick Decision (minutes)
```
1. Define decision
2. List options (3 max)
3. Simple pros/cons
4. Decide + log
5. Done
```

### Medium Decision (hours)
```
1. Define decision + criteria
2. Cost-benefit analysis
3. Risk assessment
4. Decide + log
5. Set review date
```

### Major Decision (days)
```
1. Define decision thoroughly
2. Generate options
3. Weighted decision matrix
4. Pre-mortem analysis
5. Risk mitigation plan
6. Decide + detailed log
7. Set review + success metrics
```

---

**Principle:** Better framework = better decision. Track outcomes to improve.