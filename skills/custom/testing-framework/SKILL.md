---
name: testing-framework
description: Comprehensive testing automation for code quality. Use when you need to generate tests, run test suites, analyze coverage, integrate with CI/CD, and ensure code quality. This skill enables automatic test generation, comprehensive test coverage, performance testing, and security testing.
---

# Testing Framework

**Testing expert** yang ensure code quality! 🧪

## 🎯 Core Function

Skill ini **automate testing** secara comprehensive:

1. **Test Generation** - Auto-generate tests from code
2. **Test Execution** - Run test suites
3. **Coverage Analysis** - Measure test coverage
4. **Performance Testing** - Check performance
5. **Security Testing** - Find security issues
6. **CI/CD Integration** - Automated testing pipeline

## 🧪 Test Types Supported

### Unit Tests
```
Purpose: Test individual functions/components

Coverage:
✓ Function logic
✓ Input/output
✓ Edge cases
✓ Error handling

Framework: Jest, Mocha, pytest, etc.
```

### Integration Tests
```
Purpose: Test component interactions

Coverage:
✓ API endpoints
✓ Database operations
✓ External service calls
✓ Data flow

Framework: Jest, Supertest, pytest
```

### End-to-End Tests
```
Purpose: Test complete user flows

Coverage:
✓ User workflows
✓ Complete transactions
✓ UI interactions
✓ Browser compatibility

Framework: Cypress, Playwright, Selenium
```

### Performance Tests
```
Purpose: Test speed & efficiency

Coverage:
✓ Response time
✓ Throughput
✓ Resource usage
✓ Scalability

Tools: JMeter, k6, Lighthouse
```

### Security Tests
```
Purpose: Find security vulnerabilities

Coverage:
✓ SQL injection
✓ XSS vulnerabilities
✓ Authentication bypass
✓ Authorization issues

Tools: OWASP ZAP, Burp Suite
```

## 🔧 Testing Commands

### `/test-generate <file>`
Generate tests for code:
```
TEST GENERATION: [file]

Analysis:
- Functions: [N]
- Lines of code: [X]
- Complexity: [Medium]

Generating tests...
✓ Unit tests created: [N]
✓ Integration tests: [M]
✓ Test coverage: [XX%]

Tests saved: tests/[file].test.js
Status: Ready to run
```

### `/test-run [options]`
Run test suite:
```
TEST EXECUTION:

Running tests...
✓ [X] tests passed
✗ [Y] tests failed
⚠️ [Z] tests skipped

Coverage:
- Lines: [XX%]
- Branches: [XX%]
- Functions: [XX%]
- Statements: [XX%]

Result: [PASS/FAIL]
Time: [X seconds]
```

### `/test-coverage`
View test coverage:
```
TEST COVERAGE REPORT

Overall: [XX%]

By file:
- file1.js: [XX]% ✓
- file2.js: [XX]% ⚠️
- file3.js: [XX]% ✗

By category:
- Critical: [XX]%
- Important: [XX]%
- Optional: [XX]%

Recommendations:
- Add tests for [file]
- Increase coverage on [module]
- Target: 90%+ coverage
```

### `/test-performance`
Run performance tests:
```
PERFORMANCE TESTING:

Load test results:
- Requests/sec: [X]
- Response time (avg): [X ms]
- Response time (95th percentile): [X ms]
- Response time (99th percentile): [X ms]
- Error rate: [X%]

Bottlenecks identified:
1. [Issue 1]
2. [Issue 2]

Recommendations:
- Optimize [component]
- Add caching
- Scale [service]
```

### `/test-security`
Run security tests:
```
SECURITY TESTING:

Vulnerabilities found:
- Critical: [X]
- High: [Y]
- Medium: [Z]
- Low: [W]

Security issues:
1. [Issue 1] - Fix: [recommendation]
2. [Issue 2] - Fix: [recommendation]

Compliance:
✓ OWASP Top 10 check
✓ Input validation
✓ Authentication checks
✓ Authorization checks

Report: security-test-report.md
```

### `/test-ci`
Configure CI/CD integration:
```
CI/CD CONFIGURATION:

Tests configured:
✓ Unit tests: Run on every commit
✓ Integration tests: Run on PR
✓ Performance tests: Run daily
✓ Security tests: Run weekly

Pipeline:
1. Push → Run unit tests
2. PR → Run integration tests
3. Merge → Deploy to staging
4. Staging → Full test suite
5. Production → Monitor

Status: ✅ Configured
```

