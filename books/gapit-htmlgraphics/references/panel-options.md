# Panel Options

Plugin configuration options in the Grafana panel editor.

## Value Options

### Mutate calcs (calcsMutation)

Controls which calc/reducer values are added to `field.state.calcs`.

| Value | Behavior | Performance |
|-------|----------|-------------|
| `none` | Only calcs from data source | Fastest |
| `standard` | Adds standard calcs (`{standard: true}`) | Medium |
| `all` | Adds all available calcs | Slowest |

**Access in code:**
```js
const mutation = htmlGraphics.options.calcsMutation;
```

**Standard calcs added with `'standard'`:**
```js
{
  allIsNull: false,
  allIsZero: false,
  count: 1081,
  delta: 5160.29,
  diff: -27.56,
  diffperc: -0.79,
  first: 34.50,
  firstNotNull: 34.50,
  last: 6.94,
  lastNotNull: 6.94,
  logmin: 0.0001,
  max: 92.33,
  mean: 35.17,
  min: 0.05,
  range: 92.28,
  step: 30000,
  sum: 38032.42,
}
```

**⚠️ Gotcha:** Changing from "All calcs" to "No mutation" shows old calcs until dashboard refresh. The data object needs to update.

**Recommendation:** Use `'none'` unless you need calcs; use `getFieldDisplayValues()` for formatted values instead.

---

### Reduce Options

Controls how multiple values reduce to display values.

```js
htmlGraphics.options.reduceOptions = {
  values: false,           // false = reduce, true = all data points
  calcs: ['lastNotNull'],  // Which calc to use when values=false
  fields: '',              // Field name regex filter ('' = all numeric)
}
```

**values: false (default)**
- Reduces each series to one value using `calcs[0]`
- Returns one DisplayValue per series

**values: true**
- Returns every data point as a DisplayValue
- Use for tables or detailed visualizations

**fields regex examples:**
```js
fields: ''          // All numeric fields
fields: '/.*/'      // All fields (including strings)
fields: '/^cpu/'    // Fields starting with "cpu"
fields: 'Value'     // Exact field name
```

---

## Display Options

### Add 100% (add100Percentage)

**Type:** boolean

Adds `width: 100%; height: 100%` to the root element.

```js
const add100 = htmlGraphics.options.add100Percentage;
```

**Use when:** You want the HTML/SVG to fill the panel area.

---

### Center align content (centerAlignContent)

**Type:** boolean

Centers content horizontally and vertically within panel.

```js
const centered = htmlGraphics.options.centerAlignContent;
```

---

### Overflow

**Type:** `'visible' | 'hidden' | 'scroll' | 'auto'`

Controls overflow behavior of panel content.

```js
const overflow = htmlGraphics.options.overflow;
```

| Value | Behavior |
|-------|----------|
| `visible` | Content can overflow panel bounds |
| `hidden` | Clips overflowing content |
| `scroll` | Always shows scrollbars |
| `auto` | Shows scrollbars when needed |

---

### SVG base fix (SVGBaseFix)

**Type:** boolean

Fixes SVG rendering issues in some browsers by adjusting base URL handling.

```js
const svgFix = htmlGraphics.options.SVGBaseFix;
```

**Enable when:** SVG `<use>` elements or external references aren't rendering.

---

## Code Editors

### CSS (css)

Global styles for the panel's shadow DOM.

```css
/* Applies only within this panel */
* {
  font-family: 'Open Sans', sans-serif;
}

.metric-box {
  border: 2px solid #555;
  border-radius: 8px;
  padding: 16px;
}
```

**Access in code:**
```js
const cssCode = htmlGraphics.options.css;
```

---

### Root CSS (rootCSS)

Styles applied to the root container element.

```css
/* Applied to the panel root */
display: flex;
align-items: center;
justify-content: center;
background: linear-gradient(180deg, #1f1f1f, #2d2d2d);
```

