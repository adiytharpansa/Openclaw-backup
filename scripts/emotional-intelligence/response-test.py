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
