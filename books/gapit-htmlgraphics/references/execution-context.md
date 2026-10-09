# Execution Context — htmlGraphics API

All properties and methods available in `onInit` and `onRender` via the global `htmlGraphics` object.

## htmlNode

**Type:** `ShadowRoot`

DOM root for your HTML/SVG document. Works like `document` but scoped to the panel.

```js
// Get element by ID
const box = htmlGraphics.htmlNode.getElementById('metric-box');

// Query selector
const svg = htmlGraphics.htmlNode.querySelector('#diagram');

// Query all
const nodes = htmlGraphics.htmlNode.querySelectorAll('.node');
```

**Methods:**
- `getElementById(id)` — get element by ID
- `querySelector(selector)` — first matching element
- `querySelectorAll(selector)` — all matching elements (NodeList)
- `createElement(tagName)` — create new element
- `createElementNS(namespace, tagName)` — create SVG element

---

## data

**Type:** `PanelData`

Grafana's panel data: series, fields, time ranges, state.

```js
const series = htmlGraphics.data.series; // DataFrame[]
const state = htmlGraphics.data.state;   // 'Loading' | 'Done' | 'Error'
const timeRange = htmlGraphics.data.timeRange; // { from, to, raw }
```

### PanelData Structure

| Property | Type | Description |
|----------|------|-------------|
| `series` | `DataFrame[]` | Array of data frames |
| `state` | `LoadingState` | 'Loading' \| 'Streaming' \| 'Done' \| 'Error' |
| `timeRange` | `TimeRange` | Query time range |
| `request` | `DataQueryRequest` | Query metadata |
| `error` | `DataQueryError` | Error details (if state = 'Error') |

### DataFrame Structure

Each series is a `DataFrame`:

```js
const frame = htmlGraphics.data.series[0];

frame.name;    // Series name
frame.fields;  // Field[] (columns)
frame.length;  // Number of rows
```

### Field Structure

```js
const field = frame.fields[1]; // Index 0 = time, 1+ = values

field.name;    // Field name
field.type;    // 'time' | 'number' | 'string' | 'boolean'
field.values;  // Vector with .get(index) method
field.config;  // FieldConfig (unit, decimals, thresholds, mappings)
field.labels;  // Label key-value pairs (e.g. {instance: "server-01"})
field.state;   // FieldState (calcs, range)
```

### Accessing Values

```js
// Get last value
const field = htmlGraphics.data.series[0].fields[1];
const lastValue = field.values.get(field.values.length - 1);

// Iterate all values
for (let i = 0; i < field.values.length; i++) {
  const value = field.values.get(i);
  // Process value
}

// Convert to array
const allValues = field.values.toArray();
```

---

## theme

**Type:** `GrafanaTheme2`

Current Grafana theme (light/dark mode + design tokens).

```js
// Check dark mode
const isDark = htmlGraphics.theme.isDark; // boolean

// Access colors
const bg = htmlGraphics.theme.colors.background.primary;
const text = htmlGraphics.theme.colors.text.primary;

// Typography
const font = htmlGraphics.theme.typography.fontFamily;
const size = htmlGraphics.theme.typography.fontSize; // number (px)
```

### Common Color Paths

```js
// Backgrounds
theme.colors.background.primary   // Main background
theme.colors.background.secondary // Secondary background
theme.colors.background.canvas    // Canvas/page background

// Text
theme.colors.text.primary    // Primary text
theme.colors.text.secondary  // Secondary text
theme.colors.text.disabled   // Disabled text

// Borders
theme.colors.border.weak
theme.colors.border.medium
theme.colors.border.strong

// Semantic colors
theme.colors.primary.main    // Primary action color
theme.colors.success.main    // Success/OK
theme.colors.error.main      // Error/critical
theme.colors.warning.main    // Warning
theme.colors.info.main       // Info
```

---

## options

**Type:** Panel options object

Access panel configuration.

```js
// Custom codeData (JSON from panel settings)
const customData = htmlGraphics.options.codeData;

// Calcs mutation setting
const calcsMutation = htmlGraphics.options.calcsMutation;
// 'none' | 'standard' | 'all'

// Reduce options
const reduceOpts = htmlGraphics.options.reduceOptions;
// { values: boolean, fields: string, calcs: string[] }
```

---

## width / height

**Type:** `number`

Panel dimensions in CSS pixels.

```js
const panelWidth = htmlGraphics.width;
const panelHeight = htmlGraphics.height;

// Responsive SVG
const svg = htmlGraphics.htmlNode.querySelector('svg');
svg.setAttribute('width', htmlGraphics.width - 40);
svg.setAttribute('height', htmlGraphics.height - 40);
```

---

## getTemplateSrv()

**Type:** `() => TemplateSrv`

Access Grafana dashboard variables.

