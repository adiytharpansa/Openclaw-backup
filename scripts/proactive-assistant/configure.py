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
