# Data and Metrics

Read query results from `data.series`. The official examples use `data.series[0].fields[1]` when the first result has its metric values in its second field. This is query-shape dependent: guard the series, field, and value length before positional access. Source: official [`website/docs/guides/how-to-get-metrics.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/guides/how-to-get-metrics.md) and [`website/docs/examples/communicate-between-panels.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/examples/communicate-between-panels.md).

```js
const output = htmlNode.querySelector('#output');
const valueField = data.series[0]?.fields[1];

if (output && valueField && valueField.values.length > 0) {
  output.textContent = valueField.values.get(valueField.values.length - 1);
} else if (output) {
  output.textContent = 'No data';
}
```

Some data sources provide calculations at `data.series[0].fields[1].state.calcs`; the docs caution that not every data source does, so raw values are usually the safer choice. Source: official [`website/docs/guides/how-to-get-metrics.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/guides/how-to-get-metrics.md).

`htmlGraphics.getFieldDisplayValues()` returns values using `reduceOptions`; when called without arguments it uses the panel’s reduction and prop-derived settings. Source: official [`website/docs/references.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/references.md); implementation: [`src/HTMLPanel.tsx`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/src/HTMLPanel.tsx).
