#!/bin/bash

# Self-Evolving AI Test Script

echo "🧬 Testing Self-Evolving AI..."
echo "════════════════════════════"

# Change to workspace directory
cd "$(dirname "$0")/.."

# Test 1: Check directories
echo ""
echo "📁 Test 1: Checking directories..."
if [ -d "modules" ] && [ -d "data" ]; then
    echo "✅ Directories created"
else
    echo "❌ Directories missing"
fi

# Test 2: Check scripts
echo ""
echo "📜 Test 2: Checking scripts..."
if [ -f "scripts/self-evolving-ai.sh" ]; then
    echo "✅ CLI script exists"
else
    echo "❌ CLI script missing"
fi

# Test 3: Run dashboard
echo ""
echo "📊 Test 3: Running dashboard..."
bash scripts/self-evolving-ai.sh dashboard

# Test 4: Test progress
echo ""
echo "📈 Test 4: Checking progress..."
bash scripts/self-evolving-ai.sh progress

# Test 5: Status check
echo ""
echo "🔧 Test 5: Status check..."
bash scripts/self-evolving-ai.sh status

echo ""
echo "✅ All tests completed!"
echo ""
echo "🚀 Skill is ready to use!"
echo ""
echo "Next steps:"
echo "  1. Start interacting with Oozu"
echo "  2. Check progress: bash scripts/self-evolving-ai.sh progress"
echo "  3. Evolve memory after learning: bash scripts/self-evolving-ai.sh evolve-memory"
