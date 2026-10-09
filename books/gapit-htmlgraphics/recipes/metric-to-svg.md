# Recipe: Metric to SVG

Drive SVG graphics with metric values — gauges, diagrams, custom shapes.

## Radial Gauge

**HTML/SVG:**
```html
<svg viewBox="0 0 200 200" class="gauge">
  <!-- Background arc -->
  <circle cx="100" cy="100" r="80" 
          fill="none" 
          stroke="rgba(255,255,255,0.1)" 
          stroke-width="16" />
  
  <!-- Value arc -->
  <circle id="gauge-fill" cx="100" cy="100" r="80"
          fill="none"
          stroke="#5794F2"
          stroke-width="16"
          stroke-linecap="round"
          stroke-dasharray="502.65"
          stroke-dashoffset="502.65"
          transform="rotate(-90 100 100)" />
  
  <!-- Center text -->
  <text id="gauge-value" x="100" y="100" 
        text-anchor="middle" 
        dominant-baseline="middle"
        font-size="36" 
        font-weight="700"
        fill="#fff">--</text>
  
  <text x="100" y="130" 
        text-anchor="middle" 
        font-size="12" 
        fill="#888">CPU</text>
</svg>
```

**CSS:**
```css
.gauge {
  width: 100%;
  max-width: 200px;
  height: auto;
}

#gauge-fill {
  transition: stroke-dashoffset 0.5s ease, stroke 0.3s ease;
}
```

**onInit:**
```js
window.gauge = {
  fill: htmlGraphics.htmlNode.getElementById('gauge-fill'),
  value: htmlGraphics.htmlNode.getElementById('gauge-value'),
  circumference: 2 * Math.PI * 80, // r=80
};
```

**onRender:**
```js
const dv = htmlGraphics.getFieldDisplayValues()[0];
const pct = Math.min(Math.max(dv.display.numeric, 0), 100);

const offset = window.gauge.circumference * (1 - pct / 100);

window.gauge.fill.setAttribute('stroke-dashoffset', offset);
window.gauge.fill.setAttribute('stroke', dv.display.color);
window.gauge.value.textContent = Math.round(pct);
window.gauge.value.setAttribute('fill', dv.display.color);
```

---

## Semi-Circle Gauge

**HTML/SVG:**
```html
<svg viewBox="0 0 200 110" class="semi-gauge">
  <!-- Background arc (180°) -->
  <path d="M 20 100 A 80 80 0 0 1 180 100"
        fill="none"
        stroke="rgba(255,255,255,0.1)"
        stroke-width="16"
        stroke-linecap="round" />
  
  <!-- Value arc -->
  <path id="semi-fill"
        d="M 20 100 A 80 80 0 0 1 180 100"
        fill="none"
        stroke="#5794F2"
        stroke-width="16"
        stroke-linecap="round"
        stroke-dasharray="251.33"
        stroke-dashoffset="251.33" />
  
  <text id="semi-value" x="100" y="85"
        text-anchor="middle"
        font-size="32"
        font-weight="700"
        fill="#fff">--</text>
</svg>
```

**onRender:**
```js
const dv = htmlGraphics.getFieldDisplayValues()[0];
const pct = Math.min(Math.max(dv.display.numeric, 0), 100);

// Semi-circle arc length = π * r = π * 80 ≈ 251.33
const arcLength = Math.PI * 80;
const offset = arcLength * (1 - pct / 100);

const fill = htmlGraphics.htmlNode.getElementById('semi-fill');
fill.setAttribute('stroke-dashoffset', offset);
fill.setAttribute('stroke', dv.display.color);

htmlGraphics.htmlNode.getElementById('semi-value').textContent = dv.display.text;
```

---

## Network Topology

**HTML/SVG:**
```html
<svg viewBox="0 0 400 300" class="topology">
  <!-- Links -->
  <g id="links" stroke="#444" stroke-width="2"></g>
  
  <!-- Nodes -->
  <g id="nodes"></g>
</svg>
```

**CSS:**
```css
.topology {
  width: 100%;
  height: 100%;
}

.node circle {
  transition: fill 0.3s ease, r 0.2s ease;
  cursor: pointer;
}

.node:hover circle {
  r: 22;
}

.node text {
  font-size: 10px;
  fill: #fff;
  text-anchor: middle;
  pointer-events: none;
}

.link {
  transition: stroke 0.3s ease, stroke-width 0.3s ease;
}
```

