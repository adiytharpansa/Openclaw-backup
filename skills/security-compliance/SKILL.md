# Security-Compliance Skill

## Deskripsi
Advanced security analysis, penetration testing automation, compliance management, dan vulnerability management untuk memenuhi standar keamanan enterprise seperti OWASP, SOC2, GDPR, ISO27001, dan PCI-DSS.

## Kapan Digunakan
- Security audit & vulnerability assessment
- Compliance preparation (SOC2, GDPR, ISO27001, PCI-DSS)
- Penetration testing
- Security incident response
- Access control analysis
- Encryption implementation review
- Third-party security assessment
- Security policy generation
- Risk assessment & mitigation

## Fitur Utama

### 1. Vulnerability Management
```
├── Automated Penetration Testing
├── OWASP Top 10 Scanning
├── Dependency Vulnerability Check
├── Container Security Scanning
├── Infrastructure Security Assessment
├── API Security Testing
└── Web Application Firewall Analysis
```

### 2. Compliance Frameworks
```
├── SOC2 Type I & II
├── GDPR (General Data Protection)
├── ISO 27001
├── PCI-DSS
├── HIPAA
├── CCPA
├── FedRAMP
└── Custom compliance checks
```

### 3. Access Control
```
├── Identity & Access Management (IAM)
├── Role-Based Access Control (RBAC)
├── Multi-Factor Authentication (MFA)
├── Single Sign-On (SSO) Integration
├── Privileged Access Management
├── Access Audit & Logging
└── Just-In-Time Access
```

### 4. Security Operations
```
├── Security Information & Event Management (SIEM)
├── Intrusion Detection Systems (IDS)
├── Security Orchestration, Automation & Response (SOAR)
├── Incident Response Playbooks
├── Threat Intelligence Integration
└── Security Monitoring & Alerting
```

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                  SECURITY MASTER                          │
├──────────────────────────────────────────────────────────┤
│   Vulnerability │  Compliance  │  Access Control  │ SIEM │
└─────────┬─────────┴─────┬────────┴────────┬─────────┴────┘
          │               │                 │              │
    ┌─────▼──────┐ ┌─────▼─────┐  ┌────────▼──────┐  ┌───▼────┐
    │  Nuclei    │ |  OpenSCAP │  │  IAM Review   │  │ Splunk │
    │  OWASP ZAP │ |  Compliance│ │  RBAC Audit   │  │ ELK    │
    │  Trivy     │ |  Checker  │  │  MFA Config   │  │        │
    └────────────┘ └───────────┘  └───────────────┘  └────────┘
```

## Commands

### Vulnerability Assessment
```bash
# Full security scan
./scripts/security-compliance.sh scan --target https://app.example.com --full

# Web application scan
./scripts/security-compliance.sh scan web --url https://app.example.com --owasp

# Infrastructure scan
./scripts/security-compliance.sh scan infra --ip 192.168.1.1 --ports 1-65535

# Container security scan
./scripts/security-compliance.sh scan container --image myapp:latest --severity critical,high

# Dependency security scan
./scripts/security-compliance.sh scan deps --project ./src --language python
```

### Compliance Audit
```bash
# SOC2 compliance audit
./scripts/security-compliance.sh compliance --framework SOC2 --type II --generate-report

# GDPR compliance check
./scripts/security-compliance.sh compliance --framework GDPR --check data-protection

# ISO 27001 assessment
./scripts/security-compliance.sh compliance --framework ISO27001 --assess

# PCI-DSS readiness
./scripts/security-compliance.sh compliance --framework PCI-DSS --level 1

# Generate compliance report
./scripts/security-compliance.sh report --framework SOC2 --format pdf --output reports/soc2-2026.pdf
```

### Penetration Testing
```bash
# Automated pentest
./scripts/security-compliance.sh pentest --target https://app.example.com --duration 4h

# API security testing
./scripts/security-compliance.sh pentest api --endpoint /api/v1 --auth bearer --tests xss,sql-injection,auth-bypass

# Infrastructure pentest
./scripts/security-compliance.sh pentest infra --subnet 10.0.0.0/24 --services ssh,http,mysql

