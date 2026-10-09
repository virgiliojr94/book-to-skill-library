# Lifecycle — onInit vs onRender

Two JavaScript execution hooks. Understanding when each runs is critical for correct and performant panels.

## Execution Order

```
Panel loads
    ↓
onInit  ← runs ONCE
    ↓
onRender  ← runs on panel load AND every data refresh
    ↓
(time range change / refresh / variable change)
    ↓
onRender  ← runs again
    ↓
onRender  ← runs again
    ↓
...
```

**Key rule:** `onRender` also runs on panel load (right after `onInit`).

---

## onInit

**Runs:** Once, when panel is loaded/mounted

**Use for:**
- Creating static DOM structure
- Setting up event listeners
- Caching DOM element references
- Initializing libraries/objects
- Subscribing to eventBus
- One-time calculations

**Example:**

```js
// onInit — setup that shouldn't repeat

// 1. Cache DOM references (avoids re-querying every render)
const elements = {
  title: htmlGraphics.htmlNode.getElementById('title'),
  value: htmlGraphics.htmlNode.getElementById('value'),
  status: htmlGraphics.htmlNode.getElementById('status'),
};

// 2. Set up event listeners (would duplicate if in onRender)
elements.status.addEventListener('click', () => {
  htmlGraphics.updateVariable('selectedStatus', 'active');
});

// 3. Subscribe to events
htmlGraphics.eventBus.subscribe({ type: 'external-update' }, (event) => {
  elements.title.textContent = event.payload.newTitle;
});

// 4. Create static structure
const container = htmlGraphics.htmlNode.getElementById('grid');
for (let i = 0; i < 12; i++) {
  const cell = document.createElement('div');
  cell.id = `cell-${i}`;
  cell.className = 'grid-cell';
  container.appendChild(cell);
}

// 5. Store references globally for onRender
window.panelElements = elements;
```

---

## onRender

**Runs:** On panel load + every data refresh (time range change, auto-refresh, variable change)

**Use for:**
- Updating text content with new values
- Applying threshold colors
- Toggling visibility
- Recalculating positions/sizes
- Any data-driven updates

**Example:**

```js
// onRender — data-driven updates

// Access cached elements (set in onInit)
const elements = window.panelElements;

// Get current data
const field = htmlGraphics.data.series[0].fields[1];
const value = field.values.get(field.values.length - 1);

// Update display
elements.value.textContent = value.toFixed(2);

// Apply threshold color
const displayValues = htmlGraphics.getFieldDisplayValues();
elements.value.style.color = displayValues[0].display.color;

// Conditional visibility
if (value > 80) {
  elements.status.style.display = 'block';
  elements.status.textContent = 'HIGH LOAD';
} else {
  elements.status.style.display = 'none';
}
```

---

## State Sharing Between Hooks

Variables declared in `onInit` are **not** automatically available in `onRender`. Use one of these patterns:

### Pattern 1: Global window object

```js
// onInit
window.panelState = {
  elements: {
    value: htmlGraphics.htmlNode.getElementById('value'),
  },
  previousValue: null,
};

// onRender
const state = window.panelState;
const currentValue = htmlGraphics.data.series[0].fields[1].values.get(0);

if (state.previousValue !== null) {
  const delta = currentValue - state.previousValue;
  // Show trend arrow
}

state.previousValue = currentValue;
```

### Pattern 2: DOM data attributes

```js
// onInit
const container = htmlGraphics.htmlNode.getElementById('container');
container.dataset.initialized = 'true';

// onRender
const container = htmlGraphics.htmlNode.getElementById('container');
if (container.dataset.initialized === 'true') {
  // First render after init
  container.dataset.initialized = 'false';
}
```

### Pattern 3: Re-query in onRender (simplest, slower)

```js
// onRender only — no onInit needed
const valueElement = htmlGraphics.htmlNode.getElementById('value');
valueElement.textContent = getCurrentValue();
```

---

## Common Mistakes

### ❌ Event listeners in onRender

```js
// BAD: creates duplicate listeners on every refresh
// onRender
button.addEventListener('click', handleClick);
```

**Fix:** Move to `onInit`.

```js
// GOOD
// onInit
button.addEventListener('click', handleClick);
```

### ❌ Creating DOM elements in onRender without cleanup

```js
// BAD: appends new rows on every refresh
// onRender
data.forEach(row => {
  const tr = document.createElement('tr');
  tbody.appendChild(tr);
});
```

**Fix:** Clear before appending.

```js
// GOOD
// onRender
tbody.innerHTML = ''; // Clear first
data.forEach(row => {
  const tr = document.createElement('tr');
  tbody.appendChild(tr);
});
```

### ❌ Expensive operations in onRender

```js
// BAD: parses JSON on every refresh
// onRender
const config = JSON.parse(htmlGraphics.options.codeData);
```

**Fix:** Parse once in `onInit`.

```js
// GOOD
// onInit
window.panelConfig = JSON.parse(htmlGraphics.options.codeData);

// onRender
const config = window.panelConfig;
```

### ❌ Querying DOM repeatedly

```js
// BAD: DOM query on every refresh
// onRender
htmlGraphics.htmlNode.getElementById('a').textContent = '1';
htmlGraphics.htmlNode.getElementById('b').textContent = '2';
htmlGraphics.htmlNode.getElementById('c').textContent = '3';
```

**Fix:** Cache in `onInit`.

```js
// GOOD
// onInit
window.els = {
  a: htmlGraphics.htmlNode.getElementById('a'),
  b: htmlGraphics.htmlNode.getElementById('b'),
  c: htmlGraphics.htmlNode.getElementById('c'),
};

// onRender
window.els.a.textContent = '1';
window.els.b.textContent = '2';
window.els.c.textContent = '3';
```

---

## Debugging Lifecycle

```js
// onInit
console.log('onInit fired at', new Date().toISOString());

// onRender
console.log('onRender fired at', new Date().toISOString());
console.log('Data state:', htmlGraphics.data.state);
console.log('Series count:', htmlGraphics.data.series.length);
```

Open DevTools console (`Ctrl+Shift+J`) to see output.

---

## Decision Guide

| Task | Hook |
|------|------|
| Create DOM structure | onInit |
| Add event listeners | onInit |
| Cache element refs | onInit |
| Parse config JSON | onInit |
| Initialize libraries | onInit |
| Subscribe to eventBus | onInit |
| Update text with metric | onRender |
| Apply threshold colors | onRender |
| Toggle visibility | onRender |
| Recalculate positions | onRender |
| Respond to data changes | onRender |
| Publish eventBus events | onRender (or event handlers) |
