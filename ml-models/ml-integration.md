# 🤖 ML Model Integration

_Local and cloud ML models for specialized tasks_

---

## 📦 Available Models

### Text Models
| Model | Type | Size | Use Case |
|-------|------|------|----------|
| **Qwen3.5-397B** | LLM | 397B | Main assistant (current) |
| **Llama-3-70B** | LLM | 70B | Alternative reasoning |
| **Mistral-7B** | LLM | 7B | Fast responses |
| **BERT** | Embedding | 110M | Semantic search |

### Vision Models
| Model | Type | Use Case |
|-------|------|----------|
| **CLIP** | Image-Text | Image search, captioning |
| **YOLO** | Detection | Object detection |
| **SVD** | Video | Video generation |

### Audio Models
| Model | Type | Use Case |
|-------|------|----------|
| **Whisper** | STT | Speech-to-text (installed) |
| **ElevenLabs** | TTS | Text-to-speech (installed) |

---

## 🔧 Local Model Setup

### Option 1: Ollama
```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# Pull models
ollama pull llama3:70b
ollama pull mistral:7b
ollama pull nomic-embed-text

# Run model
ollama run llama3:70b "Hello!"

# API endpoint
curl http://localhost:11434/api/generate -d '{
  "model": "llama3:70b",
  "prompt": "Hello!"
}'
```

### Option 2: LM Studio
```bash
# Download LM Studio
# https://lmstudio.ai/

# Download models via UI
# Start local server on port 1234

# Use via API
curl http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-model",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

### Option 3: HuggingFace Transformers
```python
# Install
pip install transformers torch

# Load model
from transformers import pipeline

# Text generation
generator = pipeline("text-generation", model="mistralai/Mistral-7B-Instruct-v0.2")

# Use
result = generator("Hello, I'm a language model")
```

---

## 🎯 Model Use Cases

### 1. Semantic Search Enhancement
```yaml
model: nomic-embed-text
task: Generate embeddings for memory search
benefit: Better relevance ranking
setup:
  - Generate embedding for query
  - Compare with stored embeddings
  - Return top matches
```

### 2. Document Classification
```yaml
model: BERT-base
task: Auto-tag incoming documents
benefit: Automatic organization
setup:
  - Extract text from document
  - Generate classification
  - Apply tags
  - Save to appropriate folder
```

### 3. Sentiment Analysis
```yaml
model: distilbert-base-uncased-finetuned-sst-2-english
task: Analyze email/message sentiment
benefit: Priority routing
setup:
  - Extract message text
  - Run sentiment analysis
  - Route based on sentiment
  - Flag negative for review
```

### 4. Image Captioning
```yaml
model: BLIP-2
task: Generate descriptions for images
benefit: Searchable image content
setup:
  - Extract images from files
  - Generate captions
  - Save to metadata
  - Enable text search
```

### 5. Code Review Assistant
```yaml
model: CodeLlama-34b
task: Automated code review
benefit: Faster feedback loop
setup:
  - Extract code diff
  - Run code review model
  - Generate suggestions
  - Post as PR comment
```

---

## ⚙️ Configuration

### Model Config File
```json
{
  "defaultModel": "qwen-397b",
  "fallbackModel": "mistral-7b",
  "embeddingModel": "nomic-embed-text",
  
  "providers": {
    "ollama": {
      "enabled": false,
      "url": "http://localhost:11434",
      "models": ["llama3:70b", "mistral:7b"]
    },
    "lmstudio": {
      "enabled": false,
      "url": "http://localhost:1234",
      "models": ["local-model"]
    },
    "huggingface": {
      "enabled": true,
      "api_key": "from-1password",
      "models": ["mistralai/Mistral-7B"]
    }
  },

  "cache": {
    "enabled": true,
    "ttl": 86400,
    "maxSize": "1GB"
  },

  "rateLimit": {
    "requestsPerMinute": 60,
    "tokensPerMinute": 100000
  }
}
```

---

## 🚀 Quick Start

### Test Local Model
```bash
# With Ollama
ollama run mistral:7b "What is machine learning?"

# With API
curl http://localhost:11434/api/generate \
  -d '{"model": "mistral:7b", "prompt": "Hello!"}'
```

### Generate Embeddings
```python
from sentence_transformers import SentenceTransformer

model = SentenceTransformer('nomic-ai/nomic-embed-text')
embeddings = model.encode(["Your text here"])
print(embeddings.shape)
```

### Run Inference
```python
from transformers import pipeline

classifier = pipeline("sentiment-analysis")
result = classifier("I love this product!")
print(result)  # [{'label': 'POSITIVE', 'score': 0.9998}]
```

---

## 📊 Performance Comparison

| Model | Speed | Quality | VRAM | Best For |
|-------|-------|---------|------|----------|
| Qwen-397B | Slow | Excellent | 800GB | Complex reasoning |
| Llama3-70B | Medium | Great | 140GB | General tasks |
| Mistral-7B | Fast | Good | 14GB | Quick responses |
| BERT | Very Fast | Good | 1GB | Classification |

---

## 🔐 Security

- Models run locally (no data leaves machine)
- API keys stored in 1Password
- Rate limiting enabled
- Input validation on all models
- Audit logging for model usage

---

## 📈 Monitoring

```bash
# Check model status
./ml-models/status.sh

# View usage stats
./ml-models/stats.sh

# Clear model cache
./ml-models/clear-cache.sh
```

---

## 🎯 Recommendations

### For This Setup
1. **Start with cloud models** (already configured)
2. **Add Ollama** for local fallback
3. **Install embedding model** for better search
4. **Use Mistral-7B** for quick tasks
5. **Keep Qwen-397B** for complex reasoning

### Hardware Requirements
- **7B models:** 16GB RAM, 8GB VRAM
- **70B models:** 128GB RAM, 40GB VRAM
- **397B models:** Cloud only (current setup)

---

_Last updated: 2026-04-10 (Setup Complete)_
