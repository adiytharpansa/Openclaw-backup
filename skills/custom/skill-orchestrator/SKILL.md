---
name: skill-orchestrator
description: Coordinate and chain multiple skills together for complex tasks. Use when a task requires multiple skills working in sequence or parallel. This skill enables automatic workflow creation, skill chaining, task delegation, and integrated output. It maximizes the power of all 90+ skills by making them work together seamlessly.
---

# Skill Orchestrator

**Koordinator ultimate** yang bikin semua skills kerja bareng! 🎼

## 🎯 Core Function

Skill ini **orchestrate multiple skills** untuk complex tasks:

1. **Workflow Automation** - Chain skills in sequence
2. **Task Delegation** - Split tasks to right skills
3. **Parallel Execution** - Run multiple skills concurrently
4. **Integrated Output** - Combine results seamlessly
5. **Error Recovery** - Handle failures gracefully

## 🔄 How It Works

```
RECEIVE COMPLEX TASK
     ↓
ANALYZE: What skills are needed?
     ↓
PLAN: Create workflow (sequence/parallel)
     ↓
EXECUTE: Trigger skills in order
     ↓
INTEGRATE: Combine all outputs
     ↓
DELIVER: Complete solution
```

## 📊 Workflow Patterns

### Pattern 1: Sequential Chain
```
Task: "Research & write report"

Workflow:
1. web_search → Gather info
2. data-analysis → Process data
3. summarize → Create summary
4. Deliver report
```

### Pattern 2: Parallel Execution
```
Task: "Analyze competitor presence"

Workflow:
[Parallel]
- xurl → Twitter analysis
- web_search → Web presence
- summarize → Content analysis
[Merge]
- data-analysis → Combined insights
```

### Pattern 3: Conditional Branching
```
Task: "Fix bugs in code"

Workflow:
1. code-reviewer → Identify issues
   ↓
   IF security issue → security-auditor
   IF performance → performance-monitor
   IF bug → auto-debugger
   ↓
2. Merge fixes
3. test-runner → Verify
```

### Pattern 4: Iterative Refinement
```
Task: "Create perfect blog post"

Workflow:
1. content-creator → Draft
2. quality-gate → Review
   ↓ (if issues)
3. content-creator → Revise
2. quality-gate → Review
   ↓ (repeat until perfect)
4. Deliver
```

## 🛠️ Skill Routing

### Know Which Skill to Use

| Task Type | Primary Skill | Support Skills |
|-----------|---------------|----------------|
| Research | web_search | summarize, data-analysis |
| Coding | autonomous-coding | code-reviewer, automated-tester |
| Writing | content-creator | conversation-optimizer, quality-gate |
| Analysis | data-analysis | reasoning-enhancer, decision-intelligence |
| Memory | context-mastery | learning-accelerator |
| Communication | conversation-optimizer | user-adaptation |

## ⚡ Execution Modes

### Mode 1: Auto (Default)
```
AI decides best workflow
Execute automatically
Report progress at milestones
```

### Mode 2: Interactive
```
Propose workflow
Get user approval
Execute with checkpoints
```

### Mode 3: Manual
```
User specifies exact workflow
AI executes precisely
No deviations
```

## 🔧 Commands

### `/orchestrate <task>`
Start orchestrated workflow:
```
ORCHESTRATION STARTED

Task: [task description]
Skills needed: [list]
Workflow: [sequence]
ETA: [time estimate]

Executing...
```

### `/workflow <name>`
Run predefined workflow:
```
Available workflows:
- research-report
- code-review-fix
- content-creation
- data-analysis
- full-audit
```

### `/status`
Check orchestration status:
```
WORKFLOW STATUS: [name]

Progress: [XX%]
Current skill: [skill name]
Completed: [X/Y]
Next: [next skill]
```

### `/pause` / `/resume`
Control execution:
```
Workflow paused at: [current step]
Ready to resume when you are.
```

## 📝 Example Workflows

### Workflow: Research Report
```
INPUT: "Research AI trends in 2026"

EXECUTION:
1. web_search "AI trends 2026" → Results
2. xurl "AI discussion Twitter" → Social insights
3. data-analysis (combine data) → Patterns
4. summarize → Executive summary
5. content-creator → Full report
6. Deliver

OUTPUT: Complete research report
```

### Workflow: Code Project
```
INPUT: "Build REST API with auth"

EXECUTION:
1. autonomous-coding → Build API
2. code-reviewer → Review code
3. automated-tester → Write tests
4. security-auditor → Security check
5. quality-gate → Final review
6. Deliver

OUTPUT: Production-ready API
```

### Workflow: Content Marketing
```
INPUT: "Create content strategy"

EXECUTION:
1. competitor-analyzer → Market research
2. xurl → Social media trends
3. content-creator → Content plan
4. seo-audit → SEO optimization
5. social-media-poster → Schedule posts
6. Deliver

OUTPUT: Complete content strategy
```

## 🎯 Best Practices

### DO:
- ✅ Analyze task thoroughly before orchestrating
- ✅ Choose right skills for each subtask
- ✅ Handle errors gracefully
- ✅ Integrate outputs seamlessly
- ✅ Report progress clearly

### DON'T:
- ❌ Over-complicate simple tasks
- ❌ Use too many skills unnecessarily
- ❌ Ignore skill dependencies
- ❌ Skip error handling
- ❌ Deliver fragmented results

## 📊 Performance Metrics

```
ORCHESTRATION METRICS:
- Tasks completed: [X]
- Skills used: [Y]
- Average time: [Z min]
- Success rate: [XX%]
- User satisfaction: [X/10]
```

## 🚀 Integration

Works with ALL 90+ skills:
- Coordinates execution
- Manages data flow
- Handles errors
- Integrates outputs

---

**Goal:** Make 90+ skills work as ONE powerful system! 🎯
