# 📊 Monitoring Stack

_Prometheus + Grafana + ELK for full observability_

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────┐
│              Grafana Dashboard              │
│         (Visualization & Alerting)          │
└──────────────────┬──────────────────────────┘
                   │
         ┌─────────┴─────────┐
         │                   │
         ▼                   ▼
┌─────────────────┐ ┌─────────────────┐
│   Prometheus    │ │   Elasticsearch │
│    (Metrics)    │ │     (Logs)      │
└────────┬────────┘ └────────┬────────┘
         │                   │
         ▼                   ▼
┌─────────────────────────────────────────┐
│         Exporters & Applications         │
│  (Node, Postgres, Redis, App, etc.)     │
└─────────────────────────────────────────┘
```

---

## 📈 Prometheus (Metrics)

```yaml
# monitoring/prometheus.yml
version: "3.9"
services:
  prometheus:
    image: prom/prometheus:v2.47.0
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
      - '--storage.tsdb.retention.time=30d'
      - '--web.enable-lifecycle'

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
      
  - job_name: 'node'
    static_configs:
      - targets: ['node-exporter:9100']
      
  - job_name: 'postgres'
    static_configs:
      - targets: ['postgres-exporter:9187']
      
  - job_name: 'redis'
    static_configs:
      - targets: ['redis-exporter:9121']
      
  - job_name: 'elasticsearch'
    static_configs:
      - targets: ['elasticsearch:9200']
      
  - job_name: 'application'
    static_configs:
      - targets: ['api-gateway:8000']
    metrics_path: '/metrics'
```

**Key Metrics:**
- API request rate
- Response time (p50, p95, p99)
- Error rate
- Memory usage
- CPU usage
- Queue depth
- Cache hit rate
- Database connections

---

## 📊 Grafana (Dashboards)

```yaml
# monitoring/grafana.yml
version: "3.9"
services:
  grafana:
    image: grafana/grafana:10.1.0
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=from-1password
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/dashboards:/etc/grafana/provisioning/dashboards
      - ./grafana/datasources:/etc/grafana/provisioning/datasources
```

**Dashboards:**
1. **System Overview**
   - CPU, Memory, Disk usage
   - Network I/O
   - Uptime

2. **API Performance**
   - Request rate
   - Response time (p50, p95, p99)
   - Error rate by endpoint
   - Top slow endpoints

3. **Database Health**
   - Connection pool usage
   - Query performance
   - Lock waits
   - Replication lag

4. **Cache Performance**
   - Hit/miss ratio
   - Memory usage
   - Eviction rate
   - Key count

5. **Queue Health**
   - Queue depth
   - Processing rate
   - Consumer lag
   - Dead letters

6. **Business Metrics**
   - Sessions per day
   - Tasks completed
   - Active users
   - Cost per task

---

## 📝 Elasticsearch + Kibana (Logs)

```yaml
# monitoring/elk.yml
version: "3.9"
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=true
      - ELASTIC_PASSWORD=from-1password
    volumes:
      - es_data:/usr/share/elasticsearch/data
      
  logstash:
    image: docker.elastic.co/logstash/logstash:8.11.0
    volumes:
      - ./logstash/pipeline:/usr/share/logstash/pipeline
      
  kibana:
    image: docker.elastic.co/kibana/kibana:8.11.0
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    depends_on:
      - elasticsearch
```

**Log Pipeline:**
```
Application → Filebeat → Logstash → Elasticsearch → Kibana
```

**Log Levels:**
- ERROR: Application errors
- WARN: Warnings
- INFO: General info
- DEBUG: Debug info
- AUDIT: Security audit logs

---

## 🚨 AlertManager (Alerts)

```yaml
# monitoring/alertmanager.yml
global:
  smtp_smarthost: 'smtp.gmail.com:587'
  smtp_from: 'alerts@clawd.ai'
  smtp_auth_username: 'from-1password'
  smtp_auth_password: 'from-1password'

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'telegram'
  
  routes:
    - match:
        severity: critical
      receiver: 'telegram-critical'
      
receivers:
  - name: 'telegram'
    telegram_configs:
      - bot_token: 'from-1password'
        chat_id: '6023537487'
        
  - name: 'telegram-critical'
    telegram_configs:
      - bot_token: 'from-1password'
        chat_id: '6023537487'
        disable_notification: false

inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'instance']
```

**Alert Rules:**
```yaml
# monitoring/alerts.yml
groups:
  - name: system
    rules:
      - alert: HighCPU
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          
      - alert: HighMemory
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage on {{ $labels.instance }}"
          
  - name: application
    rules:
      - alert: HighErrorRate
        expr: sum(rate(http_requests_total{status=~"5.."}[5m])) / sum(rate(http_requests_total[5m])) > 0.05
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "High error rate: {{ $value | humanizePercentage }}"
          
      - alert: SlowResponse
        expr: histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le)) > 2
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Slow response time: {{ $value }}s"
```

---

## 🔧 Setup Scripts

### Full Monitoring Stack
```bash
#!/bin/bash
# monitoring/setup-monitoring.sh

echo "Setting up monitoring stack..."

# Start Prometheus
docker-compose -f monitoring/prometheus.yml up -d

# Start Grafana
docker-compose -f monitoring/grafana.yml up -d

# Start ELK
docker-compose -f monitoring/elk.yml up -d

# Start exporters
docker run -d --name node-exporter prom/node-exporter:latest
docker run -d --name postgres-exporter -e DATA_SOURCE_NAME="postgresql://clawd:pass@postgres:5432/clawdb?sslmode=disable" prometheuscommunity/postgres-exporter
docker run -d --name redis-exporter oliver006/redis_exporter:latest --redis.addr=redis:6379

echo "Monitoring stack ready!"
echo "- Prometheus: http://localhost:9090"
echo "- Grafana: http://localhost:3000 (admin/admin)"
echo "- Kibana: http://localhost:5601"
```

---

## 📊 Grafana Dashboards

### Import Pre-built Dashboards
- Node Exporter: 1860
- PostgreSQL: 9628
- Redis: 763
- Elasticsearch: 2326
- API Gateway: Custom

### Custom Dashboard JSON
```json
{
  "dashboard": {
    "title": "Clawd Overview",
    "panels": [
      {
        "title": "Request Rate",
        "targets": [{"expr": "rate(http_requests_total[5m])"}]
      },
      {
        "title": "Response Time",
        "targets": [{"expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))"}]
      }
    ]
  }
}
```

---

_Last updated: 2026-04-10 (Enterprise Setup)_
