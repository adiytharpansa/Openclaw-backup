# DevOps-Master Skill

## Deskripsi
End-to-end DevOps automation dan infrastructure management untuk multi-cloud deployment, Kubernetes orchestration, CI/CD pipeline optimization, dan infrastructure as code dengan automatic scaling, monitoring, dan security hardening.

## Kapan Digunakan
- Deploy production environment (AWS, GCP, Azure)
- Setup Kubernetes cluster & orchestration
- Optimize CI/CD pipelines
- Configure auto-scaling & load balancing
- Implement monitoring & alerting
- Manage infrastructure as code (Terraform, Pulumi)
- Cost optimization for cloud resources
- Disaster recovery planning

## Fitur Utama

### 1. Multi-Cloud Management
```
├── AWS (EC2, S3, RDS, Lambda, etc.)
├── Google Cloud (GCE, Cloud Storage, Cloud SQL)
├── Azure (VMs, Blob Storage, SQL Database)
├── Cross-cloud networking
├── Multi-region deployment
└── Cost comparison & optimization
```

### 2. Container Orchestration
```
├── Kubernetes Cluster Management
├── Docker Compose & Swarm
├── Container registry management
├── Service mesh (Istio, Linkerd)
├── Load balancing & ingress
└── Auto-scaling configuration
```

### 3. CI/CD Pipeline
```
├── Build automation
├── Automated testing
├── Security scanning
├── Deployment strategies
├── Rollback mechanisms
├── Canary & blue-green deployment
└── Environment promotion
```

### 4. Infrastructure as Code
```
├── Terraform
├── Pulumi
├── CloudFormation
├── Ansible
├── Helm charts
└── Custom provisioning scripts
```

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                   DEVOPS MASTER                          │
├──────────────────────────────────────────────────────────┤
│  Infrastructure │  CI/CD Pipeline  │  Monitoring  │  Cost│
└──────────┬───────────────┴──────────┬─────────┴──────┬────┘
           │                         │                 │
    ┌──────▼──────┐           ┌─────▼────┐      ┌────▼────┐
    │   AWS/GCP   │           │  GitHub  │      │ Budget  │
    │  Azure      │           │  Actions │      │ Alerts  │
    │  GKE        │           │  Jenkins │      └─────────┘
    │  K8s        │           └──────────┘
    └─────────────┘
```

## Commands

### Infrastructure Provisioning
```bash
# Provision AWS infrastructure
./scripts/devops-master.sh provision --cloud aws --region us-east-1 --env production

# Provision Kubernetes cluster
./scripts/devops-master.sh k8s create --cluster production --nodes 3 --type on-demand

# Provision Azure infrastructure
./scripts/devops-master.sh provision --cloud azure --region eastasia --env staging

# Multi-cloud deployment
./scripts/devops-master.sh provision --clouds aws,azure --region us,eu --env production
```

### CI/CD Pipeline
```bash
# Setup CI/CD pipeline
./scripts/devops-master.sh ci-cd setup --type github-actions --branch main

# Configure automated testing
./scripts/devops-master.sh ci-cd test --type e2e --parallel 4

# Security scan in pipeline
./scripts/devops-master.sh ci-cd security --scan docker,deps,secrets

# Configure deployment strategy
./scripts/devops-master.sh ci-cd deploy --strategy canary --rollback-auto
```

### Kubernetes Management
```bash
# Deploy to K8s
./scripts/devops-master.sh k8s deploy --app api --version v1.2.3 --namespace production

# Scale application
./scripts/devops-master.sh k8s scale --app api --replicas 10 --min 5 --max 20

# Rolling update
./scripts/devops-master.sh k8s update --app api --image latest --strategy rolling

# Monitor K8s health
./scripts/devops-master.sh k8s health --namespace production

# View logs
./scripts/devops-master.sh k8s logs --app api --follow --tail 100
```

### Monitoring & Alerting
```bash
# Setup monitoring
./scripts/devops-master.sh monitor setup --tools prometheus,grafana,alertmanager

# Configure alerts
./scripts/devops-master.sh monitor alert --metric cpu --threshold 80% --action slack

# View dashboards
./scripts/devops-master.sh monitor dashboard --tool grafana --view production

# Performance profiling
./scripts/devops-master.sh monitor profile --app api --duration 1h
```

### Cost Optimization
```bash
# Analyze costs
./scripts/devops-master.sh cost analyze --cloud aws --timeframe 30d

# Find optimization opportunities
./scripts/devops-master.sh cost optimize --recommend --priority high

