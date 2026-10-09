# Recipe: Metric to HTML

Display metric values in HTML elements with formatting and threshold colors.

## Basic Single Value

**HTML/SVG:**
```html
<div class="metric">
  <div class="label">CPU Usage</div>
  <div id="cpu-value" class="value">--</div>
</div>
```

**CSS:**
```css
.metric {
  text-align: center;
  padding: 20px;
}

.label {
  font-size: 14px;
  color: #888;
  text-transform: uppercase;
  letter-spacing: 1px;
}

.value {
  font-size: 48px;
  font-weight: 700;
  line-height: 1.2;
}
```

**onInit:**
```js
window.els = {
  cpuValue: htmlGraphics.htmlNode.getElementById('cpu-value'),
};
```

**onRender:**
```js
const field = htmlGraphics.data.series[0].fields[1];
const value = field.values.get(field.values.length - 1);

window.els.cpuValue.textContent = value.toFixed(1) + '%';
```

---

## With Threshold Colors

Uses Grafana's configured thresholds.

**onRender:**
```js
const displayValues = htmlGraphics.getFieldDisplayValues();
const dv = displayValues[0];

const el = window.els.cpuValue;
el.textContent = dv.display.text;    // "42.3%" (formatted with unit)
el.style.color = dv.display.color;   // Threshold color
```

---

## Multiple Metrics Grid

**HTML/SVG:**
```html
<div class="grid" id="metrics-grid"></div>
```

**CSS:**
```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 16px;
  padding: 16px;
}

.metric-card {
  background: rgba(255, 255, 255, 0.05);
  border-radius: 8px;
  padding: 16px;
  text-align: center;
}

.metric-card .name {
  font-size: 12px;
  color: #888;
  margin-bottom: 8px;
}

.metric-card .val {
  font-size: 28px;
  font-weight: 600;
}
```

**onRender:**
```js
const grid = htmlGraphics.htmlNode.getElementById('metrics-grid');
grid.innerHTML = ''; // Clear previous

const displayValues = htmlGraphics.getFieldDisplayValues();

displayValues.forEach(dv => {
  const card = document.createElement('div');
  card.className = 'metric-card';
  
  const name = document.createElement('div');
  name.className = 'name';
  name.textContent = dv.field.labels?.instance || dv.field.name;
  
  const val = document.createElement('div');
  val.className = 'val';
  val.textContent = dv.display.text;
  val.style.color = dv.display.color;
  
  card.appendChild(name);
  card.appendChild(val);
  grid.appendChild(card);
});
```

---

## Table from Series

**HTML/SVG:**
```html
<table class="metrics-table">
  <thead>
    <tr>
      <th>Instance</th>
      <th>Value</th>
      <th>Status</th>
    </tr>
  </thead>
  <tbody id="table-body"></tbody>
</table>
```

**CSS:**
```css
.metrics-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 13px;
}

.metrics-table th {
  text-align: left;
  padding: 8px 12px;
  border-bottom: 2px solid rgba(255, 255, 255, 0.1);
  color: #888;
  font-weight: 500;
}

.metrics-table td {
  padding: 8px 12px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
}

.status-dot {
  display: inline-block;
  width: 8px;
  height: 8px;
  border-radius: 50%;
  margin-right: 6px;
}
```

**onRender:**
```js
const tbody = htmlGraphics.htmlNode.getElementById('table-body');
tbody.innerHTML = '';

const displayValues = htmlGraphics.getFieldDisplayValues();

displayValues.forEach(dv => {
  const row = document.createElement('tr');
  
  // Instance name
  const nameCell = document.createElement('td');
  nameCell.textContent = dv.field.labels?.instance || 'unknown';
  
  // Value
  const valueCell = document.createElement('td');
  valueCell.textContent = dv.display.text;
  valueCell.style.color = dv.display.color;
  valueCell.style.fontWeight = '600';
  
  // Status indicator
  const statusCell = document.createElement('td');
  const dot = document.createElement('span');
  dot.className = 'status-dot';
  dot.style.backgroundColor = dv.display.color;
  statusCell.appendChild(dot);
  statusCell.appendChild(document.createTextNode(
    dv.display.numeric > 80 ? 'Critical' : 'OK'
  ));
  
  row.appendChild(nameCell);
  row.appendChild(valueCell);
  row.appendChild(statusCell);
  tbody.appendChild(row);
});
```

---

## Conditional Display

**HTML/SVG:**
```html
<div id="normal-state" class="state">
  <div class="value" id="value"></div>
</div>

<div id="alert-state" class="state alert" style="display: none;">
  <div class="alert-icon">⚠</div>
  <div class="alert-text">High Load</div>
  <div class="value" id="alert-value"></div>
</div>
```

