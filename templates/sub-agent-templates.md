# Sub-Agent Orchestration Templates

_Spawn specialized agents for specific tasks_

## 🤖 Agent Profiles

### Research Agent
```
Specialization: Deep research, web search, data gathering
Best for: Market research, competitive analysis, fact-finding
Tools: web_search, browser, summarize, youtube-watcher
```

**Spawn Command:**
```bash
sessions_spawn \
  task="Research [TOPIC] - find key insights, sources, and trends" \
  label="research-agent" \
  runtime="subagent" \
  mode="run"
```

### Coding Agent
```
Specialization: Software development, debugging, code review
Best for: Feature implementation, bug fixes, refactoring
Tools: github, agentic-coding, oracle, tmux
```

**Spawn Command:**
```bash
sessions_spawn \
  task="Implement [FEATURE] - follow best practices, write tests" \
  label="coding-agent" \
  runtime="subagent" \
  mode="session"
```

### Writing Agent
```
Specialization: Content creation, copywriting, documentation
Best for: Blog posts, marketing copy, technical docs
Tools: copywriting skill, summarize, markitdown
```

**Spawn Command:**
```bash
sessions_spawn \
  task="Write [CONTENT_TYPE] about [TOPIC] - engaging, clear, actionable" \
  label="writing-agent" \
  mode="run"
```

### Review Agent
```
Specialization: Quality assurance, feedback, optimization
Best for: Code review, content editing, strategy feedback
Tools: oracle, self-improving-agent
```

**Spawn Command:**
```bash
sessions_spawn \
  task="Review [WORK] - identify issues, suggest improvements" \
  label="review-agent" \
  mode="run"
```

## 🎯 Multi-Agent Workflow Example

**Task: Build a feature end-to-end**

1. **Research Agent** - Gather requirements, best practices
2. **Coding Agent** - Implement the feature
3. **Review Agent** - Quality check
4. **Writing Agent** - Documentation

```bash
# Step 1: Research
sessions_spawn task="Research best practices for [FEATURE]" label="research"

# Step 2: Code (wait for research to complete)
sessions_spawn task="Implement [FEATURE] based on research" label="coding"

# Step 3: Review
sessions_spawn task="Review code quality and suggest improvements" label="review"

# Step 4: Document
sessions_spawn task="Write documentation for [FEATURE]" label="docs"
```

## 📋 Agent Coordination

**When to use multi-agent:**
- Complex tasks (>3 steps)
- Need different expertise areas
- Parallel work possible
- Quality assurance needed

**When single agent is enough:**
- Simple, focused tasks
- Quick lookups
- One-off operations

---

## 🔧 Custom Agent Template

Create your own specialized agent:

```markdown
### [Agent Name]
**Specialization:** [What they're best at]
**Best for:** [Use cases]
**Tools:** [Relevant skills]
**Prompt Style:** [How to instruct them]

**Spawn:**
```
sessions_spawn \
  task="[TASK TEMPLATE]" \
  label="[AGENT-LABEL]" \
  runtime="subagent" \
  mode="[run|session]"
```
```
