# ⚡ Message Queue & Event Streaming

_Async processing, task queues, real-time events_

---

## 📊 Message Queue Options

### 1. RabbitMQ (Task Queues)
**Use:** Task queues, RPC, delayed jobs

```yaml
version: "3.9"
services:
  rabbitmq:
    image: rabbitmq:3-management
    ports:
      - "5672:5672"  # AMQP
      - "15672:15672"  # Management UI
    environment:
      RABBITMQ_DEFAULT_USER: clawd
      RABBITMQ_DEFAULT_PASS: from-1password
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq

queues:
  - research_tasks: Deep research jobs
  - coding_tasks: Code generation jobs
  - email_tasks: Email processing
  - notification_tasks: Push notifications
  - backup_tasks: Backup jobs
  
exchanges:
  - clawd_direct: Direct routing
  - clawd_topic: Topic-based routing
  - clawd_fanout: Broadcast
```

**Usage:**
```python
import pika

# Connect
connection = pika.BlockingConnection(
    pika.ConnectionParameters('localhost')
)
channel = connection.channel()

# Declare queue
channel.queue_declare(queue='research_tasks', durable=True)

# Publish task
channel.basic_publish(
    exchange='',
    routing_key='research_tasks',
    body='{"topic": "AI trends", "depth": "deep"}',
    properties=pika.BasicProperties(delivery_mode=2)  # Persistent
)

# Consume
def callback(ch, method, properties, body):
    task = json.loads(body)
    process_task(task)
    ch.basic_ack(delivery_tag=method.delivery_tag)

channel.basic_consume(queue='research_tasks', on_message_callback=callback)
channel.start_consuming()
```

---

### 2. Apache Kafka (Event Streaming)
**Use:** Event sourcing, real-time streams, log aggregation

```yaml
version: "3.9"
services:
  zookeeper:
    image: confluentinc/cp-zookeeper:7.5.0
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
      
  kafka:
    image: confluentinc/cp-kafka:7.5.0
    ports:
      - "9092:9092"
    environment:
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://localhost:9092
      KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
    depends_on:
      - zookeeper
      
topics:
  - user_events: User actions
  - system_events: System events
  - research_events: Research job events
  - analytics_events: Analytics data
  - audit_events: Audit logs
```

**Usage:**
```python
from kafka import KafkaProducer, KafkaConsumer
import json

# Producer
producer = KafkaProducer(
    bootstrap_servers=['localhost:9092'],
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Send event
producer.send('user_events', {
    'user_id': '6023537487',
    'action': 'research_started',
    'topic': 'AI trends',
    'timestamp': datetime.now().isoformat()
})

# Consumer
consumer = KafkaConsumer(
    'user_events',
    bootstrap_servers=['localhost:9092'],
    auto_offset_reset='earliest',
    group_id='clawd-analytics'
)

for message in consumer:
    event = json.loads(message.value)
    process_event(event)
```

---

### 3. Redis Streams (Lightweight)
**Use:** Simple streams, real-time updates

```python
import redis

r = redis.Redis(host='localhost', port=6379)

# Add to stream
r.xadd('notifications', {
    'user_id': '6023537487',
    'message': 'Research complete!',
    'timestamp': datetime.now().isoformat()
})

# Read from stream
messages = r.xread({'notifications': '0'}, count=10)

# Consumer group
r.xgroup_create('notifications', 'clawd-workers', id='0', mkstream=True)
messages = r.xreadgroup('clawd-workers', 'worker-1', {'notifications': '>'}, count=10)
```

---

## 🎯 Use Cases

### Task Queue Pattern
```python
# Producer: Submit research job
def submit_research(topic, depth='deep'):
    channel.basic_publish(
        exchange='',
        routing_key='research_tasks',
        body=json.dumps({
            'topic': topic,
            'depth': depth,
            'created_at': datetime.now().isoformat()
        })
    )
    return {'status': 'queued', 'topic': topic}

# Consumer: Process research job
def process_research_task(body):
    task = json.loads(body)
    
    # Spawn research agent
    result = sessions_spawn(
        task=f"Research {task['topic']} - {task['depth']} analysis",
        label='research-agent'
    )
    
    # Store result
    save_to_database(result)
    
    # Notify user
    send_notification(task['user_id'], 'Research complete!')
```

### Event Sourcing Pattern
```python
# Record all state changes as events
def record_event(event_type, data):
    producer.send('system_events', {
        'event_type': event_type,
        'data': data,
        'timestamp': datetime.now().isoformat(),
        'version': 1
    })

# Rebuild state from events
def rebuild_state(entity_id):
    events = []
    for message in KafkaConsumer('system_events'):
        event = json.loads(message.value)
        if event['data']['entity_id'] == entity_id:
            events.append(event)
    
    # Apply events in order
    state = {}
    for event in sorted(events, key=lambda e: e['timestamp']):
        state = apply_event(state, event)
    
    return state
```

### CQRS Pattern
```python
# Command (write) side
def create_memory(content, tags):
    # Validate
    # Save to write database
    # Publish event
    producer.send('memory_events', {
        'type': 'memory_created',
        'content': content,
        'tags': tags
    })

# Query (read) side
def search_memories(query):
    # Read from optimized read database (Elasticsearch)
    return elasticsearch.search(query)
```

---

## 🔧 Setup Scripts

### RabbitMQ Setup
```bash
#!/bin/bash
# message-queue/setup-rabbitmq.sh

docker run -d \
  --name clawdb-rabbitmq \
  -p 5672:5672 \
  -p 15672:15672 \
  -e RABBITMQ_DEFAULT_USER=clawd \
  -e RABBITMQ_DEFAULT_PASS=from-1password \
  -v clawdb_rabbitmq:/var/lib/rabbitmq \
  rabbitmq:3-management

# Wait for RabbitMQ
sleep 10

# Create queues
docker exec clawdb-rabbitmq rabbitmqadmin declare queue name=research_tasks durable=true
docker exec clawdb-rabbitmq rabbitmqadmin declare queue name=coding_tasks durable=true
docker exec clawdb-rabbitmq rabbitmqadmin declare queue name=notification_tasks durable=true

echo "RabbitMQ ready! Management UI: http://localhost:15672"
```

### Kafka Setup
```bash
#!/bin/bash
# message-queue/setup-kafka.sh

docker-compose -f message-queue/kafka-docker-compose.yml up -d

# Wait for Kafka
sleep 30

# Create topics
docker exec clawdb-kafka kafka-topics --create \
  --bootstrap-server localhost:9092 \
  --topic user_events \
  --partitions 3 \
  --replication-factor 1

docker exec clawdb-kafka kafka-topics --create \
  --bootstrap-server localhost:9092 \
  --topic system_events \
  --partitions 3 \
  --replication-factor 1

echo "Kafka ready!"
```

---

## 📊 Monitoring

### RabbitMQ
- Management UI: http://localhost:15672
- Queue depths
- Message rates
- Consumer counts
- Memory usage

### Kafka
```bash
# List topics
kafka-topics --bootstrap-server localhost:9092 --list

# Describe topic
kafka-topics --bootstrap-server localhost:9092 --describe --topic user_events

# Consumer lag
kafka-consumer-groups --bootstrap-server localhost:9092 --describe --group clawd-analytics
```

---

## 🔐 Security

```yaml
security:
  - TLS encryption
  - SASL authentication
  - ACL for topics/queues
  - Network isolation
  - Audit logging
```

---

_Last updated: 2026-04-10 (Enterprise Setup)_
