# Recipe: Grafana Variables

Read, use, and update dashboard template variables from panel code.

## Reading Variables

### Single Variable

```js
// onRender or onInit
const region = htmlGraphics.getTemplateSrv().replace('$region');
// Returns: "us-east-1"
```

### Multi-Value Variable

```js
const services = htmlGraphics.getTemplateSrv().replace('$services');
// Returns: "{api,db,cache}" (Grafana's multi-value format)

// Parse to array
const serviceList = services
  .replace(/[{}]/g, '')
  .split(',')
  .map(s => s.trim());
// ["api", "db", "cache"]
```

### With Custom Format

```js
const templateSrv = htmlGraphics.getTemplateSrv();

// CSV format
const csv = templateSrv.replace('$services', {}, 'csv');
// "api,db,cache"

// Regex format
const regex = templateSrv.replace('$services', {}, 'regex');
// "(api|db|cache)"

// JSON format
const json = templateSrv.replace('$services', {}, 'json');
// '["api","db","cache"]'

// Pipe format
const pipe = templateSrv.replace('$services', {}, 'pipe');
// "api|db|cache"
```

### All Variables

```js
const vars = htmlGraphics.getTemplateSrv().getVariables();

vars.forEach(v => {
  console.log(v.name, v.current.value, v.current.text);
});

// Find specific variable object
const regionVar = vars.find(v => v.name === 'region');
console.log(regionVar.current.value);  // Selected value
console.log(regionVar.options);        // All available options
```

---

## Using Variables in Strings

```js
// Replace multiple variables
const query = htmlGraphics.replaceVariables(
  'rate(http_requests{region="$region", env="$env"}[5m])'
);

// Build URLs
const url = htmlGraphics.replaceVariables(
  '/api/metrics?region=$region&from=$__from&to=$__to'
);

// Time range variables (built-in)
const from = htmlGraphics.replaceVariables('$__from');  // Unix ms
const to = htmlGraphics.replaceVariables('$__to');      // Unix ms
const interval = htmlGraphics.replaceVariables('$__interval'); // "30s"
```

---

## Updating Variables

### Single Value

```js
htmlGraphics.updateVariable('region', 'us-west-2');
```

### Multi-Value

```js
htmlGraphics.updateVariable('services', ['api', 'db']);
```

### On Click

```js
// onInit
const buttons = htmlGraphics.htmlNode.querySelectorAll('.region-btn');

buttons.forEach(btn => {
  btn.addEventListener('click', (e) => {
    const region = e.currentTarget.dataset.region;
    htmlGraphics.updateVariable('region', region);
  });
});
```

---

## Complete Example: Region Selector

**HTML/SVG:**
```html
<div class="selector">
  <div class="selector-label">Select Region</div>
  <div class="btn-group" id="region-buttons">
    <button class="region-btn" data-region="us-east-1">US East</button>
    <button class="region-btn" data-region="us-west-2">US West</button>
    <button class="region-btn" data-region="eu-west-1">EU West</button>
    <button class="region-btn" data-region="ap-south-1">AP South</button>
  </div>
  <div class="current" id="current-region"></div>
</div>
```

**CSS:**
```css
.selector {
  padding: 16px;
}

.selector-label {
  font-size: 12px;
  color: #888;
  text-transform: uppercase;
  margin-bottom: 12px;
}

.btn-group {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.region-btn {
  padding: 8px 16px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  border-radius: 4px;
  background: transparent;
  color: #ccc;
  cursor: pointer;
  font-size: 13px;
  transition: all 0.2s ease;
}

.region-btn:hover {
  background: rgba(255, 255, 255, 0.05);
  border-color: rgba(255, 255, 255, 0.4);
}

.region-btn.active {
  background: #5794F2;
  border-color: #5794F2;
  color: #fff;
  font-weight: 600;
}

.current {
  margin-top: 12px;
  font-size: 13px;
  color: #888;
}
```

**onInit:**
```js
const buttons = htmlGraphics.htmlNode.querySelectorAll('.region-btn');

buttons.forEach(btn => {
  btn.addEventListener('click', (e) => {
    const region = e.currentTarget.dataset.region;
    htmlGraphics.updateVariable('region', region);
  });
});

window.regionEls = {
  buttons: buttons,
  current: htmlGraphics.htmlNode.getElementById('current-region'),
};
```

**onRender:**
```js
const currentRegion = htmlGraphics.getTemplateSrv().replace('$region');

// Update active state
window.regionEls.buttons.forEach(btn => {
  if (btn.dataset.region === currentRegion) {
    btn.classList.add('active');
  } else {
    btn.classList.remove('active');
  }
});

window.regionEls.current.textContent = `Current: ${currentRegion}`;
```

---

## Conditional Rendering by Variable

