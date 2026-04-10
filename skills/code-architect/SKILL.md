# Code-Architect Skill

## Deskripsi
Advanced code analysis, refactoring, dan architecture design dengan comprehensive code review, security scanning, performance optimization, dan automatic refactoring capabilities.

## Kapan Digunakan
- Code refactoring besar atau complex migration
- Architecture redesign & optimization
- Performance bottleneck identification
- Security audit & vulnerability fix
- Technical debt reduction
- Code quality improvement
- Dependency analysis & cleanup
- Scalability assessment

## Fitur Utama

### 1. Advanced Code Analysis
```
├── Syntax & Semantics
├── Design Patterns
├── Anti-Pattern Detection
├── Code Smells
├── Complexity Analysis
├── Coupling & Cohesion
└── Documentation Coverage
```

### 2. Security Analysis
```
├── OWASP Top 10 Scanning
├── Hardcoded Credentials Detection
├── SQL Injection Prevention
├── XSS Vulnerability Check
├── CSRF Protection Audit
├── Authentication Flow Review
├── Encryption Review
└── Dependency Vulnerability Scan
```

### 3. Performance Optimization
```
├── Bottleneck Detection
├── Algorithm Complexity Analysis
├── Memory Leak Detection
├── Database Query Optimization
├── Caching Strategy Review
├── Async/Concurrency Analysis
├── Resource Usage Profiling
└── Scalability Assessment
```

### 4. Refactoring Engine
```
├── Automatic Code Refactoring
├── Design Pattern Application
├── API Simplification
├── Module Restructuring
├── Code Deduplication
├── Naming Convention Fixes
├── Test Coverage Improvement
└── Legacy Code Modernization
```

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    CODE ANALYZER                          │
├──────────────────────────────────────────────────────────┤
│  Static Analysis  │  Security │  Performance  │  Quality │
└────────────────────┬───────────┴─────┬─────────┴─────┬────┘
                     │                 │               │
          ┌──────────▼────────┐ ┌─────▼──────┐ ┌──────▼──────┐
          │   Findings Report │ │ Recommendations │ │ Action Plan│
          └──────────┬────────┘ └─────┬──────┘ └──────┬──────┘
                     │                 │               │
          ┌──────────▼─────────────────▼───────────────▼──────┐
          │             REFACTORING ENGINE                     │
          │  Auto-Fix | Manual Review | Test Validation       │
          └───────────────────────────────────────────────────┘
```

## Commands

### Code Analysis
```bash
# Analyze entire codebase
./scripts/code-architect.sh analyze --path ./src --full

# Analyze specific file
./scripts/code-architect.sh analyze ./src/api.py --detailed

# Security scan
./scripts/code-architect.sh security --path ./src --strict

# Performance audit
./scripts/code-architect.sh performance --path ./src --profile

# Complexity analysis
./scripts/code-architect.sh metrics --path ./src
```

### Refactoring
```bash
# Automatic refactoring
./scripts/code-architect.sh refactor --path ./src --auto

# Specific refactoring
./scripts/code-architect.sh refactor --type deduplication
./scripts/code-architect.sh refactor --type security-fix
./scripts/code-architect.sh refactor --type performance

# Preview changes
./scripts/code-architect.sh refactor --path ./src --preview

# Apply refactoring with review
./scripts/code-architect.sh refactor --path ./src --review
```

### Architecture Review
```bash
# Full architecture review
./scripts/code-architect.sh architecture --path ./src --report

# Dependency analysis
./scripts/code-architect.sh dependencies --path ./src --graph

# Scalability assessment
./scripts/code-architect.sh scalability --path ./src --load 1000

# Technical debt assessment
./scripts/code-architect.sh debt --path ./src --estimate
```

### Generate Reports
```bash
# Generate full report
./scripts/code-architect.sh report --path ./src --format html

# Security report
./scripts/code-architect.sh report --type security --format pdf

# Performance report
./scripts/code-architect.sh report --type performance --format json

# Executive summary
./scripts/code-architect.sh report --type summary --stakeholders
```

## Implementation

### Main Analysis Engine
```python
#!/usr/bin/env python3
"""
Code Architect - Advanced Code Analysis Engine
Performs comprehensive code analysis, security scanning, and refactoring
"""

