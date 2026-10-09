# Recipe: Panel Communication

Cross-panel interaction using Grafana's eventBus.

## Basic Pub/Sub

### Publisher Panel

```js
// onInit — set up click handlers
const nodes = htmlGraphics.htmlNode.querySelectorAll('.node');

nodes.forEach(node => {
  node.addEventListener('click', (e) => {
    const nodeId = e.currentTarget.dataset.id;
    
    htmlGraphics.eventBus.publish({
      type: 'node-selected',
      payload: {
        nodeId: nodeId,
        timestamp: Date.now(),
      }
    });
  });
});
```

### Subscriber Panel

```js
// onInit — subscribe to events
htmlGraphics.eventBus.subscribe({ type: 'node-selected' }, (event) => {
  const nodeId = event.payload.nodeId;
  
  // Update this panel's display
  const detail = htmlGraphics.htmlNode.getElementById('detail-view');
  detail.textContent = `Selected: ${nodeId}`;
  
  // Store for onRender
  window.selectedNode = nodeId;
});
```

---

## Complete Example: Master-Detail

### Panel A — Node List (Master)

**HTML/SVG:**
```html
<div class="node-list" id="node-list"></div>
```

**CSS:**
```css
.node-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 8px;
}

.node-item {
  padding: 10px 12px;
  border-radius: 4px;
  background: rgba(255, 255, 255, 0.03);
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  align-items: center;
  transition: background 0.2s ease;
}

.node-item:hover {
  background: rgba(255, 255, 255, 0.08);
}

.node-item.selected {
  background: rgba(87, 148, 242, 0.2);
  border-left: 3px solid #5794F2;
}

.node-status {
  width: 8px;
  height: 8px;
  border-radius: 50%;
}
```

**onInit:**
```js
window.masterState = {
  selectedId: null,
  list: htmlGraphics.htmlNode.getElementById('node-list'),
};
```

**onRender:**
```js
const list = window.masterState.list;
list.innerHTML = '';

const displayValues = htmlGraphics.getFieldDisplayValues();

displayValues.forEach(dv => {
  const nodeId = dv.field.labels?.instance || dv.field.name;
  
  const item = document.createElement('div');
  item.className = 'node-item';
  if (nodeId === window.masterState.selectedId) {
    item.classList.add('selected');
  }
  
  const name = document.createElement('span');
  name.textContent = nodeId;
  
  const right = document.createElement('div');
  right.style.display = 'flex';
  right.style.alignItems = 'center';
  right.style.gap = '8px';
  
  const value = document.createElement('span');
  value.textContent = dv.display.text;
  value.style.color = dv.display.color;
  
  const status = document.createElement('div');
  status.className = 'node-status';
  status.style.backgroundColor = dv.display.color;
  
  right.appendChild(value);
  right.appendChild(status);
  
  item.appendChild(name);
  item.appendChild(right);
  
  item.addEventListener('click', () => {
    window.masterState.selectedId = nodeId;
    
    // Publish selection
    htmlGraphics.eventBus.publish({
      type: 'node-selected',
      payload: {
        nodeId: nodeId,
        value: dv.display.numeric,
        labels: dv.field.labels,
      }
    });
    
    // Update visual selection
    list.querySelectorAll('.node-item').forEach(el => 
      el.classList.remove('selected')
    );
    item.classList.add('selected');
  });
  
  list.appendChild(item);
});
```

### Panel B — Detail View (Slave)

**HTML/SVG:**
```html
<div class="detail" id="detail">
  <div class="empty-state" id="empty">
    Select a node from the list
  </div>
  <div class="detail-content" id="content" style="display: none;">
    <h3 id="detail-title"></h3>
    <div class="detail-grid" id="detail-grid"></div>
  </div>
</div>
```

**onInit:**
```js
window.detailState = {
  selectedNode: null,
  els: {
    empty: htmlGraphics.htmlNode.getElementById('empty'),
    content: htmlGraphics.htmlNode.getElementById('content'),
    title: htmlGraphics.htmlNode.getElementById('detail-title'),
    grid: htmlGraphics.htmlNode.getElementById('detail-grid'),
  }
};

// Subscribe to selection events
htmlGraphics.eventBus.subscribe({ type: 'node-selected' }, (event) => {
  const { nodeId, labels } = event.payload;
  
  window.detailState.selectedNode = nodeId;
  
  const els = window.detailState.els;
  els.empty.style.display = 'none';
  els.content.style.display = 'block';
  els.title.textContent = nodeId;
  
  // Render labels
  els.grid.innerHTML = '';
  Object.entries(labels || {}).forEach(([key, value]) => {
    const row = document.createElement('div');
    row.className = 'detail-row';
    row.innerHTML = `<span class="key">${key}</span><span class="val">${value}</span>`;
    els.grid.appendChild(row);
  });
});
```

