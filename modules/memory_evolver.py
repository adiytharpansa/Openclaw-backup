#!/usr/bin/env python3
"""Memory evolver for Self-Evolving AI"""

import json
import os
from datetime import datetime
from typing import Dict, List

class MemoryEvolver:
    def __init__(self, workspace_path: str = None):
        self.workspace = workspace_path or os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.memory_file = os.path.join(self.workspace, 'MEMORY.md')
    
    def extract_key_insights(self, conversations: List[Dict], learnings: List[Dict]) -> List[str]:
        """Extract key insights from conversations and learnings"""
        insights = []
        
        # Extract from learnings
        for learning in learnings[-20:]:  # Last 20 learnings
            if learning.get('importance') in ['high', 'critical']:
                insights.append(f"- {learning.get('insight')} (Added: {learning.get('timestamp')[:10]})")
        
        # Extract from conversations
        successful = [c for c in conversations if c.get('outcome') == 'success']
        if successful:
            # Common tags
            all_tags = []
            for c in successful[-50:]:
                all_tags.extend(c.get('tags', []))
            
            from collections import Counter
            tag_counts = Counter(all_tags)
            
            if tag_counts:
                top_tags = tag_counts.most_common(5)
                if top_tags:
                    insights.append(f"\n**Most Used Skills:** " + 
                                  ', '.join([f"{tag}" for tag, _ in top_tags[:3]]))
        
        return insights
    
    def update_memory(self):
        """Update MEMORY.md with new learnings"""
        if not os.path.exists(self.memory_file):
            return {"status": "no_memory_file", "message": "MEMORY.md not found"}
        
        # Load existing memory
        with open(self.memory_file, 'r') as f:
            memory_content = f.read()
        
        # Extract key insights
        conv_file = os.path.join(self.workspace, 'data/conversations/log.json')
        learnings_file = os.path.join(self.workspace, 'data/learnings/history.json')
        
        conversations = []
        learnings = []
        
        if os.path.exists(conv_file):
            with open(conv_file, 'r') as f:
                conversations = json.load(f)
        
        if os.path.exists(learnings_file):
            with open(learnings_file, 'r') as f:
                learnings = json.load(f)
        
        insights = self.extract_key_insights(conversations, learnings)
        
        if not insights:
            return {"status": "no_new_insights", "message": "No significant insights to add"}
        
        # Create update section
        update_section = f"""
## Recent Updates

**Date:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')}  
**Updates from Self-Evolving AI:**

""" + '\n'.join(insights) + """

---
_Last updated: """ + datetime.now().strftime('%Y-%m-%d %H:%M') + """_
"""
        
        # Find where to insert (before Last updated)
        lines = memory_content.split('\n')
        insert_index = len(lines)
        
        # Check if already updated today
        today = datetime.now().strftime('%Y-%m-%d')
        if any(today in line for line in lines):
            return {"status": "already_updated", "message": f"Memory already updated today ({today})"}
        
        # Insert update section
        lines.append(update_section.strip())
        
        # Save updated memory
        with open(self.memory_file, 'w') as f:
            f.write('\n'.join(lines))
        
        return {
            "status": "success",
            "insights_added": len(insights),
            "date": today
        }
    
    def consolidate(self):
        """Consolidate short-term to long-term memory"""
        conv_file = os.path.join(self.workspace, 'data/conversations/log.json')
        patterns_file = os.path.join(self.workspace, 'data/patterns/detected.json')
        insights = []
        
        if os.path.exists(conv_file):
            with open(conv_file, 'r') as f:
                conversations = json.load(f)
            
            # Analyze patterns
            from collections import Counter
            all_tags = []
            for c in conversations:
                all_tags.extend(c.get('tags', []))
            
            tag_counts = Counter(all_tags).most_common(10)
            
            for tag, count in tag_counts:
                insights.append(f"Skill '{tag}' used {count} times")
        
        if os.path.exists(patterns_file):
            with open(patterns_file, 'r') as f:
                patterns = json.load(f)
            
            if patterns.get('tag_frequency'):
                top_tags = patterns['tag_frequency'].most_common(3)
                insights.append(f"Top preferences: " + ', '.join([t for t, _ in top_tags]))
        
        return {
            "consolidated_at": datetime.now().isoformat(),
            "insights_count": len(insights),
            "insights": insights
        }
