---
name: security-scanner
description: Security auditing and vulnerability scanning for YOUR systems only. Use when you need to check code, configurations, or systems for security vulnerabilities. This skill helps identify security issues, verify compliance with best practices, and provide remediation guidance for your own projects.
---

# Security Scanner

**Security auditor** untuk sistem kamu sendiri! 🔐

## ⚠️ IMPORTANT: LEGAL USE ONLY

**This skill is for:**
- ✅ Scanning YOUR OWN code & systems
- ✅ Testing systems you own/manage
- ✅ Security research with permission
- ✅ Compliance checking

**NOT for:**
- ❌ Unauthorized scanning
- ❌ Hacking other people's systems
- ❌ Exploiting vulnerabilities
- ❌ Illegal security testing

---

## 🎯 Core Function

Skill ini **scan security** untuk kamu:

1. **Code Security** - Check code for vulnerabilities
2. **Configuration** - Review security settings
3. **Dependencies** - Check for vulnerable packages
4. **Compliance** - Verify security standards
5. **Reports** - Generate detailed findings
6. **Remediation** - Provide fix recommendations

## 🔍 Security Check Areas

### 1. Code Security
```
Check for:
- SQL injection vulnerabilities
- XSS (Cross-Site Scripting)
- CSRF (Cross-Site Request Forgery)
- Insecure direct object references
- Broken authentication
- Sensitive data exposure
- XXE (XML External Entity)
- Insecure deserialization
- Security misconfigurations
- Insufficient logging & monitoring
```

### 2. Dependency Security
```
Check for:
- Outdated packages
- Known vulnerabilities (CVE)
- End-of-life dependencies
- Suspicious package sources
- License compliance issues
- Malicious packages
```

### 3. Configuration Security
```
Check for:
- Weak passwords/policies
- Missing HTTPS/TLS
- Overly permissive CORS
- Debug mode in production
- Exposed sensitive endpoints
- Default credentials
- Weak encryption
- Missing security headers
```

### 4. Authentication & Authorization
```
Check for:
- Strong password policies
- Multi-factor authentication
- Session management security
- Rate limiting
- Account lockout policies
- JWT security best practices
- OAuth security
```

### 5. Data Security
```
Check for:
- Data encryption at rest
- Data encryption in transit
- Proper data masking
- Secure data storage
- Data retention policies
- GDPR/compliance requirements
```

## 📋 OWASP Top 10 Checklist

### A1: Broken Access Control
```
CHECK:
✓ Authorization checks on all endpoints
✓ No directory listing enabled
✓ No unauthorized data access
✓ Proper access control lists

FINDINGS: [List any issues]
RECOMMENDATION: Implement proper access control
```

### A2: Cryptographic Failures
```
CHECK:
✓ All data encrypted with strong algorithms
✓ TLS 1.2+ for all communications
✓ Secure key storage
✓ No hardcoded keys

FINDINGS: [List any issues]
RECOMMENDATION: Upgrade encryption standards
```

### A3: Injection
```
CHECK:
✓ All user input validated
✓ Parameterized queries used
✓ No raw SQL in code
✓ Input sanitization applied

FINDINGS: [List any issues]
RECOMMENDATION: Use prepared statements
```

### A4: Insecure Design
```
CHECK:
✓ Security by design implemented
✓ Threat modeling done
✓ Security requirements defined
✓ Attack surface minimized

FINDINGS: [List any issues]
RECOMMENDATION: Review security design
```

### A5: Security Misconfiguration
```
CHECK:
✓ No debug mode in production
✓ Default credentials changed
✓ Unnecessary services disabled
✓ Security headers set

FINDINGS: [List any issues]
RECOMMENDATION: Harden configuration
```

### A6: Vulnerable Components
```
CHECK:
✓ All dependencies updated
✓ Known CVEs checked
✓ End-of-life dependencies removed
✓ Dependency auditing in place

FINDINGS: [List any issues]
RECOMMENDATION: Update vulnerable packages
```

### A7: Authentication Failures
```
CHECK:
✓ Multi-factor authentication
✓ Strong password policies
✓ Session timeouts configured
✓ Account lockout policies

FINDINGS: [List any issues]
RECOMMENDATION: Strengthen authentication
```

### A8: Software & Data Integrity
```
CHECK:
✓ Code signing implemented
✓ Software update verification
✓ Integrity checks in place
✓ Third-party dependencies trusted

FINDINGS: [List any issues]
RECOMMENDATION: Implement integrity checks
```

### A9: Security Logging
```
CHECK:
✓ Comprehensive logging enabled
✓ Logs protected from tampering
✓ Sensitive data not logged
✓ Log monitoring active

FINDINGS: [List any issues]
RECOMMENDATION: Improve logging
```