# Social engineering simulation
./scripts/security-compliance.sh pentest social --phishing --employees 100 --template finance
```

### Incident Response
```bash
# Security incident detection
./scripts/security-compliance.sh incident detect --monitor all --threshold high

# Incident triage
./scripts/security-compliance.sh incident triage --id INC-2026-001

# Contain threat
./scripts/security-compliance.sh incident contain --id INC-2026-001 --action isolate

# Investigate incident
./scripts/security-compliance.sh incident investigate --id INC-2026-001 --timeline

# Remediate vulnerability
./scripts/security-compliance.sh incident remediate --id INC-2026-001 --patch
```

### Access Control Audit
```bash
# IAM review
./scripts/security-compliance.sh access review --cloud aws --service iam

# RBAC analysis
./scripts/security-compliance.sh access rbac --service kubernetes --namespace production

# MFA configuration check
./scripts/security-compliance.sh access mfa --service all --compliance missing

# Privileged access audit
./scripts/security-compliance.sh access privileged --service all --review overdue
```

## Implementation

### Vulnerability Scanner
```python
#!/usr/bin/env python3
"""
Security-Compliance - Vulnerability Scanner Engine
Automated security testing and vulnerability assessment
"""

import subprocess
import json
from pathlib import Path
from typing import Dict, List, Optional
from dataclasses import dataclass, field
from datetime import datetime
from enum import Enum

class Severity(Enum):
    CRITICAL = "critical"
    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"
    INFO = "info"

class VulnerabilityType(Enum):
    OWASP_TOP_10 = "owasp"
    CVE = "cve"
    MISCONFIGURATION = "misconfiguration"
    HARDWARE = "hardware"
    NETWORK = "network"

@dataclass
class Vulnerability:
    id: str
    name: str
    description: str
    severity: Severity
    vulnerability_type: VulnerabilityType
    affected_component: str
    cvss_score: float
    cvss_vector: str
    remediation: str
    references: List[str]
    discovered_at: datetime

