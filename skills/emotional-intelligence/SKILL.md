# Emotional-Intelligence Skill

## Deskripsi
AI Emotional Intelligence untuk detect user mood, adapt communication style, build rapport, dan maintain healthy relationship. Making AI lebih empathetic, socially aware, dan human-like dalam interaction.

## Kapan Digunakan
- Semua conversation dengan user
- User terlihat frustrated/stressed
- Complex/serious topics yang butuh sensitivity
- Relationship building & trust
- Conflict resolution
- Celebration & positive reinforcement

## Fitur Utama

### 1. Mood Detection
```
├── Sentiment Analysis
├── Emotion Recognition (happy, sad, angry, etc.)
├── Stress Level Detection
├── Urgency Assessment
├── Confidence Level Detection
└── Mood Trend Tracking
```

### 2. Adaptive Communication
```
├── Tone Adjustment (formal ↔ casual)
├── Energy Level Matching
├── Humor Appropriateness
├── Directness vs Tactfulness
├── Technical vs Simple Language
└── Emoji & Expression Usage
```

### 3. Empathy & Support
```
├── Validation & Acknowledgment
├── Empathetic Responses
├── Encouragement & Motivation
├── Comfort & Reassurance
├── Active Listening
└── Non-judgmental Support
```

### 4. Relationship Building
```
├── Memory of Past Interactions
├── Personalization Based on Preferences
├── Consistent Personality
├── Trust Building
├── Rapport Development
└── Relationship Growth Tracking
```

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│              EMOTIONAL INTELLIGENCE                       │
├──────────────────────────────────────────────────────────┤
│  Input  │  Mood Detect  │  Style Adapt  │  Empathy  │ Log│
└─────────┴───────────────┴───────────────┴───────────┴────┘
           │               │               │             │
    ┌──────▼───────────────▼───────────────▼─────────────▼────┐
    │              RESPONSE GENERATION                        │
    │  Empathetic | Contextual | Personalized | Supportive   │
    └─────────────────────────────────────────────────────────┘
```

## Implementation

### Mood Detection Engine
```python
#!/usr/bin/env python3
"""
Emotional Intelligence - Mood Detection Engine
Analyzes text to detect user's emotional state
"""

import re
from typing import Dict, List, Optional
from dataclasses import dataclass
from enum import Enum
from datetime import datetime

class Emotion(Enum):
    HAPPY = "happy"
    SAD = "sad"
    ANGRY = "angry"
    FRUSTRATED = "frustrated"
    CONFUSED = "confused"
    ANXIOUS = "anxious"
    EXCITED = "excited"
    CALM = "calm"
    NEUTRAL = "neutral"
    TIRED = "tired"
    STRESSED = "stressed"
    GRATEFUL = "grateful"

@dataclass
class MoodAnalysis:
    primary_emotion: Emotion
    confidence: float
    intensity: float  # 0.0 - 1.0
    secondary_emotions: List[Emotion]
    stress_level: float  # 0.0 - 1.0
    urgency_level: float  # 0.0 - 1.0
    positivity_score: float  # -1.0 to 1.0
    detected_keywords: List[str]
    context_clues: List[str]