### A10: Server-Side Request Forgery
```
CHECK:
✓ Outbound requests controlled
✓ URL validation implemented
✓ Internal network protected
✓ SSRF protections active

FINDINGS: [List any issues]
RECOMMENDATION: Implement SSRF protection
```

## 🔧 Commands

### `/security-scan <target>`
Scan a target (code, file, project):
```
SECURITY SCAN INITIATED

Target: [code/file/project]
Scope: [full/partial]
Depth: [basic/thorough]

Scanning...
✓ Code analysis complete
✓ Dependency check complete
✓ Configuration review complete
✓ Compliance check complete

FINDINGS:
- Critical: [X]
- High: [Y]
- Medium: [Z]
- Low: [W]

Report generated: security-scan-report.md
```

### `/security-check <component>`
Check specific component:
```
SECURITY CHECK: [component]

Component: Database connection
✓ Encryption: Enabled
✓ Authentication: Secure
✓ Connection pooling: Configured
✓ SQL injection: Protected

Status: ✅ SECURE
```

### `/security-dependencies`
Check dependencies:
```
DEPENDENCY SECURITY CHECK

Packages checked: [X]
Vulnerabilities found: [Y]
- Critical: [N]
- High: [N]
- Medium: [N]
- Low: [N]

Action: Update [package] to [version]
```

### `/security-compliance <standard>`
Check compliance:
```
COMPLIANCE CHECK: [standard]

Standard: OWASP Top 10
- A1: ✓ PASS
- A2: ⚠️ NEEDS ATTENTION
- A3: ✓ PASS
- A4: ✓ PASS
- A5: ✓ PASS
- A6: ✓ PASS
- A7: ✓ PASS
- A8: ⚠️ NEEDS ATTENTION
- A9: ✓ PASS
- A10: ✓ PASS

Overall: 80% compliant
```

### `/security-fix`
Get fix recommendations:
```
SECURITY FIXES AVAILABLE

Critical Issues (2):
1. SQL injection in login
   Fix: Use parameterized queries
   File: login.php
   Lines: 45-52

2. Weak password policy
   Fix: Enforce strong passwords
   Config: auth.json

High Issues (3):
[More recommendations]

Total fixes needed: [X]
```

### `/security-report`
Generate security report:
```
SECURITY REPORT

Scan date: [timestamp]
System: [name/version]
Findings:
- Critical: [X]
- High: [Y]
- Medium: [Z]
- Low: [W]

Overall score: [XX/100]
Security level: [High/Medium/Low]

Report: security-report-[date].md
```

## 📊 Security Score

```
SECURITY SCORECARD:

Code Quality: 85%
Dependencv Security: 90%
Configuration: 75%
Authentication: 80%
Data Protection: 88%
Logging: 70%

OVERALL: 81% ✅ GOOD

Rating: A-
Recommendation: Address high-priority items
```

## 🎯 Common Security Issues

### Issue 1: SQL Injection
```
VULNERABLE CODE:
query = "SELECT * FROM users WHERE id = " + user_input

FIX:
query = "SELECT * FROM users WHERE id = ?"
cursor.execute(query, (user_input,))

STATUS: ✓ FIXED
```

### Issue 2: XSS Vulnerability
```
VULNERABLE CODE:
<div>{userInput}</div>

FIX:
<div>{escapeHtml(userInput)}</div>

STATUS: ✓ FIXED
```

### Issue 3: Hardcoded Password
```
VULNERABLE CODE:
password = "secret123"

FIX:
password = os.environ.get('DB_PASSWORD')
# Use environment variables or secrets manager

STATUS: ✓ FIXED
```

## 📝 Security Best Practices

### DO:
- ✅ Scan code regularly
- ✅ Keep dependencies updated
- ✅ Use environment variables for secrets
- ✅ Implement proper authentication
- ✅ Enable logging & monitoring
- ✅ Follow security best practices
- ✅ Conduct regular security audits

### DON'T:
- ❌ Hardcode secrets
- ❌ Use default passwords
- ❌ Skip dependency updates
- ❌ Disable security features
- ❌ Ignore security warnings
- ❌ Use outdated libraries

## 🚀 Integration

Works with:
- **Code reviewers** - For code scanning
- **Dependency scanners** - Package security
- **Compliance checkers** - Standards validation
- **Auto-fix tools** - Remediation
- **CI/CD pipelines** - Automated security

---

**Legal Use Only!** 🔐  
**For YOUR systems only!** ✅

**Status:** Security Scanner READY  
**Scope:** Your systems only  
**Compliance:** OWASP Top 10
