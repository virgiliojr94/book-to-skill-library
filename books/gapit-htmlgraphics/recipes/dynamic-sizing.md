# Recipe: Dynamic Sizing

Responsive layouts that adapt to panel dimensions.

## Panel Dimensions

```js
// Available in onInit and onRender
const width = htmlGraphics.width;   // px
const height = htmlGraphics.height; // px
```

**Note:** Updates automatically when panel is resized.

---

## Responsive SVG (viewBox)

Simplest approach — SVG scales automatically.

**HTML/SVG:**
```html
<svg viewBox="0 0 400 300" 
     preserveAspectRatio="xMidYMid meet"
     style="width: 100%; height: 100%;">
  <circle cx="200" cy="150" r="80" fill="#5794F2" />
</svg>
```

**CSS:**
```css
svg {
  display: block;
  width: 100%;
  height: 100%;
}
```

**preserveAspectRatio values:**
| Value | Behavior |
|-------|----------|
| `xMidYMid meet` | Fit inside, center (default) |
| `xMidYMid slice` | Fill, crop overflow |
| `none` | Stretch to fill (distorts) |
| `xMinYMin meet` | Fit, align top-left |

---

## Explicit Dimension Calculation

When you need precise control.

**onRender:**
```js
const padding = 20;
const width = htmlGraphics.width - (padding * 2);
const height = htmlGraphics.height - (padding * 2);

const svg = htmlGraphics.htmlNode.querySelector('svg');
svg.setAttribute('width', width);
svg.setAttribute('height', height);
svg.setAttribute('viewBox', `0 0 ${width} ${height}`);

// Recalculate element positions
const centerX = width / 2;
const centerY = height / 2;
const radius = Math.min(width, height) / 3;

const circle = htmlGraphics.htmlNode.querySelector('#main-circle');
circle.setAttribute('cx', centerX);
circle.setAttribute('cy', centerY);
circle.setAttribute('r', radius);
```

---

## Responsive Font Sizing

Scale text with panel size.

```js
// onRender
const baseSize = Math.min(htmlGraphics.width, htmlGraphics.height) / 10;

const valueEl = htmlGraphics.htmlNode.getElementById('value');
valueEl.style.fontSize = `${baseSize}px`;

const labelEl = htmlGraphics.htmlNode.getElementById('label');
labelEl.style.fontSize = `${baseSize * 0.3}px`;
```

**Or with CSS clamp():**
```css
.value {
  font-size: clamp(16px, 8vw, 72px);
}

.label {
  font-size: clamp(10px, 2vw, 16px);
}
```

---

## Breakpoint-Based Layout

Switch layouts based on panel size.

**onRender:**
```js
const width = htmlGraphics.width;
const container = htmlGraphics.htmlNode.getElementById('container');

// Remove all layout classes
container.classList.remove('layout-xs', 'layout-sm', 'layout-md', 'layout-lg');

if (width < 300) {
  container.classList.add('layout-xs');
} else if (width < 500) {
  container.classList.add('layout-sm');
} else if (width < 800) {
  container.classList.add('layout-md');
} else {
  container.classList.add('layout-lg');
}
```

**CSS:**
```css
/* Extra small: stacked, minimal */
.layout-xs .metric-grid {
  grid-template-columns: 1fr;
  gap: 8px;
}
.layout-xs .label { display: none; }
.layout-xs .value { font-size: 24px; }

/* Small: 2 columns */
.layout-sm .metric-grid {
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
}
.layout-sm .value { font-size: 32px; }

/* Medium: 3 columns */
.layout-md .metric-grid {
  grid-template-columns: repeat(3, 1fr);
  gap: 16px;
}
.layout-md .value { font-size: 40px; }

/* Large: 4+ columns, full detail */
.layout-lg .metric-grid {
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 20px;
}
.layout-lg .value { font-size: 48px; }
.layout-lg .sparkline { display: block; }
```

---

## Adaptive Content Density

Show/hide elements based on available space.

```js
// onRender
const { width, height } = htmlGraphics;
const area = width * height;

const showSparklines = area > 100000;  // ~320x320
const showLabels = width > 250;
const showDetails = width > 400 && height > 200;

htmlGraphics.htmlNode.querySelectorAll('.sparkline').forEach(el => {
  el.style.display = showSparklines ? 'block' : 'none';
});

htmlGraphics.htmlNode.querySelectorAll('.label').forEach(el => {
  el.style.display = showLabels ? 'block' : 'none';
});

htmlGraphics.htmlNode.querySelectorAll('.detail').forEach(el => {
  el.style.display = showDetails ? 'block' : 'none';
});
```

---

## Dynamic Grid Columns

Calculate optimal column count.

```js
// onRender
const width = htmlGraphics.width;
const minCardWidth = 150;
const gap = 12;

const columns = Math.max(1, Math.floor((width + gap) / (minCardWidth + gap)));

const grid = htmlGraphics.htmlNode.getElementById('grid');
grid.style.display = 'grid';
grid.style.gridTemplateColumns = `repeat(${columns}, 1fr)`;
grid.style.gap = `${gap}px`;
```

**Or pure CSS (simpler):**
```css
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 12px;
}
```

---

## Fit Text to Container

Shrink text to avoid overflow.

```js
// onRender
function fitText(element, maxWidth, maxFontSize = 48, minFontSize = 10) {
  let fontSize = maxFontSize;
  element.style.fontSize = `${fontSize}px`;
  
  while (element.scrollWidth > maxWidth && fontSize > minFontSize) {
    fontSize -= 1;
    element.style.fontSize = `${fontSize}px`;
  }
}

const valueEl = htmlGraphics.htmlNode.getElementById('value');
valueEl.textContent = '1,234,567.89';
fitText(valueEl, htmlGraphics.width - 40);
```

