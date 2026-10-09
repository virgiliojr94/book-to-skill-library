# Recipe: Render the Last Value

**HTML/SVG**

```html
<div id="metric-value">No data</div>
```

**onRender** — this follows the official first-series, second-field query shape. The guards are required because the value field may not exist or may be empty.

```js
const output = htmlNode.getElementById('metric-value');
const valueField = data.series[0]?.fields[1];

if (output && valueField && valueField.values.length > 0) {
  output.textContent = valueField.values.get(valueField.values.length - 1);
} else if (output) {
  output.textContent = 'No data';
}
```

Source: official [`website/docs/examples/simple-example.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/examples/simple-example.md) and [`website/docs/examples/communicate-between-panels.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/examples/communicate-between-panels.md).