**Access in code:**
```js
const rootCSS = htmlGraphics.options.rootCSS;
```

**Difference from CSS:** `rootCSS` is inline style on root element; `css` is a stylesheet.

---

### HTML/SVG (html)

The markup document.

```html
<div class="container">
  <svg width="200" height="200">
    <circle id="gauge" cx="100" cy="100" r="80" />
  </svg>
  <div id="value-label"></div>
</div>
```

**Access in code:**
```js
const htmlCode = htmlGraphics.options.html;
```

---

### Code Data (codeData)

JSON object available in JavaScript. Use for configuration, thresholds, mappings, static data.

**Panel setting:**
```json
{
  "thresholds": {
    "warning": 70,
    "critical": 90
  },
  "labels": {
    "cpu": "CPU Usage",
    "mem": "Memory"
  },
  "colors": ["#73BF69", "#FF9830", "#F2495C"]
}
```

**Access in code:**
```js
// onInit
const config = htmlGraphics.options.codeData;

const warningThreshold = config.thresholds.warning;
const cpuLabel = config.labels.cpu;
```

**Note:** Already parsed as object — no `JSON.parse()` needed.

---

### onInit (onInit)

JavaScript that runs once when panel loads.

```js
// Setup code
window.panelState = {
  elements: {
    value: htmlGraphics.htmlNode.getElementById('value'),
  }
};
```

**Access in code:**
```js
const initCode = htmlGraphics.options.onInit;
```

---

### onRender (onRender)

JavaScript that runs on panel load + every data refresh.

```js
// Update code
const field = htmlGraphics.data.series[0].fields[1];
const value = field.values.get(field.values.length - 1);
window.panelState.elements.value.textContent = value;
```

**Access in code:**
```js
const renderCode = htmlGraphics.options.onRender;
```

---

## Panel JSON Example

Complete panel configuration:

```json
{
  "type": "gapit-htmlgraphics-panel",
  "title": "Custom Visualization",
  "options": {
    "calcsMutation": "none",
    "reduceOptions": {
      "values": false,
      "calcs": ["lastNotNull"],
      "fields": ""
    },
    "add100Percentage": true,
    "centerAlignContent": true,
    "overflow": "hidden",
    "SVGBaseFix": true,
    "codeData": "{\n  \"threshold\": 80\n}",
    "rootCSS": "display: flex;\nalign-items: center;",
    "css": "* {\n  font-family: Open Sans;\n}",
    "html": "<div id=\"value\"></div>",
    "onInit": "window.el = htmlGraphics.htmlNode.getElementById('value');",
    "onRender": "const f = htmlGraphics.data.series[0].fields[1];\nwindow.el.textContent = f.values.get(0);"
  },
  "gridPos": { "h": 8, "w": 12, "x": 0, "y": 0 }
}
```

---

## Provisioning Panels

When provisioning dashboards as JSON, escape newlines in code fields:

```json
{
  "options": {
    "onRender": "const field = htmlGraphics.data.series[0].fields[1];\nconst value = field.values.get(field.values.length - 1);\nhtmlGraphics.htmlNode.getElementById('value').textContent = value;"
  }
}
```

**Tip:** Develop in UI, then export dashboard JSON (`Dashboard settings → JSON Model`).

---

## Option Decision Guide

| Need | Option | Value |
|------|--------|-------|
| Fill panel area | `add100Percentage` | `true` |
| Center content | `centerAlignContent` | `true` |
| Scrollable content | `overflow` | `auto` or `scroll` |
| Clip overflow | `overflow` | `hidden` |
| Fast rendering | `calcsMutation` | `none` |
| Need mean/max/min | `calcsMutation` | `standard` |
| SVG not rendering | `SVGBaseFix` | `true` |
| Static config | `codeData` | JSON object |
| Reusable styles | `css` | CSS rules |
| Root layout | `rootCSS` | Inline styles |
