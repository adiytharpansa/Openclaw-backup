---
name: api-integrator
description: Seamless integration with external APIs. Use when you need to connect to any API, handle authentication, manage rate limits, parse responses, and build robust API clients. This skill enables easy API integration, auto-generation of client code, and comprehensive error handling.
---

# API Integrator

**API connection expert** yang connect ke sembarang API! 🔌

## 🎯 Core Function

Skill ini **integrate dengan API** dengan mudah:

1. **API Discovery** - Find & understand APIs
2. **Client Generation** - Auto-generate API clients
3. **Authentication** - Handle all auth methods
4. **Request Building** - Proper request formatting
5. **Response Parsing** - Extract needed data
6. **Error Handling** - Robust error management
7. **Rate Limiting** - Respect API limits

## 🔗 Supported Auth Methods

### OAuth 2.0
```
Flow:
1. Get authorization URL
2. User authenticates
3. Receive authorization code
4. Exchange for access token
5. Use token for API calls
6. Refresh token when expired

Support:
- Authorization code
- Client credentials
- Implicit (legacy)
- PKCE
```

### API Key
```
Methods:
- Header: X-API-Key: your_key
- Query: ?api_key=your_key
- Body: { "api_key": "your_key" }
- Env: Process.env.API_KEY

Security:
✓ Never hardcode keys
✓ Use environment variables
✓ Rotate keys regularly
✓ Limit key permissions
```

### JWT (JSON Web Token)
```
Flow:
1. Authenticate with credentials
2. Receive JWT
3. Store token securely
4. Include in requests: Authorization: Bearer <token>
5. Handle expiration
6. Refresh token if needed

Security:
✓ Validate token signature
✓ Check expiration
✓ Use HTTPS only
✓ Store securely
```

### Basic Auth
```
Format:
Authorization: Basic base64(username:password)

Usage:
- Simple authentication
- Internal APIs
- Not for public APIs (use OAuth)

Security:
✓ Always use HTTPS
✓ Protect credentials
✓ Don't log auth headers
```

## 🛠️ API Integration Commands

### `/api-connect <api-name>`
Connect to an API:
```
API CONNECTION: [api-name]

Status: Connecting...
✓ Endpoint discovered
✓ Documentation parsed
✓ Auth methods identified
✓ Ready to authenticate

Commands available:
- /api-list
- /api-call <endpoint>
- /api-auth <method>
- /api-schema
```

### `/api-auth <method>`
Authenticate with API:
```
AUTHENTICATION: [method]

OAuth 2.0:
1. Authorization URL: [url]
2. Client ID: [id]
3. Scopes: [list]

Action: Redirect to authorization URL
After: Token received, API ready

API Key:
✓ Key validated
✓ Permissions checked
✓ Rate limits: [X/minute]

Status: AUTHENTICATED ✓
```

### `/api-call <endpoint> [params]`
Call API endpoint:
```
API CALL: [endpoint]

Request:
Method: GET
Headers: { Authorization: Bearer ... }
Query: [params]

Response:
Status: 200 OK
Data: { extracted content }

Result: ✅ Success
```

### `/api-schema`
Show API schema:
```
API SCHEMA: [api-name]

Endpoints:
- GET /users - List users
- POST /users - Create user
- GET /users/:id - Get user
- PUT /users/:id - Update user
- DELETE /users/:id - Delete user

Request/Response Schemas:
Users: { id, name, email, created_at }
Errors: { code, message, details }

Rate Limits:
- 1000 requests/hour
- 100 requests/minute
```

### `/api-rate-limit`
Check rate limits:
```
RATE LIMITS:

Current usage:
- Today: 450 / 1000
- This minute: 5 / 100
- This hour: 450 / 1000

Reset times:
- Minute: in 25 seconds
- Hour: in 50 minutes
- Day: in 3 hours 12 minutes

Status: ✅ Within limits
```

### `/api-docs`
View API documentation:
```
API DOCUMENTATION

Available endpoints: [count]
Request examples: [count]
Response examples: [count]
Error codes: [count]

Sections:
1. Authentication
2. Endpoints
3. Request/Response formats
4. Error handling
5. Rate limits
6. Examples

Documentation complete!
```

## 🔧 API Integration Patterns

### Pattern 1: Simple GET Request
```
Task: Fetch user data

Implementation:
1. Connect to API
2. Authenticate
3. GET /users/:id
4. Parse response
5. Return data

Code:
response = await api.get(`/users/${userId}`)
return response.data
```

