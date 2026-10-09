# Data and Metrics

How Grafana data reaches your panel and how to extract values.

## PanelData Structure

```js
htmlGraphics.data = {
  series: DataFrame[],      // Query results
  state: LoadingState,      // 'Loading' | 'Streaming' | 'Done' | 'Error'
  timeRange: TimeRange,     // { from, to, raw }
  request: DataQueryRequest,// Query metadata
  error?: DataQueryError,   // If state = 'Error'
}
```

### Checking Data State

```js
// onRender
if (htmlGraphics.data.state === 'Error') {
  showError(htmlGraphics.data.error.message);
  return;
}

if (htmlGraphics.data.state === 'Loading') {
  showSpinner();
  return;
}

if (htmlGraphics.data.series.length === 0) {
  showNoData();
  return;
}

// Data ready
renderData();
```

---

## DataFrame (Series)

Each query result is a `DataFrame`:

```js
const frame = htmlGraphics.data.series[0];

frame.name;     // "up{instance='server-01'}" or custom name
frame.fields;   // Field[] — columns
frame.length;   // Number of rows
frame.refId;    // Query ref ID ('A', 'B', etc.)
frame.meta;     // Metadata (executed query, stats)
```

### Multiple Series

```js
// Iterate all series
htmlGraphics.data.series.forEach((frame, index) => {
  console.log(`Series ${index}:`, frame.name);
  
  const valueField = frame.fields[1];
  const lastValue = valueField.values.get(valueField.values.length - 1);
  
  console.log(`  Last value: ${lastValue}`);
});

// Find specific series by name
const cpuSeries = htmlGraphics.data.series.find(
  f => f.name.includes('cpu')
);

// Filter series by label
const prodSeries = htmlGraphics.data.series.filter(f => {
  const valueField = f.fields[1];
  return valueField.labels?.env === 'production';
});
```

---

## Field (Column)

```js
const field = frame.fields[1];

field.name;    // "Value" or metric name
field.type;    // 'time' | 'number' | 'string' | 'boolean'
field.values;  // Vector — use .get(index)
field.config;  // FieldConfig
field.labels;  // { instance: "server-01", job: "node" }
field.state;   // FieldState (calcs, range)
```

### Field Types

```js
// Time field (usually fields[0])
const timeField = frame.fields.find(f => f.type === 'time');

// Number fields (metrics)
const numberFields = frame.fields.filter(f => f.type === 'number');

// String fields (labels/dimensions)
const stringFields = frame.fields.filter(f => f.type === 'string');
```

### Field Config

```js
field.config = {
  unit: 'percent',         // Unit ID
  decimals: 2,             // Decimal places
  min: 0,                  // Soft min
  max: 100,                // Soft max
  thresholds: {            // Threshold config
    mode: 'absolute',
    steps: [
      { value: null, color: 'green' },
      { value: 80, color: 'yellow' },
      { value: 90, color: 'red' },
    ]
  },
  mappings: [],            // Value mappings
  displayName: 'CPU %',    // Custom display name
  color: {                 // Color config
    mode: 'thresholds',
    fixedColor: '#73BF69'
  }
}
```

---

## Extracting Values

### Last Value (Most Common)

```js
const field = htmlGraphics.data.series[0].fields[1];
const lastValue = field.values.get(field.values.length - 1);
```

### First Value

```js
const firstValue = field.values.get(0);
```

### All Values as Array

```js
const allValues = field.values.toArray();
// [1.2, 3.4, 5.6, ...]
```

### Iterate Time Series

```js
const timeField = frame.fields[0];
const valueField = frame.fields[1];

for (let i = 0; i < frame.length; i++) {
  const timestamp = timeField.values.get(i);
  const value = valueField.values.get(i);
  
  console.log(new Date(timestamp), value);
}
```

### Filter Null Values

```js
const values = field.values.toArray().filter(v => v !== null);
const lastNotNull = values[values.length - 1];
```

---

## getFieldDisplayValues() — Formatted Values

Returns values with Grafana formatting applied (units, decimals, thresholds, mappings).

```js
const displayValues = htmlGraphics.getFieldDisplayValues();

displayValues.forEach(dv => {
  console.log(dv.display.text);     // "42.3%"
  console.log(dv.display.numeric);  // 42.3
  console.log(dv.display.color);    // "#FF9830" (threshold color)
  console.log(dv.field.name);       // Source field name
});
```

### With Custom Calcs

