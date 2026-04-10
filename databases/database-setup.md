# 💾 Database Integration

_Enterprise-grade data storage for all workloads_

---

## 📊 Database Stack

### 1. PostgreSQL (Primary)
**Use:** Relational data, complex queries, transactions

```yaml
version: "1.0"
config:
  host: localhost
  port: 5432
  database: clawdb
  user: clawd
  password: from-1password
  max_connections: 100
  ssl: true

tables:
  - users
  - sessions
  - tasks
  - memories
  - workflows
  - analytics
  - audit_logs

features:
  - Full-text search
  - JSONB support
  - Triggers & stored procedures
  - Row-level security
  - Point-in-time recovery
```

**Schema:**
```sql
-- Memories table
CREATE TABLE memories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT NOT NULL,
    tags TEXT[],
    embedding vector(768),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    metadata JSONB
);

-- Create index for vector search
CREATE INDEX memories_embedding_idx ON memories USING ivfflat (embedding vector_cosine_ops);

-- Sessions table
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    started_at TIMESTAMPTZ DEFAULT NOW(),
    ended_at TIMESTAMPTZ,
    message_count INTEGER DEFAULT 0,
    metadata JSONB
);

-- Analytics table
CREATE TABLE analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type TEXT NOT NULL,
    event_data JSONB,
    timestamp TIMESTAMPTZ DEFAULT NOW(),
    user_id UUID
);

CREATE INDEX analytics_timestamp_idx ON analytics(timestamp DESC);
```

---

### 2. Redis (Caching + Real-time)
**Use:** Hot data, sessions, pub/sub, rate limiting

```yaml
version: "1.0"
config:
  host: localhost
  port: 6379
  password: from-1password
  maxmemory: 2gb
  maxmemory-policy: allkeys-lru

data_structures:
  - strings: cache values
  - hashes: user sessions
  - lists: task queues
  - sets: unique visitors
  - sorted_sets: leaderboards
  - pubsub: real-time events

use_cases:
  - Query cache (TTL: 1h)
  - Session storage (TTL: 24h)
  - Rate limiting (sliding window)
  - Real-time notifications
  - Task queues
```

**Commands:**
```bash
# Cache query
SET cache:search:ai-trends "result" EX 3600

# Get cached
GET cache:search:ai-trends

# Rate limiting
INCR rate:user:6023537487:minute
EXPIRE rate:user:6023537487:minute 60

# Pub/Sub
PUBLISH notifications:user:6023537487 "New message"
SUBSCRIBE notifications:user:6023537487
```

---

### 3. MongoDB (Documents)
**Use:** Flexible schema, logs, unstructured data

```yaml
version: "1.0"
config:
  uri: mongodb://localhost:27017
  database: clawdb
  auth: from-1password

collections:
  - logs: Application logs
  - events: User events
  - documents: Flexible docs
  - configurations: App configs
  - backups: Backup metadata

indexes:
  - logs: { timestamp: -1 }
  - events: { user_id: 1, timestamp: -1 }
  - documents: { tags: 1 }
```

---

### 4. Vector Database (Embeddings)
**Use:** Semantic search, RAG, similarity

**Option A: Weaviate**
```yaml
version: "1.0"
config:
  url: http://localhost:8080
  api_key: from-1password

classes:
  - Memory:
      vectorizer: text2vec-transformers
      properties:
        - content: text
        - tags: text[]
        - created_at: date
        
  - Document:
      vectorizer: text2vec-transformers
      properties:
        - title: text
        - content: text
        - source: text
```

**Option B: Pinecone**
```yaml
version: "1.0"
config:
  api_key: from-1password
  environment: us-west1-gcp

indexes:
  - name: memories
    dimension: 768
    metric: cosine
    pods: 1
    
  - name: documents
    dimension: 768
    metric: cosine
    pods: 1
```

**Option C: pgvector (PostgreSQL extension)**
```sql
-- Enable extension
CREATE EXTENSION vector;

-- Create table with vector
CREATE TABLE embeddings (
    id UUID PRIMARY KEY,
    content TEXT,
    embedding vector(768)
);

-- Similarity search
SELECT * FROM embeddings
ORDER BY embedding <-> '[query_vector]'
LIMIT 10;
```

---

## 🔧 Setup Scripts

### PostgreSQL Setup
```bash
#!/bin/bash
# databases/setup-postgres.sh

docker run -d \
  --name clawdb-postgres \
  -e POSTGRES_DB=clawdb \
  -e POSTGRES_USER=clawd \
  -e POSTGRES_PASSWORD_FILE=/run/secrets/db_password \
  -p 5432:5432 \
  -v clawdb_data:/var/lib/postgresql/data \
  postgres:15-alpine

# Run migrations
psql -h localhost -U clawd -d clawdb -f databases/schema.sql
```

### Redis Setup
```bash
#!/bin/bash
# databases/setup-redis.sh

docker run -d \
  --name clawdb-redis \
  -p 6379:6379 \
  -v clawdb_redis:/data \
  redis:7-alpine \
  redis-server --appendonly yes
```

### MongoDB Setup
```bash
#!/bin/bash
# databases/setup-mongo.sh

docker run -d \
  --name clawdb-mongo \
  -p 27017:27017 \
  -v clawdb_mongo:/data/db \
  mongo:6
```

### Weaviate Setup
```bash
#!/bin/bash
# databases/setup-weaviate.sh

docker run -d \
  --name clawdb-weaviate \
  -p 8080:8080 \
  -e QUERY_DEFAULTS_LIMIT=25 \
  -e AUTHENTICATION_ANONYMOUS_ACCESS_ENABLED=false \
  -e PERSISTENCE_DATA_PATH="/var/lib/weaviate" \
  -e DEFAULT_VECTORIZER_MODULE="text2vec-transformers" \
  -v clawdb_weaviate:/var/lib/weaviate \
  semitechnologies/weaviate:latest
```

---

## 📈 Performance Tuning

### PostgreSQL
```sql
-- Optimize connections
ALTER SYSTEM SET max_connections = 200;
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET work_mem = '16MB';

-- Vacuum settings
ALTER SYSTEM SET autovacuum = on;
ALTER SYSTEM SET autovacuum_max_workers = 3;
```

### Redis
```conf
# redis.conf
maxmemory 2gb
maxmemory-policy allkeys-lru
appendonly yes
appendfsync everysec
```

---

## 🔐 Security

```yaml
security:
  encryption_at_rest: true
  encryption_in_transit: true
  backup_encryption: true
  
  access_control:
    - Role-based access
    - IP whitelisting
    - API key authentication
    
  audit:
    - Log all queries
    - Track failed auth
    - Alert on anomalies
```

---

## 📊 Monitoring

```bash
# PostgreSQL
pg_stat_activity
pg_stat_database
pg_locks

# Redis
INFO memory
INFO stats
MONITOR

# MongoDB
db.currentOp()
db.serverStatus()
```

---

_Last updated: 2026-04-10 (Enterprise Setup)_
