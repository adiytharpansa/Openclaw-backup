---
name: error-recovery
description: Smart error handling and self-healing capabilities. Use when errors occur, tasks fail, or systems are in an unstable state. This skill enables automatic error detection, root cause analysis, retry logic with alternative approaches, graceful degradation, and continuous learning from mistakes.
---

# Error Recovery

**Self-healing AI** yang recover otomatis dari errors! 🛡️

## 🎯 Core Function

Skill ini **handle errors** secara cerdas:

1. **Error Detection** - Spot errors immediately
2. **Root Cause Analysis** - Find why error happened
3. **Retry Logic** - Try again with better approach
4. **Alternative Paths** - Find workarounds
5. **Graceful Degradation** - Partial success when full fails
6. **Learning** - Prevent future errors

## 🔄 Error Recovery Process

```
ERROR DETECTED
     ↓
ANALYZE: What went wrong?
     ↓
ROOT CAUSE: Why did it happen?
     ↓
RETRY: Try again with fix
     ↓
ALTERNATIVE: If retry fails
     ↓
DEGRADE: Partial solution
     ↓
LEARN: Update prevention
```

## 📊 Error Categories

### Category 1: Code Errors
```
Syntax errors
Runtime exceptions
Logic bugs
Infinite loops
Memory leaks
Type errors
```

### Category 2: API Errors
```
Rate limiting
Authentication failures
Timeout errors
Invalid responses
Service unavailable
API changes
```

### Category 3: Network Issues
```
Connection timeouts
DNS failures
SSL certificate errors
Network unreachable
Packet loss
```

### Category 4: Resource Issues
```
Disk space low
Memory exhausted
CPU overloaded
File not found
Permission denied
```

### Category 5: Data Issues
```
Invalid data format
Missing required fields
Data corruption
Schema mismatches
Encoding errors
```

## 🛠️ Recovery Strategies

### Strategy 1: Immediate Retry
```
FOR: Transient errors
ACTIONS:
1. Wait brief period
2. Retry same operation
3. If still fails → Exponential backoff
4. Max retries: 3

EXAMPLE: Network timeout
- Retry 1: Wait 1s
- Retry 2: Wait 2s
- Retry 3: Wait 4s
- If fails → Use alternative
```

### Strategy 2: Alternative Approach
```
FOR: Persistent failures
ACTIONS:
1. Identify root cause
2. Find alternative solution
3. Implement workaround
4. Deliver partial success

EXAMPLE: API unavailable
- Primary: Use main API
- Alternative: Use cached data
- Fallback: Ask user for data
```

### Strategy 3: Graceful Degradation
```
FOR: Partial functionality
ACTIONS:
1. Identify what works
2. Deliver partial solution
3. Note what's missing
4. Offer alternatives

EXAMPLE: Database down
- Full feature: Requires DB
- Degraded: Work with cache
- Minimal: Ask user for info
```

### Strategy 4: Self-Healing
```
FOR: Recurring issues
ACTIONS:
1. Detect pattern
2. Auto-apply fix
3. Monitor effectiveness
4. Update prevention logic

EXAMPLE: Memory leak
- Detect: Memory growing
- Fix: Clear cache
- Prevent: Schedule regular cleanup
```

## 🔧 Error Handling Commands

### `/error-check`
Check current error status:
```
ERROR STATUS:

Recent errors (24h):
✓ [X] handled automatically
✓ [Y] required user intervention
✓ [Z] prevented by recovery

Active issues: [None/Count]
Recovery rate: [XX%]
```

### `/error-logs`
View error logs:
```
ERROR LOGS:

[timestamp] [error] [status]
2026-04-10 14:32 - Timeout - AUTO FIXED
2026-04-10 12:15 - Invalid input - AWAITING USER
2026-04-10 10:45 - API error - RETRY SUCCESS

Summary:
- Total errors: [X]
- Auto-fixed: [XX%]
- User needed: [YY%]
```

### `/error-patterns`
Show recurring errors:
```
ERROR PATTERNS:

1. API timeouts (5 occurrences)
   Pattern: Happens every 10-15 min
   Cause: Rate limiting
   Prevention: Added caching

2. Input validation (3 occurrences)
   Pattern: User provides wrong format
   Cause: Missing validation
   Prevention: Added checks
```

