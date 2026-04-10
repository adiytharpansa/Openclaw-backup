# ⚙️ Workflow Automation Platform

_Zapier-style automation for OpenClaw_

---

## 🎯 How It Works

```
TRIGGER → CONDITIONS → ACTIONS → OUTPUT
```

### Example Flow
```
TRIGGER: New email received
CONDITIONS: From important contact + has attachment
ACTIONS: Download attachment → Summarize → Save to Notion → Notify
OUTPUT: Summary in Notion + Telegram notification
```

---

## 📋 Pre-Built Workflows

### 1. Email → Knowledge Base
```yaml
name: "Email to Knowledge"
trigger:
  type: email_received
  conditions:
    from: "important@contacts.com"
    has_attachment: true
actions:
  - download_attachment
  - summarize_content
  - save_to_notion: "Knowledge Base"
  - tag: ["email", "important"]
output:
  - notion_page_created
  - notification_sent
```

### 2. GitHub → Daily Report
```yaml
name: "GitHub Daily Summary"
trigger:
  type: schedule
  cron: "0 18 * * *"  # Daily at 6 PM
actions:
  - fetch_github_notifications
  - fetch_github_pull_requests
  - fetch_github_issues
  - generate_summary
  - send_email_report
output:
  - daily_report_email
```

### 3. Research → Content Pipeline
```yaml
name: "Research to Content"
trigger:
  type: manual
  input: topic
actions:
  - web_search: "{{topic}}"
  - extract_top_results: 5
  - summarize_each
  - compile_insights
  - draft_blog_post
  - save_to_obsidian
output:
  - blog_draft
  - research_summary
```

### 4. Calendar → Prep Brief
```yaml
name: "Meeting Prep"
trigger:
  type: calendar_event
  conditions:
    starts_in: "30 minutes"
    has_attendees: true
actions:
  - fetch_attendee_info
  - search_related_notes
  - generate_brief
  - send_notification
output:
  - meeting_brief
  - reminder_sent
```

### 5. CI/CD → Notification
```yaml
name: "Build Alert"
trigger:
  type: webhook
  source: github_actions
  conditions:
    status: ["failure", "success"]
actions:
  - parse_build_result
  - get_commit_info
  - format_message
  - send_notification: telegram
  - log_to_analytics
output:
  - notification_sent
  - build_logged
```

---

## 🔧 Custom Workflow Builder

### Template
```yaml
name: "My Custom Workflow"
description: "What this workflow does"
trigger:
  type: [schedule|webhook|email|manual|file_change]
  conditions:
    # Your conditions here
actions:
  - action_1: params
  - action_2: params
  - action_3: params
output:
  - expected_outputs
error_handling:
  on_failure: [retry|notify|stop|fallback]
  max_retries: 3
```

### Available Triggers
- `schedule` - Cron-based scheduling
- `webhook` - HTTP webhook
- `email` - Email received
- `file_change` - File/folder changes
- `manual` - Manual trigger
- `api_call` - API endpoint call
- `message` - Chat message received

### Available Actions
- `web_search` - Search the web
- `browser_navigate` - Open website
- `summarize` - Summarize content
- `send_email` - Send email
- `send_message` - Telegram/Discord/Slack
- `save_file` - Save to workspace
- `run_script` - Execute script
- `call_api` - HTTP API call
- `spawn_agent` - Start sub-agent
- `update_notion` - Update Notion page
- `update_github` - GitHub operations

---

## 📁 Workflow Files

```
workflows/
├── automation-platform.md    # This file
├── active/
│   ├── email-to-knowledge.yaml
│   ├── github-daily.yaml
│   └── ci-alert.yaml
├── templates/
│   ├── schedule-based.yaml
│   ├── webhook-based.yaml
│   └── event-based.yaml
└── logs/
    └── execution-history.md
```

---

## 🚀 Running Workflows

### Manual Execution
```bash
# Run a workflow
./workflows/run.sh email-to-knowledge.yaml

# Run with parameters
./workflows/run.sh research.yaml --topic "AI trends"
```

### Scheduled Execution
```bash
# Enable scheduler
./workflows/scheduler.sh --start

# View scheduled workflows
./workflows/scheduler.sh --list

# Disable scheduler
./workflows/scheduler.sh --stop
```

### Webhook Trigger
```bash
# Get webhook URL
./workflows/webhook.sh --url ci-alert

# Test webhook
curl -X POST <webhook-url> -d '{"status": "success"}'
```

---

## 📊 Execution History

| Date | Workflow | Status | Duration | Output |
|------|----------|--------|----------|--------|
| - | - | - | - | - |

---

## 🔐 Security

- Workflows run in sandboxed environment
- API keys from 1Password only
- Rate limiting on all actions
- Audit logging enabled
- Approval required for destructive actions

---

## 🎯 Best Practices

1. **Start Simple** - Begin with single-trigger, single-action workflows
2. **Test Thoroughly** - Test each action individually first
3. **Error Handling** - Always define on_failure behavior
4. **Logging** - Log execution for debugging
5. **Rate Limits** - Respect API rate limits
6. **Security** - Never hardcode credentials

---

## 📈 Monitoring

```bash
# View workflow stats
./workflows/stats.sh

# View recent executions
./workflows/logs.sh --limit 10

# Check failed workflows
./workflows/logs.sh --status failed
```

---

_Last updated: 2026-04-10 (Setup Complete)_
