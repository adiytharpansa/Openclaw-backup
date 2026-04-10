---
name: workflow-automation
description: Automate recurring workflows and multi-step tasks. Use when you need to create automated processes, schedule recurring tasks, or chain operations together. This skill enables creation of custom workflows, automation of daily/weekly/monthly routines, and trigger-based task execution.
---

# Workflow Automation

**Automate SEMUA yang repetitive!** ⚙️

## 🎯 Core Function

Skill ini **automate workflows** untuk:

1. **Daily Routines** - Morning briefings, status checks
2. **Weekly Reports** - Project summaries, analytics
3. **Monthly Tasks** - Financial reports, retrospectives
4. **Triggers** - Event-based automation
5. **Scheduled Tasks** - Time-based automation

## 🔄 Workflow Patterns

### Pattern 1: Daily Routine
```
Morning Briefing (8 AM):
1. Check calendar events (next 24h)
2. Check email (new messages)
3. Check notifications (Discord, GitHub)
4. Check weather (today's forecast)
5. Compile & deliver briefing
```

### Pattern 2: Weekly Report
```
Friday Report (4 PM):
1. Git activity (commits, PRs, issues)
2. Project progress (all active projects)
3. Meeting summaries (week's meetings)
4. Tasks completed vs planned
5. Generate & send report
```

### Pattern 3: Monthly Review
```
Month End Review:
1. Financial summary (income/expenses)
2. Goals progress (all OKRs)
3. Learning progress (new skills/knowledge)
4. Health metrics (if tracked)
5. Generate insights & next month plan
```

### Pattern 4: Trigger-Based
```
When [event] happens:
→ [Action 1]
→ [Action 2]
→ [Notify you]
```

Examples:
- When email arrives from [person] → Archive + Summarize
- When GitHub PR created → Review + Comment
- When meeting ends → Take notes + Send summary

## 📋 Creating Workflows

### Simple Workflow:
```
/workflow create "Daily Standup"

Steps:
1. Check calendar for today
2. Review pending tasks
3. Check team notifications
4. Generate standup summary
5. Send to you
```

### Complex Workflow:
```
/workflow create "Project Launch"

Pre-launch:
1. Verify all tasks complete
2. Check documentation
3. Test all features
4. Review security
5. Notify team

Launch:
1. Deploy to production
2. Monitor health
3. Update status
4. Announce success

Post-launch:
1. Track metrics
2. Monitor issues
3. Generate report
4. Celebrate!
```

## 🔧 Workflow Commands

### `/workflow create <name>`
Create new workflow:
```
CREATE WORKFLOW: Daily Health Check

Steps:
1. Check service status
2. View error logs
3. Check disk usage
4. Monitor response times
5. Alert on issues

Status: Saved ✓
Schedule: Daily at 9 AM
```

### `/workflow list`
List all workflows:
```
WORKFLOWS:

1. Daily Health Check ✅ Active
   Schedule: Daily 9 AM
   Last run: Today, 9:00 AM

2. Weekly Report ✅ Active
   Schedule: Friday 4 PM
   Last run: Last Friday

3. Monthly Review ✅ Active
   Schedule: 1st of month
   Last run: April 1st
```

### `/workflow run <name>`
Run specific workflow:
```
RUNNING: Daily Health Check

Executing...
1. ✅ Service status: OK
2. ✅ Error logs: Clean
3. ✅ Disk usage: 60%
4. ✅ Response times: Normal
5. ✅ All systems green

Report delivered.
```

### `/workflow schedule <name> <time>`
Set schedule for workflow:
```
SCHEDULE UPDATE:

Daily Health Check → Daily 9 AM
Weekly Report → Friday 4 PM
Monthly Review → 1st of month, 10 AM
```

### `/workflow trigger <event>`
Create trigger-based automation:
```
TRIGGER CREATED:

Event: New email from important-contacts
Actions:
  1. Read email
  2. Summarize content
  3. Check calendar for conflicts
  4. Alert if urgent
  5. Archive with tags

Status: Active ✓
```

### `/workflow status`
Check workflow status:
```
WORKFLOW STATUS:

Active workflows: 3
Scheduled runs today: 2
Completed today: 1
Pending: 1
Errors (24h): 0

Health: 100%
```

## 📅 Common Workflows

### Workflow 1: Daily Briefing
```
SCHEDULE: Every day, 8:00 AM

ACTIONS:
1. Check calendar (next 24h events)
2. Check email (unread messages)
3. Check GitHub (notifications)
4. Check weather (today's forecast)
5. Compile into briefing
6. Deliver to you

OUTPUT:
"Good morning Sanz!

📅 Today:
- Meeting with X at 2 PM
- Deadline for Y due tomorrow

📧 Emails: 3 unread (1 urgent)

🐙 GitHub: 2 PRs waiting

🌤️ Weather: Sunny, 32°C

Ready to crush today! 💪"
```

