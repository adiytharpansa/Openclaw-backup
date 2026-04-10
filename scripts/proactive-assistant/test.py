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
