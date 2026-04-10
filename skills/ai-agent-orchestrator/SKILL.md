# AI-Agent-Orchestrator Skill

## Deskripsi
Skill ultimate untuk manage multiple AI agents secara simultaneous dengan intelligent coordination, load balancing, dan automatic task distribution. Memungkinkan parallel processing yang coordinated untuk project kompleks.

## Kapan Digunakan
- Project kompleks yang butuh multi-agent collaboration
- Task distribution otomatis ke specialized agents
- Parallel processing dengan coordination
- Load balancing untuk heavy workloads
- Multi-step workflows yang butuh specialization
- Emergency fallback saat agent gagal

## Fitur Utama

### 1. Multi-Agent Management
```
├── Agent Pool Management
├── Dynamic Agent Spawning
├── Agent Health Monitoring
├── Automatic Failover
├── Resource Allocation
└── Load Balancing
```

### 2. Task Distribution
```
├── Intelligent Task Analysis
├── Skill-Based Routing
├── Priority Queue Management
├── Dependency Resolution
├── Parallel Execution
└── Result Aggregation
```

### 3. Cross-Agent Communication
```
├── Shared Memory Space
├── Message Passing
├── State Synchronization
├── Conflict Resolution
├── Consensus Mechanisms
└── Event Broadcasting
```

### 4. Monitoring & Recovery
```
├── Real-time Health Checks
├── Performance Metrics
├── Error Detection
├── Automatic Retry
├── Fallback Strategies
└── Recovery Protocols
```

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│                 ORCHESTRATOR CORE                        │
├─────────────────────────────────────────────────────────┤
│  Task Analyzer  │  Router  │  Load Balancer  │  Monitor │
└────────┬────────┴────┬─────┴────────┬────────┴────┬─────┘
         │             │              │             │
    ┌────▼────┐   ┌────▼────┐   ┌────▼────┐   ┌────▼────┐
    │ Agent 1 │   │ Agent 2 │   │ Agent 3 │   │ Agent N │
    │ (Coding)│   │(Research)│  │ (Testing)│   │(Special)│
    └────┬────┘   └────┬────┘   └────┬────┘   └────┬────┘
         │             │              │             │
         └─────────────┴──────────────┴─────────────┘
                              │
                    ┌─────────▼──────────┐
                    │  Result Aggregator │
                    │  & Consolidator    │
                    └─────────┬──────────┘
                              │
                    ┌─────────▼──────────┐
                    │   Final Response   │
                    └────────────────────┘
```

## Commands

### Spawn Agents
```bash
# Spawn single agent
./scripts/orchestrator.sh spawn --type coding --task "Build REST API"

# Spawn multiple agents
./scripts/orchestrator.sh spawn --count 3 --types coding,research,testing

# Spawn with resource limits
./scripts/orchestrator.sh spawn --type coding --memory 2GB --cpu 2
```

### Task Distribution
```bash
# Distribute task automatically
./scripts/orchestrator.sh distribute --task "Build full-stack app"

# Manual assignment
./scripts/orchestrator.sh assign --agent coding-agent --task "Write tests"

# Priority queue
./scripts/orchestrator.sh queue --priority high --task "Fix critical bug"
```

### Monitoring
```bash
# Check agent health
./scripts/orchestrator.sh health

# View active agents
./scripts/orchestrator.sh list

# Get metrics
./scripts/orchestrator.sh metrics --agent coding-agent

# View logs
./scripts/orchestrator.sh logs --agent coding-agent --tail 50
```

### Coordination
```bash
# Sync state across agents
./scripts/orchestrator.sh sync --agents all

# Broadcast message
./scripts/orchestrator.sh broadcast "Deploying in 5 minutes"

# Stop all agents
./scripts/orchestrator.sh stop --graceful
```

## Implementation

### Main Orchestrator Script
```python
#!/usr/bin/env python3
"""
AI Agent Orchestrator - Core Engine
Manages multiple AI agents with intelligent coordination
"""

import asyncio
import json
from datetime import datetime
from typing import Dict, List, Optional
from dataclasses import dataclass
from enum import Enum

class AgentStatus(Enum):
    IDLE = "idle"
    BUSY = "busy"
    ERROR = "error"
    OFFLINE = "offline"

@dataclass
class Agent:
    id: str
    type: str
    status: AgentStatus
    current_task: Optional[str]
    memory_usage: float
    cpu_usage: float
    tasks_completed: int
    last_heartbeat: datetime

