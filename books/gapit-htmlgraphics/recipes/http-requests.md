# Recipe: HTTP Requests

Fetch external data from APIs within panel code.

## Basic Fetch

```js
// onInit — fetch once
async function loadData() {
  try {
    const response = await fetch('https://api.example.com/data');
    const data = await response.json();
    
    window.externalData = data;
    renderExternalData(data);
  } catch (err) {
    console.error('Fetch failed:', err);
    showError(err.message);
  }
}

loadData();
```

---

## Fetch with Grafana Variables

```js
// onInit
const region = htmlGraphics.getTemplateSrv().replace('$region');
const from = htmlGraphics.replaceVariables('$__from');
const to = htmlGraphics.replaceVariables('$__to');

const url = `https://api.example.com/metrics?region=${region}&from=${from}&to=${to}`;

fetch(url)
  .then(r => r.json())
  .then(data => {
    window.apiData = data;
    render(data);
  });
```

---

## Periodic Polling

```js
// onInit
window.pollState = {
  interval: null,
  data: null,
};

async function poll() {
  try {
    const res = await fetch('https://api.example.com/status');
    window.pollState.data = await res.json();
    updateDisplay();
  } catch (err) {
    console.error('Poll failed:', err);
  }
}

// Initial fetch
poll();

// Poll every 30 seconds
window.pollState.interval = setInterval(poll, 30000);

// Cleanup on re-init
if (window.pollState.interval) {
  clearInterval(window.pollState.interval);
}
```

**⚠️ Warning:** Intervals persist across panel refreshes. Always clear before setting new ones.

---

## Complete Example: External API Dashboard

**HTML/SVG:**
```html
<div class="api-panel">
  <div class="status-bar">
    <span id="api-status" class="status-badge">Loading...</span>
    <span id="last-update" class="timestamp"></span>
  </div>
  
  <div id="api-content" class="content"></div>
  
  <div id="api-error" class="error" style="display: none;"></div>
</div>
```

**CSS:**
```css
.api-panel {
  padding: 16px;
}

.status-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.status-badge {
  padding: 4px 10px;
  border-radius: 12px;
  font-size: 11px;
  font-weight: 600;
  text-transform: uppercase;
}

.status-badge.ok {
  background: rgba(115, 191, 105, 0.2);
  color: #73BF69;
}

.status-badge.error {
  background: rgba(242, 73, 92, 0.2);
  color: #F2495C;
}

.status-badge.loading {
  background: rgba(255, 152, 48, 0.2);
  color: #FF9830;
}

.timestamp {
  font-size: 11px;
  color: #888;
}

.error {
  padding: 12px;
  background: rgba(242, 73, 92, 0.1);
  border-left: 3px solid #F2495C;
  border-radius: 4px;
  font-size: 13px;
  color: #F2495C;
}

.data-row {
  display: flex;
  justify-content: space-between;
  padding: 8px 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}
```

**onInit:**
```js
window.apiPanel = {
  els: {
    status: htmlGraphics.htmlNode.getElementById('api-status'),
    lastUpdate: htmlGraphics.htmlNode.getElementById('last-update'),
    content: htmlGraphics.htmlNode.getElementById('api-content'),
    error: htmlGraphics.htmlNode.getElementById('api-error'),
  },
  data: null,
  interval: null,
};

function setStatus(state, text) {
  const el = window.apiPanel.els.status;
  el.className = `status-badge ${state}`;
  el.textContent = text;
}

function showError(message) {
  const el = window.apiPanel.els.error;
  el.style.display = 'block';
  el.textContent = message;
  setStatus('error', 'Error');
}

function hideError() {
  window.apiPanel.els.error.style.display = 'none';
}

function renderData(data) {
  const content = window.apiPanel.els.content;
  content.innerHTML = '';
  
  Object.entries(data).forEach(([key, value]) => {
    const row = document.createElement('div');
    row.className = 'data-row';
    
    const keyEl = document.createElement('span');
    keyEl.textContent = key;
    keyEl.style.color = '#888';
    
    const valEl = document.createElement('span');
    valEl.textContent = typeof value === 'object' 
      ? JSON.stringify(value) 
      : value;
    valEl.style.fontWeight = '600';
    
    row.appendChild(keyEl);
    row.appendChild(valEl);
    content.appendChild(row);
  });
  
  window.apiPanel.els.lastUpdate.textContent = 
    new Date().toLocaleTimeString();
}

async function fetchData() {
  setStatus('loading', 'Loading');
  
  try {
    const region = htmlGraphics.getTemplateSrv().replace('$region');
    const url = `https://api.example.com/status?region=${region}`;
    
    const res = await fetch(url, {
      headers: { 'Accept': 'application/json' },
    });
    
    if (!res.ok) {
      throw new Error(`HTTP ${res.status}: ${res.statusText}`);
    }
    
    const data = await res.json();
    window.apiPanel.data = data;
    
    hideError();
    setStatus('ok', 'Connected');
    renderData(data);
    
  } catch (err) {
    showError(err.message);
  }
}

