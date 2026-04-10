# 🔍 Search Engine Setup

_Enterprise-grade search capabilities_

---

## 📊 Search Stack

### 1. Elasticsearch (Primary)
**Use:** Full-text search, analytics, aggregations

```yaml
version: "8.11.0"
config:
  host: localhost
  port: 9200
  ssl: true
  auth: elastic / from-1password
  
indices:
  - memories: All memory entries
  - documents: All documents
  - conversations: Chat history
  - analytics: Usage data
  - logs: Application logs

features:
  - Full-text search
  - Fuzzy matching
  - Autocomplete
  - Faceted search
  - Aggregations
  - Real-time indexing
```

**Index Template:**
```json
{
  "index_patterns": ["memories-*"],
  "template": {
    "settings": {
      "number_of_shards": 3,
      "number_of_replicas": 1,
      "analysis": {
        "analyzer": {
          "custom_analyzer": {
            "type": "custom",
            "tokenizer": "standard",
            "filter": ["lowercase", "stop", "snowball"]
          }
        }
      }
    },
    "mappings": {
      "properties": {
        "content": { 
          "type": "text",
          "analyzer": "custom_analyzer",
          "fields": {
            "keyword": { "type": "keyword" }
          }
        },
        "tags": { "type": "keyword" },
        "created_at": { "type": "date" },
        "embedding": { "type": "dense_vector", "dims": 768 }
      }
    }
  }
}
```

**Search Queries:**
```json
// Full-text search
{
  "query": {
    "multi_match": {
      "query": "AI trends",
      "fields": ["content", "tags"],
      "fuzziness": "AUTO"
    }
  }
}

// Semantic + keyword hybrid
{
  "query": {
    "bool": {
      "must": [
        { "match": { "content": "AI" } }
      ],
      "filter": [
        { "term": { "tags": "research" } },
        { "range": { "created_at": { "gte": "now-30d" } } }
      ]
    }
  }
}
```

---

### 2. Meilisearch (Fast Alternative)
**Use:** Typo-tolerant search, instant results

```yaml
version: "1.6"
config:
  host: localhost
  port: 7700
  api_key: from-1password
  
indexes:
  - memories
  - documents
  - conversations

features:
  - Typo tolerance
  - Faceted search
  - Synonyms
  - Stop words
  - Custom ranking
  - Instant search
```

**Setup:**
```bash
# Install Meilisearch
docker run -d \
  --name clawdb-meilisearch \
  -p 7700:7700 \
  -v meilisearch_data:/meili_data \
  getmeili/meilisearch:latest \
  meilisearch --master-key=from-1password

# Add documents
curl -X POST 'http://localhost:7700/indexes/memories/documents' \
  -H 'Authorization: Bearer API_KEY' \
  -H 'Content-Type: application/json' \
  --data-binary '[{"id": 1, "content": "AI research notes"}]'

# Search
curl -X POST 'http://localhost:7700/indexes/memories/search' \
  -H 'Authorization: Bearer API_KEY' \
  -H 'Content-Type: application/json' \
  --data-binary '{ "q": "AI research" }'
```

---

### 3. Typesense (Another Alternative)
**Use:** Developer-friendly, fast, typo-tolerant

```yaml
version: "0.25.0"
config:
  host: localhost
  port: 8108
  api_key: from-1password
  
collections:
  - memories
  - documents
  - conversations
```

---

## 🔧 Setup Scripts

### Elasticsearch Setup
```bash
#!/bin/bash
# search/setup-elasticsearch.sh

docker run -d \
  --name clawdb-elasticsearch \
  -p 9200:9200 \
  -p 9300:9300 \
  -e "discovery.type=single-node" \
  -e "xpack.security.enabled=true" \
  -e "ELASTIC_PASSWORD=from-1password" \
  -v clawdb_es:/usr/share/elasticsearch/data \
  docker.elastic.co/elasticsearch/elasticsearch:8.11.0

# Wait for ES to be ready
sleep 30

# Create index template
curl -X PUT "localhost:9200/_index_template/memories_template" \
  -H "Content-Type: application/json" \
  -u elastic:password \
  -d @search/es-template.json

# Create Kibana for visualization
docker run -d \
  --name clawdb-kibana \
  -p 5601:5601 \
  -e ELASTICSEARCH_HOSTS=http://clawdb-elasticsearch:9200 \
  docker.elastic.co/kibana/kibana:8.11.0
```

### Meilisearch Setup
```bash
#!/bin/bash
# search/setup-meilisearch.sh

docker run -d \
  --name clawdb-meilisearch \
  -p 7700:7700 \
  -e MEILI_MASTER_KEY=from-1password \
  -v clawdb_meili:/meili_data \
  getmeili/meilisearch:latest
```

---

## 📈 Search Optimization

### Elasticsearch Tuning
```json
{
  "settings": {
    "index": {
      "refresh_interval": "30s",
      "number_of_replicas": 1,
      "codec": "best_compression",
      "routing": {
        "allocation": {
          "total_shards_per_node": 2
        }
      }
    }
  }
}
```

### Query Optimization
```javascript
// Use filter context for non-scoring queries
{
  "query": {
    "bool": {
      "filter": [
        { "term": { "status": "active" } },
        { "range": { "date": { "gte": "now-7d" } } }
      ],
      "must": [
        { "match": { "content": "search terms" } }
      ]
    }
  }
}

// Use source filtering to reduce response size
{
  "_source": ["id", "title", "snippet"],
  "query": { ... }
}
```

---

## 🔍 Search Features

### Autocomplete
```json
{
  "suggest": {
    "text": "artif",
    "completion": {
      "field": "suggest",
      "size": 10
    }
  }
}
```

### Highlighting
```json
{
  "query": { "match": { "content": "AI" } },
  "highlight": {
    "fields": {
      "content": {
        "pre_tags": ["<em>"],
        "post_tags": ["</em>"]
      }
    }
  }
}
```

### Aggregations
```json
{
  "size": 0,
  "aggs": {
    "tags": {
      "terms": { "field": "tags" }
    },
    "date_histogram": {
      "date_histogram": {
        "field": "created_at",
        "calendar_interval": "month"
      }
    }
  }
}
```

---

## 📊 Monitoring

```bash
# Elasticsearch cluster health
curl -X GET "localhost:9200/_cluster/health?pretty"

# Index stats
curl -X GET "localhost:9200/_cat/indices?v"

# Search performance
curl -X GET "localhost:9200/_nodes/stats/search?pretty"

# Slow queries
curl -X GET "localhost:9200/_cat/slow_search?v"
```

---

## 🔐 Security

```yaml
security:
  - HTTPS enabled
  - Authentication required
  - Role-based access control
  - Audit logging
  - IP filtering
  - Rate limiting
```

---

_Last updated: 2026-04-10 (Enterprise Setup)_
