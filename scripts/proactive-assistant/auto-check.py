#!/usr/bin/env python3
"""Auto-check for proactive suggestions"""
import sys
sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from skills.proactive_assistant.SKILL import ProactiveAI, ProactiveEngine
from datetime import datetime

async def check_and_suggest(context):
    """Check and suggest proactive actions"""
    engine = ProactiveAI()
    
    if await engine.should_be_proactive(context):
        suggestions = await engine.get_proactive_suggestions(context)
        if suggestions:
            print("💡 Proactive Suggestions:")
            print(suggestions)
            return suggestions
    
    return None

if __name__ == "__main__":
    context = {
        'user_state': 'active',
        'tasks': [],
        'files': [],
        'dependencies': []
    }
    
    import asyncio
    asyncio.run(check_and_suggest(context))
