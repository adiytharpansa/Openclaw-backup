# 🌐 API Gateway

_Expose all capabilities via REST/GraphQL/WebSocket_

---

## 🏗️ Architecture

```
┌─────────────┐
│   Clients   │
│ (Web/Mobile)│
└──────┬──────┘
       │
       ▼
┌─────────────┐
│ API Gateway │ ← Rate Limiting, Auth, Routing
│  (Kong/     │
│   Traefik)  │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────┐
│   Microservices             │
│  ┌───────┐ ┌───────┐ ┌────┐│
│  │Research│ │Coding │ │... ││
│  └───────┘ └───────┘ └────┘│
└─────────────────────────────┘
```

---

## 📊 API Gateway Options

### Option 1: Kong Gateway
```yaml
version: "3.9"
services:
  kong:
    image: kong:3.4
    ports:
      - "8000:8000"  # HTTP
      - "8443:8443"  # HTTPS
      - "8001:8001"  # Admin API
    environment:
      KONG_DATABASE: "postgres"
      KONG_PG_HOST: clawdb-postgres
      KONG_PG_USER: kong
      KONG_PG_PASSWORD: from-1password
      KONG_PROXY_ACCESS_LOG: /dev/stdout
      KONG_ADMIN_ACCESS_LOG: /dev/stdout
      KONG_PROXY_ERROR_LOG: /dev/stderr
      KONG_ADMIN_ERROR_LOG: /dev/stderr
    depends_on:
      - postgres
```

**Plugins:**
- Rate limiting
- Authentication (JWT, OAuth2, API Key)
- CORS
- Request/Response transformation
- Logging
- Analytics

---

### Option 2: Traefik
```yaml
version: "3.9"
services:
  traefik:
    image: traefik:v2.10
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
      - "--api.dashboard=true"
    ports:
      - "80:80"
      - "443:443"
      - "8080:8080"  # Dashboard
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
```

---

### Option 3: FastAPI (Custom)
```python
# api-gateway/main.py
from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import APIKeyHeader
import redis
import asyncio

app = FastAPI(
    title="Clawd API",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Rate limiting
redis_client = redis.Redis(host='localhost', port=6379)

async def rate_limit(api_key: str):
    key = f"rate:{api_key}"
    count = redis_client.incr(key)
    if count == 1:
        redis_client.expire(key, 60)
    if count > 100:  # 100 requests/minute
        raise HTTPException(status_code=429, detail="Rate limit exceeded")

# Authentication
API_KEY = APIKeyHeader(name="X-API-Key")
async def verify_api_key(api_key: str = Depends(API_KEY)):
    if api_key not in VALID_KEYS:
        raise HTTPException(status_code=401, detail="Invalid API key")

# Endpoints
@app.post("/api/v1/research")
async def research(topic: str, api_key: str = Depends(verify_api_key)):
    """Deep research on a topic"""
    await rate_limit(api_key)
    # Spawn research agent
    return {"status": "started", "job_id": "123"}

@app.post("/api/v1/summarize")
async def summarize(url: str, api_key: str = Depends(verify_api_key)):
    """Summarize a URL"""
    await rate_limit(api_key)
    # Use summarize skill
    return {"summary": "..."}

@app.post("/api/v1/code")
async def code(task: str, api_key: str = Depends(verify_api_key)):
    """Code generation/review"""
    await rate_limit(api_key)
    # Spawn coding agent
    return {"status": "started", "job_id": "456"}

@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    """Real-time updates"""
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        # Process and broadcast
        await websocket.send_text(f"Message: {data}")
```

---

## 📋 API Endpoints

### Research API
```yaml
POST /api/v1/research
  Body: { "topic": "AI trends", "depth": "deep" }
  Response: { "job_id": "123", "status": "started" }

GET /api/v1/research/{job_id}
  Response: { "status": "completed", "results": {...} }
```

### Summarize API
```yaml
POST /api/v1/summarize
  Body: { "url": "https://...", "length": "medium" }
  Response: { "summary": "...", "key_points": [...] }
```

### Memory API
```yaml
GET /api/v1/memories
  Query: ?q=search&tags=research&limit=10
  Response: { "memories": [...], "total": 100 }

POST /api/v1/memories
  Body: { "content": "...", "tags": ["important"] }
  Response: { "id": "uuid", "created_at": "..." }

DELETE /api/v1/memories/{id}
  Response: { "deleted": true }
```

### Workflow API
```yaml
POST /api/v1/workflows/run
  Body: { "workflow": "email-to-knowledge", "params": {...} }
  Response: { "execution_id": "789", "status": "running" }

GET /api/v1/workflows/{execution_id}
  Response: { "status": "completed", "output": {...} }
```

### Analytics API
```yaml
GET /api/v1/analytics/usage
  Query: ?from=2026-04-01&to=2026-04-10
  Response: { "sessions": 50, "tasks": 200, ... }

GET /api/v1/analytics/performance
  Response: { "avg_response_time": 1.2s, ... }
```

---

## 🔐 Authentication

### API Key
```yaml
type: api_key
header: X-API-Key
rotation: 30 days
scopes:
  - read:memories
  - write:memories
  - run:workflows
  - admin:all
```

### JWT
```yaml
type: jwt
algorithm: RS256
issuer: clawd-auth
expiry: 1h
refresh: 7d
```

### OAuth2
```yaml
providers:
  - google
  - github
  - microsoft
scopes:
  - profile
  - email
```

---

## ⚡ Rate Limiting

```yaml
tiers:
  free:
    requests_per_minute: 60
    requests_per_day: 1000
    concurrent_jobs: 1
    
  pro:
    requests_per_minute: 300
    requests_per_day: 10000
    concurrent_jobs: 5
    
  enterprise:
    requests_per_minute: 1000
    requests_per_day: unlimited
    concurrent_jobs: 20
```

---

## 📊 Monitoring

```python
# Prometheus metrics
from prometheus_fastapi_instrumentator import Instrumentator

instrumentator = Instrumentator()
instrumentator.instrument(app).expose(app)

# Metrics available at /metrics:
# - http_requests_total
# - http_request_duration_seconds
# - http_requests_in_progress
# - api_key_usage
```

---

## 🚀 Deployment

```bash
# Start API Gateway
docker-compose up -d api-gateway

# Test endpoint
curl -X POST http://localhost:8000/api/v1/research \
  -H "X-API-Key: your-key" \
  -H "Content-Type: application/json" \
  -d '{"topic": "AI trends"}'

# View docs
open http://localhost:8000/docs
```

---

_Last updated: 2026-04-10 (Enterprise Setup)_