**onInit:**
```js
// Define topology structure
window.topology = {
  nodes: [
    { id: 'core', label: 'Core', x: 200, y: 50 },
    { id: 'sw1', label: 'SW-1', x: 100, y: 150 },
    { id: 'sw2', label: 'SW-2', x: 300, y: 150 },
    { id: 'srv1', label: 'SRV-1', x: 50, y: 250 },
    { id: 'srv2', label: 'SRV-2', x: 150, y: 250 },
    { id: 'srv3', label: 'SRV-3', x: 250, y: 250 },
    { id: 'srv4', label: 'SRV-4', x: 350, y: 250 },
  ],
  links: [
    { from: 'core', to: 'sw1' },
    { from: 'core', to: 'sw2' },
    { from: 'sw1', to: 'srv1' },
    { from: 'sw1', to: 'srv2' },
    { from: 'sw2', to: 'srv3' },
    { from: 'sw2', to: 'srv4' },
  ],
};

const svgNS = 'http://www.w3.org/2000/svg';
const linksGroup = htmlGraphics.htmlNode.getElementById('links');
const nodesGroup = htmlGraphics.htmlNode.getElementById('nodes');

// Build links
window.topology.links.forEach((link, i) => {
  const from = window.topology.nodes.find(n => n.id === link.from);
  const to = window.topology.nodes.find(n => n.id === link.to);
  
  const line = document.createElementNS(svgNS, 'line');
  line.setAttribute('id', `link-${i}`);
  line.setAttribute('class', 'link');
  line.setAttribute('x1', from.x);
  line.setAttribute('y1', from.y);
  line.setAttribute('x2', to.x);
  line.setAttribute('y2', to.y);
  linksGroup.appendChild(line);
});

// Build nodes
window.topology.nodes.forEach(node => {
  const g = document.createElementNS(svgNS, 'g');
  g.setAttribute('class', 'node');
  g.setAttribute('id', `node-${node.id}`);
  
  const circle = document.createElementNS(svgNS, 'circle');
  circle.setAttribute('cx', node.x);
  circle.setAttribute('cy', node.y);
  circle.setAttribute('r', 18);
  circle.setAttribute('fill', '#555');
  
  const text = document.createElementNS(svgNS, 'text');
  text.setAttribute('x', node.x);
  text.setAttribute('y', node.y + 4);
  text.textContent = node.label;
  
  g.appendChild(circle);
  g.appendChild(text);
  
  // Click handler
  g.addEventListener('click', () => {
    htmlGraphics.updateVariable('selectedNode', node.id);
  });
  
  nodesGroup.appendChild(g);
});
```

**onRender:**
```js
// Map metrics to nodes by label
htmlGraphics.data.series.forEach(frame => {
  const field = frame.fields[1];
  const nodeId = field.labels?.node || field.labels?.instance;
  
  if (!nodeId) return;
  
  const status = field.values.get(field.values.length - 1);
  const nodeEl = htmlGraphics.htmlNode.getElementById(`node-${nodeId}`);
  
  if (nodeEl) {
    const circle = nodeEl.querySelector('circle');
    circle.setAttribute('fill', status === 1 ? '#73BF69' : '#F2495C');
  }
});
```

---

## Bar Chart

**HTML/SVG:**
```html
<svg viewBox="0 0 400 200" class="bar-chart">
  <g id="bars"></g>
  <g id="labels"></g>
  <line x1="40" y1="170" x2="390" y2="170" stroke="#444" stroke-width="1" />
</svg>
```

**onRender:**
```js
const svgNS = 'http://www.w3.org/2000/svg';
const barsGroup = htmlGraphics.htmlNode.getElementById('bars');
const labelsGroup = htmlGraphics.htmlNode.getElementById('labels');

barsGroup.innerHTML = '';
labelsGroup.innerHTML = '';

const displayValues = htmlGraphics.getFieldDisplayValues();
const max = Math.max(...displayValues.map(dv => dv.display.numeric));

const chartHeight = 130;
const chartBottom = 170;
const barWidth = 300 / displayValues.length - 10;

displayValues.forEach((dv, i) => {
  const height = (dv.display.numeric / max) * chartHeight;
  const x = 50 + i * (barWidth + 10);
  const y = chartBottom - height;
  
  // Bar
  const rect = document.createElementNS(svgNS, 'rect');
  rect.setAttribute('x', x);
  rect.setAttribute('y', y);
  rect.setAttribute('width', barWidth);
  rect.setAttribute('height', height);
  rect.setAttribute('fill', dv.display.color);
  rect.setAttribute('rx', 3);
  barsGroup.appendChild(rect);
  
  // Value label
  const valueText = document.createElementNS(svgNS, 'text');
  valueText.setAttribute('x', x + barWidth / 2);
  valueText.setAttribute('y', y - 6);
  valueText.setAttribute('text-anchor', 'middle');
  valueText.setAttribute('font-size', '11');
  valueText.setAttribute('fill', '#fff');
  valueText.textContent = dv.display.numeric.toFixed(0);
  labelsGroup.appendChild(valueText);
  
  // Name label
  const nameText = document.createElementNS(svgNS, 'text');
  nameText.setAttribute('x', x + barWidth / 2);
  nameText.setAttribute('y', chartBottom + 16);
  nameText.setAttribute('text-anchor', 'middle');
  nameText.setAttribute('font-size', '10');
  nameText.setAttribute('fill', '#888');
  nameText.textContent = (dv.field.labels?.instance || '').slice(0, 8);
  labelsGroup.appendChild(nameText);
});
```