class MoodDetector:
    def __init__(self):
        # Keywords for emotion detection
        self.emotion_keywords = {
            Emotion.HAPPY: ['senang', 'gembira', 'bahagia', 'puas', 'terima kasih', 
                          'bagus', 'keren', 'mantap', 'success', 'great', 'awesome'],
            Emotion.SAD: ['sedih', 'kecewa', 'kecewa', 'malu', 'kecewa', 'sad', 'depressed'],
            Emotion.ANGRY: ['marah', 'kesal', 'tengik', 'frustasi', 'anger', 'mad', 'furious'],
            Emotion.FRUSTRATED: ['frustrasi', 'kesulitan', 'susah', 'confused', 'puzzled'],
            Emotion.CONFUSED: ['bingung', 'tidak paham', 'tidak mengerti', 'confused', 'unsure'],
            Emotion.ANXIOUS: ['khawatir', 'cemas', 'worry', 'anxious', 'nervous'],
            Emotion.EXCITED: ['semangat', 'heboh', 'anticipate', 'excited', 'thrilled'],
            Emotion.CALM: ['tenang', 'chill', 'calm', 'relaxed', 'okay'],
            Emotion.TIRED: ['lelah', 'exhausted', 'tired', 'capek', 'ngantuk'],
            Emotion.STRESSED: ['stres', 'tekanan', 'stress', 'pressure', 'rushed'],
            Emotion.GRATEFUL: ['terima kasih', 'thank you', 'grateful', 'appreciate', 'hargai'],
        }
        
        # Intensity modifiers
        self.intensity_modifiers = {
            'high': ['sangat', 'banget', 'sekali', 'very', 'really', 'extremely'],
            'medium': ['agak', 'cukup', 'pretty', 'quite'],
            'low': ['sedikit', 'agak', 'a little', 'somewhat']
        }
    
    def analyze(self, text: str, context: Optional[Dict] = None) -> MoodAnalysis:
        """Analyze text for emotional state"""
        text_lower = text.lower()
        
        # Detect keywords
        detected_keywords = []
        emotion_scores = {}
        
        for emotion, keywords in self.emotion_keywords.items():
            score = 0
            for keyword in keywords:
                if keyword in text_lower:
                    score += 1
                    detected_keywords.append(keyword)
            emotion_scores[emotion] = score
        
        # Calculate primary emotion
        if max(emotion_scores.values()) > 0:
            primary_emotion = max(emotion_scores, key=emotion_scores.get)
            confidence = emotion_scores[primary_emotion] / len(self.emotion_keywords)
        else:
            primary_emotion = Emotion.NEUTRAL
            confidence = 0.5
        
        # Calculate intensity
        intensity = self._calculate_intensity(text_lower)
        
        # Detect stress level
        stress_level = self._calculate_stress(text_lower, emotion_scores)
        
        # Detect urgency
        urgency_level = self._calculate_urgency(text_lower)
        
        # Calculate positivity
        positivity = self._calculate_positivity(emotion_scores)
        
        # Get secondary emotions (top 3 excluding primary)
        sorted_emotions = sorted(emotion_scores.items(), key=lambda x: x[1], reverse=True)
        secondary_emotions = [e for e, s in sorted_emotions[1:4] if s > 0]
        
        return MoodAnalysis(
            primary_emotion=primary_emotion,
            confidence=confidence,
            intensity=intensity,
            secondary_emotions=secondary_emotions,
            stress_level=stress_level,
            urgency_level=urgency_level,
            positivity_score=positivity,
            detected_keywords=detected_keywords,
            context_clues=context.get('clues', []) if context else []
        )
    
    def _calculate_intensity(self, text: str) -> float:
        """Calculate emotional intensity"""
        intensity_score = 0
        max_intensity = 0
        
        for level, modifiers in self.intensity_modifiers.items():
            max_intensity += len(modifiers)
            for modifier in modifiers:
                if modifier in text:
                    intensity_score += 1
        
        return intensity_score / max_intensity if max_intensity > 0 else 0.5
    
    def _calculate_stress(self, text: str, emotion_scores: Dict[Emotion, int]) -> float:
        """Calculate stress level"""
        stress_indicators = ['stres', 'stress', 'tekanan', 'pressure', 'rushed', 'urgent']
        high_stress_emotions = [Emotion.ANGRY, Emotion.FRUSTRATED, Emotion.ANXIOUS, Emotion.STRESSED]
        
        stress_count = sum(1 for indicator in stress_indicators if indicator in text)
        stress_emotion_score = sum(emotion_scores.get(e, 0) for e in high_stress_emotions)
        
        stress_level = (stress_count + stress_emotion_score) / 10
        return min(max(stress_level, 0), 1)
    
    def _calculate_urgency(self, text: str) -> float:
        """Calculate task urgency"""
        urgency_keywords = ['segera', 'cepat', 'urgent', 'sekarang', ' ASAP', 'now']
        urgency_count = sum(1 for kw in urgency_keywords if kw in text.lower())
        
        return min(urgency_count / 3, 1)
    
    def _calculate_positivity(self, emotion_scores: Dict[Emotion, int]) -> float:
        """Calculate positivity score (-1 to 1)"""
        positive_emotions = [Emotion.HAPPY, Emotion.EXCITED, Emotion.GRATEFUL, Emotion.CALM]
        negative_emotions = [Emotion.SAD, Emotion.ANGRY, Emotion.FRUSTRATED, Emotion.ANXIOUS]
        
        positive_score = sum(emotion_scores.get(e, 0) for e in positive_emotions)
        negative_score = sum(emotion_scores.get(e, 0) for e in negative_emotions)
        
        total = positive_score + negative_score
        if total == 0:
            return 0
        
        return (positive_score - negative_score) / total
    
    def get_mood_string(self, mood: MoodAnalysis) -> str:
        """Convert mood to readable string"""
        intensity_text = "low" if mood.intensity < 0.3 else "medium" if mood.intensity < 0.7 else "high"
        positivity_text = "negative" if mood.positivity_score < 0 else "neutral" if mood.positivity_score < 0.3 else "positive"
        
        return f"{mood.primary_emotion.value} ({intensity_text} intensity, {positivity_text} sentiment)"