# Set budgets
./scripts/devops-master.sh cost budget --monthly 10000 --alert-at 80%

# Reserved instances
./scripts/devops-master.sh cost reserved --auto --compute 70%
```

## Implementation

### Infrastructure Provisioning (Terraform)
```python
#!/usr/bin/env python3
"""
DevOps Master - Infrastructure Provisioning Engine
Manages multi-cloud infrastructure with Terraform and Pulumi
"""

import subprocess
import json
from pathlib import Path
from typing import Dict, List, Optional
from dataclasses import dataclass
from datetime import datetime

@dataclass
class InfrastructureConfig:
    cloud: str
    region: str
    environment: str
    resources: List[dict]
    tags: Dict[str, str]

class InfrastructureProvisioner:
    def __init__(self, workspace: str):
        self.workspace = Path(workspace)
        self.tf_backend = "s3"  # AWS S3 backend
        self.state_lock = "dynamodb"
        
    async def provision(self, config: InfrastructureConfig):
        """Provision infrastructure based on config"""
        
        # Generate Terraform configuration
        tf_config = self._generate_terraform_config(config)
        
        # Initialize Terraform
        await self._run_terraform("init", backend_config=self._get_backend_config())
        
        # Plan changes
        plan = await self._run_terraform("plan", out="tfplan")
        
        # Apply changes (with auto-approve for CI/CD)
        await self._run_terraform("apply", tfplan, auto_approve=True)
        
        # Export outputs
        outputs = await self._run_terraform("output", json=True)
        
        # Store state
        self._store_state(config, outputs)
        
        return outputs
    
    async def _run_terraform(self, command: str, *args, **kwargs):
        """Run Terraform command"""
        cmd = ["terraform", command] + list(args)
        
        if kwargs.get('auto_approve'):
            cmd.append("-auto-approve")
        
        result = subprocess.run(
            cmd,
            cwd=str(self.workspace),
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            raise Exception(f"Terraform {command} failed: {result.stderr}")
        
        return result.stdout
    
    def _generate_terraform_config(self, config: InfrastructureConfig) -> Dict:
        """Generate Terraform configuration"""
        
        if config.cloud == "aws":
            return {
                "provider": {
                    "aws": {
                        "region": config.region
                    }
                },
                "resources": {
                    "aws_vpc": {
                        "main": {
                            "cidr_block": "10.0.0.0/16",
                            "tags": config.tags
                        }
                    },
                    "aws_subnet": {
                        "public": {
                            "vpc_id": "${aws_vpc.main.id}",
                            "cidr_block": "10.0.1.0/24",
                            "availability_zone": f"{config.region}a",
                            "tags": config.tags
                        }
                    },
                    "aws_security_group": {
                        "web": {
                            "name": f"{config.environment}-web-sg",
                            "description": "Web security group",
                            "ingress": [
                                {
                                    "from_port": 80,
                                    "to_port": 80,
                                    "protocol": "tcp",
                                    "cidr_blocks": ["0.0.0.0/0"]
                                },
                                {
                                    "from_port": 443,
                                    "to_port": 443,
                                    "protocol": "tcp",
                                    "cidr_blocks": ["0.0.0.0/0"]
                                }
                            ],
                            "tags": config.tags
                        }
                    },
                    "aws_instance": {
                        "web": {
                            "ami": "ami-0c55b159cbfafe1f0",
                            "instance_type": "t3.micro",
                            "subnet_id": "${aws_subnet.public.id}",
                            "security_groups": ["${aws_security_group.web.name}"],
                            "tags": config.tags
                        }
                    }
                }
            }
        
        # Add more cloud providers
        return {}
    
    def _get_backend_config(self) -> Dict:
        """Get Terraform backend configuration"""
        return {
            "bucket": "terraform-state-bucket",
            "key": f"{self.workspace.name}/terraform.tfstate",
            "region": "us-east-1",
            "dynamodb_table": self.state_lock,
            "encrypt": True
        }
    
    def _store_state(self, config: InfrastructureConfig, outputs: Dict):
        """Store infrastructure state"""
        state = {
            "config": config.__dict__,
            "outputs": outputs,
            "timestamp": datetime.now().isoformat(),
            "state_version": "3.0"
        }
        
        state_file = self.workspace / f"state-{config.environment}.json"
        with open(state_file, 'w') as f:
            json.dump(state, f, indent=2)

class KubernetesManager:
    def __init__(self, cluster_name: str):
        self.cluster_name = cluster_name
        self.kubeconfig = f"~/.kube/config-{cluster_name}"
        
    async def deploy(self, app_config: Dict):
        """Deploy application to Kubernetes"""
        
        # Create deployment manifest
        deployment = {
            "apiVersion": "apps/v1",
            "kind": "Deployment",
            "metadata": {
                "name": app_config['name'],
                "namespace": app_config.get('namespace', 'default')
            },
            "spec": {
                "replicas": app_config.get('replicas', 3),
                "selector": {
                    "matchLabels": {
                        "app": app_config['name']
                    }
                },
                "template": {
                    "metadata": {
                        "labels": {
                            "app": app_config['name']
                        }
                    },
                    "spec": {
                        "containers": [{
                            "name": app_config['name'],
                            "image": app_config['image'],
                            "ports": [{
                                "containerPort": app_config.get('port', 8080)
                            }],
                            "resources": {
                                "requests": {
                                    "memory": app_config.get('memory_request', '128Mi'),
                                    "cpu": app_config.get('cpu_request', '100m')
                                },
                                "limits": {
                                    "memory": app_config.get('memory_limit', '256Mi'),
                                    "cpu": app_config.get('cpu_limit', '200m')
                                }
                            }
                        }]
                    }
                }
            }
        }
        
        # Apply deployment
        await self._kubectl("apply", f"-f -", input=json.dumps(deployment))
        
        # Wait for rollout
        await self._kubectl("rollout", "status", "deployment", app_config['name'])
        
    async def scale(self, app_name: str, replicas: int):
        """Scale application"""
        await self._kubectl("scale", "deployment", app_name, f"--replicas={replicas}")
    
    async def _kubectl(self, *args, input: str = None):
        """Run kubectl command"""
        cmd = ["kubectl", "--kubeconfig", self.kubeconfig] + list(args)
        
        result = subprocess.run(
            cmd,
            input=input,
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            raise Exception(f"kubectl {' '.join(args)} failed: {result.stderr}")
        
        return result.stdout
```

### CI/CD Pipeline Configuration
```yaml
# GitHub Actions CI/CD Pipeline
name: Production Pipeline
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

env:
  AWS_REGION: us-east-1
  ECR_REGISTRY: ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-east-1.amazonaws.com

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test -- --coverage
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
  
  security-scan:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v3
      
      - name: Run SAST
        uses: github/codeql-action/init@v2
      
      - name: Run CodeQL
        uses: github/codeql-action/analyze@v2
      
      - name: Scan Docker image
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'app:latest'
          format: 'sarif'
          output: 'trivy-results.sarif'
  
  build:
    runs-on: ubuntu-latest
    needs: [test, security-scan]
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}
      
      - name: Login to ECR
        run: aws ecr get-login-password --region ${{ env.AWS_REGION }} | docker login --username AWS --password-stdin ${{ env.ECR_REGISTRY }}
      
      - name: Build and push Docker image
        run: |
          docker build -t ${{ env.ECR_REGISTRY }}/app:${{ github.sha }} .
          docker push ${{ env.ECR_REGISTRY }}/app:${{ github.sha }}
  
  deploy:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    environment: production
    steps:
      - uses: actions/checkout@v3
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ env.AWS_REGION }}
      
      - name: Deploy to EKS
        run: |
          aws eks update-kubeconfig --name production-cluster --region ${{ env.AWS_REGION }}
          kubectl set image deployment/app app=${{ env.ECR_REGISTRY }}/app:${{ github.sha }}
          kubectl rollout status deployment/app