**onRender:**
```js
const field = htmlGraphics.data.series[0].fields[1];
const value = field.values.get(field.values.length - 1);

const normalState = htmlGraphics.htmlNode.getElementById('normal-state');
const alertState = htmlGraphics.htmlNode.getElementById('alert-state');

if (value > 80) {
  normalState.style.display = 'none';
  alertState.style.display = 'block';
  htmlGraphics.htmlNode.getElementById('alert-value').textContent = value.toFixed(1) + '%';
} else {
  normalState.style.display = 'block';
  alertState.style.display = 'none';
  htmlGraphics.htmlNode.getElementById('value').textContent = value.toFixed(1) + '%';
}
```

---

## Trend Indicator

Shows change direction vs previous value.

**HTML/SVG:**
```html
<div class="metric-with-trend">
  <div id="current-value" class="value"></div>
  <div id="trend" class="trend"></div>
</div>
```

**CSS:**
```css
.trend {
  font-size: 14px;
  margin-top: 4px;
}

.trend.up { color: #F2495C; }
.trend.down { color: #73BF69; }
.trend.flat { color: #888; }
```

**onInit:**
```js
window.panelState = {
  previousValue: null,
  els: {
    value: htmlGraphics.htmlNode.getElementById('current-value'),
    trend: htmlGraphics.htmlNode.getElementById('trend'),
  }
};
```

**onRender:**
```js
const state = window.panelState;
const field = htmlGraphics.data.series[0].fields[1];
const value = field.values.get(field.values.length - 1);

state.els.value.textContent = value.toFixed(1) + '%';

if (state.previousValue !== null) {
  const delta = value - state.previousValue;
  const pct = ((delta / state.previousValue) * 100).toFixed(1);
  
  if (Math.abs(delta) < 0.01) {
    state.els.trend.textContent = '— no change';
    state.els.trend.className = 'trend flat';
  } else if (delta > 0) {
    state.els.trend.textContent = `▲ +${pct}%`;
    state.els.trend.className = 'trend up';
  } else {
    state.els.trend.textContent = `▼ ${pct}%`;
    state.els.trend.className = 'trend down';
  }
}

state.previousValue = value;
```

---

## Sparkline (CSS-only)

**HTML/SVG:**
```html
<div class="sparkline-container">
  <div id="sparkline" class="sparkline"></div>
  <div id="spark-value" class="value"></div>
</div>
```

**CSS:**
```css
.sparkline {
  display: flex;
  align-items: flex-end;
  gap: 2px;
  height: 40px;
  margin-bottom: 8px;
}

.spark-bar {
  flex: 1;
  background: #5794F2;
  border-radius: 2px 2px 0 0;
  min-height: 2px;
  transition: height 0.3s ease;
}
```

**onRender:**
```js
const field = htmlGraphics.data.series[0].fields[1];
const values = field.values.toArray().filter(v => v !== null);

// Take last 20 points
const recent = values.slice(-20);
const max = Math.max(...recent);
const min = Math.min(...recent);
const range = max - min || 1;

const sparkline = htmlGraphics.htmlNode.getElementById('sparkline');
sparkline.innerHTML = '';

recent.forEach(v => {
  const bar = document.createElement('div');
  bar.className = 'spark-bar';
  const heightPct = ((v - min) / range) * 100;
  bar.style.height = Math.max(heightPct, 5) + '%';
  sparkline.appendChild(bar);
});

// Current value
const current = recent[recent.length - 1];
htmlGraphics.htmlNode.getElementById('spark-value').textContent = current.toFixed(1);
```

---

## Progress Bar

**HTML/SVG:**
```html
<div class="progress-container">
  <div class="progress-label">
    <span>Disk Usage</span>
    <span id="progress-pct">0%</span>
  </div>
  <div class="progress-track">
    <div id="progress-fill" class="progress-fill"></div>
  </div>
</div>
```

**CSS:**
```css
.progress-container {
  padding: 16px;
}

.progress-label {
  display: flex;
  justify-content: space-between;
  font-size: 13px;
  margin-bottom: 8px;
}

.progress-track {
  height: 8px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  border-radius: 4px;
  transition: width 0.4s ease, background-color 0.3s ease;
  width: 0%;
}
```

**onRender:**
```js
const displayValues = htmlGraphics.getFieldDisplayValues();
const dv = displayValues[0];
const pct = Math.min(dv.display.numeric, 100);

const fill = htmlGraphics.htmlNode.getElementById('progress-fill');
fill.style.width = pct + '%';
fill.style.backgroundColor = dv.display.color;

htmlGraphics.htmlNode.getElementById('progress-pct').textContent = dv.display.text;
```

---

## Gotchas

1. **Clear before rebuild** — `innerHTML = ''` prevents duplicate elements on refresh
2. **Cache DOM refs** — query in `onInit`, reuse in `onRender`
3. **Handle null values** — `field.values.toArray().filter(v => v !== null)`
4. **Check series exists** — `if (htmlGraphics.data.series.length === 0) return;`
5. **Use `getFieldDisplayValues()`** — handles units, decimals, thresholds automatically