import ast
import re
import subprocess
from pathlib import Path
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass, field
from enum import Enum
from datetime import datetime

class Severity(Enum):
    CRITICAL = "critical"
    HIGH = "high"
    MEDIUM = "medium"
    LOW = "low"
    INFO = "info"

class IssueType(Enum):
    SECURITY = "security"
    PERFORMANCE = "performance"
    QUALITY = "quality"
    MAINTAINABILITY = "maintainability"
    SCALABILITY = "scalability"

@dataclass
class CodeIssue:
    file: str
    line: int
    column: int
    severity: Severity
    issue_type: IssueType
    message: str
    suggestion: str
    code_snippet: str
    confidence: float

@dataclass
class AnalysisReport:
    total_files: int
    total_issues: int
    issues_by_severity: Dict[Severity, int]
    issues_by_type: Dict[IssueType, int]
    top_issues: List[CodeIssue]
    code_metrics: Dict[str, any]
    recommendations: List[str]
    refactoring_plan: List[str]

class CodeAnalyzer:
    def __init__(self, codebase_path: str):
        self.codebase = Path(codebase_path)
        self.issues: List[CodeIssue] = []
        self.metrics: Dict[str, any] = {}
        
    def analyze(self) -> AnalysisReport:
        """Run full analysis"""
        self._scan_files()
        self._check_security()
        self._analyze_performance()
        self._check_quality()
        self._calculate_metrics()
        return self._generate_report()
    
    def _scan_files(self):
        """Scan all source files"""
        extensions = ['.py', '.js', '.ts', '.java', '.go', '.rs']
        for ext in extensions:
            for file in self.codebase.rglob(f'*{ext}'):
                self._analyze_file(file)
    
    def _analyze_file(self, file: Path):
        """Analyze single file"""
        try:
            with open(file, 'r') as f:
                content = f.read()
                lines = content.split('\n')
            
            # Syntax analysis
            self._check_syntax(file, content)
            
            # Security checks
            self._check_security_vulnerabilities(file, content, lines)
            
            # Performance checks
            self._check_performance_issues(file, content, lines)
            
            # Quality checks
            self._check_code_quality(file, content, lines)
            
        except Exception as e:
            self.issues.append(CodeIssue(
                file=str(file),
                line=0,
                column=0,
                severity=Severity.CRITICAL,
                issue_type=IssueType.QUALITY,
                message=f"Cannot read file: {e}",
                suggestion="Check file permissions",
                code_snippet="",
                confidence=1.0
            ))
    
    def _check_security_vulnerabilities(self, file: Path, content: str, lines: List[str]):
        """Check for security vulnerabilities"""
        
        # Hardcoded credentials
        patterns = {
            'API_KEY': r'[Aa][Pp][Ii]_[Kk][Ee][Yy].*[:=].*["\'][A-Za-z0-9]{16,}',
            'PASSWORD': r'[Pp][Aa][Ss][Ss]word.*[:=].*["\'][^"\']+',
            'SECRET': r'[Ss]ecret.*[:=].*["\'][^"\']+',
            'AWS_KEY': r'AKIA[0-9A-Z]{16}',
            'PRIVATE_KEY': r'-----BEGIN (RSA |DSA |EC |OPENSSH )?PRIVATE KEY-----'
        }
        
        for pattern_name, pattern in patterns.items():
            matches = re.finditer(pattern, content)
            for match in matches:
                line_num = content[:match.start()].count('\n') + 1
                self.issues.append(CodeIssue(
                    file=str(file),
                    line=line_num,
                    column=match.start(),
                    severity=Severity.CRITICAL,
                    issue_type=IssueType.SECURITY,
                    message=f"Potential {pattern_name} detected",
                    suggestion="Use environment variables or secret manager",
                    code_snippet=lines[line_num - 1].strip(),
                    confidence=0.9
                ))
        
        # SQL Injection
        if re.search(r'\.execute\(.*\+', content):
            self.issues.append(CodeIssue(
                file=str(file),
                line=0,
                column=0,
                severity=Severity.CRITICAL,
                issue_type=IssueType.SECURITY,
                message="Potential SQL injection - string concatenation in query",
                suggestion="Use parameterized queries",
                code_snippet="",
                confidence=0.8
            ))
    
    def _check_performance_issues(self, file: Path, content: str, lines: List[str]):
        """Check for performance issues"""
        
        # N+1 query detection
        if re.search(r'for\s+\w+\s+in\s+:.*\.query\(\)', content, re.DOTALL):
            self.issues.append(CodeIssue(
                file=str(file),
                line=0,
                column=0,
                severity=Severity.HIGH,
                issue_type=IssueType.PERFORMANCE,
                message="Potential N+1 query pattern",
                suggestion="Use batch loading or join",
                code_snippet="",
                confidence=0.75
            ))
        
        # Inefficient string concatenation in loops
        if re.search(r'[\w]+\s*\+=\s*["\'][^\']+', content):
            self.issues.append(CodeIssue(
                file=str(file),
                line=0,
                column=0,
                severity=Severity.MEDIUM,
                issue_type=IssueType.PERFORMANCE,
                message="Inefficient string concatenation in loop",
                suggestion="Use list comprehension and join",
                code_snippet="",
                confidence=0.8
            ))
    
    def _check_code_quality(self, file: Path, content: str, lines: List[str]):
        """Check code quality issues"""
        
        # Long functions
        for i, line in enumerate(lines):
            if re.match(r'^\s*def\s+\w+', line):
                # Count lines in function
                func_start = i
                func_end = i + 1
                while func_end < len(lines) and (lines[func_end].startswith('    ') or lines[func_end].strip() == ''):
                    func_end += 1
                func_length = func_end - func_start
                
                if func_length > 50:
                    self.issues.append(CodeIssue(
                        file=str(file),
                        line=func_start + 1,
                        column=0,
                        severity=Severity.MEDIUM,
                        issue_type=IssueType.QUALITY,
                        message=f"Function too long: {func_length} lines",
                        suggestion="Break into smaller functions",
                        code_snippet=line.strip(),
                        confidence=0.9
                    ))
        
        # Magic numbers
        magic_pattern = r'(?<!=|==|<=|>=|!=)\b\d{2,}\b(?!\.)'
        for i, line in enumerate(lines):
            if re.search(magic_pattern, line) and 'def ' not in line and '#' not in line:
                self.issues.append(CodeIssue(
                    file=str(file),
                    line=i + 1,
                    column=0,
                    severity=Severity.LOW,
                    issue_type=IssueType.QUALITY,
                    message="Magic number detected",
                    suggestion="Define as named constant",
                    code_snippet=line.strip(),
                    confidence=0.85
                ))
    
    def _calculate_metrics(self):
        """Calculate code metrics"""
        metrics = {
            'total_lines': 0,
            'comment_lines': 0,
            'blank_lines': 0,
            'functions': 0,
            'classes': 0,
            'complexity_score': 0
        }
        
        for ext in ['.py', '.js', '.ts']:
            for file in self.codebase.rglob(f'*{ext}'):
                with open(file, 'r') as f:
                    content = f.read()
                    lines = content.split('\n')
                    
                    metrics['total_lines'] += len(lines)
                    metrics['comment_lines'] += sum(1 for l in lines if l.strip().startswith(('#', '//', '*')))
                    metrics['blank_lines'] += sum(1 for l in lines if not l.strip())
                    metrics['functions'] += len(re.findall(r'\bdef\s+\w+|\bfunction\s+\w+', content))
                    metrics['classes'] += len(re.findall(r'\bclass\s+\w+', content))
        
        self.metrics = metrics
    
    def _generate_report(self) -> AnalysisReport:
        """Generate comprehensive analysis report"""
        report = AnalysisReport(
            total_files=len(list(self.codebase.rglob('*'))),
            total_issues=len(self.issues),
            issues_by_severity=self._count_by_severity(),
            issues_by_type=self._count_by_type(),
            top_issues=sorted(self.issues, key=lambda x: (
                {'critical': 0, 'high': 1, 'medium': 2, 'low': 3, 'info': 4}[x.severity.value],
                x.confidence
            ))[:20],
            code_metrics=self.metrics,
            recommendations=self._generate_recommendations(),
            refactoring_plan=self._generate_refactoring_plan()
        )
        return report
    
    def _count_by_severity(self) -> Dict[Severity, int]:
        counts = {s: 0 for s in Severity}
        for issue in self.issues:
            counts[issue.severity] += 1
        return counts
    
    def _count_by_type(self) -> Dict[IssueType, int]:
        counts = {t: 0 for t in IssueType}
        for issue in self.issues:
            counts[issue.issue_type] += 1
        return counts
    
    def _generate_recommendations(self) -> List[str]:
        """Generate prioritized recommendations"""
        recommendations = []
        
        # Critical security issues
        if self.issues_by_severity.get(Severity.CRITICAL, 0) > 0:
            recommendations.append("URGENT: Fix all critical security vulnerabilities first")
        
        # High complexity
        if self.metrics.get('complexity_score', 0) > 100:
            recommendations.append("Consider breaking down complex modules")
        
        # Low test coverage
        recommendations.append("Improve test coverage to at least 80%")
        
        return recommendations
    
    def _generate_refactoring_plan(self) -> List[str]:
        """Generate step-by-step refactoring plan"""
        plan = []
        
        # Phase 1: Security fixes
        security_issues = [i for i in self.issues if i.issue_type == IssueType.SECURITY and i.severity == Severity.CRITICAL]
        if security_issues:
            plan.append("Phase 1: Fix critical security vulnerabilities")
        
        # Phase 2: Performance
        perf_issues = [i for i in self.issues if i.issue_type == IssueType.PERFORMANCE and i.severity in [Severity.CRITICAL, Severity.HIGH]]
        if perf_issues:
            plan.append("Phase 2: Optimize performance bottlenecks")
        
        # Phase 3: Code quality
        plan.append("Phase 3: Improve code quality and maintainability")
        
        return plan

