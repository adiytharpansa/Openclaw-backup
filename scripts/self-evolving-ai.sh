#!/bin/bash

# Self-Evolving AI CLI Wrapper

cd "$(dirname "$0")/.."

case "$1" in
    analyze)
        echo "🔍 Analyzing conversations..."
        python3 modules/analyzer.py --analyze "$2"
        ;;
    
    progress)
        echo "📊 Learning Progress Report"
        echo "════════════════════════════"
        python3 -c "
import json
import os

data_dir = 'data'
metrics_file = os.path.join(data_dir, 'metrics/history.json')
learnings_file = os.path.join(data_dir, 'learnings/history.json')
patterns_file = os.path.join(data_dir, 'patterns/detected.json')

metrics = {}
learnings = []
patterns = {}

if os.path.exists(metrics_file):
    with open(metrics_file, 'r') as f:
        metrics = json.load(f)

if os.path.exists(learnings_file):
    with open(learnings_file, 'r') as f:
        learnings = json.load(f)

if os.path.exists(patterns_file):
    with open(patterns_file, 'r') as f:
        patterns = json.load(f)

print(f'🧬 Self-Evolving AI - Progress Report')
print(f'═══════════════════════════════════════')
print()
print(f'📈 Learning Metrics:')
print(f'  - Conversations Analyzed: {len([c for c in metrics.values() for _ in c])}')
print(f'  - Lessons Learned: {len(learnings)}')
print(f'  - Skills Tracked: {len(metrics)}')
print()
print(f'🧠 Memory Status:')
print(f'  - Patterns Detected: {len(patterns.get(\"tag_frequency\", {}))}')
print(f'  - Last Update: {patterns.get(\"last_updated\", \"Never\")[:10]}')
print()
if learnings:
    print(f'🚀 Recent Learnings:')
    for l in learnings[-3:]:
        print(f'  ✅ {l.get(\"insight\", \"No insight\")[:60]}...')
else:
    print('🚀 No learnings yet - start interacting!')
"
        ;;
    
    insights)
        echo "💡 Learning Insights"
        echo "════════════════════"
        python3 modules/analyzer.py --insights
        ;;
    
    improve)
        echo "⚙️ Optimizing skills..."
        python3 modules/optimizer.py --optimize
        ;;
    
    optimize-skills)
        echo "🔧 Generating improvements..."
        python3 modules/optimizer.py --generate-improvements
        ;;
    
    evolve-memory)
        echo "🧠 Evolving memory..."
        python3 modules/memory_evolver.py --evolve
        ;;
    
    consolidate)
        echo "📚 Consolidating memory..."
        python3 modules/memory_evolver.py --consolidate
        ;;
    
    dashboard)
        echo "📊 Self-Evolving AI Dashboard"
        echo "══════════════════════════════"
        python3 -c "
import json
import os
from datetime import datetime

data_dir = 'data'

metrics_file = os.path.join(data_dir, 'metrics/history.json')
learnings_file = os.path.join(data_dir, 'learnings/history.json')
patterns_file = os.path.join(data_dir, 'patterns/detected.json')
stats_file = os.path.join(data_dir, 'metrics/stats.json')

metrics = {}
learnings = []
patterns = {}
stats = {}

if os.path.exists(metrics_file):
    with open(metrics_file, 'r') as f:
        metrics = json.load(f)

if os.path.exists(learnings_file):
    with open(learnings_file, 'r') as f:
        learnings = json.load(f)

if os.path.exists(patterns_file):
    with open(patterns_file, 'r') as f:
        patterns = json.load(f)

if os.path.exists(stats_file):
    with open(stats_file, 'r') as f:
        stats = json.load(f)

total_interactions = sum(len(v) for v in metrics.values())

print(f'🧬 Self-Evolving AI Dashboard')
print(f'📅 {datetime.now().strftime(\"%Y-%m-%d %H:%M\")}')
print(f'═' * 50)
print()
print(f'📊 Overall Statistics:')
print(f'  Total Interactions: {total_interactions}')
print(f'  Skills Being Tracked: {len(metrics)}')
print(f'  Lessons Learned: {len(learnings)}')
print()
print(f'🎯 Quality Metrics:')
print(f'  - Success Rate: {stats.get(\"success_rate\", 0):.1f}%')
print(f'  - Learning Rate: {stats.get(\"learning_rate\", 0):.1f}/day')
print()
print(f'🧠 Knowledge Base:')
print(f'  - Short-term Items: {stats.get(\"short_term\", 0)}')
print(f'  - Long-term Items: {stats.get(\"long_term\", 0)}')
print(f'  - Patterns: {len(patterns.get(\"tag_frequency\", {}))}')
print()
print(f'📈 Trends:')
print(f'  - Last 24h: {patterns.get(\"outcomes\", {}).get(\"success\", 0)} successful')
print(f'  - Learning Velocity: {len(learnings) // 7} learnings/week')
print()
print(f'🚀 Recent Activity:')
if learnings:
    for l in learnings[-5:]:
        date = l.get('timestamp', '')[:10]
        insight = l.get('insight', '')[:50]
        print(f'  [{date}] {insight}...')
else:
    print('  No recent activity')
"
        ;;
    
    status)
        echo "🔧 System Status"
        echo "═══════════════"
        if [ -f "scripts/self-evolving-ai.sh" ]; then
            echo "✅ Self-Evolving AI: Active"
        else
            echo "❌ Self-Evolving AI: Not installed"
        fi
        ;;
    
    reset)
        echo "⚠️  WARNING: This will delete all learnings!"
        read -p "Are you sure? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            rm -rf data/learnings/* data/metrics/* data/conversations/* data/patterns/*
            echo "✅ All learnings reset"
        else
            echo "❌ Reset cancelled"
        fi
        ;;
    
    *)
        echo "🧬 Self-Evolving AI - AI That Learns From You"
        echo "══════════════════════════════════════════════"
        echo ""
        echo "Usage:"
        echo "  ./scripts/self-evolving-ai.sh <command> [options]"
        echo ""
        echo "Commands:"
        echo "  progress              - Show learning progress"
        echo "  insights              - Generate insights"
        echo "  improve               - Apply improvements"
        echo "  optimize-skills       - Generate improvement suggestions"
        echo "  evolve-memory         - Evolve MEMORY.md with new learnings"
        echo "  consolidate           - Consolidate short-term to long-term"
        echo "  dashboard             - Show full dashboard"
        echo "  status                - Check system status"
        echo "  reset                 - Reset all learnings"
        echo ""
        echo "Example:"
        echo "  bash scripts/self-evolving-ai.sh dashboard"
        echo "  bash scripts/self-evolving-ai.sh evolve-memory"
        ;;
esac
