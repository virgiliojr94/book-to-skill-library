---
name: gapit-htmlgraphics
description: Use when creating or updating Grafana HTML Graphics panels with HTML/SVG, custom properties, metric rendering, Grafana template variables, panel lifecycle hooks, or cross-panel CustomEvent communication.
---

# GAPIT HTML Graphics

Use this index for source-backed HTML Graphics panel code. Build markup in **HTML/SVG**, configure it with **Custom properties**, run setup in **onInit**, and update data-driven DOM in **onRender**. The hooks are separate executions; each code block must be self-contained. Source: official [`website/docs/quick-start.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/quick-start.md) and [`src/HTMLPanel.tsx`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/src/HTMLPanel.tsx).

## Navigation

| Need | Read |
| --- | --- |
| Execution context, hook isolation, available references | [references/execution-context.md](references/execution-context.md) |
| Query-result access and positional-field guard | [references/data-and-metrics.md](references/data-and-metrics.md) |
| `panelupdate`, `panelwillunmount`, resize behavior | [references/lifecycle.md](references/lifecycle.md) |
| Documented panel options and qualitative guidance | [references/panel-options.md](references/panel-options.md) |
| Render the last value into HTML | [recipes/metric-to-html.md](recipes/metric-to-html.md) |
| Update an SVG attribute from a Grafana variable | [recipes/metric-to-svg.md](recipes/metric-to-svg.md) |
| Write a Grafana template variable | [recipes/grafana-variable.md](recipes/grafana-variable.md) |
| Send data between panels with `CustomEvent` | [recipes/panel-communication.md](recipes/panel-communication.md) |
| Re-run sizing setup when the panel changes size | [recipes/dynamic-sizing.md](recipes/dynamic-sizing.md) |
| Source-backed execution-cost guidance | [patterns/performance.md](patterns/performance.md) |
| Source manifest | [references/sources.md](references/sources.md) |

## Authoring rules

- Keep `onInit` and `onRender` independent: neither can use a local declared by the other. Use DOM nodes and event handlers when the official examples need communication. Source: [`src/HTMLPanel.tsx`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/src/HTMLPanel.tsx).
- Render values with `textContent`, not HTML parsing. Source: official [`website/docs/examples/simple-example.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/examples/simple-example.md).
- Treat Custom properties as parsed configuration, not mutable hook state. Source: official [`website/docs/references.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/references.md).
- When using `fields[1]`, require the documented query shape and guard the series, field, and value count. Source: official [`website/docs/guides/how-to-get-metrics.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/guides/how-to-get-metrics.md).