```

### Monitoring Stack
```python
#!/usr/bin/env python3
"""
DevOps Master - Monitoring & Alerting
Sets up Prometheus, Grafana, and Alertmanager
"""

import subprocess
from dataclasses import dataclass

@dataclass
class MonitoringConfig:
    prometheus_version: str = "2.45.0"
    grafana_version: str = "10.0.0"
    alertmanager_version: str = "0.25.0"
    retention_days: int = 30
    scrape_interval: str = "15s"

class MonitoringSetup:
    def __init__(self, config: MonitoringConfig):
        self.config = config
    
    def setup_prometheus(self):
        """Setup Prometheus monitoring"""
        prometheus_config = {
            "global": {
                "scrape_interval": self.config.scrape_interval,
                "evaluation_interval": "15s"
            },
            "alerting": {
                "alertmanagers": [
                    {
                        "static_configs": [
                            {
                                "targets": ["alertmanager:9093"]
                            }
                        ]
                    }
                ]
            },
            "rule_files": ["/etc/prometheus/rules/*.yml"],
            "scrape_configs": [
                {
                    "job_name": "prometheus",
                    "static_configs": [{"targets": ["localhost:9090"]}]
                },
                {
                    "job_name": "nodes",
                    "static_configs": [
                        {"targets": ["node1:9100", "node2:9100", "node3:9100"]}
                    ]
                },
                {
                    "job_name": "kubernetes-pods",
                    "kubernetes_sd_configs": [{
                        "role": "pod"
                    }],
                    "relabel_configs": [
                        {
                            "source_labels": ["__meta_kubernetes_pod_annotation_prometheus_io_scrape"],
                            "action": "keep",
                            "regex": "true"
                        }
                    ]
                }
            ]
        }
        
        # Write configuration
        with open("/etc/prometheus/prometheus.yml", 'w') as f:
            import yaml
            yaml.dump(prometheus_config, f)
    
    def setup_alerts(self):
        """Setup alerting rules"""
        alerts = {
            "groups": [
                {
                    "name": "infrastructure",
                    "rules": [
                        {
                            "alert": "HighCPUUsage",
                            "expr": "100 - (avg by(instance) (irate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100) > 80",
                            "for": "5m",
                            "labels": {
                                "severity": "warning"
                            },
                            "annotations": {
                                "summary": "High CPU usage on {{ $labels.instance }}",
                                "description": "CPU usage is above 80% for more than 5 minutes"
                            }
                        },
                        {
                            "alert": "DiskSpaceLow",
                            "expr": "(node_filesystem_avail_bytes{fstype!~\"tmpfs|overlay\"} / node_filesystem_size_bytes{fstype!~\"tmpfs|overlay\"}) * 100 < 20",
                            "for": "10m",
                            "labels": {
                                "severity": "critical"
                            },
                            "annotations": {
                                "summary": "Low disk space on {{ $labels.instance }}",
                                "description": "Disk space is below 20% on {{ $labels.mountpoint }}"
                            }
                        }
                    ]
                },
                {
                    "name": "application",
                    "rules": [
                        {
                            "alert": "HighErrorRate",
                            "expr": "rate(http_requests_total{status=~\"5..\"}[5m]) / rate(http_requests_total[5m]) > 0.05",
                            "for": "5m",
                            "labels": {
                                "severity": "critical"
                            },
                            "annotations": {
                                "summary": "High error rate for {{ $labels.job }}",
                                "description": "Error rate is above 5% for more than 5 minutes"
                            }
                        }
                    ]
                }
            ]
        }
        
        with open("/etc/prometheus/rules/alerts.yml", 'w') as f:
            import yaml
            yaml.dump(alerts, f)