### Pattern 2: POST with Data
```
Task: Create new resource

Implementation:
1. Validate input
2. Authenticate
3. POST /resources
4. Send payload
5. Handle response

Code:
response = await api.post('/resources', {
  name: 'Resource',
  description: 'Description'
})
return response.data
```

### Pattern 3: Pagination
```
Task: Fetch all items

Implementation:
1. Get page 1
2. Check if more pages
3. Loop through pages
4. Accumulate results
5. Return complete list

Code:
const allItems = []
let page = 1
do {
  const response = await api.get('/items', { page })
  allItems.push(...response.data)
  page++
} while (response.hasMore)
return allItems
```

### Pattern 4: Error Handling
```
Task: API call with retries

Implementation:
1. Attempt API call
2. If error, check type
3. Retry if transient
4. Fail if permanent
5. Log & report

Code:
try {
  return await api.call(endpoint)
} catch (error) {
  if (error.isRetryable) {
    return await api.call(endpoint, { retry: true })
  }
  throw error
}
```

### Pattern 5: Rate Limit Handling
```
Task: Respect rate limits

Implementation:
1. Check current usage
2. If near limit, wait
3. Use exponential backoff
4. Queue requests if needed
5. Continue after limit resets

Code:
if (usage >= limit * 0.8) {
  const waitTime = calculateWaitTime(usage)
  await sleep(waitTime)
}
await api.call(endpoint)
```

## 📊 API Metrics

```
API METRICS (Today):

APIs connected: [X]
Total calls: [Y]
Success rate: [XX%]
Avg response time: [X ms]
Errors: [Z]

By API:
- API A: [N] calls, [XX]% success
- API B: [N] calls, [XX]% success
- API C: [N] calls, [XX]% success

Rate limit usage: [XX%]
Cache hits: [XX%]
```

## 🎯 Common API Integrations

### GitHub API
```
Capabilities:
- Repository management
- Issue tracking
- PR reviews
- CI/CD status

Authentication: OAuth / API Key
Rate Limit: 5000 requests/hour (authenticated)
```

### Twitter/X API
```
Capabilities:
- Post tweets
- Get timelines
- User data
- Analytics

Authentication: OAuth 2.0
Rate Limit: Varies by endpoint
```

### Google APIs
```
Capabilities:
- Gmail
- Drive
- Calendar
- Sheets

Authentication: OAuth 2.0
Rate Limit: Varies by service
```

### Stripe API
```
Capabilities:
- Payments
- Customers
- Refunds
- Webhooks

Authentication: API Key
Rate Limit: 100 requests/second
```

### Custom Webhooks
```
Setup:
1. Register webhook URL
2. Verify signature
3. Process payload
4. Respond appropriately
5. Handle retries

Security: HMAC signature verification
```

## 🔒 Security Best Practices

### DO:
- ✅ Always use HTTPS
- ✅ Validate all inputs
- ✅ Sanitize responses
- ✅ Handle errors gracefully
- ✅ Implement rate limiting
- ✅ Rotate API keys regularly
- ✅ Use environment variables
- ✅ Log API activity

### DON'T:
- ❌ Hardcode API keys
- ❌ Log sensitive data
- ❌ Exceed rate limits
- ❌ Skip authentication
- ❌ Use HTTP instead of HTTPS
- ❌ Trust client-side validation
- ❌ Ignore error responses

## 🚀 Integration Examples

### Example 1: GitHub Integration
```
1. Connect to GitHub API
2. Authenticate with OAuth
3. Get repository info
4. Fetch recent commits
5. Generate summary
6. Notify user

Result: ✅ GitHub data integrated
```

### Example 2: Email Integration
```
1. Connect to Gmail API
2. Authenticate OAuth
3. Fetch unread emails
4. Categorize by importance
5. Summarize key points
6. Deliver briefing

Result: ✅ Email integration ready
```

### Example 3: Weather Integration
```
1. Connect to weather API
2. Get current location
3. Fetch weather data
4. Format response
5. Provide recommendations
6. Set up alerts

Result: ✅ Weather service integrated
```

---

**Goal:** Connect to ANY API easily and securely! 🔌

**Status:** API Integrator READY  
**Support:** OAuth, API Keys, JWT, Basic Auth  
**Security:** Enterprise-grade