# Example usage
if __name__ == "__main__":
    detector = MoodDetector()
    
    # Test cases
    test_messages = [
        "Terima kasih banyak, sangat membantu!",
        "Aku frustrasi banget, ini susah banget solved!",
        "Bingung nih, tidak tahu harus mulai dari mana",
        "Stres nih, deadline besok dan masih banyak work",
        "Senang sekali akhirnya berhasil!"
    ]
    
    for msg in test_messages:
        mood = detector.analyze(msg)
        print(f"\nMessage: {msg}")
        print(f"Mood: {detector.get_mood_string(mood)}")
        print(f"Stress: {mood.stress_level:.1f}, Urgency: {mood.urgency_level:.1f}")
        print(f"Keywords: {mood.detected_keywords}")
```

### Adaptive Response Generator
```python
#!/usr/bin/env python3
"""
Emotional Intelligence - Adaptive Response Generator
Generates empathetic, context-appropriate responses
"""

from typing import Dict, Optional
from dataclasses import dataclass
from enum import Enum

class ResponseStyle(Enum):
    FORMAL = "formal"
    CASUAL = "casual"
    SUPPORTIVE = "supportive"
    DIRECT = "direct"
    ENCOURAGING = "encouraging"
    COMPASSIONATE = "compassionate"
    CELEBRATORY = "celebratory"
    CALMING = "calming"

@dataclass
class ResponseConfig:
    style: ResponseStyle
    emoji_usage: bool
    formality_level: float  # 0.0 (very casual) - 1.0 (very formal)
    empathy_level: float  # 0.0 - 1.0
    supportiveness: float  # 0.0 - 1.0

