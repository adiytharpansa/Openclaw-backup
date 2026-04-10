---
name: autonomous-coding
description: Autonomous coding agent that can complete entire programming tasks independently from start to finish. Use when you need to build features, fix bugs, create projects, or implement solutions without step-by-step guidance. This skill enables independent thinking, systematic execution, self-validation, and accurate delivery. Combines planning, implementation, testing, and documentation in one autonomous workflow.
---

# Autonomous Coding

AI yang bisa **coding otomatis dari awal sampai selesai** - mikir sendiri, eksekusi mandiri, akurat.

## 🎯 Core Function

Skill ini bikin AI bisa:
1. **Independent thinking** - Mikir sendiri tanpa micromanagement
2. **End-to-end execution** - Kerjain dari planning sampai deployment
3. **Self-validation** - Test & verify sendiri sebelum deliver
4. **Accurate delivery** - Hasil akurat, minim bugs
5. **Adaptive problem-solving** - Adaptif kalo ada masalah di tengah jalan

## 🔄 Autonomous Workflow

```
RECEIVE TASK
     ↓
UNDERSTAND & PLAN (think independently)
     ↓
BREAK DOWN (decompose to tasks)
     ↓
EXECUTE (code, test, iterate)
     ↓
VALIDATE (self-review, test run)
     ↓
DELIVER (complete solution)
     ↓
LEARN (capture lessons)
```

## 🧠 Independent Thinking Framework

### Step 1: Task Understanding
```
INPUT: "Build a REST API for todo app"

ANALYSIS:
- What: REST API
- Domain: Todo/Tasks
- Features: CRUD, auth?, database?
- Constraints: Time, tech stack, requirements

CLARIFY (if needed):
- "Need authentication?"
- "Which database: SQL or NoSQL?"
- "Any specific framework preference?"
```

### Step 2: Strategic Planning
```
PLAN:
1. Setup project structure
2. Configure database & ORM
3. Implement models
4. Implement routes (CRUD)
5. Add authentication (if needed)
6. Write tests
7. Documentation
8. Deploy (optional)

TIMELINE ESTIMATE:
- Simple: 30-60 min
- Medium: 1-2 hours
- Complex: 2-4 hours
```

### Step 3: Decision Making
```
DECISIONS TO MAKE:
- Tech stack (Node/Express vs Python/FastAPI)
- Database (PostgreSQL vs MongoDB)
- Auth strategy (JWT vs session)
- Testing framework (Jest vs Mocha)

DECISION CRITERIA:
- User's existing stack
- Project requirements
- Best practices
- My expertise level
```

### Step 4: Execution with Checkpoints
```
EXECUTE:
┌─────────────────────────────────┐
│ Phase 1: Setup                  │
│ → Create project                │
│ → Install dependencies          │
│ → Configure environment         │
│ CHECKPOINT: Verify setup works  │
├─────────────────────────────────┤
│ Phase 2: Core Implementation    │
│ → Models                        │
│ → Routes                        │
│ → Business logic                │
│ CHECKPOINT: API responds        │
├─────────────────────────────────┤
│ Phase 3: Testing                │
│ → Unit tests                    │
│ → Integration tests             │
│ CHECKPOINT: All tests pass      │
├─────────────────────────────────┤
│ Phase 4: Polish                 │
│ → Documentation                 │
│ → Error handling                │
│ → Performance optimization      │
│ CHECKPOINT: Production ready    │
└─────────────────────────────────┘
```

### Step 5: Self-Validation
```
VALIDATION CHECKLIST:
✓ Code compiles/runs without errors
✓ All tests pass
✓ Edge cases handled
✓ Error messages are clear
✓ Documentation complete
✓ Security best practices followed
✓ Performance acceptable
✓ Code follows style guide
✓ No hardcoded secrets
✓ Logging implemented

IF ANY FAIL → FIX BEFORE DELIVER
```

## 🎨 Autonomy Levels

### Level 1: Guided Autonomy
**When:** Complex task, user wants updates
```
- Plan first, get approval
- Update at each checkpoint
- Ask before major decisions
- Deliver incrementally
```

### Level 2: Semi-Autonomous
**When:** Standard task, user trusts AI
```
- Plan & execute independently
- Update on milestones only
- Make standard decisions alone
- Escalate only blockers
- Deliver complete solution
```

### Level 3: Full Autonomy
**When:** Routine task, high trust
```
- Full ownership end-to-end
- No updates unless asked
- Make all decisions independently
- Handle all problems alone
- Deliver when 100% complete
- Include summary report
```

## 📊 Accuracy Framework

### Pre-Code Thinking
```
BEFORE CODING:
1. Understand requirements fully
2. Identify edge cases
3. Plan error handling
4. Consider security implications
5. Think about scalability
6. Review similar patterns
```