---

## Responsive Topology Layout

Reposition nodes based on panel size.

```js
// onRender
const width = htmlGraphics.width;
const height = htmlGraphics.height;
const padding = 40;

const nodes = [
  { id: 'core', xPct: 0.5, yPct: 0.15 },
  { id: 'sw1', xPct: 0.25, yPct: 0.5 },
  { id: 'sw2', xPct: 0.75, yPct: 0.5 },
  { id: 'srv1', xPct: 0.15, yPct: 0.85 },
  { id: 'srv2', xPct: 0.35, yPct: 0.85 },
  { id: 'srv3', xPct: 0.65, yPct: 0.85 },
  { id: 'srv4', xPct: 0.85, yPct: 0.85 },
];

const usableWidth = width - (padding * 2);
const usableHeight = height - (padding * 2);

nodes.forEach(node => {
  const x = padding + (node.xPct * usableWidth);
  const y = padding + (node.yPct * usableHeight);
  
  const el = htmlGraphics.htmlNode.getElementById(`node-${node.id}`);
  if (el) {
    const circle = el.querySelector('circle');
    const text = el.querySelector('text');
    
    circle.setAttribute('cx', x);
    circle.setAttribute('cy', y);
    text.setAttribute('x', x);
    text.setAttribute('y', y + 4);
  }
});

// Update links
// ... recalculate line coordinates
```

---

## Aspect Ratio Container

Maintain proportions.

**CSS:**
```css
.aspect-container {
  position: relative;
  width: 100%;
  padding-bottom: 56.25%; /* 16:9 */
}

.aspect-content {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}
```

**Or modern CSS:**
```css
.aspect-container {
  aspect-ratio: 16 / 9;
  width: 100%;
}
```

---

## Scroll on Overflow

**Panel option:** Set `overflow` to `auto` or `scroll`.

**Or CSS:**
```css
.scrollable {
  max-height: 100%;
  overflow-y: auto;
  overflow-x: hidden;
}

/* Custom scrollbar */
.scrollable::-webkit-scrollbar {
  width: 6px;
}

.scrollable::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.05);
}

.scrollable::-webkit-scrollbar-thumb {
  background: rgba(255, 255, 255, 0.2);
  border-radius: 3px;
}

.scrollable::-webkit-scrollbar-thumb:hover {
  background: rgba(255, 255, 255, 0.3);
}
```

---

## Complete Responsive Example

**HTML/SVG:**
```html
<div id="container" class="responsive-container">
  <div class="header">
    <h3 id="title">Metrics</h3>
    <span id="count" class="count"></span>
  </div>
  <div id="grid" class="metric-grid"></div>
</div>
```

**CSS:**
```css
.responsive-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  padding: 12px;
  box-sizing: border-box;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  margin-bottom: 12px;
  flex-shrink: 0;
}

.metric-grid {
  display: grid;
  gap: 12px;
  flex: 1;
  overflow-y: auto;
  align-content: start;
}

.metric-card {
  background: rgba(255, 255, 255, 0.04);
  border-radius: 6px;
  padding: 12px;
  text-align: center;
}

/* Compact mode */
.compact .header { display: none; }
.compact .metric-card { padding: 8px; }
.compact .metric-name { display: none; }
```

**onRender:**
```js
const { width, height } = htmlGraphics;
const container = htmlGraphics.htmlNode.getElementById('container');
const grid = htmlGraphics.htmlNode.getElementById('grid');

// Compact mode for small panels
const isCompact = height < 150 || width < 250;
container.classList.toggle('compact', isCompact);

// Dynamic columns
const minCard = isCompact ? 80 : 140;
const cols = Math.max(1, Math.floor(width / minCard));
grid.style.gridTemplateColumns = `repeat(${cols}, 1fr)`;

// Responsive font
const fontSize = Math.max(14, Math.min(width / cols / 4, 36));

// Render cards
const displayValues = htmlGraphics.getFieldDisplayValues();
grid.innerHTML = '';

displayValues.forEach(dv => {
  const card = document.createElement('div');
  card.className = 'metric-card';
  
  const name = document.createElement('div');
  name.className = 'metric-name';
  name.textContent = dv.field.labels?.instance || dv.field.name;
  name.style.fontSize = '11px';
  name.style.color = '#888';
  name.style.marginBottom = '6px';
  
  const value = document.createElement('div');
  value.textContent = dv.display.text;
  value.style.fontSize = `${fontSize}px`;
  value.style.fontWeight = '600';
  value.style.color = dv.display.color;
  
  card.appendChild(name);
  card.appendChild(value);
  grid.appendChild(card);
});

// Update count
htmlGraphics.htmlNode.getElementById('count').textContent = 
  `${displayValues.length} items`;
```

---

## Panel Options for Sizing

| Option | Effect |
|--------|--------|
| `add100Percentage` | Adds `width:100%; height:100%` to root |
| `centerAlignContent` | Centers content horizontally + vertically |
| `overflow: hidden` | Clips overflow |
| `overflow: auto` | Scrollbars when needed |

---

## Gotchas

1. **Dimensions update on resize** — `onRender` fires on panel resize
2. **`box-sizing: border-box`** — include padding in size calculations
3. **SVG viewBox** — simplest responsive approach; avoid manual recalc when possible
4. **Flexbox/Grid first** — CSS layout is faster than JS calculations
5. **Avoid fixed pixels** — use percentages, `vw`/`vh`, `clamp()`
6. **Test at multiple sizes** — resize panel in edit mode to verify
7. **Height in Grafana** — panel height is set by dashboard grid, not content