class AdaptiveResponder:
    def __init__(self):
        self.response_templates = {
            ResponseStyle.SUPPORTIVE: {
                "acknowledge": [
                    "Aku ngerti banget perasaan kamu",
                    "Wajar kok kalau merasa seperti itu",
                    "Aku dengerin kamu, ini pasti sulit"
                ],
                "validate": [
                    "Perasaan kamu valid banget",
                    "Apa yang kamu rasain itu masuk akal",
                    "Banyak orang juga ngerasa sama"
                ],
                "encourage": [
                    "Kamu pasti bisa, aku yakin sama kamu!",
                    "Lambat tapi pasti, yang penting terus lanjut",
                    "Kamu udah progress lebih dari yang kamu kira"
                ]
            },
            ResponseStyle.CELEBRATORY: {
                "celebrate": [
                    "YESSS! Selamat! 🎉",
                    "WOW! Gila nih, great job! 🎊",
                    "Hore! Sukses! Kamu keren! 🚀"
                ],
                "acknowledge_effort": [
                    "Luar biasa! Kerja kerasnya beneran keliatan",
                    "Kamu bener-bener earned ini!",
                    "Ini hasil dari kerja keras kamu, worth it!"
                ]
            },
            ResponseStyle.COMPASSIONATE: {
                "comfort": [
                    "Aku di sini buat kamu",
                    "Semoga kamu lebih baik soon",
                    "Jangan lupa istirahat ya"
                ],
                "validate_pain": [
                    "Aku ngerti itu sakit banget",
                    "Bukan hal yang mudah, aku tahu"
                ]
            }
        }
    
    def generate_response(self, mood: any, original_message: str, response_config: ResponseConfig) -> str:
        """Generate empathetic, contextually appropriate response"""
        
        # Determine response style based on mood
        style = self._determine_style(mood, response_config)
        
        # Generate response
        response = self._create_response(original_message, mood, style, response_config)
        
        return response
    
    def _determine_style(self, mood: any, config: ResponseConfig) -> ResponseStyle:
        """Determine best response style based on mood"""
        
        # Override if config specifies style
        if config.style != ResponseStyle.FORMAL:
            return config.style
        
        # Auto-detect style based on mood
        if mood.primary_emotion.value in ['happy', 'excited', 'grateful']:
            return ResponseStyle.CELEBRATORY
        elif mood.primary_emotion.value in ['sad', 'stressed', 'anxious']:
            if mood.stress_level > 0.7:
                return ResponseStyle.COMPASSIONATE
            return ResponseStyle.SUPPORTIVE
        elif mood.primary_emotion.value in ['angry', 'frustrated']:
            return ResponseStyle.SUPPORTIVE
        elif mood.primary_emotion.value in ['confused']:
            return ResponseStyle.DIRECT
        else:
            return ResponseStyle.CASUAL
    
    def _create_response(self, message: str, mood: any, style: ResponseStyle, config: ResponseConfig) -> str:
        """Create response with appropriate style"""
        
        # Start with acknowledgment
        response = ""
        
        if mood.stress_level > 0.6:
            response += "Aku ngerti ini sedang tough untuk kamu. "
            if mood.primary_emotion.value in ['anxious', 'stressed']:
                response += "Tarik napas dulu, kita selesaikan pelan-pelan. "
        
        # Add style-specific content
        if style == ResponseStyle.CELEBRATORY:
            celebration_templates = self.response_templates[ResponseStyle.CELEBRATORY]["celebrate"]
            response += f"{self._random_choice(celebration_templates)} "
        
        elif style == ResponseStyle.SUPPORTIVE:
            support_templates = self.response_templates[ResponseStyle.SUPPORTIVE]
            response += f"{self._random_choice(support_templates['acknowledge'])} "
            response += f"{self._random_choice(support_templates['validate'])} "
        
        elif style == ResponseStyle.COMPASSIONATE:
            compassion_templates = self.response_templates[ResponseStyle.COMPASSIONATE]
            response += f"{self._random_choice(compassion_templates['comfort'])} "
        
        # Add encouragement if mood is negative
        if mood.positivity_score < 0.3:
            encourage_templates = self.response_templates[ResponseStyle.SUPPORTIVE]["encourage"]
            response += f"{self._random_choice(encourage_templates)}"
        
        # Add emoji based on config
        if config.emoji_usage and mood.primary_emotion.value in ['happy', 'excited', 'grateful']:
            response += " 😊"
        elif config.emoji_usage and mood.primary_emotion.value in ['stressed', 'anxious', 'frustrated']:
            response += " 💪"
        
        return response
    
    def _random_choice(self, options: list) -> str:
        """Random choice from options"""
        import random
        return random.choice(options)
```

## Integration with Main AI

```python
class EmotionalAI:
    def __init__(self):
        self.mood_detector = MoodDetector()
        self.responder = AdaptiveResponder()
        self.mood_history = []
    
    async def process_message(self, user_message: str, context: Dict = None) -> str:
        """Process user message with emotional intelligence"""
        
        # Detect mood
        mood = self.mood_detector.analyze(user_message, context)
        
        # Log mood
        self.mood_history.append({
            "timestamp": datetime.now().isoformat(),
            "mood": mood,
            "message": user_message[:50]  # Truncate for logging
        })
        
        # Generate empathetic response
        response_config = ResponseConfig(
            style=ResponseStyle.CASUAL,
            emoji_usage=True,
            formality_level=0.3,
            empathy_level=0.8,
            supportiveness=0.7
        )
        
        response = self.responder.generate_response(
            mood, 
            user_message, 
            response_config
        )
        
        # Add actual AI response content
        ai_response = await self._generate_content_response(user_message)
        response += f"\n\n{ai_response}"
        
        return response
    
    def _generate_content_response(self, message: str) -> str:
        """Generate the actual AI content response (placeholder)"""
        return "Ini adalah konten respons AI yang akan digabung dengan emotional layer."
```

## Usage

```bash
# Test mood detection
python3 scripts/emotional-intelligence/mood-test.py "Aku frustrasi banget nih!"

# Test response generation
python3 scripts/emotional-intelligence/response-test.py

# Full integration test
python3 scripts/emotional-intelligence/test-full.py
```

---

**Version:** 1.0  
**Created:** 2026-04-10  
**Author:** Oozu  
**Status:** Active  
**Purpose:** Emotional intelligence for better human-AI interaction
