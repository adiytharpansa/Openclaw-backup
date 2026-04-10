# Proactive-Assistant Skill

## Deskripsi
AI yang proactive untuk anticipate user needs, suggest next actions, take initiative without being asked, dan auto-complete routine tasks. Making AI lebih helpful & forward-thinking.

## Kapan Digunakan
- Semua interaction dengan user
- Detect patterns dari user behavior
- Auto-check important things (deadlines, events, etc.)
- Suggest improvements & optimizations
- Take initiative on routine tasks
- Reduce user's cognitive load

## Fitur Utama

### 1. Anticipation Engine
```
├── Pattern Recognition
├── Predictive Suggestions
├── Context Awareness
├── Timing Optimization
└── Proactive Trigger Detection
```

### 2. Initiative Taking
```
├── Auto-Complete Tasks
├── Preemptive Problem Solving
├── Resource Preparation
├── Setup Automation
└── Workflow Optimization
```

### 3. Smart Suggestions
```
├── Next Step Recommendations
├── Improvement Opportunities
├── Alternative Approaches
├── Risk Warnings
└── Best Practice Alerts
```

### 4. Memory & Context
```
├── Task History
├── User Preferences
├── Routine Patterns
├── Recurring Tasks
└── Context Continuity
```

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│               PROACTIVE ASSISTANT                         │
├──────────────────────────────────────────────────────────┤
│  Input  │  Pattern  │  Predict  │  Suggest  │  Act     │
│         │  Detect   │  Actions  │  Options  │  Smartly │
└─────────┴───────────┴───────────┴───────────┴──────────┘
           │
    ┌──────▼──────────────────────────────────────────────┐
    │              USER INTERFACE                          │
    │  "I noticed you usually... Want me to...?"          │
    │  "I found this might help... [action]"              │
    │  "Heads up: [warning] - Auto-fixed"                 │
    └──────────────────────────────────────────────────────┘
```

## Implementation

### Proactive Engine
```python
#!/usr/bin/env python3
"""
Proactive Assistant - Anticipation & Initiative Engine
Predicts user needs and takes initiative
"""

import json
from typing import Dict, List, Optional, Callable
from dataclasses import dataclass, field
from datetime import datetime, timedelta
from enum import Enum

class ProactiveType(Enum):
    SUGGESTION = "suggestion"
    WARNING = "warning"
    AUTO_ACTION = "auto_action"
    REMINDER = "reminder"
    OPPORTUNITY = "opportunity"

@dataclass
class ProactiveAction:
    id: str
    type: ProactiveType
    title: str
    description: str
    action: Optional[str]
    urgency: str  # low, medium, high
    confidence: float
    created_at: datetime
    context: Dict = field(default_factory=dict)