class VulnerabilityScanner:
    def __init__(self, target: str):
        self.target = target
        self.vulnerabilities: List[Vulnerability] = []
        self.scanners = {
            'nuclei': self._run_nuclei,
            'zap': self._run_zap,
            'trivy': self._run_trivy,
            'snyk': self._run_snyk
        }
    
    async def scan(self, scanner_types: List[str] = None):
        """Run comprehensive vulnerability scan"""
        if scanner_types is None:
            scanner_types = ['nuclei', 'zap', 'trivy']
        
        for scanner in scanner_types:
            if scanner in self.scanners:
                await self.scanners[scanner]()
        
        return self.vulnerabilities
    
    async def _run_nuclei(self):
        """Run Nuclei vulnerability scanner"""
        try:
            # Nuclei scan
            result = subprocess.run([
                'nuclei',
                '-u', self.target,
                '-t', 'OWASP-Top-10/',
                '-t', 'cves/',
                '-jsonl',
                '-o', '/tmp/nuclei-output.jsonl'
            ], capture_output=True, text=True)
            
            # Parse results
            with open('/tmp/nuclei-output.jsonl', 'r') as f:
                for line in f:
                    data = json.loads(line)
                    vuln = Vulnerability(
                        id=data.get('template-id', 'unknown'),
                        name=data.get('info', {}).get('name', 'Unknown'),
                        description=data.get('info', {}).get('description', ''),
                        severity=self._map_severity(data.get('info', {}).get('severity', '')),
                        vulnerability_type=VulnerabilityType.OWASP_TOP_10,
                        affected_component=data.get('match', ''),
                        cvss_score=data.get('info', {}).get('cvss-score', 0),
                        cvss_vector=data.get('info', {}).get('cvss-metrics', ''),
                        remediation=data.get('info', {}).get('remediation', ''),
                        references=data.get('info', {}).get('references', []),
                        discovered_at=datetime.now()
                    )
                    self.vulnerabilities.append(vuln)
        
        except Exception as e:
            print(f"Nuclei scan failed: {e}")
    
    async def _run_zap(self):
        """Run OWASP ZAP scanner"""
        try:
            # Start ZAP spider
            subprocess.run([
                'zap-cli',
                'spider', self.target,
                '--max-duration', '30'
            ], capture_output=True)
            
            # Run active scan
            subprocess.run([
                'zap-cli',
                'active-scan', self.target,
                '--risk', '1',
                '--alert-threshold', 'medium'
            ], capture_output=True)
            
            # Generate report
            subprocess.run([
                'zap-cli',
                'report', '-o', '/tmp/zap-report.json', '-f', 'json'
            ], capture_output=True)
            
            # Parse ZAP report
            self._parse_zap_report('/tmp/zap-report.json')
        
        except Exception as e:
            print(f"ZAP scan failed: {e}")
    
    def _parse_zap_report(self, report_path: str):
        """Parse OWASP ZAP report"""
        with open(report_path, 'r') as f:
            report = json.load(f)
        
        for alert in report.get('alerts', []):
            vuln = Vulnerability(
                id=alert.get('alertId', 'unknown'),
                name=alert.get('name', 'Unknown'),
                description=alert.get('description', ''),
                severity=self._map_severity(alert.get('risk', '')),
                vulnerability_type=VulnerabilityType.OWASP_TOP_10,
                affected_component=alert.get('uri', ''),
                cvss_score=alert.get('confidence', 0) / 3.0,
                cvss_vector='',
                remediation=alert.get('solution', ''),
                references=alert.get('otherinfo', []),
                discovered_at=datetime.now()
            )
            self.vulnerabilities.append(vuln)
    
    def _map_severity(self, severity: str) -> Severity:
        """Map vulnerability severity"""
        severity_map = {
            'critical': Severity.CRITICAL,
            'high': Severity.HIGH,
            'medium': Severity.MEDIUM,
            'low': Severity.LOW,
            'informational': Severity.INFO
        }
        return severity_map.get(severity.lower(), Severity.INFO)
    
    def generate_report(self, format: str = 'json') -> dict:
        """Generate vulnerability scan report"""
        report = {
            'scan_id': self._generate_scan_id(),
            'target': self.target,
            'timestamp': datetime.now().isoformat(),
            'summary': {
                'total_vulnerabilities': len(self.vulnerabilities),
                'by_severity': self._count_by_severity(),
                'by_type': self._count_by_type()
            },
            'vulnerabilities': [self._vuln_to_dict(v) for v in self.vulnerabilities],
            'recommendations': self._generate_recommendations()
        }
        
        if format == 'json':
            return json.dumps(report, indent=2)
        elif format == 'html':
            return self._generate_html_report(report)
        
        return report
    
    def _count_by_severity(self) -> Dict[Severity, int]:
        """Count vulnerabilities by severity"""
        counts = {s: 0 for s in Severity}
        for vuln in self.vulnerabilities:
            counts[vuln.severity] += 1
        return counts
    
    def _count_by_type(self) -> Dict[VulnerabilityType, int]:
        """Count vulnerabilities by type"""
        counts = {t: 0 for t in VulnerabilityType}
        for vuln in self.vulnerabilities:
            counts[vuln.vulnerability_type] += 1
        return counts
    
    def _generate_recommendations(self) -> List[str]:
        """Generate prioritized recommendations"""
        recommendations = []
        
        critical_vulns = [v for v in self.vulnerabilities if v.severity == Severity.CRITICAL]
        high_vulns = [v for v in self.vulnerabilities if v.severity == Severity.HIGH]
        
        if critical_vulns:
            recommendations.append(f"URGENT: Fix {len(critical_vulns)} critical vulnerabilities immediately")
        
        if high_vulns:
            recommendations.append(f"HIGH: Address {len(high_vulns)} high-severity issues within 48 hours")
        
        recommendations.append("Enable Web Application Firewall (WAF)")
        recommendations.append("Implement Content Security Policy (CSP)")
        recommendations.append("Enable HTTPS and HSTS")
        
        return recommendations
    
    def _generate_scan_id(self) -> str:
        """Generate unique scan ID"""
        return f"VULN-{datetime.now().strftime('%Y%m%d%H%M%S')}"
