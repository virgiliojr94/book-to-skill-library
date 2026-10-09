# Pattern: State Management

Track state across onInit and onRender executions.

## The Problem

Variables declared in `onInit` aren't automatically available in `onRender`:

```js
// ❌ Doesn't work
// onInit
const myState = { count: 0 };

// onRender
myState.count++; // ReferenceError: myState is not defined
```

**Why:** `onInit` and `onRender` execute in isolated scopes.

---

## Solution 1: Global window Object (Recommended)

Store state on `window` — survives across hooks.

```js
// onInit
window.panelState = {
  previousValue: null,
  elements: {
    value: htmlGraphics.htmlNode.getElementById('value'),
    trend: htmlGraphics.htmlNode.getElementById('trend'),
  },
  config: JSON.parse(htmlGraphics.options.codeData || '{}'),
};

// onRender
const state = window.panelState;

const currentValue = htmlGraphics.data.series[0].fields[1].values.get(0);

if (state.previousValue !== null) {
  const delta = currentValue - state.previousValue;
  state.elements.trend.textContent = delta > 0 ? '↑' : '↓';
}

state.previousValue = currentValue;
```

**Pros:**
- Simple, explicit
- Works across all hooks
- Easy to debug (`console.log(window.panelState)`)

**Cons:**
- Global namespace pollution (mitigate with unique names)
- Persists across panel re-init (clear if needed)

---

## Solution 2: DOM Data Attributes

Store state directly on DOM elements.

```js
// onInit
const container = htmlGraphics.htmlNode.getElementById('container');
container.dataset.initialized = 'true';
container.dataset.count = '0';

// onRender
const container = htmlGraphics.htmlNode.getElementById('container');
const count = parseInt(container.dataset.count || '0');

container.dataset.count = (count + 1).toString();

if (container.dataset.initialized === 'true') {
  // First render after init
  container.dataset.initialized = 'false';
}
```

**Pros:**
- State lives with the element
- No global namespace usage
- Survives across re-renders

**Cons:**
- Only stores strings (need JSON or parse)
- Tied to a DOM element
- Verbose for complex state

---

## Solution 3: Closure Pattern

Wrap both hooks in a closure (advanced).

```js
// Entire code (onInit + onRender combined)
(function() {
  // Shared state
  let previousValue = null;
  let elements = null;
  
  // Initialize once
  if (!elements) {
    elements = {
      value: htmlGraphics.htmlNode.getElementById('value'),
    };
  }
  
  // Check if this is onInit or onRender
  const isInit = !window._panelInitialized;
  
  if (isInit) {
    window._panelInitialized = true;
    // onInit logic here
    console.log('Initializing');
  }
  
  // onRender logic (runs always)
  const currentValue = htmlGraphics.data.series[0].fields[1].values.get(0);
  
  if (previousValue !== null) {
    const delta = currentValue - previousValue;
    // Use delta
  }
  
  previousValue = currentValue;
})();
```

**Note:** This approach requires putting both `onInit` and `onRender` code in a single editor (usually `onRender`), losing the separation benefit.

**Pros:**
- True encapsulation
- No global pollution

**Cons:**
- Loses onInit/onRender separation
- Harder to debug
- Not idiomatic for this plugin

---

## State Lifecycle

### Initialization

```js
// onInit
if (!window.panelState) {
  window.panelState = {
    // Initial state
    counter: 0,
    lastUpdate: null,
    cache: {},
  };
} else {
  // State already exists (panel re-initialized)
  console.log('Reusing existing state');
}
```

### Reset on Re-Init

```js
// onInit
// Always reset state on init
window.panelState = {
  counter: 0,
  lastUpdate: null,
  cache: {},
};
```

### Cleanup

```js
// onInit
// Clear old intervals/timers
if (window.panelState?.interval) {
  clearInterval(window.panelState.interval);
}

window.panelState = {
  interval: setInterval(poll, 30000),
};
```

---

## State Patterns

### 1. Counter / Accumulator

```js
// onInit
window.panelState = { renderCount: 0 };

// onRender
window.panelState.renderCount++;
console.log(`Rendered ${window.panelState.renderCount} times`);
```

### 2. Delta Tracking

```js
// onInit
window.panelState = { previous: null };

// onRender
const current = getCurrentValue();

if (window.panelState.previous !== null) {
  const change = current - window.panelState.previous;
  showTrend(change);
}

window.panelState.previous = current;
```

### 3. Flag / Mode Toggle

