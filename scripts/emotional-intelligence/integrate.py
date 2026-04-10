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