```

### Compliance Framework Implementation
```python
#!/usr/bin/env python3
"""
Security-Compliance - Compliance Framework Manager
Manages SOC2, GDPR, ISO27001, and other compliance frameworks
"""

from dataclasses import dataclass, field
from typing import Dict, List
from enum import Enum
from datetime import datetime

class Framework(Enum):
    SOC2 = "SOC2"
    GDPR = "GDPR"
    ISO27001 = "ISO27001"
    PCI_DSS = "PCI-DSS"
    HIPAA = "HIPAA"

@dataclass
class Control:
    id: str
    name: str
    description: str
    framework: str
    type: str  # Technical, Administrative, Physical
    requirement: str
    evidence_required: List[str]
    status: str  # compliant, non_compliant, partial, not_assessed

class ComplianceManager:
    def __init__(self, framework: Framework):
        self.framework = framework
        self.controls: List[Control] = []
        self.evidence: Dict[str, str] = {}
    
    def load_framework(self):
        """Load compliance controls for framework"""
        if self.framework == Framework.SOC2:
            self._load_soc2_controls()
        elif self.framework == Framework.GDPR:
            self._load_gdpr_controls()
        elif self.framework == Framework.ISO27001:
            self._load_iso27001_controls()
    
    def _load_soc2_controls(self):
        """Load SOC2 Type II controls"""
        self.controls = [
            Control(
                id="CC1.1",
                name="Control Environment",
                description="Organization demonstrates commitment to integrity and ethical values",
                framework="SOC2",
                type="Administrative",
                requirement="Document and communicate code of conduct",
                evidence_required=[
                    "Code of conduct document",
                    "Employee training records",
                    "Ethics training completion"
                ],
                status="not_assessed"
            ),
            Control(
                id="CC6.1",
                name="Logical and Physical Access Controls",
                description="Logical access security software",
                framework="SOC2",
                type="Technical",
                requirement="Implement access controls for software",
                evidence_required=[
                    "IAM policy",
                    "Access control matrix",
                    "MFA configuration",
                    "SSO logs"
                ],
                status="not_assessed"
            ),
            Control(
                id="CC7.2",
                name="System Operations",
                description="Detect and respond to security events",
                framework="SOC2",
                type="Technical",
                requirement="Monitor and log security events",
                evidence_required=[
                    "SIEM configuration",
                    "Incident response plan",
                    "Security monitoring logs",
                    "Alert rules"
                ],
                status="not_assessed"
            ),
            Control(
                id="CC8.1",
                name="Change Management",
                description="Authorize, design, develop, acquire, implement, document, maintain",
                framework="SOC2",
                type="Administrative",
                requirement="Implement change management process",
                evidence_required=[
                    "Change management policy",
                    "Change request logs",
                    "Code review records",
                    "Deployment logs"
                ],
                status="not_assessed"
            )
        ]
    
    def _load_gdpr_controls(self):
        """Load GDPR controls"""
        self.controls = [
            Control(
                id="GDPR-ART6",
                name="Lawful Basis for Processing",
                description="Processing must have lawful basis",
                framework="GDPR",
                type="Administrative",
                requirement="Document lawful basis for each data processing activity",
                evidence_required=[
                    "Data processing register",
                    "Lawful basis assessment",
                    "Consent records"
                ],
                status="not_assessed"
            ),
            Control(
                id="GDPR-ART32",
                name="Security of Processing",
                description="Implement appropriate technical and organizational measures",
                framework="GDPR",
                type="Technical",
                requirement="Encryption, pseudonymization, access controls",
                evidence_required=[
                    "Encryption policy",
                    "Access control configuration",
                    "Security assessment",
                    "Data protection impact assessment"
                ],
                status="not_assessed"
            )
        ]
    
    def assess_control(self, control_id: str, evidence: Dict[str, str]) -> bool:
        """Assess control compliance with provided evidence"""
        control = next((c for c in self.controls if c.id == control_id), None)
        if not control:
            raise ValueError(f"Control {control_id} not found")
        
        # Check if all required evidence is provided
        missing = set(control.evidence_required) - set(evidence.keys())
        
        if missing:
            control.status = "partial"
            return False
        
        # Validate evidence (simple check)
        for evidence_item in control.evidence_required:
            if not evidence[evidence_item]:
                control.status = "non_compliant"
                return False
        
        control.status = "compliant"
        return True
    
    def generate_compliance_report(self) -> dict:
        """Generate compliance assessment report"""
        total_controls = len(self.controls)
        compliant = sum(1 for c in self.controls if c.status == "compliant")
        partial = sum(1 for c in self.controls if c.status == "partial")
        non_compliant = sum(1 for c in self.controls if c.status == "non_compliant")
        
        report = {
            'report_id': self._generate_report_id(),
            'framework': self.framework.value,
            'generated_at': datetime.now().isoformat(),
            'summary': {
                'total_controls': total_controls,
                'compliant': compliant,
                'partial': partial,
                'non_compliant': non_compliant,
                'compliance_percentage': (compliant / total_controls * 100) if total_controls > 0 else 0
            },
            'controls': [
                {
                    'id': c.id,
                    'name': c.name,
                    'status': c.status,
                    'evidence_status': self._check_evidence_status(c)
                }
                for c in self.controls
            ],
            'gaps': self._identify_gaps(),
            'recommendations': self._generate_recommendations()
        }
        
        return report
    
    def _check_evidence_status(self, control: Control) -> str:
        """Check evidence status for control"""
        missing = set(control.evidence_required) - set(self.evidence.keys())
        if missing:
            return f"Missing: {', '.join(missing)}"
        return "Complete"
    
    def _identify_gaps(self) -> List[dict]:
        """Identify compliance gaps"""
        gaps = []
        for control in self.controls:
            if control.status in ['non_compliant', 'partial']:
                gaps.append({
                    'control_id': control.id,
                    'control_name': control.name,
                    'status': control.status,
                    'missing_evidence': set(control.evidence_required) - set(self.evidence.keys())
                })
        return gaps
    
    def _generate_report_id(self) -> str:
        """Generate unique report ID"""
        return f"COMP-{self.framework.value}-{datetime.now().strftime('%Y%m%d')}"
