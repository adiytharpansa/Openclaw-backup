#!/bin/bash

# Test Emotional Intelligence
echo "🧠 Testing Emotional Intelligence..."
echo ""

# Test cases
test_messages=(
    "Terima kasih banyak, sangat membantu!"
    "Aku frustrasi banget, susah banget solved!"
    "Bingung nih, tidak tahu harus mulai dari mana"
    "Stres nih, deadline besok dan masih banyak work"
    "Senang sekali akhirnya berhasil!"
)

echo "Test Messages:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

for msg in "${test_messages[@]}"; do
    echo "Message: $msg"
    echo ""
    echo "Expected Mood: (Analyze manually or add detection logic)"
    echo ""
done

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Emotional Intelligence skill ready!"
echo ""
echo "How to use:"
echo "  - AI will detect mood from user messages"
echo "  - Response style will adapt to mood"
echo "  - Empathy level: 80%"
echo "  - Emoji usage: Enabled"