---

## Line Chart (Sparkline SVG)

**HTML/SVG:**
```html
<svg viewBox="0 0 400 100" preserveAspectRatio="none" class="sparkline-svg">
  <path id="spark-line" fill="none" stroke="#5794F2" stroke-width="2" />
  <path id="spark-area" fill="url(#gradient)" opacity="0.2" />
  
  <defs>
    <linearGradient id="gradient" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0%" stop-color="#5794F2" stop-opacity="0.6" />
      <stop offset="100%" stop-color="#5794F2" stop-opacity="0" />
    </linearGradient>
  </defs>
</svg>
```

**onRender:**
```js
const field = htmlGraphics.data.series[0].fields[1];
const values = field.values.toArray().filter(v => v !== null);

if (values.length < 2) return;

const max = Math.max(...values);
const min = Math.min(...values);
const range = max - min || 1;

const width = 400;
const height = 100;
const stepX = width / (values.length - 1);

// Build line path
const points = values.map((v, i) => {
  const x = i * stepX;
  const y = height - ((v - min) / range) * height;
  return `${x},${y}`;
});

const linePath = 'M ' + points.join(' L ');
htmlGraphics.htmlNode.getElementById('spark-line').setAttribute('d', linePath);

// Build area path (line + close to bottom)
const areaPath = linePath + ` L ${width},${height} L 0,${height} Z`;
htmlGraphics.htmlNode.getElementById('spark-area').setAttribute('d', areaPath);
```

---

## Status Grid (Heatmap-style)

**HTML/SVG:**
```html
<svg viewBox="0 0 400 200" class="status-grid">
  <g id="grid-cells"></g>
</svg>
```

**onRender:**
```js
const svgNS = 'http://www.w3.org/2000/svg';
const grid = htmlGraphics.htmlNode.getElementById('grid-cells');
grid.innerHTML = '';

const displayValues = htmlGraphics.getFieldDisplayValues();

const cols = 10;
const cellSize = 36;
const gap = 4;

displayValues.forEach((dv, i) => {
  const col = i % cols;
  const row = Math.floor(i / cols);
  
  const x = col * (cellSize + gap);
  const y = row * (cellSize + gap);
  
  const rect = document.createElementNS(svgNS, 'rect');
  rect.setAttribute('x', x);
  rect.setAttribute('y', y);
  rect.setAttribute('width', cellSize);
  rect.setAttribute('height', cellSize);
  rect.setAttribute('rx', 4);
  rect.setAttribute('fill', dv.display.color);
  
  // Tooltip via title element
  const title = document.createElementNS(svgNS, 'title');
  title.textContent = `${dv.field.labels?.instance}: ${dv.display.text}`;
  rect.appendChild(title);
  
  grid.appendChild(rect);
});
```

---

## SVG Gotchas

1. **Use `createElementNS`** — SVG elements need namespace:
   ```js
   const svgNS = 'http://www.w3.org/2000/svg';
   const circle = document.createElementNS(svgNS, 'circle');
   ```

2. **Attributes vs properties** — use `setAttribute()` for SVG:
   ```js
   circle.setAttribute('fill', '#fff');  // ✅
   circle.style.fill = '#fff';           // ✅ (also works)
   circle.fill = '#fff';                 // ❌ won't work
   ```

3. **viewBox for responsiveness:**
   ```html
   <svg viewBox="0 0 400 300" preserveAspectRatio="xMidYMid meet">
   ```

4. **stroke-dasharray for arcs:**
   - Full circle: `2 * Math.PI * radius`
   - Semi-circle: `Math.PI * radius`

5. **Transitions in CSS:**
   ```css
   #gauge-fill {
     transition: stroke-dashoffset 0.5s ease;
   }
   ```

6. **Text anchoring:**
   ```html
   <text text-anchor="middle" dominant-baseline="middle">
   ```

7. **Clear before rebuild** — `group.innerHTML = ''` in onRender