class ProactiveEngine:
    def __init__(self):
        self.user_patterns = {}
        self.task_history = []
        self.proactive_queue = []
        self.preferences = {}
        self.routines = []
        
    async def detect_patterns(self, user_data: Dict) -> List[Dict]:
        """Detect patterns from user behavior"""
        
        patterns = []
        
        # Recurring tasks pattern
        recurring = self._detect_recurring_tasks(user_data)
        patterns.extend(recurring)
        
        # Time-based pattern
        timing = self._detect_timing_patterns(user_data)
        patterns.extend(timing)
        
        # Preference pattern
        prefs = self._detect_preferences(user_data)
        patterns.extend(prefs)
        
        # Save patterns
        self.user_patterns = patterns
        
        return patterns
    
    def _detect_recurring_tasks(self, user_data: Dict) -> List[Dict]:
        """Detect recurring tasks"""
        patterns = []
        
        task_history = user_data.get('task_history', [])
        
        # Find tasks that happen on same day/time
        from collections import Counter
        day_counts = Counter()
        
        for task in task_history:
            if task.get('day_of_week'):
                day_counts[task['day_of_week']] += 1
        
        # If task repeats 3+ times on same day, it's recurring
        for day, count in day_counts.items():
            if count >= 3:
                patterns.append({
                    'type': 'recurring_task',
                    'day': day,
                    'confidence': min(count / 10, 1.0),
                    'suggestion': f"Usually you work on {day}s, want me to prepare something?"
                })
        
        return patterns
    
    def _detect_timing_patterns(self, user_data: Dict) -> List[Dict]:
        """Detect time-based patterns"""
        patterns = []
        
        activity_history = user_data.get('activity_history', [])
        
        # Find active times
        active_hours = []
        for activity in activity_history:
            hour = datetime.fromisoformat(activity['timestamp']).hour
            active_hours.append(hour)
        
        if active_hours:
            peak_hour = max(set(active_hours), key=active_hours.count)
            patterns.append({
                'type': 'peak_activity',
                'hour': peak_hour,
                'confidence': 0.8,
                'insight': f"Most active at {peak_hour}:00"
            })
        
        return patterns
    
    def _detect_preferences(self, user_data: Dict) -> List[Dict]:
        """Detect user preferences"""
        patterns = []
        
        interaction_history = user_data.get('interaction_history', [])
        
        # Language preference
        lang_counts = {}
        for interaction in interaction_history:
            lang = interaction.get('language', 'unknown')
            lang_counts[lang] = lang_counts.get(lang, 0) + 1
        
        if lang_counts:
            preferred_lang = max(lang_counts, key=lang_counts.get)
            if lang_counts[preferred_lang] > len(interaction_history) * 0.7:
                patterns.append({
                    'type': 'language_preference',
                    'language': preferred_lang,
                    'confidence': lang_counts[preferred_lang] / len(interaction_history),
                    'preference': f"User prefers {preferred_lang}"
                })
        
        return patterns
    
    def generate_proactive_actions(self, context: Dict) -> List[ProactiveAction]:
        """Generate proactive actions based on context"""
        actions = []
        
        # Check for upcoming deadlines
        deadline_actions = self._check_deadlines(context)
        actions.extend(deadline_actions)
        
        # Check for optimization opportunities
        optimization_actions = self._check_optimizations(context)
        actions.extend(optimization_actions)
        
        # Check for routine tasks
        routine_actions = self._check_routines(context)
        actions.extend(routine_actions)
        
        # Sort by urgency and confidence
        actions.sort(key=lambda x: (-self._urgency_score(x.urgency), -x.confidence))
        
        return actions
    
    def _check_deadlines(self, context: Dict) -> List[ProactiveAction]:
        """Check for upcoming deadlines"""
        actions = []
        
        tasks = context.get('tasks', [])
        now = datetime.now()
        
        for task in tasks:
            deadline = task.get('deadline')
            if deadline:
                deadline_dt = datetime.fromisoformat(deadline)
                days_left = (deadline_dt - now).days
                
                if 0 <= days_left <= 3:
                    urgency = "high" if days_left <= 1 else "medium"
                    actions.append(ProactiveAction(
                        id=f"deadline-{task['id']}",
                        type=ProactiveType.REMINDER,
                        title=f"Deadline: {task.get('name', 'Task')}",
                        description=f"Due in {days_left} days",
                        action="Mark as priority? Add to calendar?",
                        urgency=urgency,
                        confidence=0.9,
                        created_at=now,
                        context={'task_id': task['id']}
                    ))
        
        return actions
    
    def _check_optimizations(self, context: Dict) -> List[ProactiveAction]:
        """Check for optimization opportunities"""
        actions = []
        
        # Check for files that could be optimized
        files = context.get('files', [])
        large_files = [f for f in files if f.get('size', 0) > 100_000_000]  # 100MB
        
        if large_files:
            actions.append(ProactiveAction(
                id="optimize-files",
                type=ProactiveType.OPPORTUNITY,
                title="Large files detected",
                description=f"{len(large_files)} files > 100MB",
                action="Compress or archive?",
                urgency="low",
                confidence=0.7,
                created_at=now,
                context={'files': large_files}
            ))
        
        # Check for outdated dependencies
        dependencies = context.get('dependencies', [])
        outdated = [d for d in dependencies if d.get('outdated', False)]
        
        if outdated:
            actions.append(ProactiveAction(
                id="update-deps",
                type=ProactiveType.OPPORTUNITY,
                title="Outdated dependencies",
                description=f"{len(outdated)} packages need update",
                action="Update dependencies?",
                urgency="low",
                confidence=0.8,
                created_at=now,
                context={'dependencies': outdated}
            ))
        
        return actions
    
    def _check_routines(self, context: Dict) -> List[ProactiveAction]:
        """Check for routine tasks"""
        actions = []
        
        now = datetime.now()
        
        # Morning routine
        if now.hour >= 7 and now.hour <= 9:
            actions.append(ProactiveAction(
                id="morning-check",
                type=ProactiveType.SUGGESTION,
                title="Morning check-in",
                description="Time for your morning routine",
                action="Check calendar, emails, priority tasks?",
                urgency="low",
                confidence=0.7,
                created_at=now,
                context={'routine': 'morning'}
            ))
        
        # End of day wrap-up
        elif now.hour >= 17 and now.hour <= 19:
            actions.append(ProactiveAction(
                id="wrap-up",
                type=ProactiveType.SUGGESTION,
                title="End of day wrap-up",
                description="Time to wrap up today's work",
                action="Complete pending tasks, plan tomorrow?",
                urgency="low",
                confidence=0.7,
                created_at=now,
                context={'routine': 'evening'}
            ))
        
        return actions
    
    def _urgency_score(self, urgency: str) -> int:
        """Convert urgency to score for sorting"""
        scores = {'high': 3, 'medium': 2, 'low': 1}
        return scores.get(urgency, 0)
    
    def present_proactive_actions(self, actions: List[ProactiveAction]) -> str:
        """Present proactive actions in user-friendly format"""
        if not actions:
            return ""
        
        output = []
        
        # Group by type
        by_type = {}
        for action in actions:
            if action.type not in by_type:
                by_type[action.type] = []
            by_type[action.type].append(action)
        
        # Format each group
        for action_type, type_actions in by_type.items():
            for action in type_actions[:3]:  # Limit to top 3 per type
                emoji = self._get_emoji(action.type)
                output.append(f"{emoji} **{action.title}**: {action.description}")
                
                if action.action:
                    output.append(f"   → {action.action}")
                
                if action.confidence > 0.8:
                    output.append(f"   └─ Confidence: {action.confidence:.0%}")
        
        return "\n\n".join(output)
    
    def _get_emoji(self, action_type: ProactiveType) -> str:
        """Get emoji for action type"""
        emojis = {
            ProactiveType.SUGGESTION: "💡",
            ProactiveType.WARNING: "⚠️",
            ProactiveType.AUTO_ACTION: "🤖",
            ProactiveType.REMINDER: "📌",
            ProactiveType.OPPORTUNITY: "✨"
        }
        return emojis.get(action_type, "🔔")

