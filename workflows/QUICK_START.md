# Workflow Automation Zero - Quick Start

## What is this?
Zero-code workflow automation for OpenClaw. Automate tasks without writing code!

## Available Templates

### 1. Slack Notification
Send messages to Slack when triggered.

**Create:**
```bash
python scripts/workflow-automation-zero/main.py create "Slack Notify" slack-notification
```

### 2. Telegram Alert
Send alerts to Telegram.

**Create:**
```bash
python scripts/workflow-automation-zero/main.py create "Telegram Alert" telegram-alert
```

### 3. Daily Report
Automated daily summary report.

**Create:**
```bash
python scripts/workflow-automation-zero/main.py create "Daily Report" daily-report
```

### 4. GitHub PR Notify
Notify when GitHub PR is created.

**Create:**
```bash
python scripts/workflow-automation-zero/main.py create "PR Notify" github-pr-notify
```

### 5. Daily Backup
Automated daily backup.

**Create:**
```bash
python scripts/workflow-automation-zero/main.py create "Daily Backup" backup-daily
```

## Commands

```bash
# List all workflows
python scripts/workflow-automation-zero/main.py list

# View templates
python scripts/workflow-automation-zero/main.py templates

# Create workflow
python scripts/workflow-automation-zero/main.py create "My Workflow" template-name

# Run workflow manually
python scripts/workflow-automation-zero/main.py run <workflow_id>
```

## Next Steps

1. Choose a template above
2. Create workflow
3. Customize config
4. Enable workflow
5. Test execution

For custom workflows, edit `scripts/workflow-automation-zero/templates.json`
