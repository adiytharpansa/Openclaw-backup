#!/usr/bin/env python3
"""Core learning engine for Self-Evolving AI"""

import json
import os
from datetime import datetime
from typing import Dict, List, Any

class Learner:
    def __init__(self, workspace_path: str = None):
        self.workspace = workspace_path or os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.data_dir = os.path.join(self.workspace, 'data')
        self.learnings = []
        self.load_learnings()
    
    def load_learnings(self):
        """Load existing learnings"""
        learnings_file = os.path.join(self.data_dir, 'learnings/history.json')
        if os.path.exists(learnings_file):
            with open(learnings_file, 'r') as f:
                self.learnings = json.load(f)
    
    def save_learnings(self):
        """Save learnings to file"""
        learnings_file = os.path.join(self.data_dir, 'learnings/history.json')
        os.makedirs(os.path.dirname(learnings_file), exist_ok=True)
        with open(learnings_file, 'w') as f:
            json.dump(self.learnings, f, indent=2)
    
    def learn(self, context: str, insight: str, category: str = "general", importance: str = "medium"):
        """Add new learning"""
        learning = {
            "id": datetime.now().isoformat(),
            "context": context,
            "insight": insight,
            "category": category,
            "importance": importance,
            "timestamp": datetime.now().isoformat()
        }
        self.learnings.append(learning)
        self.save_learnings()
        return learning
    
    def get_learnings(self, category: str = None, importance: str = None):
        """Filter learnings by category or importance"""
        filtered = self.learnings
        if category:
            filtered = [l for l in filtered if l.get('category') == category]
        if importance:
            filtered = [l for l in filtered if l.get('importance') == importance]
        return filtered
    
    def get_recent(self, count: int = 10):
        """Get most recent learnings"""
        return self.learnings[-count:]
    
    def search(self, query: str):
        """Search learnings by keyword"""
        query_lower = query.lower()
        return [l for l in self.learnings 
                if query_lower in l.get('context', '').lower() 
                or query_lower in l.get('insight', '').lower()]
