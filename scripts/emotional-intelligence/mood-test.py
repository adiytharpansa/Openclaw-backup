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