# Main execution
if __name__ == "__main__":
    config = MonitoringConfig()
    setup = MonitoringSetup(config)
    setup.setup_prometheus()
    setup.setup_alerts()
    print("Monitoring setup complete!")
```

## Integration Points

### With GitOps
```yaml
# ArgoCD Application
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: production-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/company/k8s-manifests.git
    targetRevision: HEAD
    path: environments/production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
```

### With Chaos Engineering
```yaml
# Chaos Mesh configuration
apiVersion: chaos-mesh.org/v1alpha1
kind: PodChaos
metadata:
  name: network-delay-example
  namespace: chaos-testing
spec:
  action: latency
  mode: one
  selector:
    labelSelectors:
      app: api
  latency:
    latency: "100ms"
    correlation: "80"
    target: "network"
```

## Cost Optimization Strategies

### Auto-scaling
```yaml
# Horizontal Pod Autoscaler
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: api-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: api
  minReplicas: 3
  maxReplicas: 20
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

### Reserved Instances
```python
def optimize_reserved_instances():
    """Analyze and recommend reserved instances"""
    
    analysis = {
        "current_spend": 5000,
        "reserved_opportunity": 3500,
        "savings_percentage": 30,
        "recommendations": [
            {
                "instance_type": "m5.large",
                "current_usage": 85,
                "reserved_quantity": 10,
                "savings": 500
            },
            {
                "instance_type": "r5.xlarge",
                "current_usage": 92,
                "reserved_quantity": 5,
                "savings": 800
            }
        ]
    }
    
    return analysis
```

---

**Version:** 1.0  
**Created:** 2026-04-10  
**Author:** Oozu for Tuan  
**Status:** Active  
**Priority:** ⭐⭐⭐⭐⭐
