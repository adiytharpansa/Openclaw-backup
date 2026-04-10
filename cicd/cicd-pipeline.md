# 🔄 CI/CD Pipeline

_Automated testing, building, and deployment_

---

## 🏗️ Pipeline Architecture

```
┌─────────────┐
│  Git Push   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   GitHub    │
│   Actions   │
└──────┬──────┘
       │
       ▼
┌─────────────────────────────────────┐
│           Pipeline Stages            │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐   │
│  │Test │→│Build│→│Scan │→│Deploy│  │
│  └─────┘ └─────┘ └─────┘ └─────┘   │
└─────────────────────────────────────┘
       │
       ▼
┌─────────────┐
│  Kubernetes │
│   Docker    │
│   Cloud     │
└─────────────┘
```

---

## 📋 GitHub Actions Workflow

```yaml
# .github/workflows/cicd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  # ==================== TEST ====================
  
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_DB: testdb
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
      
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run linter
        run: npm run lint
      
      - name: Run tests
        run: npm test
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/testdb
          REDIS_URL: redis://localhost:6379
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info

  # ==================== BUILD ====================
  
  build:
    needs: test
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Login to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=sha
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  # ==================== SECURITY SCAN ====================
  
  security:
    needs: build
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          format: 'sarif'
          output: 'trivy-results.sarif'
          severity: 'CRITICAL,HIGH'
      
      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'
      
      - name: Run Snyk
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        continue-on-error: true

  # ==================== DEPLOY ====================
  
  deploy-staging:
    needs: [test, build, security]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    environment: staging
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Staging
        run: |
          ./cicd/deploy.sh staging
        env:
          KUBE_CONFIG: ${{ secrets.KUBE_CONFIG_STAGING }}
          IMAGE_TAG: ${{ github.sha }}

  deploy-production:
    needs: [test, build, security]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    environment: production
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Deploy to Production
        run: |
          ./cicd/deploy.sh production
        env:
          KUBE_CONFIG: ${{ secrets.KUBE_CONFIG_PRODUCTION }}
          IMAGE_TAG: ${{ github.sha }}
      
      - name: Health check
        run: |
          ./cicd/health-check.sh production
      
      - name: Notify deployment
        if: always()
        run: |
          ./cicd/notify.sh ${{ job.status }}

  # ==================== BACKUP ====================
  
  backup:
    runs-on: ubuntu-latest
    if: github.event_name == 'schedule'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Create backup
        run: |
          ./backup/backup.sh
      
      - name: Upload to S3
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-west-2
      
      - name: Sync backup to S3
        run: |
          aws s3 sync ./backups s3://clawdb-backups/$(date +%Y%m%d)/
```

---

## 🔧 Deployment Script

```bash
#!/bin/bash
# cicd/deploy.sh

set -e

ENVIRONMENT=$1
IMAGE_TAG=$2

if [ -z "$ENVIRONMENT" ]; then
    echo "Usage: $0 <staging|production> [image-tag]"
    exit 1
fi

IMAGE_TAG=${IMAGE_TAG:-latest}

echo "Deploying to $ENVIRONMENT with tag $IMAGE_TAG"

# Setup kubectl
echo "$KUBE_CONFIG" | base64 -d > /tmp/kubeconfig
export KUBECONFIG=/tmp/kubeconfig

# Update image
kubectl set image deployment/clawd-api \
  clawd-api=ghcr.io/${{ github.repository }}:$IMAGE_TAG \
  -n clawd-$ENVIRONMENT

# Wait for rollout
kubectl rollout status deployment/clawd-api -n clawd-$ENVIRONMENT --timeout=300s

# Run migrations
kubectl exec -n clawd-$ENVIRONMENT deployment/clawd-api -- npm run migrate

echo "Deployment complete!"
```

---

## 🏥 Health Check Script

```bash
#!/bin/bash
# cicd/health-check.sh

ENVIRONMENT=$1
BASE_URL=""

if [ "$ENVIRONMENT" == "staging" ]; then
    BASE_URL="https://staging.clawd.ai"
elif [ "$ENVIRONMENT" == "production" ]; then
    BASE_URL="https://api.clawd.ai"
fi

echo "Running health checks for $ENVIRONMENT..."

# Check API health
response=$(curl -s -o /dev/null -w "%{http_code}" $BASE_URL/health)
if [ "$response" != "200" ]; then
    echo "❌ API health check failed (HTTP $response)"
    exit 1
fi
echo "✅ API health check passed"

# Check database connection
response=$(curl -s $BASE_URL/health/db)
if [[ ! "$response" == *"connected"* ]]; then
    echo "❌ Database health check failed"
    exit 1
fi
echo "✅ Database health check passed"

# Check Redis connection
response=$(curl -s $BASE_URL/health/redis)
if [[ ! "$response" == *"connected"* ]]; then
    echo "❌ Redis health check failed"
    exit 1
fi
echo "✅ Redis health check passed"

echo "✅ All health checks passed!"
```

---

## 📢 Notification Script

```bash
#!/bin/bash
# cicd/notify.sh

STATUS=$1
CHANNEL="telegram"

if [ "$STATUS" == "success" ]; then
    MESSAGE="✅ Deployment successful to $ENVIRONMENT"
else
    MESSAGE="❌ Deployment failed to $ENVIRONMENT"
fi

# Send to Telegram
curl -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
  -d "chat_id=$TELEGRAM_CHAT_ID" \
  -d "text=$MESSAGE" \
  -d "parse_mode=Markdown"

# Send to Slack (optional)
if [ -n "$SLACK_WEBHOOK_URL" ]; then
    curl -X POST "$SLACK_WEBHOOK_URL" \
      -H 'Content-Type: application/json' \
      -d "{\"text\": \"$MESSAGE\"}"
fi
```

---

## 📊 Pipeline Status Badges

```markdown
<!-- Add to README.md -->

[![CI/CD](https://github.com/your-org/clawd/actions/workflows/cicd.yml/badge.svg)](https://github.com/your-org/clawd/actions)
[![Coverage](https://codecov.io/gh/your-org/clawd/branch/main/graph/badge.svg)](https://codecov.io/gh/your-org/clawd)
[![Security Scan](https://github.com/your-org/clawd/actions/workflows/security.yml/badge.svg)](https://github.com/your-org/clawd/actions)
```

---

_Last updated: 2026-04-10 (Enterprise Setup)_