// Clear previous interval
if (window.apiPanel.interval) {
  clearInterval(window.apiPanel.interval);
}

// Initial fetch + polling
fetchData();
window.apiPanel.interval = setInterval(fetchData, 60000);
```

---

## POST Request

```js
async function sendData(payload) {
  const res = await fetch('https://api.example.com/action', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload),
  });
  
  if (!res.ok) {
    throw new Error(`Failed: ${res.status}`);
  }
  
  return res.json();
}

// Usage: button click handler
// onInit
const btn = htmlGraphics.htmlNode.getElementById('action-btn');

btn.addEventListener('click', async () => {
  btn.disabled = true;
  btn.textContent = 'Sending...';
  
  try {
    const result = await sendData({ action: 'restart', target: 'server-01' });
    btn.textContent = 'Success!';
    setTimeout(() => { btn.textContent = 'Restart'; btn.disabled = false; }, 2000);
  } catch (err) {
    btn.textContent = 'Failed';
    console.error(err);
    setTimeout(() => { btn.textContent = 'Restart'; btn.disabled = false; }, 2000);
  }
});
```

---

## With Authentication

```js
// API key from panel codeData
const config = htmlGraphics.options.codeData;

const res = await fetch('https://api.example.com/data', {
  headers: {
    'Authorization': `Bearer ${config.apiToken}`,
    'Accept': 'application/json',
  }
});
```

**⚠️ Security:** Tokens in `codeData` are visible in dashboard JSON. For sensitive credentials:
- Use a proxy datasource
- Use Grafana's data source proxy
- Never commit tokens to git

---

## Using Grafana's Proxy

Route requests through Grafana to avoid CORS and hide credentials.

```js
// Uses Grafana's datasource proxy
const datasourceId = 1; // Your datasource ID
const url = `/api/datasources/proxy/${datasourceId}/api/v1/query?query=up`;

const res = await fetch(url, {
  credentials: 'same-origin', // Include Grafana session cookie
});
const data = await res.json();
```

---

## Parallel Requests

```js
async function loadAll() {
  try {
    const [status, metrics, config] = await Promise.all([
      fetch('/api/status').then(r => r.json()),
      fetch('/api/metrics').then(r => r.json()),
      fetch('/api/config').then(r => r.json()),
    ]);
    
    render({ status, metrics, config });
  } catch (err) {
    showError(err.message);
  }
}
```

---

## Request with Timeout

```js
async function fetchWithTimeout(url, timeoutMs = 5000) {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), timeoutMs);
  
  try {
    const res = await fetch(url, { signal: controller.signal });
    clearTimeout(timeout);
    return res;
  } catch (err) {
    clearTimeout(timeout);
    if (err.name === 'AbortError') {
      throw new Error(`Request timed out after ${timeoutMs}ms`);
    }
    throw err;
  }
}
```

---

## Caching Responses

```js
// onInit
window.apiCache = {
  data: null,
  timestamp: 0,
  ttl: 60000, // 1 minute
};

async function getCachedData(url) {
  const now = Date.now();
  const cache = window.apiCache;
  
  if (cache.data && (now - cache.timestamp) < cache.ttl) {
    return cache.data; // Return cached
  }
  
  const res = await fetch(url);
  const data = await res.json();
  
  cache.data = data;
  cache.timestamp = now;
  
  return data;
}
```

---

## Combining API Data with Grafana Metrics

```js
// onInit
window.combined = { apiData: null };

async function loadApiData() {
  const res = await fetch('https://api.example.com/inventory');
  window.combined.apiData = await res.json();
  render();
}

loadApiData();

// onRender
function render() {
  const apiData = window.combined.apiData;
  if (!apiData) return;
  
  const metrics = htmlGraphics.getFieldDisplayValues();
  
  // Join API data with metrics by key
  const merged = metrics.map(dv => {
    const instanceId = dv.field.labels?.instance;
    const apiRecord = apiData.find(item => item.hostname === instanceId);
    
    return {
      instance: instanceId,
      value: dv.display.text,
      color: dv.display.color,
      // From API
      owner: apiRecord?.owner || 'unknown',
      location: apiRecord?.datacenter || 'unknown',
      sla: apiRecord?.sla_tier || 'standard',
    };
  });
  
  renderTable(merged);
}

render();
```

---

## Gotchas

1. **CORS** — external APIs must allow Grafana's origin, or use datasource proxy
2. **Mixed content** — HTTPS Grafana can't fetch HTTP APIs
3. **Intervals persist** — always `clearInterval()` before setting new ones
4. **onRender runs often** — don't fetch in `onRender`; fetch in `onInit` or on events
5. **Credentials in JSON** — dashboard JSON is readable; use proxies for secrets
6. **No await in onInit top-level** — wrap in async function
7. **Error handling** — always try/catch; network failures are common
8. **Rate limits** — respect API limits; use caching and reasonable poll intervals