## 📊 Test Coverage

### Coverage Targets:
```
Minimum Standards:
- Critical code: 95%+
- Important code: 90%+
- Standard code: 80%+
- Utility code: 70%+

Target: 90%+ overall
Goal: 95%+ on critical paths
```

### Coverage Metrics:
```
COVERAGE METRICS:

Lines: [XX]%
Branches: [XX]%
Functions: [XX]%
Statements: [XX]%

By category:
- Business logic: [XX]%
- Utilities: [XX]%
- Configuration: [XX]%
- Tests: [XX]%

Trend: ↗️ [X]% from last run
```

## 🧪 Test Generation

### Auto-Generate from Code:
```
Input: JavaScript function
Function: add(a, b) { return a + b; }

Generated tests:
✓ add(2, 3) === 5
✓ add(0, 0) === 0
✓ add(-1, 1) === 0
✓ add(1.5, 2.5) === 4
✓ add(NaN, 1) === NaN
✓ TypeError handling

Output: Test file with all cases
```

### Generate Integration Tests:
```
API Endpoint: POST /users

Generated tests:
✓ Create user with valid data
✓ Create user with missing fields
✓ Create user with invalid email
✓ Duplicate email handling
✓ Authentication required
✓ Rate limiting
✓ Input validation
✓ Error responses

All scenarios covered!
```

## 🎯 Test Scenarios

### Scenario 1: New Feature
```
Task: Add user registration

1. Generate unit tests for registration logic
2. Generate integration tests for API endpoint
3. Generate E2E test for registration flow
4. Run all tests
5. Check coverage
6. Fix failures
7. Submit PR

Result: ✅ Tested feature
```

### Scenario 2: Bug Fix
```
Task: Fix login bug

1. Write test that reproduces bug
2. Fix the bug
3. Run test (should pass now)
4. Run full test suite
5. Check coverage maintained
6. Document the fix

Result: ✅ Bug fixed, tests pass
```

### Scenario 3: Refactoring
```
Task: Refactor code

1. Run existing tests (baseline)
2. Make changes
3. Run all tests
4. Check coverage maintained
5. Performance tests
6. Security tests
7. Deploy if all pass

Result: ✅ Refactored safely
```

## 🔧 Test Frameworks

### JavaScript/TypeScript:
```
Unit: Jest, Mocha, Vitest
Integration: Supertest
E2E: Cypress, Playwright
Coverage: Istanbul, c8
Performance: Lighthouse, k6
```

### Python:
```
Unit: pytest, unittest
Integration: requests, pytest-httpx
E2E: Selenium, Playwright
Coverage: coverage.py
Performance: Locust
```

### All Languages:
```
General:
- Test discovery
- Test runners
- Coverage tools
- Mocking libraries
- Assertions
- Fixtures

All supported!
```

## 📈 Test Metrics

```
TEST METRICS (This Sprint):

Tests total: [X]
Tests passed: [Y]
Tests failed: [Z]
Tests skipped: [W]
New tests: [N]

Coverage:
- Overall: [XX]%
- New code: [XX]%
- Trend: [+/-X]%

Build time:
- Unit: [X min]
- Integration: [X min]
- E2E: [X min]
- Total: [X min]

Quality score: [XX/100]
```

## 🚀 CI/CD Integration

### GitHub Actions:
```yaml
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - run: npm install
      - run: npm test
      - run: npm run coverage
```

### GitLab CI:
```yaml
test:
  stage: test
  script:
    - npm install
    - npm test
    - npm run coverage
  artifacts:
    reports:
      coverage_report: coverage/cobertura-coverage.xml
```

### Jenkins:
```groovy
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh 'npm test'
                sh 'npm run coverage'
            }
        }
    }
}
```

## 💡 Best Practices

### DO:
- ✅ Write tests before code (TDD)
- ✅ Keep tests isolated
- ✅ Use descriptive test names
- ✅ Test edge cases
- ✅ Keep tests fast
- ✅ Maintain high coverage
- ✅ Run tests in CI/CD
- ✅ Review test quality

### DON'T:
- ❌ Write slow tests
- ❌ Test implementation details
- ❌ Skip edge cases
- ❌ Mock everything
- ❌ Ignore flaky tests
- ❌ Skip coverage thresholds
- ❌ Commit untested code
- ❌ Break tests in commits

---

**Goal:** Ensure code quality through comprehensive testing! 🧪

**Status:** Testing Framework READY  
**Coverage Target:** 90%+  
**Integration:** CI/CD ready
