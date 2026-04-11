#!/bin/bash

# Self-Evolving AI Setup Script

echo "🧬 Setting up Self-Evolving AI..."

# Create directories
mkdir -p scripts/self-evolving
mkdir -p modules
mkdir -p data/conversations
mkdir -p data/patterns
mkdir -p data/feedback
mkdir -p data/metrics
mkdir -p data/logs
mkdir -p tests

# Initialize data files
echo "[]" > data/conversations/log.json
echo "[]" > data/patterns/detected.json
echo "[]" > data/feedback/all.json
echo "[]" > data/metrics/history.json
echo '{"conversations":0,"lessons":0,"corrections":0,"preferences":0,"improvements":0}' > data/metrics/stats.json

# Initialize learnings directory
mkdir -p data/learnings
echo "[]" > data/learnings/history.json

# Make scripts executable
chmod +x scripts/self-evolving-ai.sh
chmod +x scripts/setup-self-evolving.sh

# Make modules executable
chmod +x modules/*.py

echo "✅ Self-Evolving AI setup complete!"
echo ""
echo "🚀 Quick Start:"
echo "  1. Interact naturally with Oozu"
echo "  2. System will auto-learn from conversations"
echo "  3. Check progress: bash scripts/self-evolving-ai.sh progress"
echo "  4. Evolve memory: bash scripts/self-evolving-ai.sh evolve-memory"
echo ""
echo "💡 The more you interact, the smarter Oozu gets!"