class Orchestrator:
    def __init__(self):
        self.agents: Dict[str, Agent] = {}
        self.task_queue: List[dict] = []
        self.shared_memory: Dict[str, any] = {}
        self.event_log: List[dict] = []
        
    async def spawn_agent(self, agent_type: str, config: dict) -> str:
        """Spawn new agent with specified type and config"""
        agent_id = f"{agent_type}-{datetime.now().strftime('%Y%m%d%H%M%S')}"
        
        agent = Agent(
            id=agent_id,
            type=agent_type,
            status=AgentStatus.IDLE,
            current_task=None,
            memory_usage=0.0,
            cpu_usage=0.0,
            tasks_completed=0,
            last_heartbeat=datetime.now()
        )
        
        self.agents[agent_id] = agent
        self.log_event("agent_spawned", {"agent_id": agent_id, "type": agent_type})
        
        return agent_id
    
    async def analyze_task(self, task: str) -> dict:
        """Analyze task and determine required agents"""
        # Use NLP to analyze task complexity
        # Return required agent types and estimated time
        return {
            "complexity": "high",
            "required_agents": ["coding", "testing", "research"],
            "estimated_time": 3600,
            "dependencies": []
        }
    
    async def distribute_task(self, task: str, priority: str = "normal"):
        """Distribute task to appropriate agents"""
        analysis = await self.analyze_task(task)
        
        # Find available agents
        available_agents = [
            agent for agent in self.agents.values()
            if agent.status == AgentStatus.IDLE
            and agent.type in analysis["required_agents"]
        ]
        
        # Assign tasks
        for i, agent in enumerate(available_agents):
            await self.assign_task(agent.id, task, priority)
    
    async def assign_task(self, agent_id: str, task: str, priority: str):
        """Assign specific task to agent"""
        if agent_id not in self.agents:
            raise ValueError(f"Agent {agent_id} not found")
        
        agent = self.agents[agent_id]
        agent.status = AgentStatus.BUSY
        agent.current_task = task
        
        self.task_queue.append({
            "agent_id": agent_id,
            "task": task,
            "priority": priority,
            "assigned_at": datetime.now()
        })
        
        self.log_event("task_assigned", {
            "agent_id": agent_id,
            "task": task,
            "priority": priority
        })
    
    async def health_check(self):
        """Check health of all agents"""
        for agent_id, agent in self.agents.items():
            # Check heartbeat
            time_since_heartbeat = datetime.now() - agent.last_heartbeat
            if time_since_heartbeat.total_seconds() > 300:  # 5 minutes
                agent.status = AgentStatus.OFFLINE
                self.log_event("agent_offline", {"agent_id": agent_id})
    
    def log_event(self, event_type: str, data: dict):
        """Log orchestrator event"""
        self.event_log.append({
            "timestamp": datetime.now().isoformat(),
            "event": event_type,
            "data": data
        })
    
    def get_metrics(self) -> dict:
        """Get orchestrator metrics"""
        return {
            "total_agents": len(self.agents),
            "active_agents": sum(1 for a in self.agents.values() if a.status == AgentStatus.BUSY),
            "idle_agents": sum(1 for a in self.agents.values() if a.status == AgentStatus.IDLE),
            "offline_agents": sum(1 for a in self.agents.values() if a.status == AgentStatus.OFFLINE),
            "queued_tasks": len(self.task_queue),
            "total_events": len(self.event_log)
        }

# Main execution
if __name__ == "__main__":
    orchestrator = Orchestrator()
    # Run orchestrator
```

### Agent Communication Protocol
```yaml
protocol:
  version: "1.0"
  message_types:
    - task_assign
    - task_complete
    - task_failed
    - status_update
    - memory_sync
    - help_request
    - broadcast
  
  message_format:
    type: string
    from: string
    to: string | "all"
    timestamp: ISO8601
    payload: object
    priority: low | normal | high | critical
  
  delivery_guarantee: at-least-once
  retry_policy:
    max_retries: 3
    backoff: exponential
    initial_delay: 1s
    max_delay: 30s
```

### Shared Memory Structure
```json
{
  "global": {
    "project_context": {},
    "shared_knowledge": {},
    "common_resources": {}
  },
  "agent_specific": {
    "agent-1": {
      "local_memory": {},
      "task_history": [],
      "learnings": []
    }
  },
  "synchronization": {
    "last_sync": "ISO8601",
    "version": 1,
    "conflicts": []
  }
}
```

## Integration Points

### With Existing Skills
```python
# Example: Use coding + testing agents together
async def build_feature(feature_spec):
    # Spawn coding agent
    coding_agent = await orchestrator.spawn_agent("coding")
    
    # Spawn testing agent
    testing_agent = await orchestrator.spawn_agent("testing")
    
    # Assign tasks
    await orchestrator.assign_task(
        coding_agent.id,
        f"Implement: {feature_spec}"
    )
    
    await orchestrator.assign_task(
        testing_agent.id,
        f"Write tests for: {feature_spec}"
    )
    
    # Wait for completion
    results = await orchestrator.wait_for_completion()
    
    # Aggregate results
    return orchestrator.aggregate_results(results)