```js
const values = htmlGraphics.getFieldDisplayValues({
  reduceOptions: {
    values: false,              // Reduce to single value per series
    calcs: ['mean', 'max'],     // Which calcs to compute
    fields: '/.*/'              // Field name regex filter
  }
});
```

### values: true (All Data Points)

```js
const allPoints = htmlGraphics.getFieldDisplayValues({
  reduceOptions: {
    values: true,  // Return every data point
    calcs: []
  }
});

// Returns one DisplayValue per data point
```

---

## Calcs (Reducers)

Pre-computed aggregations available in `field.state.calcs`.

```js
const field = htmlGraphics.data.series[0].fields[1];
const calcs = field.state?.calcs;

if (calcs) {
  console.log(calcs.mean);       // Average
  console.log(calcs.max);        // Maximum
  console.log(calcs.min);        // Minimum
  console.log(calcs.last);       // Last value
  console.log(calcs.lastNotNull);// Last non-null
  console.log(calcs.sum);        // Total
  console.log(calcs.count);      // Number of points
  console.log(calcs.delta);      // Cumulative change
  console.log(calcs.diff);       // Last - first
  console.log(calcs.diffperc);   // Percent change
  console.log(calcs.range);      // Max - min
}
```

**Note:** Calcs availability depends on panel option `calcsMutation`:
- `'none'` — Only calcs from data source
- `'standard'` — Standard calcs added
- `'all'` — All calcs added (slowest)

### Manual Reducer

```js
// Use fieldReducers directly
const meanReducer = htmlGraphics.fieldReducers.mean;
const field = htmlGraphics.data.series[0].fields[1];
const meanValue = meanReducer.reduce(field);
```

---

## Labels (Dimensions)

Prometheus-style labels attached to fields.

```js
const field = htmlGraphics.data.series[0].fields[1];

field.labels;
// { instance: "server-01", job: "node", env: "prod" }

// Access specific label
const instance = field.labels?.instance;

// Group series by label
const byInstance = {};
htmlGraphics.data.series.forEach(frame => {
  const field = frame.fields[1];
  const instance = field.labels?.instance || 'unknown';
  
  if (!byInstance[instance]) {
    byInstance[instance] = [];
  }
  byInstance[instance].push(frame);
});
```

---

## Time Range

```js
const tr = htmlGraphics.data.timeRange;

tr.from;      // DateTime (moment-like object)
tr.to;        // DateTime
tr.raw.from;  // 'now-6h' or absolute timestamp
tr.raw.to;    // 'now'

// Convert to JS Date
const fromDate = tr.from.toDate();
const toDate = tr.to.toDate();

// Duration in ms
const durationMs = tr.to.valueOf() - tr.from.valueOf();
```

---

## Common Data Patterns

### Single Stat

```js
const field = htmlGraphics.data.series[0].fields[1];
const value = field.values.get(field.values.length - 1);
const formatted = htmlGraphics.getFieldDisplayValues()[0].display.text;
```

### Multi-Series Comparison

```js
const values = htmlGraphics.data.series.map(frame => {
  const field = frame.fields[1];
  return {
    name: frame.name,
    value: field.values.get(field.values.length - 1),
    labels: field.labels,
  };
});

// Sort by value
values.sort((a, b) => b.value - a.value);
```

### Table Data

```js
const frame = htmlGraphics.data.series[0];
const rows = [];

for (let i = 0; i < frame.length; i++) {
  const row = {};
  frame.fields.forEach(field => {
    row[field.name] = field.values.get(i);
  });
  rows.push(row);
}

// rows = [{ time: 1234, value: 42, host: "server-01" }, ...]
```

### Status Mapping

```js
const statusField = frame.fields.find(f => f.name === 'status');
const status = statusField.values.get(statusField.values.length - 1);

const statusMap = {
  0: { text: 'DOWN', color: '#F2495C' },
  1: { text: 'UP', color: '#73BF69' },
  2: { text: 'DEGRADED', color: '#FF9830' },
};

const { text, color } = statusMap[status] || { text: 'UNKNOWN', color: '#888' };
```

---

## Debugging Data

```js
// onRender
console.log('Full data object:', htmlGraphics.data);
console.log('Series count:', htmlGraphics.data.series.length);

htmlGraphics.data.series.forEach((frame, i) => {
  console.log(`\nSeries ${i}: ${frame.name}`);
  console.log('  Length:', frame.length);
  console.log('  Fields:', frame.fields.map(f => `${f.name} (${f.type})`));
  
  frame.fields.forEach(field => {
    console.log(`  ${field.name}:`, field.values.toArray().slice(0, 5), '...');
  });
});
```