**onRender:**
```js
// Re-render detail if node selected
const selectedNode = window.detailState.selectedNode;
if (!selectedNode) return;

// Find matching series
const frame = htmlGraphics.data.series.find(f => {
  const field = f.fields[1];
  return (field.labels?.instance || field.name) === selectedNode;
});

if (frame) {
  const field = frame.fields[1];
  const value = field.values.get(field.values.length - 1);
  // Update detail with current value
}
```

---

## Hover Sync

Highlight related elements across panels on hover.

### Publisher

```js
// onInit
const items = htmlGraphics.htmlNode.querySelectorAll('.item');

items.forEach(item => {
  item.addEventListener('mouseenter', (e) => {
    htmlGraphics.eventBus.publish({
      type: 'item-hover',
      payload: { itemId: e.currentTarget.dataset.id }
    });
  });
  
  item.addEventListener('mouseleave', () => {
    htmlGraphics.eventBus.publish({
      type: 'item-hover',
      payload: { itemId: null }
    });
  });
});
```

### Subscriber

```js
// onInit
htmlGraphics.eventBus.subscribe({ type: 'item-hover' }, (event) => {
  const itemId = event.payload.itemId;
  
  const allItems = htmlGraphics.htmlNode.querySelectorAll('.item');
  
  allItems.forEach(item => {
    if (itemId === null) {
      item.classList.remove('dimmed', 'highlighted');
    } else if (item.dataset.id === itemId) {
      item.classList.add('highlighted');
      item.classList.remove('dimmed');
    } else {
      item.classList.add('dimmed');
      item.classList.remove('highlighted');
    }
  });
});
```

**CSS:**
```css
.item {
  transition: opacity 0.2s ease, transform 0.2s ease;
}

.item.dimmed {
  opacity: 0.3;
}

.item.highlighted {
  transform: scale(1.05);
  box-shadow: 0 0 0 2px #5794F2;
}
```

---

## Grafana Built-In Events

Subscribe to Grafana's native events.

```js
// onInit

// Time range changed
htmlGraphics.eventBus.subscribe(
  { type: 'time-range-updated' },
  (event) => {
    console.log('New range:', event.payload);
  }
);

// Refresh triggered
htmlGraphics.eventBus.subscribe(
  { type: 'refresh' },
  () => {
    console.log('Dashboard refreshed');
  }
);

// Variable changed
htmlGraphics.eventBus.subscribe(
  { type: 'variables-changed' },
  (event) => {
    console.log('Variables updated');
  }
);
```

**Note:** Event type names may vary by Grafana version. Log events to discover:

```js
// Debug: log all events (development only)
htmlGraphics.eventBus.getStream().subscribe(event => {
  console.log('Event:', event.type, event.payload);
});
```

---

## Filter Sync Pattern

Multiple panels sharing a filter state.

### Filter Panel

```js
// onInit
const filterInput = htmlGraphics.htmlNode.getElementById('filter-input');

let debounceTimer;
filterInput.addEventListener('input', (e) => {
  clearTimeout(debounceTimer);
  
  debounceTimer = setTimeout(() => {
    htmlGraphics.eventBus.publish({
      type: 'filter-changed',
      payload: { filter: e.target.value }
    });
  }, 300); // Debounce 300ms
});
```

### Consumer Panels

```js
// onInit
window.filterState = { filter: '' };

htmlGraphics.eventBus.subscribe({ type: 'filter-changed' }, (event) => {
  window.filterState.filter = event.payload.filter.toLowerCase();
  applyFilter();
});

function applyFilter() {
  const items = htmlGraphics.htmlNode.querySelectorAll('.item');
  const filter = window.filterState.filter;
  
  items.forEach(item => {
    const text = item.textContent.toLowerCase();
    item.style.display = text.includes(filter) ? '' : 'none';
  });
}

// onRender
applyFilter(); // Re-apply after data refresh
```

---

## Unsubscribe / Cleanup

```js
// onInit
const subscription = htmlGraphics.eventBus.subscribe(
  { type: 'my-event' },
  handler
);

// Store for later cleanup
window.subscriptions = window.subscriptions || [];
window.subscriptions.push(subscription);

// Cleanup (if panel re-initializes)
if (window.subscriptions) {
  window.subscriptions.forEach(sub => sub.unsubscribe());
  window.subscriptions = [];
}
```

---

## Event Naming Convention

Use namespaced event types to avoid collisions:

```js
// ✅ Good
type: 'topology:node-selected'
type: 'topology:link-hover'
type: 'metrics:filter-changed'

// ❌ Avoid generic names
type: 'click'
type: 'update'
type: 'change'
```

---

## Gotchas

1. **Subscribe in `onInit`** — subscribing in `onRender` creates duplicates
2. **eventBus is dashboard-scoped** — all panels on same dashboard share it
3. **No cross-dashboard events** — use URL params or variables instead
4. **Payload must be serializable** — avoid DOM refs, functions, circular refs
5. **Events are synchronous** — handlers run immediately
6. **State in `window`** — event handlers can't return values to onRender directly
7. **Debounce high-frequency events** — hover/input events can flood
