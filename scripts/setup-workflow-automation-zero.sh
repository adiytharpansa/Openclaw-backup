#!/bin/bash

# Workflow Automation Zero Setup Script

echo "⚙️ Setting up Workflow Automation Zero..."

# Create directories
mkdir -p scripts/workflow-automation-zero
mkdir -p workflows/templates
mkdir -p workflows/executions

# Create main script
cat > scripts/workflow-automation-zero/main.py << 'EOF'
#!/usr/bin/env python3
"""
Workflow Automation Zero - Main CLI
"""

import json
import sys
import asyncio
from datetime import datetime

sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from skills.workflow_automation_zero.SKILL import WorkflowEngine, workflow_templates

async def create_workflow(name, template_name):
    """Create workflow from template"""
    if template_name not in workflow_templates:
        print(f"❌ Template '{template_name}' not found")
        return
    
    engine = WorkflowEngine()
    template = workflow_templates[template_name]
    
    workflow = await engine.create_workflow(template)
    print(f"✅ Created workflow: {workflow.name}")
    print(f"   ID: {workflow.id}")
    print(f"   Steps: {len(workflow.steps)}")

async def list_workflows(engine):
    """List all workflows"""
    stats = engine.get_workflow_stats()
    print("📊 Workflow Statistics:")
    print(f"   Total: {stats['total_workflows']}")
    print(f"   Enabled: {stats['enabled_workflows']}")
    print(f"   Success Rate: {stats['success_rate']:.1f}%")

async def main():
    if len(sys.argv) < 2:
        print("Workflow Automation Zero CLI")
        print("")
        print("Usage:")
        print("  python main.py create <name> <template>")
        print("  python main.py list")
        print("  python main.py run <workflow_id>")
        print("  python main.py templates")
        print("")
        print("Available templates:")
        for name in workflow_templates:
            print(f"  - {name}")
        return
    
    engine = WorkflowEngine()
    
    command = sys.argv[1]
    
    if command == "create":
        if len(sys.argv) < 4:
            print("Usage: create <name> <template>")
            return
        name = sys.argv[2]
        template = sys.argv[3]
        await create_workflow(name, template)
    
    elif command == "list":
        await list_workflows(engine)
    
    elif command == "templates":
        print("Available Templates:")
        for name, template in workflow_templates.items():
            print(f"\n{name}:")
            print(f"  {template['description']}")
            print(f"  Steps: {len(template['steps'])}")
    
    elif command == "run":
        if len(sys.argv) < 3:
            print("Usage: run <workflow_id>")
            return
        workflow_id = sys.argv[2]
        try:
            result = await engine.execute_workflow(workflow_id)
            print(f"Execution: {result['status']}")
        except Exception as e:
            print(f"Error: {e}")

if __name__ == "__main__":
    asyncio.run(main())
EOF

chmod +x scripts/workflow-automation-zero/main.py

# Create template library
cat > scripts/workflow-automation-zero/templates.json << 'EOF'
{
  "slack-notification": {
    "name": "Slack Notification",
    "description": "Send notification to Slack",
    "trigger": {"type": "webhook", "endpoint": "/notify"},
    "steps": [
      {
        "id": "1",
        "type": "send_message",
        "name": "Send to Slack",
        "config": {
          "integration": "slack",
          "action": "send_message",
          "channel": "#general",
          "message": "{{message}}"
        }
      }
    ]
  },
  "telegram-alert": {
    "name": "Telegram Alert",
    "description": "Send alert to Telegram",
    "trigger": {"type": "webhook", "endpoint": "/alert"},
    "steps": [
      {
        "id": "1",
        "type": "send_message",
        "name": "Send to Telegram",
        "config": {
          "integration": "telegram",
          "action": "send_message",
          "chat_id": "CHANNEL_ID",
          "message": "⚠️ {{message}}"
        }
      }
    ]
  },
  "daily-report": {
    "name": "Daily Report",
    "description": "Send daily summary report",
    "trigger": {"type": "time_based", "schedule": "0 9 * * *"},
    "steps": [
      {
        "id": "1",
        "type": "transform",
        "name": "Format report",
        "config": {"format": "Daily Report - {{date}}"}
      },
      {
        "id": "2",
        "type": "send_message",
        "name": "Send report",
        "config": {
          "integration": "telegram",
          "action": "send_message",
          "message": "{{formatted_report}}"
        }
      }
    ]
  },
  "github-pr-notify": {
    "name": "GitHub PR Notification",
    "description": "Notify on GitHub PR",
    "trigger": {"type": "webhook", "endpoint": "/github/pr"},
    "steps": [
      {
        "id": "1",
        "type": "transform",
        "name": "Format message",
        "config": {
          "format": "🚀 PR: {{title}} by {{author}}"
        }
      },
      {
        "id": "2",
        "type": "send_message",
        "name": "Post to Slack",
        "config": {
          "integration": "slack",
          "action": "send_message",
          "channel": "#dev-updates",
          "message": "{{formatted_message}}"
        }
      }
    ]
  },
  "backup-daily": {
    "name": "Daily Backup",
    "description": "Backup files daily",
    "trigger": {"type": "time_based", "schedule": "0 2 * * *"},
    "steps": [
      {
        "id": "1",
        "type": "http",
        "name": "Create backup",
        "config": {
          "method": "POST",
          "url": "http://internal/backup",
          "headers": {"Authorization": "Bearer TOKEN"}
        }
      },
      {
        "id": "2",
        "type": "send_message",
        "name": "Notify completion",
        "config": {
          "integration": "telegram",
          "action": "send_message",
          "message": "✅ Backup completed"
        }
      }
    ]
  }
}
EOF

# Create test script
cat > scripts/workflow-automation-zero/test.py << 'EOF'
#!/usr/bin/env python3
"""Test workflow automation"""
import sys
import asyncio

sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from skills.workflow_automation_zero.SKILL import WorkflowEngine

async def test():
    engine = WorkflowEngine()
    
    print("⚙️ Testing Workflow Automation Zero...")
    print("")
    
    # Test 1: List available integrations
    print("📦 Available Integrations:")
    for name in engine.integrations:
        print(f"  - {name}")
    print("")
    
    # Test 2: Get stats (empty)
    stats = engine.get_workflow_stats()
    print("📊 Initial Stats:")
    print(f"  Total workflows: {stats['total_workflows']}")
    print(f"  Enabled: {stats['enabled_workflows']}")
    print("")
    
    print("✅ Workflow Automation Zero ready!")
    print("")
    print("Usage:")
    print("  python main.py create <name> <template>")
    print("  python main.py list")
    print("  python main.py templates")

if __name__ == "__main__":
    asyncio.run(test())
EOF

chmod +x scripts/workflow-automation-zero/test.py

# Create quick start guide
cat > workflows/QUICK_START.md << 'EOF'
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
EOF

echo "✅ Workflow Automation Zero setup complete!"
echo ""
echo "Quick Start:"
echo "  cd /mnt/data/openclaw/workspace/.openclaw/workspace"
echo "  python scripts/workflow-automation-zero/main.py templates"
echo ""
echo "Available Templates:"
echo "  - slack-notification"
echo "  - telegram-alert"
echo "  - daily-report"
echo "  - github-pr-notify"
echo "  - backup-daily"
