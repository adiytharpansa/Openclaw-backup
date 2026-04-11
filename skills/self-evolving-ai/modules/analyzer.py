#!/usr/bin/env python3
"""Pattern analyzer for Self-Evolving AI"""

import json
import os
from datetime import datetime
from collections import Counter
from typing import Dict, List, Any

class PatternAnalyzer:
    def __init__(self, workspace_path: str = None):
        self.workspace = workspace_path or os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.data_dir = os.path.join(self.workspace, 'data')
        self.conversations = []
        self.patterns = {}
        self.load_conversations()
    
    def load_conversations(self):
        """Load conversation logs"""
        conv_file = os.path.join(self.data_dir, 'conversations/log.json')
        if os.path.exists(conv_file):
            with open(conv_file, 'r') as f:
                self.conversations = json.load(f)
    
    def add_conversation(self, message: str, response: str, outcome: str = "success", 
                        tags: List[str] = None, metadata: Dict = None):
        """Add conversation to log"""
        conv = {
            "id": datetime.now().isoformat(),
            "message": message,
            "response": response,
            "outcome": outcome,
            "tags": tags or [],
            "metadata": metadata or {},
            "timestamp": datetime.now().isoformat()
        }
        self.conversations.append(conv)
        self.save_conversations()
        self.detect_patterns()
    
    def save_conversations(self):
        """Save conversation log"""
        conv_file = os.path.join(self.data_dir, 'conversations/log.json')
        with open(conv_file, 'w') as f:
            json.dump(self.conversations, f, indent=2)
    
    def detect_patterns(self):
        """Analyze conversations for patterns"""
        all_tags = []
        for conv in self.conversations:
            all_tags.extend(conv.get('tags', []))
        
        tag_counts = Counter(all_tags)
        outcomes = Counter([c.get('outcome', 'unknown') for c in self.conversations])
        
        hourly = Counter()
        for conv in self.conversations:
            try:
                hour = datetime.fromisoformat(conv['timestamp']).hour
                hourly[hour] += 1
            except:
                pass
        
        self.patterns = {
            "tag_frequency": dict(tag_counts.most_common(20)),
            "outcomes": dict(outcomes),
            "hourly_activity": dict(hourly),
            "last_updated": datetime.now().isoformat()
        }
        
        self.save_patterns()
    
    def save_patterns(self):
        """Save detected patterns"""
        pattern_file = os.path.join(self.data_dir, 'patterns/detected.json')
        with open(pattern_file, 'w') as f:
            json.dump(self.patterns, f, indent=2)
    
    def get_patterns(self):
        """Get detected patterns"""
        pattern_file = os.path.join(self.data_dir, 'patterns/detected.json')
        if os.path.exists(pattern_file):
            with open(pattern_file, 'r') as f:
                return json.load(f)
        return {}
    
    def get_insights(self) -> List[Dict]:
        """Generate insights from patterns"""
        patterns = self.get_patterns()
        insights = []
        
        if patterns.get('tag_frequency'):
            top_tags = patterns['tag_frequency'].most_common(3)
            for tag, count in top_tags:
                insights.append({
                    "type": "top_tag",
                    "tag": tag,
                    "count": count,
                    "timestamp": datetime.now().isoformat()
                })
        
        if patterns.get('hourly_activity'):
            peak_hour = max(patterns['hourly_activity'].items(), key=lambda x: x[1])[0]
            insights.append({
                "type": "peak_activity",
                "hour": peak_hour,
                "timestamp": datetime.now().isoformat()
            })
        
        return insights
