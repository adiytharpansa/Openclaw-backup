# Browser Automation Workflows

_Pre-configured browser automation patterns_

## 🌐 Common Workflows

### 1. Research & Extract
**Use case:** Gather information from websites

```bash
# Navigate to site
browser action=navigate targetUrl="https://example.com"

# Take snapshot to see page structure
browser action=snapshot refs="aria"

# Extract specific content
browser action=act kind="click" ref="[element-ref]"

# Screenshot for documentation
browser action=screenshot fullPage=true
```

### 2. Form Filling
**Use case:** Submit forms, applications, surveys

```bash
# Navigate to form
browser action=navigate targetUrl="https://example.com/form"

# Wait for page load
browser action=snapshot

# Fill fields
browser action=act kind="fill" ref="[field-ref]" text="[value]"

# Submit
browser action=act kind="click" ref="[submit-button]" submit=true
```

### 3. Login Sequence (Secure)
**Use case:** Access authenticated areas

⚠️ **Security Note:** Never store credentials in plain text. Use 1Password or environment variables.

```bash
# Navigate to login
browser action=navigate targetUrl="https://example.com/login"

# User enters credentials manually (secure)
# Or use 1Password CLI to inject:
# op read "op://vault/login/username"

# After login, save session
browser action=snapshot
```

### 4. Data Extraction
**Use case:** Scrape structured data from pages

```bash
# Navigate to target page
browser action=navigate targetUrl="https://example.com/data"

# Extract with evaluate
browser action=act kind="evaluate" fn="() => {
  return document.querySelectorAll('.item').map(el => ({
    title: el.querySelector('.title')?.innerText,
    link: el.querySelector('a')?.href,
    date: el.querySelector('.date')?.innerText
  }))
}"

# Save results to file
# (Results returned in browser response)
```

### 5. Multi-Page Navigation
**Use case:** Navigate through paginated content

```bash
# Page 1
browser action=navigate targetUrl="https://example.com/page/1"
# ... extract data ...

# Next page
browser action=act kind="click" ref="[next-button]"

# Wait for load
browser action=act kind="wait" timeoutMs=3000

# Repeat...
```

### 6. Screenshot Documentation
**Use case:** Capture visual evidence

```bash
# Full page screenshot
browser action=screenshot fullPage=true type="png"

# Specific element
browser action=screenshot ref="[element-ref]" type="jpeg"

# With delay (for animations)
browser action=screenshot delayMs=2000
```

---

## 🎯 Workflow Templates

### Template: Competitive Research
```
1. Navigate to competitor website
2. Snapshot homepage structure
3. Extract pricing info
4. Extract feature list
5. Screenshot key pages
6. Save to knowledge/competitive/[competitor-name].md
```

### Template: Job Application
```
1. Navigate to job posting
2. Extract job requirements
3. Snapshot company info
4. Fill application form (with 1Password)
5. Upload resume
6. Screenshot confirmation
7. Log to memory/projects/job-search.md
```

### Template: Social Media Monitoring
```
1. Navigate to Twitter/X profile
2. Extract recent posts
3. Identify engagement patterns
4. Screenshot notable content
5. Save insights to knowledge/social/[profile].md
```

### Template: E-commerce Price Tracking
```
1. Navigate to product page
2. Extract current price
3. Extract availability status
4. Screenshot product
5. Log to memory/shopping/[product].md
6. Compare with historical data
```

---

## 🔧 Advanced Techniques

### Wait for Element
```bash
# Wait for specific element to appear
browser action=act kind="wait" textGone="Loading..." timeoutMs=10000
```

### Scroll Page
```bash
# Scroll down
browser action=act kind="scroll" deltaY=500

# Scroll to specific element
browser action=act kind="scrollIntoView" ref="[element-ref]"
```

### Handle Dialogs
```bash
# Accept confirmation dialog
browser action=dialog accept=true

# Enter prompt text
browser action=dialog accept=true promptText="[your answer]"
```

### Execute Custom JavaScript
```bash
browser action=act kind="evaluate" fn="() => {
  // Your JavaScript here
  return document.title
}"
```

---

## 📋 Best Practices

### ✅ Do
- Use `snapshot` to understand page structure before acting
- Wait for page loads with appropriate timeouts
- Take screenshots for documentation
- Use ARIA refs for stable element selection
- Handle errors gracefully

### ❌ Don't
- Don't hardcode credentials
- Don't skip wait times (causes flakiness)
- Don't rely on fragile selectors (use ARIA)
- Don't automate without checking robots.txt
- Don't scrape at high rates (be respectful)

---

## 🔐 Security Guidelines

1. **Credentials:** Use 1Password, never plain text
2. **Sessions:** Don't persist sensitive sessions
3. **Data:** Encrypt extracted sensitive data
4. **Rate Limiting:** Respect website rate limits
5. **Robots.txt:** Check before scraping

---

## 📁 Integration with Other Tools

### With Memory System
```bash
# After browser extraction, save to memory
# 1. Extract data via browser
# 2. Format as markdown
# 3. Write to memory/YYYY-MM-DD.md or knowledge/
```

### With Sub-Agents
```bash
# Spawn agent for browser task
sessions_spawn \
  task="Research [topic] using browser - extract key info" \
  label="browser-research" \
  mode="run"
```

### With Summarize
```bash
# After extracting content, summarize it
# 1. Browser extracts text
# 2. Pass to summarize tool
# 3. Save summary to knowledge/
```

---

## 🚀 Quick Start Examples

### Example 1: Quick Research
```bash
# Search and extract
browser action=navigate targetUrl="https://news.ycombinator.com"
browser action=snapshot refs="aria"
# Review snapshot, then extract specific items
```

### Example 2: Document a Page
```bash
browser action=navigate targetUrl="https://example.com"
browser action=screenshot fullPage=true
# Screenshot saved, review in file browser
```

### Example 3: Fill & Submit
```bash
browser action=navigate targetUrl="https://example.com/contact"
browser action=snapshot
# Identify form fields from snapshot
browser action=act kind="fill" ref="e12" text="Your message"
browser action=act kind="click" ref="e15" submit=true
```

---

_Last updated: 2026-04-10_
