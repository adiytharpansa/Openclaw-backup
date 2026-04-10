#!/bin/bash

# Proactive Assistant Setup Script

echo "🤖 Setting up Proactive Assistant Skill..."

# Create directories
mkdir -p scripts/proactive-assistant
mkdir -p memory/patterns

# Create test script
cat > scripts/proactive-assistant/test.py << 'EOF'
#!/usr/bin/env python3
"""Test proactive engine"""
import sys
sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from skills.proactive_assistant.SKILL import ProactiveEngine

if __name__ == "__main__":
    engine = ProactiveEngine()
    
    # Sample user data
    user_data = {
        'task_history': [
            {'day_of_week': 'Monday', 'task': 'Review'},
            {'day_of_week': 'Monday', 'task': 'Meeting'},
            {'day_of_week': 'Friday', 'task': 'Weekly report'},
        ],
        'activity_history': [
            {'timestamp': '2026-04-10T08:00:00'},
        ],
        'interaction_history': [
            {'language': 'id'},
        ]
    }
    
    # Detect patterns
    patterns = engine.detect_patterns(user_data)
    print("🔍 Detected Patterns:")
    for p in patterns:
        print(f"   - {p['type']}: {p.get('insight', 'N/A')}")
    
    # Generate proactive actions
    context = {
        'tasks': [
            {'id': '1', 'name': 'Task 1', 'deadline': '2026-04-12T17:00:00'},
        ],
        'files': [],
        'dependencies': []
    }
    
    actions = engine.generate_proactive_actions(context)
    print(f"\n💡 Proactive Actions ({len(actions)}):")
    print(engine.present_proactive_actions(actions))
EOF

chmod +x scripts/proactive-assistant/test.py

# Create auto-check script
cat > scripts/proactive-assistant/auto-check.py << 'EOF'
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
EOF

chmod +x scripts/proactive-assistant/auto-check.py

# Create config script
cat > scripts/proactive-assistant/configure.py << 'EOF'
#!/usr/bin/env python3
"""Configure proactive assistant"""
import json
import sys
sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

config = {
    'auto_actions': True,
    'threshold': 0.7,
    'max_suggestions': 3,
    'cooldown_seconds': 300,
    'active_hours': {'start': 6, 'end': 23}
}

# Save config
with open('memory/patterns/proactive-config.json', 'w') as f:
    json.dump(config, f, indent=2)

print("✅ Configuration saved to memory/patterns/proactive-config.json")
print(json.dumps(config, indent=2))
EOF

chmod +x scripts/proactive-assistant/configure.py

echo "✅ Proactive Assistant setup complete!"
echo "   - test.py: Test proactive engine"
echo "   - auto-check.py: Auto-check for suggestions"
echo "   - configure.py: Configure behavior"