```js
// Get variable value
const region = htmlGraphics.getTemplateSrv().replace('$region');

// Get all variables
const vars = htmlGraphics.getTemplateSrv().getVariables();

// Check if variable exists
const hasRegion = htmlGraphics.getTemplateSrv().variableExists('region');
```

---

## replaceVariables()

**Type:** `(str: string) => string`

Replace `$variable` placeholders in strings.

```js
// Single variable
const url = htmlGraphics.replaceVariables('/api/data?region=$region');

// Multiple variables
const query = htmlGraphics.replaceVariables(
  'rate(requests{region="$region",env="$env"}[5m])'
);
```

---

## updateVariable()

**Type:** `(name: string, value: string | string[]) => void`

Set dashboard variable values programmatically.

```js
// Single value
htmlGraphics.updateVariable('region', 'us-west-2');

// Multi-value
htmlGraphics.updateVariable('services', ['api', 'db', 'cache']);

// Example: update on click
element.addEventListener('click', () => {
  htmlGraphics.updateVariable('selectedNode', element.dataset.id);
});
```

---

## getLocationSrv()

**Type:** `() => LocationService`

Navigate within Grafana or update URL.

```js
// Navigate to another dashboard
htmlGraphics.getLocationSrv().update({
  path: '/d/abc123/my-dashboard',
  query: { 'var-region': 'us-east-1' }
});

// Update current URL query params
htmlGraphics.getLocationSrv().partial({ 'var-filter': 'enabled' });

// Get current location
const location = htmlGraphics.getLocationSrv().getLocation();
```

---

## eventBus

**Type:** `EventBus`

Publish/subscribe events for panel-to-panel communication.

```js
// Subscribe (in onInit)
htmlGraphics.eventBus.subscribe({ type: 'node-clicked' }, (event) => {
  const nodeId = event.payload.nodeId;
  // Update this panel
});

// Publish (in onRender or event handler)
htmlGraphics.eventBus.publish({
  type: 'node-clicked',
  payload: { nodeId: 'server-01', status: 'down' }
});

// Unsubscribe
const subscription = htmlGraphics.eventBus.subscribe(...);
subscription.unsubscribe();
```

---

## getFieldDisplayValues()

**Type:** `(options?) => DisplayValue[]`

Get display-ready values with formatting (units, decimals, thresholds, mappings).

```js
// Default calcs
const displayValues = htmlGraphics.getFieldDisplayValues();

displayValues.forEach(dv => {
  console.log(dv.display.text);    // "42.3 ms" (formatted)
  console.log(dv.display.numeric); // 42.3 (raw number)
  console.log(dv.display.color);   // "#73BF69" (threshold color)
});

// Custom calcs
const values = htmlGraphics.getFieldDisplayValues({
  reduceOptions: {
    values: false,
    calcs: ['mean', 'lastNotNull']
  }
});
```

### DisplayValue Structure

```js
{
  display: {
    text: "42.3 ms",      // Formatted string
    numeric: 42.3,        // Raw number
    color: "#73BF69",     // Threshold color
    suffix: " ms",        // Unit suffix
    prefix: "",           // Unit prefix
  },
  field: Field,           // Source field reference
  view: DataFrameView,    // Parent DataFrame
  colIndex: 1,            // Column index
  rowIndex: 0,            // Row index (if values = true)
}
```

---

## fieldReducers

**Type:** `Record<string, FieldReducerInfo>`

All available calc/reducer functions.

```js
// List all reducers
Object.keys(htmlGraphics.fieldReducers).forEach(id => {
  const reducer = htmlGraphics.fieldReducers[id];
  console.log(id, reducer.name, reducer.description);
});

// Use a reducer manually
const maxReducer = htmlGraphics.fieldReducers.max;
const field = htmlGraphics.data.series[0].fields[1];
const maxValue = maxReducer.reduce(field);
```

### Common Reducers

| ID | Name | Description |
|----|------|-------------|
| `last` | Last | Last value |
| `lastNotNull` | Last (not null) | Last non-null value |
| `first` | First | First value |
| `mean` | Mean | Average |
| `max` | Max | Maximum |
| `min` | Min | Minimum |
| `sum` | Total | Sum of all values |
| `count` | Count | Number of values |
| `range` | Range | Difference between min and max |
| `delta` | Delta | Cumulative change |
| `diff` | Difference | Difference between first and last |
| `diffperc` | Difference percent | Percent change |

---

## Summary

**Core DOM:** `htmlNode`  
**Data:** `data`, `getFieldDisplayValues()`, `fieldReducers`  
**Theming:** `theme`, `width`, `height`  
**Config:** `options`  
**Variables:** `getTemplateSrv()`, `replaceVariables()`, `updateVariable()`  
**Navigation:** `getLocationSrv()`  
**Events:** `eventBus`

All available in both `onInit` and `onRender`.