```

### With Sub-Agent System
```bash
# Integrate with OpenClaw sub-agents
./scripts/orchestrator.sh integrate --with subagents
```

## Monitoring Dashboard

### Real-time Metrics
```json
{
  "orchestrator": {
    "uptime": "24h 15m",
    "total_tasks": 156,
    "completed_tasks": 142,
    "failed_tasks": 3,
    "avg_task_time": "12m 30s"
  },
  "agents": {
    "total": 8,
    "active": 5,
    "idle": 2,
    "offline": 1
  },
  "resources": {
    "memory_usage": "4.2GB / 8GB",
    "cpu_usage": "65%",
    "network_io": "120MB/s"
  }
}
```

### Alert Rules
```yaml
alerts:
  - name: agent_offline
    condition: agent.status == OFFLINE for 5m
    action: notify + auto_restart
  
  - name: high_memory
    condition: memory_usage > 90%
    action: scale_down + notify
  
  - name: task_queue_backlog
    condition: queue_size > 100
    action: spawn_more_agents
  
  - name: task_failure_rate
    condition: failure_rate > 10% in 1h
    action: pause + investigate
```

## Use Cases

### Use Case 1: Full-Stack Development
```
User: "Build e-commerce website"

Orchestrator:
1. Spawn research agent → Market analysis
2. Spawn design agent → UI/UX design
3. Spawn frontend agent → React implementation
4. Spawn backend agent → API development
5. Spawn database agent → Schema design
6. Spawn testing agent → E2E tests
7. Spawn devops agent → Deployment setup

All agents coordinate via shared memory
Results aggregated into final deliverable
```

### Use Case 2: Emergency Bug Fix
```
User: "Critical bug in production!"

Orchestrator:
1. Priority: CRITICAL
2. Spawn debugging agent → Root cause analysis
3. Spawn coding agent → Fix implementation
4. Spawn testing agent → Regression tests
5. Spawn devops agent → Hotfix deployment

Parallel execution with coordination
Deployed in <30 minutes
```

### Use Case 3: Research Project
```
User: "Research AI trends 2026"

Orchestrator:
1. Spawn research agents (3x) → Different sources
2. Spawn analysis agent → Pattern detection
3. Spawn writing agent → Report generation
4. Spawn review agent → Quality check

Distributed research with consolidated output
```

## Performance Optimization

### Load Balancing Strategies
```python
strategies = {
    "round_robin": "Distribute evenly",
    "least_loaded": "Send to least busy agent",
    "skill_based": "Match task to agent expertise",
    "priority_queue": "High priority first",
    "affinity": "Stick to same agent for related tasks"
}
```

### Resource Management
```python
resource_limits = {
    "max_agents": 20,
    "max_memory_per_agent": "2GB",
    "max_cpu_per_agent": "2 cores",
    "max_concurrent_tasks": 50,
    "graceful_shutdown_timeout": "30s"
}
```

## Error Handling

### Fallback Strategies
```python
fallbacks = {
    "agent_crash": "Restart agent + reassign task",
    "agent_timeout": "Mark offline + spawn replacement",
    "task_failure": "Retry with different agent",
    "memory_overflow": "Scale down + clear cache",
    "network_issue": "Queue tasks + retry later"
}
```

### Recovery Protocol
```yaml
recovery:
  step1: Detect failure
  step2: Save agent state
  step3: Spawn replacement
  step4: Restore state
  step5: Resume task
  step6: Log incident
  step7: Analyze root cause
```

## Security

### Access Control
```yaml
permissions:
  spawn_agents: admin
  kill_agents: admin
  assign_tasks: user
  view_metrics: user
  modify_config: admin
  access_memory: agent_only
```

### Audit Trail
```json
{
  "audit_log": {
    "enabled": true,
    "retention": "90 days",
    "events": [
      "agent_spawned",
      "agent_killed",
      "task_assigned",
      "task_completed",
      "task_failed",
      "config_changed",
      "permission_denied"
    ]
  }
}
```

## Metrics & KPIs

### Performance Metrics
- Task completion rate
- Average task duration
- Agent utilization rate
- Queue wait time
- Error rate
- Recovery time

### Quality Metrics
- Task success rate
- Rework rate
- Customer satisfaction
- Code quality score
- Test coverage

### Cost Metrics
- Compute cost per task
- Agent cost per hour
- Resource efficiency
- Cost per successful task

---

**Version:** 1.0  
**Created:** 2026-04-10  
**Author:** Oozu for Tuan  
**Status:** Active  
**Priority:** ⭐⭐⭐⭐⭐
