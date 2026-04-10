#!/usr/bin/env python3
"""
Memory Trigger Check
Auto-detect patterns in user input and suggest memory saves
"""

import re
import json
import sys
from datetime import datetime

# Define trigger patterns
TRIGGERS = {
    "preferences": [
        (r"gue prefer\*", "User preference", "preferences"),
        (r"aku suka\*", "User likes", "preferences"),
        (r"aku nggak suka\*", "User dislikes", "preferences"),
        (r"selalu\*", "Always rule", "rules"),
        (r"nggak pernah\*", "Never rule", "rules"),
        (r"harus\*", "Must do rule", "rules"),
        (r"jangan\*", "Don't rule", "rules"),
    ],
    "important": [
        (r"ingat\*", "Remember request", "high_priority"),
        (r"jangan lupa\*", "Don't forget", "high_priority"),
        (r"remember\*", "Remember request", "high_priority"),
        (r"deadline\*", "Deadline mentioned", "projects"),
        (r"due\*", "Due date mentioned", "projects"),
        (r"besok\*", "Tomorrow mentioned", "general"),
        (r"minggu depan\*", "Next week mentioned", "projects"),
    ],
    "learnings": [
        (r"belajar\*", "Learning mentioned", "learnings"),
        (r"tahu sekarang\*", "New knowledge", "learnings"),
        (r"turns out\*", "Discovery", "learnings"),
        (r"learned that\*", "Learned fact", "learnings"),
        (r"discovered\*", "Discovered", "learnings"),
        (r"tahu\*", "Knowledge shared", "learnings"),
    ],
    "technical": [
        (r"tech\*", "Tech mentioned", "technical"),
        (r"tool\*", "Tool mentioned", "skills"),
        (r"skill\*", "Skill mentioned", "skills"),
        (r"library\*", "Library mentioned", "technical"),
        (r"framework\*", "Framework mentioned", "technical"),
        (r"package\*", "Package mentioned", "technical"),
    ],
    "projects": [
        (r"project\*", "Project mentioned", "projects"),
        (r"task\*", "Task mentioned", "projects"),
        (r"work\*", "Work mentioned", "projects"),
        (r"client\*", "Client mentioned", "projects"),
        (r"bug\*", "Bug mentioned", "projects"),
        (r"issue\*", "Issue mentioned", "projects"),
    ],
}

def match_triggers(text):
    """Match text against all trigger patterns"""
    text_lower = text.lower()
    matches = []
    
    for category, patterns in TRIGGERS.items():
        for pattern, description, priority in patterns:
            # Convert regex pattern to work with Python
            regex_pattern = pattern.replace("*", ".*")
            if re.search(regex_pattern, text_lower):
                matches.append({
                    "trigger": description,
                    "category": category,
                    "priority": priority,
                    "timestamp": datetime.now().isoformat(),
                    "original_text": text
                })
    
    return matches

def main():
    if len(sys.argv) < 2:
        print("Usage: memory-trigger-check.py \"user input\"")
        sys.exit(1)
    
    input_text = sys.argv[1]
    matches = match_triggers(input_text)
    
    if matches:
        print(f"✅ {len(matches)} memory trigger(s) detected!\n")
        print("Memory to save:")
        print(f"  Text: \"{input_text}\"")
        print(f"  Timestamp: {datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')}")
        print()
        for i, match in enumerate(matches, 1):
            print(f"  {i}. {match['trigger']}")
            print(f"     Category: {match['category']}")
            print(f"     Priority: {match['priority']}")
            print()
        
        # Save to JSON for downstream processing
        output = {
            "input": input_text,
            "matches": matches,
            "timestamp": datetime.now().isoformat()
        }
        
        with open("memory-trigger-output.json", "w") as f:
            json.dump(output, f, indent=2)
        
        print("✅ Output saved to memory-trigger-output.json")
    else:
        print("❌ No memory triggers detected")

if __name__ == "__main__":
    main()