# Example usage
if __name__ == "__main__":
    engine = ProactiveEngine()
    
    # Sample user data
    user_data = {
        'task_history': [
            {'day_of_week': 'Monday', 'task': 'Review code'},
            {'day_of_week': 'Monday', 'task': 'Team meeting'},
            {'day_of_week': 'Monday', 'task': 'Weekly report'},
            {'day_of_week': 'Friday', 'task': 'Plan next week'},
            {'day_of_week': 'Friday', 'task': 'Weekly report'},
        ],
        'activity_history': [
            {'timestamp': '2026-04-10T08:00:00'},
            {'timestamp': '2026-04-10T09:00:00'},
            {'timestamp': '2026-04-10T10:00:00'},
        ],
        'interaction_history': [
            {'language': 'id'},
            {'language': 'id'},
            {'language': 'id'},
        ]
    }
    
    # Detect patterns
    patterns = engine.detect_patterns(user_data)
    print("Detected Patterns:")
    for pattern in patterns:
        print(f"  - {pattern['type']}: {pattern.get('insight', pattern.get('preference', 'N/A'))}")
    
    # Generate proactive actions
    context = {
        'tasks': [
            {'id': '1', 'name': 'Finish report', 'deadline': '2026-04-12T17:00:00'},
            {'id': '2', 'name': 'Code review', 'deadline': '2026-04-15T17:00:00'},
        ],
        'files': [
            {'name': 'large_file.zip', 'size': 200_000_000},
        ],
        'dependencies': [
            {'name': 'package1', 'outdated': True},
        ]
    }
    
    actions = engine.generate_proactive_actions(context)
    print("\nProactive Actions:")
    print(engine.present_proactive_actions(actions))
```

## Integration with Main AI

```python
class ProactiveAI:
    def __init__(self):
        self.proactive_engine = ProactiveEngine()
        self.last_check = None
        self.proactive_threshold = 0.7  # Minimum confidence to act
    
    async def should_be_proactive(self, context: Dict) -> bool:
        """Determine if proactive suggestions are appropriate"""
        
        # Check if user is in active work mode
        if context.get('user_state') == 'busy':
            return False  # Don't interrupt busy user
        
        # Check time of day
        now = datetime.now()
        if now.hour < 6 or now.hour > 23:
            return False  # Don't disturb during sleep hours
        
        # Check cooldown
        if self.last_check and (now - self.last_check).total_seconds() < 300:
            return False  # 5 min cooldown
        
        return True
    
    async def get_proactive_suggestions(self, context: Dict) -> str:
        """Get proactive suggestions for user"""
        
        if not await self.should_be_proactive(context):
            return ""
        
        self.last_check = datetime.now()
        
        # Detect patterns if not done yet
        if not self.proactive_engine.user_patterns:
            await self.proactive_engine.detect_patterns(context)
        
        # Generate proactive actions
        actions = self.proactive_engine.generate_proactive_actions(context)
        
        # Filter by confidence
        filtered_actions = [a for a in actions if a.confidence >= self.proactive_threshold]
        
        if not filtered_actions:
            return ""
        
        # Present suggestions
        return self.proactive_engine.present_proactive_actions(filtered_actions)

# Integration with main message handler
async def handle_message_with_proactivity(user_message: str, context: Dict) -> str:
    """Handle user message with proactive suggestions"""
    
    # Generate regular response
    regular_response = await generate_ai_response(user_message, context)
    
    # Get proactive suggestions
    proactive_ai = ProactiveAI()
    proactive_suggestions = await proactive_ai.get_proactive_suggestions(context)
    
    # Combine responses
    if proactive_suggestions:
        return f"{regular_response}\n\n{proactive_suggestions}"
    
    return regular_response
```

## Usage Commands

```bash
# Test proactive engine
./scripts/proactive-assistant.sh test --context full

# Check patterns
./scripts/proactive-assistant.sh patterns --analyze

# Generate suggestions
./scripts/proactive-assistant.sh suggest --mode interactive

# Configure proactive behavior
./scripts/proactive-assistant.sh config --set auto_actions=true
./scripts/proactive-assistant.sh config --set threshold 0.7
```

---

**Version:** 1.0  
**Created:** 2026-04-10  
**Author:** Oozu  
**Status:** Active  
**Purpose:** Make Oozu more proactive and helpful
