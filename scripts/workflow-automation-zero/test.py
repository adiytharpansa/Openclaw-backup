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