```js
// onRender
const env = htmlGraphics.getTemplateSrv().replace('$env');

const prodPanel = htmlGraphics.htmlNode.getElementById('prod-view');
const devPanel = htmlGraphics.htmlNode.getElementById('dev-view');

if (env === 'production') {
  prodPanel.style.display = 'block';
  devPanel.style.display = 'none';
} else {
  prodPanel.style.display = 'none';
  devPanel.style.display = 'block';
}
```

---

## Variable-Driven Styling

```js
// onRender
const theme = htmlGraphics.getTemplateSrv().replace('$colorTheme');

const themes = {
  blue: { primary: '#5794F2', bg: '#1f2d3d' },
  green: { primary: '#73BF69', bg: '#1f3d2d' },
  purple: { primary: '#B877D9', bg: '#2d1f3d' },
};

const colors = themes[theme] || themes.blue;

const container = htmlGraphics.htmlNode.getElementById('container');
container.style.backgroundColor = colors.bg;
container.style.borderColor = colors.primary;
```

---

## Drill-Down Navigation

Navigate to another dashboard with variables.

```js
// onInit
const nodes = htmlGraphics.htmlNode.querySelectorAll('.drill-node');

nodes.forEach(node => {
  node.addEventListener('click', (e) => {
    const instance = e.currentTarget.dataset.instance;
    
    htmlGraphics.getLocationSrv().update({
      path: '/d/host-details/host-details',
      query: {
        'var-instance': instance,
        'var-region': htmlGraphics.getTemplateSrv().replace('$region'),
        from: htmlGraphics.replaceVariables('$__from'),
        to: htmlGraphics.replaceVariables('$__to'),
      }
    });
  });
});
```

---

## Filter Data by Variable

```js
// onRender
const selectedEnv = htmlGraphics.getTemplateSrv().replace('$env');

// Filter series by label matching variable
const filtered = htmlGraphics.data.series.filter(frame => {
  const field = frame.fields[1];
  return field.labels?.env === selectedEnv;
});

// Render only filtered data
filtered.forEach(frame => {
  const value = frame.fields[1].values.get(0);
  // Display
});
```

---

## Multi-Value Checkboxes

**HTML/SVG:**
```html
<div class="checkbox-group" id="service-checks">
  <label><input type="checkbox" value="api" /> API</label>
  <label><input type="checkbox" value="db" /> Database</label>
  <label><input type="checkbox" value="cache" /> Cache</label>
  <label><input type="checkbox" value="queue" /> Queue</label>
</div>
```

**onInit:**
```js
const checkboxes = htmlGraphics.htmlNode.querySelectorAll('#service-checks input');

function updateServices() {
  const selected = Array.from(checkboxes)
    .filter(cb => cb.checked)
    .map(cb => cb.value);
  
  htmlGraphics.updateVariable('services', selected.length > 0 ? selected : ['$__all']);
}

checkboxes.forEach(cb => {
  cb.addEventListener('change', updateServices);
});

window.serviceCheckboxes = checkboxes;
```

**onRender:**
```js
// Sync checkbox state with variable
const servicesRaw = htmlGraphics.getTemplateSrv().replace('$services', {}, 'csv');
const selected = servicesRaw.split(',').map(s => s.trim());

window.serviceCheckboxes.forEach(cb => {
  cb.checked = selected.includes(cb.value);
});
```

---

## Built-In Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `$__from` | Time range start (Unix ms) | `1704067200000` |
| `$__to` | Time range end (Unix ms) | `1704153600000` |
| `$__interval` | Auto interval | `30s` |
| `$__interval_ms` | Interval in ms | `30000` |
| `$__range` | Time range duration | `1d` |
| `$__range_s` | Range in seconds | `86400` |
| `$__range_ms` | Range in ms | `86400000` |
| `$__dashboard` | Dashboard name | `My Dashboard` |
| `$__org` | Organization name | `Main Org.` |
| `$__user` | Current user login | `admin` |
| `$__timeFilter` | Time filter expression | Data source specific |

```js
// Usage
const fromMs = parseInt(htmlGraphics.replaceVariables('$__from'));
const toMs = parseInt(htmlGraphics.replaceVariables('$__to'));
const durationHours = (toMs - fromMs) / 3600000;
```

---

## Gotchas

1. **`updateVariable()` triggers refresh** — panel re-renders after variable change
2. **Multi-value format** — `{a,b,c}` needs parsing; use format option (`csv`, `json`)
3. **Variable must exist** — check with `getVariables()` before updating
4. **Async nature** — variable updates aren't immediate; don't read right after write
5. **Case sensitive** — `$Region` ≠ `$region`
6. **All value** — `$__all` is the "All" option value
7. **Regex chars** — escape special chars when building regex from variables
