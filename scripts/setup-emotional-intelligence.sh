#!/bin/bash

# Emotional Intelligence Setup Script

echo "🧠 Setting up Emotional Intelligence Skill..."

# Create directories
mkdir -p scripts/emotional-intelligence
mkdir -p memory/relationships

# Create main scripts
cat > scripts/emotional-intelligence/mood-test.py << 'EOF'
#!/usr/bin/env python3
"""Test mood detection"""
import sys
sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from skills.emotional_intelligence.SKILL import MoodDetector

if __name__ == "__main__":
    detector = MoodDetector()
    
    if len(sys.argv) < 2:
        print("Usage: mood-test.py \"message\"")
        sys.exit(1)
    
    message = " ".join(sys.argv[1:])
    mood = detector.analyze(message)
    
    print(f"Message: {message}")
    print(f"\nMood Analysis:")
    print(f"  Primary Emotion: {mood.primary_emotion.value}")
    print(f"  Confidence: {mood.confidence:.1%}")
    print(f"  Intensity: {mood.intensity:.1%}")
    print(f"  Stress Level: {mood.stress_level:.1%}")
    print(f"  Positivity: {mood.positivity_score:+.1f}")
    print(f"  Keywords: {', '.join(mood.detected_keywords) or 'None'}")
EOF

chmod +x scripts/emotional-intelligence/mood-test.py

# Create response test
cat > scripts/emotional-intelligence/response-test.py << 'EOF'
#!/usr/bin/env python3
"""Test response generation"""
import sys
sys.path.insert(0, '/mnt/data/openclaw/workspace/.openclaw/workspace')

from skills.emotional_intelligence.SKILL import MoodDetector, AdaptiveResponder, ResponseConfig

if __name__ == "__main__":
    detector = MoodDetector()
    responder = AdaptiveResponder()
    
    test_messages = [
        "Terima kasih banyak!",
        "Aku frustrasi banget!",
        "Bingung nih, tidak tahu harus mulai dari mana"
    ]
    
    for msg in test_messages:
        mood = detector.analyze(msg)
        config = ResponseConfig(
            style="casual",
            emoji_usage=True,
            formality_level=0.3,
            empathy_level=0.8,
            supportiveness=0.7
        )
        
        response = responder.generate_response(mood, msg, config)
        
        print(f"\n{'='*60}")
        print(f"Message: {msg}")
        print(f"Mood: {mood.primary_emotion.value} ({mood.positivity_score:+.1f})")
        print(f"Response: {response}")
EOF

chmod +x scripts/emotional-intelligence/response-test.py

# Create integration script
cat > scripts/emotional-intelligence/integrate.py << 'EOF'
#!/usr/bin/env python3
"""Integrate emotional intelligence into main AI"""
import json
from datetime import datetime

def log_mood(mood_analysis):
    """Log mood to memory"""
    log_entry = {
        "timestamp": datetime.now().isoformat(),
        "mood": {
            "primary": mood_analysis.primary_emotion.value,
            "confidence": mood_analysis.confidence,
            "stress": mood_analysis.stress_level,
            "positivity": mood_analysis.positivity_score
        },
        "message": mood_analysis.detected_keywords
    }
    
    with open("memory/relationships/mood-log.json", "a") as f:
        f.write(json.dumps(log_entry) + "\n")
    
    return log_entry

if __name__ == "__main__":
    print("Emotional Intelligence integrated!")
    print("Mood tracking started.")
EOF

chmod +x scripts/emotional-intelligence/integrate.py

echo "✅ Emotional Intelligence setup complete!"
echo "   - mood-test.py: Test mood detection"
echo "   - response-test.py: Test response generation"
echo "   - integrate.py: Integration script"