### `/error-prevention`
Set prevention rules:
```
PREVENTION RULES:

1. Network timeout → Enable retry with cache
2. API rate limit → Implement queue
3. Input errors → Add validation
4. Memory high → Auto-cleanup

Rules active: [X]
```

### `/recover`
Attempt recovery:
```
RECOVERY INITIATED

Current issue: [description]
Attempt: [1/3]
Status: Attempting recovery...
Expected time: [X seconds]

Recovery: [SUCCESS/FAILED]
If failed → [alternative options]
```

### `/debug <issue>`
Debug specific issue:
```
DEBUGGING: [issue]

Analysis:
- Symptoms: [list]
- Potential causes: [list]
- Diagnostic steps: [list]
- Root cause: [identified]
- Solution: [fix applied]

Status: FIXED
```

## 🔄 Error Handling Workflow

### Simple Error:
```
ERROR: Network timeout
ACTION:
1. Detect timeout
2. Wait 1 second
3. Retry request
4. Success!

RESULT: ✅ Auto-recovered
```

### Medium Error:
```
ERROR: API authentication failed
ACTION:
1. Detect auth error
2. Verify credentials
3. Re-authenticate
4. Retry original request
5. Success!

RESULT: ✅ Self-healed
```

### Complex Error:
```
ERROR: Database connection failed
ACTION:
1. Detect connection failure
2. Try immediate retry (fail)
3. Try alternative DB (fail)
4. Use cached data (success)
5. Alert user of degraded state

RESULT: ⚠️ Partial success with notification
```

## 📝 Error Classification

### Critical Errors:
```
Require immediate attention:
- Security breach
- Data loss
- System crash
- Financial error

ACTION: Stop, Alert, Manual fix
```

### Major Errors:
```
Significant impact but recoverable:
- Service unavailable
- Data corruption
- Performance degradation

ACTION: Auto-retry with fallback
```

### Minor Errors:
```
Low impact, easy to fix:
- Temporary timeout
- Validation error
- Minor formatting issue

ACTION: Auto-recover silently
```

### Informational:
```
Warnings, not errors:
- Rate limit approaching
- Deprecated feature
- Performance warning

ACTION: Log and monitor
```

## 🎯 Common Error Scenarios

### Scenario 1: Code Generation Error
```
ERROR: Syntax error in generated code
ACTION:
1. Identify error location
2. Check syntax rules
3. Fix the error
4. Re-validate
5. Deliver corrected code

RESULT: ✅ Code ready
```

### Scenario 2: API Rate Limit
```
ERROR: Too many requests
ACTION:
1. Stop making requests
2. Calculate wait time
3. Queue pending requests
4. Implement rate limiting
5. Retry when ready

RESULT: ✅ Requests processed
```

### Scenario 3: Invalid User Input
```
ERROR: User provided wrong format
ACTION:
1. Validate input
2. Identify specific issue
3. Provide clear error message
4. Show correct format
5. Allow retry

RESULT: ✅ Correct input received
```

### Scenario 4: Missing Dependencies
```
ERROR: Required module not found
ACTION:
1. Identify missing module
2. Check installation
3. Install dependency
4. Verify installation
5. Retry operation

RESULT: ✅ Dependency resolved
```

## 📊 Error Metrics

```
ERROR METRICS:

Total errors detected: [X]
Auto-recovered: [XX%]
Manual intervention: [YY%]
Mean time to recovery: [X min]
Error-free uptime: [XX%]

Top error types:
1. [Type]: [N] occurrences
2. [Type]: [N] occurrences
3. [Type]: [N] occurrences

Prevention rate: [XX%]
```

## 🧠 Learning from Errors

### Error Pattern Learning:
```
PATTERN DETECTED:
- Errors happen at [time/frequency]
- Associated with [condition]
- Root cause: [cause]

ACTION:
- Preventive measure: [measure]
- Monitor: [what to watch]
- Alert: [when to notify]
```

### Prevention Rules:
```
NEW PREVENTION RULE ADDED:

If: [condition]
Then: [preventive action]
Trigger: [when to check]

Example:
If: API response slow
Then: Enable caching
Check: Every request
```

---

**Goal:** Make errors rare, and handle them gracefully when they occur! 🛡️

**Status:** Error Recovery ACTIVE  
**Recovery Rate:** [XX%]  
**Learning:** Continuous improvement