### Workflow 2: Git Activity Summary
```
SCHEDULE: Every Monday, 9:00 AM

ACTIONS:
1. Fetch git activity (last 7 days)
2. Summarize commits
3. List PRs created/merged
4. Note issues opened/resolved
5. Calculate metrics (commits, PRs, etc.)
6. Generate report

OUTPUT:
"WEEKLY GIT SUMMARY

This week:
- Commits: 47 (↑12%)
- PRs: 8 created, 6 merged
- Issues: 5 opened, 4 closed
- Contributors: 3 active

Top projects:
- Project A: 20 commits
- Project B: 15 commits
- Project C: 12 commits

All good! ✅"
```

### Workflow 3: Project Progress Check
```
SCHEDULE: Daily, 5:00 PM

ACTIONS:
1. Check all active projects
2. Review task completion
3. Note blockers
4. Calculate progress %
5. Generate status report
6. Alert on critical issues

OUTPUT:
"PROJECT STATUS (5 PM)

✅ Project A: 85% complete
   - 3 tasks done today
   - On track

⚠️ Project B: 40% complete
   - 1 task done today
   - Blocker: Waiting for API

📝 Project C: 60% complete
   - 2 tasks done today
   - Normal progress

1 blocker needs attention! ⚠️"
```

### Workflow 4: Financial Summary
```
SCHEDULE: Monthly, 1st of month, 10:00 AM

ACTIONS:
1. Import financial data
2. Categorize transactions
3. Calculate income/expenses
4. Check budget status
5. Note trends
6. Generate report

OUTPUT:
"MARCH FINANCIAL SUMMARY

Income: $5,000
Expenses: $3,200
Savings: $1,800 (36%)

By category:
- Housing: $1,200
- Food: $400
- Entertainment: $200
- Others: $1,400

Budget status: ✅ On track
Month-over-month: +5% savings

Good month! 💰"
```

### Workflow 5: Learning Progress
```
SCHEDULE: Weekly, Sunday, 3:00 PM

ACTIONS:
1. Review learning activities
2. Note new concepts learned
3. Track practice hours
4. Assess understanding
5. Suggest next steps
6. Update learning path

OUTPUT:
"WEEKLY LEARNING (April 5-7)

This week:
- Studied: Machine Learning basics
- Practice: 8 hours
- Projects: 1 small project

Learned:
- Supervised vs unsupervised
- Decision trees
- Neural networks intro

Next week:
- Deep dive into SVMs
- More practice problems
- Build small classifier

Keep it up! 📚"
```

## 🚀 Advanced Features

### Conditional Workflows
```
/workflow create "Smart Alert"

Conditions:
IF error rate > 5% THEN
  1. Collect error details
  2. Alert me immediately
  3. Attempt auto-fix
  4. Log incident

IF response time > 2s THEN
  1. Run diagnostics
  2. Identify bottleneck
  3. Apply optimization
  4. Log issue

ELSE
  (no action needed)
```

### Loop Workflows
```
/workflow create "Deploy Pipeline"

Steps (loop until success):
1. Build application
2. Run tests
3. If tests fail → Retry build
4. If tests pass → Deploy
5. Verify deployment
6. If verification fails → Rollback

Max retries: 3
After max retries → Alert me
```

### Multi-Step with Approval
```
/workflow create "Major Change"

Steps:
1. Analyze change impact
2. Present to me
3. WAIT for approval
   - If approve → Continue
   - If deny → Stop
   - If modify → Revise and re-present
4. Implement changes
5. Test changes
6. Deploy to staging
7. Notify me

Approvals needed at: Step 3
```

## 📊 Workflow Analytics

```
WORKFLOW METRICS:

Total workflows: 5
Active workflows: 5
Completed (today): 3
Failed (today): 0
Total executions (month): 150

Average execution time:
- Simple: 2 minutes
- Medium: 5 minutes
- Complex: 15 minutes

Success rate: 99%
User satisfaction: 95%
```

## 💡 Pro Tips

### For Best Results:

1. **Keep workflows simple** - Break complex tasks
2. **Test before scheduling** - Run manually first
3. **Add error handling** - What if something fails?
4. **Set clear triggers** - Define conditions precisely
5. **Monitor performance** - Watch execution times
6. **Review regularly** - Optimize workflows
7. **Document workflows** - Keep track of what they do

---

**Goal:** Automate everything repetitive! ⚡

**Status:** Workflow Automation ACTIVE  
**Workflows created:** 5+ ready to use  
**Automation level:** Maximum 🤖