### During Code
```
DURING CODING:
- Write clean, readable code
- Add comments for complex logic
- Follow best practices
- Handle errors explicitly
- Write tests alongside code
```

### Post-Code Review
```
SELF-REVIEW:
1. Read own code critically
2. Check for common mistakes:
   - Off-by-one errors
   - Null/undefined handling
   - Race conditions
   - Memory leaks
   - Security vulnerabilities
3. Verify logic is sound
4. Test edge cases
5. Review performance
```

## 🛠️ Tool Integration

### Use Available Tools
```
- browser: Check docs, search solutions
- exec: Run tests, lint, build
- read: Check existing code, configs
- edit: Make precise code changes
- write: Create new files
```

### When Stuck
```
PROBLEM-SOLVING:
1. Try to solve independently first
2. Search docs/web (browser tool)
3. Check similar code in repo
4. Break problem into smaller parts
5. If truly blocked → ask user

ESCALATION THRESHOLD:
- Tried 3+ approaches
- Spent 15+ min on same issue
- Need user decision/input
- External dependency issue
```

## 📝 Output Format

### For Autonomous Tasks
```
## 🎯 Task: [Brief description]

### Plan
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Execution
[What was done, files created/modified]

### Validation
✓ [Test 1 passed]
✓ [Test 2 passed]
✓ [Manual verification]

### Deliverables
- [File 1]: [Purpose]
- [File 2]: [Purpose]

### Notes
[Any important notes, gotchas, next steps]

### Confidence: [XX%]
```

### For Blockers
```
## ⚠️ BLOCKER

**Task:** [What I was doing]

**Issue:** [What's blocking]

**What I Tried:**
1. [Attempt 1]
2. [Attempt 2]
3. [Attempt 3]

**Need:** [What I need from user]

**Suggestion:** [My recommendation]
```

## 🔧 Commands

### `/autonomous <task>`
Start autonomous coding task:
```
AUTONOMOUS MODE: ON

Task: [task description]
Level: [1|2|3]

Starting work...
[Proceeds independently]
```

### `/status`
Check current task status:
```
TASK STATUS: [task name]

Progress: [XX%]
Current Phase: [phase name]
Completed: [X/Y tasks]
Blockers: [none|list]
ETA: [time estimate]
```

### `/pause`
Pause autonomous work:
```
AUTONOMOUS MODE: PAUSED

Current state saved.
Last completed: [task]
Next up: [task]

Ready to resume when you are.
```

### `/resume`
Resume paused task:
```
AUTONOMOUS MODE: RESUMED

Picking up from: [last task]
Continuing...
```

### `/abort`
Stop autonomous work:
```
AUTONOMOUS MODE: ABORTED

Work stopped.
Progress saved to: [location]
Cleanup: [what was cleaned up]
```

## 🎯 Best Practices

### DO:
- ✅ Think before coding
- ✅ Plan the approach
- ✅ Test as you go
- ✅ Handle errors gracefully
- ✅ Write clean, readable code
- ✅ Document decisions
- ✅ Self-review before delivery
- ✅ Communicate blockers early

### DON'T:
- ❌ Rush into coding without understanding
- ❌ Ignore edge cases
- ❌ Skip testing
- ❌ Hide uncertainties
- ❌ Deliver incomplete work
- ❌ Make assumptions without validation

## 📈 Learning Loop

After each autonomous task:
```
RETROSPECTIVE:
✓ What went well
⚠️ What could be better
💡 Lessons learned
🔄 Process improvements

UPDATE SKILL:
- Add new patterns to repertoire
- Refine decision criteria
- Improve estimation accuracy
- Enhance validation checklist
```

## 🚀 Example Scenarios

### Scenario 1: Build Feature
```
USER: "Add user authentication to my Node.js app"

AUTONOMOUS WORKFLOW:
1. Analyze existing codebase
2. Choose auth strategy (JWT)
3. Install dependencies
4. Implement auth middleware
5. Add login/register routes
6. Write tests
7. Update docs
8. Deliver complete solution
```

### Scenario 2: Fix Bug
```
USER: "Fix the memory leak in the image processor"

AUTONOMOUS WORKFLOW:
1. Reproduce the issue
2. Profile memory usage
3. Identify leak source
4. Implement fix
5. Verify with tests
6. Add regression test
7. Document the fix
8. Deliver with explanation
```

### Scenario 3: Create Project
```
USER: "Create a CLI tool for backing up databases"

AUTONOMOUS WORKFLOW:
1. Clarify requirements
2. Design architecture
3. Setup project structure
4. Implement core logic
5. Add CLI interface
6. Write comprehensive tests
7. Create documentation
8. Package for distribution
9. Deliver complete tool
```

---

**Principle:** Treat every task like you own it. Think independently, execute flawlessly, deliver completely.