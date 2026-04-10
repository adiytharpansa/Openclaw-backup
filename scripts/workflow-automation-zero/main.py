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