```js
// onInit
window.panelState = { expanded: false };

const toggle = htmlGraphics.htmlNode.getElementById('toggle');
toggle.addEventListener('click', () => {
  window.panelState.expanded = !window.panelState.expanded;
  updateView();
});

function updateView() {
  const detail = htmlGraphics.htmlNode.getElementById('detail');
  detail.style.display = window.panelState.expanded ? 'block' : 'none';
}

// onRender
updateView(); // Re-apply state after data refresh
```

### 4. Cache

```js
// onInit
window.panelState = { cache: {} };

// onRender
const series = htmlGraphics.data.series;
const cache = window.panelState.cache;

series.forEach(frame => {
  const key = frame.refId;
  
  if (!cache[key]) {
    // First time seeing this series
    cache[key] = {
      firstSeen: Date.now(),
      count: 0,
    };
  }
  
  cache[key].count++;
  cache[key].lastValue = frame.fields[1].values.get(0);
});
```

### 5. History Buffer

```js
// onInit
window.panelState = {
  history: [],
  maxHistory: 20,
};

// onRender
const value = htmlGraphics.data.series[0].fields[1].values.get(0);

window.panelState.history.push({
  value: value,
  timestamp: Date.now(),
});

// Keep only last N items
if (window.panelState.history.length > window.panelState.maxHistory) {
  window.panelState.history.shift();
}

// Use history for trend/sparkline
renderSparkline(window.panelState.history);
```

---

## Namespace Convention

Avoid collisions when multiple panels use global state.

```js
// ❌ Generic name (collision risk)
window.state = {};

// ✅ Panel-specific namespace
window.topologyPanel = {};

// ✅ Unique prefix
window._gapit_panel_123 = {};

// ✅ Function scope (best)
window.getPanelState = window.getPanelState || (() => {
  const state = {};
  return () => state;
})();

// Usage
const state = window.getPanelState();
```

---

## State Inspection (Debug)

```js
// onRender
console.log('Current state:', window.panelState);

// Or add a debug button
// onInit
const debug = document.createElement('button');
debug.textContent = 'Log State';
debug.style.cssText = 'position: absolute; top: 4px; right: 4px; z-index: 10;';
debug.addEventListener('click', () => {
  console.log('Panel State:', window.panelState);
});
htmlGraphics.htmlNode.appendChild(debug);
```

---

## Complete Example: Stateful Panel

```js
// onInit
if (!window.myPanel) {
  window.myPanel = {
    // DOM refs
    elements: {
      value: htmlGraphics.htmlNode.getElementById('value'),
      trend: htmlGraphics.htmlNode.getElementById('trend'),
      history: htmlGraphics.htmlNode.getElementById('history'),
    },
    
    // State
    previousValue: null,
    history: [],
    maxHistory: 10,
    
    // Config
    config: htmlGraphics.options.codeData || {},
    
    // Timers
    interval: null,
  };
}

// Clear old interval
if (window.myPanel.interval) {
  clearInterval(window.myPanel.interval);
}

// Start new interval
window.myPanel.interval = setInterval(() => {
  // Poll or update something
}, 30000);

// Click handlers
window.myPanel.elements.value.addEventListener('click', () => {
  window.myPanel.history = []; // Clear history
});

// onRender
const state = window.myPanel;

const field = htmlGraphics.data.series[0].fields[1];
const currentValue = field.values.get(field.values.length - 1);

// Update value
state.elements.value.textContent = currentValue.toFixed(1);

// Track delta
if (state.previousValue !== null) {
  const delta = currentValue - state.previousValue;
  state.elements.trend.textContent = delta >= 0 ? `+${delta.toFixed(1)}` : delta.toFixed(1);
  state.elements.trend.style.color = delta >= 0 ? '#73BF69' : '#F2495C';
}

// Update history
state.history.push(currentValue);
if (state.history.length > state.maxHistory) {
  state.history.shift();
}

// Render sparkline from history
renderSparkline(state.history);

// Save for next render
state.previousValue = currentValue;

function renderSparkline(values) {
  state.elements.history.innerHTML = '';
  const max = Math.max(...values);
  const min = Math.min(...values);
  const range = max - min || 1;
  
  values.forEach(v => {
    const bar = document.createElement('div');
    bar.style.cssText = `
      flex: 1;
      background: #5794F2;
      height: ${((v - min) / range) * 100}%;
      min-height: 2px;
    `;
    state.elements.history.appendChild(bar);
  });
}
```

---

## Gotchas

1. **State persists across panel refresh** — clear in `onInit` if needed
2. **Global pollution** — use unique namespace
3. **Memory leaks** — clear intervals, remove event listeners in cleanup
4. **String-only in data attributes** — use JSON for complex data
5. **State ≠ reactive** — changing state doesn't auto-update DOM; call render function
6. **Multiple panels** — each needs unique state key if using `window`
