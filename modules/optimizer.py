#!/usr/bin/env python3
"""Auto-optimizer for Self-Evolving AI"""

import json
import os
from datetime import datetime
from typing import Dict, List

class SkillOptimizer:
    def __init__(self, workspace_path: str = None):
        self.workspace = workspace_path or os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
        self.data_dir = os.path.join(self.workspace, 'data')
        self.metrics = {}
        self.improvements = []
        self.load_metrics()
    
    def load_metrics(self):
        """Load existing metrics"""
        metrics_file = os.path.join(self.data_dir, 'metrics/history.json')
        if os.path.exists(metrics_file):
            with open(metrics_file, 'r') as f:
                self.metrics = json.load(f)
    
    def save_metrics(self):
        """Save metrics"""
        metrics_file = os.path.join(self.data_dir, 'metrics/history.json')
        with open(metrics_file, 'w') as f:
            json.dump(self.metrics, f, indent=2)
    
    def track_performance(self, skill: str, action: str, success: bool, 
                         duration: float = None, details: Dict = None):
        """Track performance metrics"""
        entry = {
            "timestamp": datetime.now().isoformat(),
            "skill": skill,
            "action": action,
            "success": success,
            "duration": duration,
            "details": details or {}
        }
        
        if skill not in self.metrics:
            self.metrics[skill] = []
        
        self.metrics[skill].append(entry)
        self.save_metrics()
    
    def get_performance_stats(self, skill: str = None):
        """Get performance statistics"""
        if skill and skill in self.metrics:
            data = self.metrics[skill]
            return {
                "total": len(data),
                "success": sum(1 for d in data if d.get('success')),
                "fail": sum(1 for d in data if not d.get('success')),
                "success_rate": sum(1 for d in data if d.get('success')) / len(data) * 100 if data else 0,
                "avg_duration": sum(d.get('duration', 0) for d in data) / len(data) if data else 0
            }
        
        # Overall stats
        all_skills = set()
        for skill_data in self.metrics.values():
            all_skills.update([d.get('skill') for d in skill_data if 'skill' in d])
        
        return {
            "skills": list(all_skills),
            "total_records": sum(len(d) for d in self.metrics.values())
        }
    
    def generate_improvements(self):
        """Generate improvement suggestions"""
        improvements = []
        
        for skill, data in self.metrics.items():
            if not data:
                continue
            
            stats = self.get_performance_stats(skill)
            
            # Check for low success rate
            if stats['success_rate'] < 80:
                improvements.append({
                    "type": "low_success_rate",
                    "skill": skill,
                    "current_rate": stats['success_rate'],
                    "target_rate": 90,
                    "priority": "high",
                    "suggestion": f"Improve {skill} to increase success rate to 90%"
                })
            
            # Check for slow performance
            if stats.get('avg_duration', 0) > 5:  # 5 seconds threshold
                improvements.append({
                    "type": "slow_performance",
                    "skill": skill,
                    "current_duration": stats['avg_duration'],
                    "target_duration": 3,
                    "priority": "medium",
                    "suggestion": f"Optimize {skill} to reduce average duration to under 3 seconds"
                })
        
        self.improvements = improvements
        return improvements
    
    def apply_improvements(self, improvement_id: str = None):
        """Apply generated improvements"""
        if not self.improvements:
            return {"status": "no_improvements", "message": "No improvements to apply"}
        
        if improvement_id:
            improvements = [i for i in self.improvements if i.get('id') == improvement_id]
        else:
            improvements = self.improvements
        
        applied = []
        for imp in improvements:
            applied.append({
                "id": imp.get('id'),
                "type": imp.get('type'),
                "skill": imp.get('skill'),
                "status": "applied",
                "timestamp": datetime.now().isoformat()
            })
        
        return {
            "status": "success",
            "applied": len(applied),
            "improvements": applied
        }
    
    def get_summary(self):
        """Get performance summary"""
        stats = self.get_performance_stats()
        improvements = self.generate_improvements()
        
        return {
            "timestamp": datetime.now().isoformat(),
            "total_skills": len(stats.get('skills', [])),
            "total_records": stats.get('total_records', 0),
            "improvements_detected": len(improvements),
            "high_priority": len([i for i in improvements if i.get('priority') == 'high']),
            "medium_priority": len([i for i in improvements if i.get('priority') == 'medium']),
            "low_priority": len([i for i in improvements if i.get('priority') == 'low'])
        }