# Main execution
if __name__ == "__main__":
    analyzer = CodeAnalyzer("./src")
    report = analyzer.analyze()
    print(f"Analyzed {report.total_files} files, found {report.total_issues} issues")
    print(f"By severity: {report.issues_by_severity}")
```

## Integration Points

### With CI/CD
```yaml
# GitHub Actions
name: Code Architecture Check
on: [push, pull_request]
jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run Code Architect
        run: ./scripts/code-architect.sh analyze --path ./src --format json
      - name: Upload Report
        uses: actions/upload-artifact@v3
        with:
          name: code-report
          path: reports/
```

### With Git Hooks
```bash
# pre-commit hook
#!/bin/bash
./scripts/code-architect.sh analyze --path ./src --auto-fix
git add -A
```

## Report Formats

### HTML Report
```html
<!DOCTYPE html>
<html>
<head>
    <title>Code Architecture Report</title>
</head>
<body>
    <h1>Analysis Summary</h1>
    <div class="metrics">
        <h2>Code Metrics</h2>
        <ul>
            <li>Total Files: {{ total_files }}</li>
            <li>Total Lines: {{ total_lines }}</li>
            <li>Issues Found: {{ total_issues }}</li>
        </ul>
    </div>
    <h2>Issues by Severity</h2>
    <table>
        <tr><th>Severity</th><th>Count</th></tr>
        {% for severity, count in issues_by_severity.items() %}
        <tr><td>{{ severity }}</td><td>{{ count }}</td></tr>
        {% endfor %}
    </table>
</body>
</html>
```

### JSON Report
```json
{
  "report_id": "uuid",
  "generated_at": "ISO8601",
  "codebase_path": "./src",
  "summary": {
    "total_files": 156,
    "total_lines": 45000,
    "total_issues": 234
  },
  "issues": [...],
  "metrics": {...},
  "recommendations": [...],
  "refactoring_plan": [...]
}
```

---

**Version:** 1.0  
**Created:** 2026-04-10  
**Author:** Oozu for Tuan  
**Status:** Active  
**Priority:** ⭐⭐⭐⭐⭐
