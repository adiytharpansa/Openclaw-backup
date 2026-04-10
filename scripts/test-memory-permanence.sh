#!/bin/bash
# Test script untuk memory-permanence

cd /mnt/data/openclaw/workspace/.openclaw/workspace

echo "🧠 Testing Memory Permanence System..."
echo ""

# Test 1: Save preference
echo "Test 1: Save user preference"
./scripts/memory-permanence.sh save "User prefers Bahasa Indonesia" "preferences" "high"
echo ""

# Test 2: Save learning
echo "Test 2: Save technical learning"
./scripts/memory-permanence.sh save "Async/await lebih cepat untuk I/O" "learnings" "normal"
echo ""

# Test 3: Search memory
echo "Test 3: Search memory for 'preferences'"
./scripts/memory-permanence.sh search "preferences" "all"
echo ""

# Test 4: Check memory health
echo "Test 4: Check memory health"
./scripts/memory-permanence.sh health
echo ""

echo "✅ All tests completed!"
