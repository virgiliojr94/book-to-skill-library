# Panel Options

Use the panel editor for HTML/SVG document, CSS, Root CSS, Custom properties, `onInit`, and `onRender`. Root CSS is loaded outside the shadow root; CSS is added before the HTML/SVG document inside the shadow root. Source: official [`website/docs/options.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/options.md).

## Dynamic options

- **Dynamic htmlGraphics** updates `htmlGraphics` when data is available.
- **Dynamic data** updates `data` for `onInit`; `onRender` updates normally.
- **Dynamic fieldDisplayValues** updates field display values.
- **Dynamic props** updates only values under `htmlGraphics.props`; mapped `htmlGraphics.width` and `htmlGraphics.height` values do not thereby become dynamic.
- **Trigger panelupdate when mounted** triggers `htmlNode.onpanelupdate` when the panel first loads.
- **Trigger onInit on resize** reruns `onInit` on width/height changes without cleanup or `onpanelwillunmount`.

Source: official [`website/docs/options.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/options.md).

## Calculations

Mutate calcs only adds calculations; it does not remove calculations Grafana already added. After changing from All calcs to No mutation, prior calculations can remain until the dashboard refreshes. The docs advise selecting only calculations needed, or using `getFieldDisplayValues` when only a few metrics need changed calculations. Source: official [`website/docs/options.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/options.md) and [`website/docs/performance.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/performance.md).