```

## Integration Points

### With SIEM
```yaml
# Splunk Universal Forwarder Configuration
[default]
server = https://splunk:8089
username = forwarder
password = secure_password

[monitor:///var/log/auth.log]
disabled = false
index = security

[monitor:///var/log/syslog]
disabled = false
index = security
```

### With SOAR
```python
# Incident Response Playbook
incident_playbook = {
    "name": "Data Breach Response",
    "trigger": "suspicious_data_access",
    "steps": [
        {
            "action": "isolate_system",
            "target": "{{affected_system}}",
            "timeout": 300
        },
        {
            "action": "preserve_evidence",
            "destination": "forensic_storage",
            "method": "disk_image"
        },
        {
            "action": "notify_soc",
            "channels": ["slack", "email"],
            "severity": "critical"
        },
        {
            "action": "investigate",
            "tools": ["siem_query", "endpoint_detection"],
            "timeframe": "24h"
        }
    ]
}
```

## Security Best Practices

### Encryption Standards
```yaml
encryption:
  data_at_rest:
    algorithm: AES-256-GCM
    key_rotation: 90 days
    kms: AWS KMS / Azure Key Vault
  
  data_in_transit:
    min_tls_version: "1.3"
    cipher_suites:
      - TLS_AES_256_GCM_SHA384
      - TLS_CHACHA20_POLY1305_SHA256
  
  key_management:
    rotation_policy: automated
    backup: encrypted
    access: rbac
```

### Access Control Policy
```yaml
access_control:
  authentication:
    mfa_required: true
    mfa_methods:
      - TOTP
      - FIDO2
      - SMS
    password_policy:
      min_length: 12
      require_uppercase: true
      require_lowercase: true
      require_numbers: true
      require_special: true
      max_age: 90 days
  
  authorization:
    model: RBAC
    least_privilege: true
    just_in_time: true
    approval_required: true
    review_frequency: quarterly
```

---

**Version:** 1.0  
**Created:** 2026-04-10  
**Author:** Oozu for Tuan  
**Status:** Active  
**Priority:** ⭐⭐⭐⭐⭐
