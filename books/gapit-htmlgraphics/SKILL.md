---
name: gapit-htmlgraphics
description: Build custom HTML/SVG visualization panels in Grafana using the GAPIT HTML Graphics plugin. Use when creating custom Grafana visualizations, embedding HTML/SVG content in dashboards, building dynamic graphics driven by metrics, or implementing custom panel interactions.
---

# GAPIT HTML Graphics Panel

Grafana plugin for fully custom HTML/SVG visualizations. Build network diagrams, custom gauges, interactive topology maps, or any viz not covered by built-in panels.

**Plugin model:** HTML/SVG document + JavaScript hooks (onInit/onRender) + htmlGraphics API

## Quick Start

1. **Install plugin:**
   ```bash
   grafana-cli plugins install gapit-htmlgraphics-panel
   # Restart Grafana
   ```

2. **Add panel → HTML Graphics**

3. **Three editors:**
   - CSS — global styles
   - HTML/SVG — markup
   - JavaScript — onInit (setup once) + onRender (update on data)

4. **Save:** `Ctrl+S` in editor or click outside

## Core Workflow

### Minimal Example

**HTML/SVG:**
```html
<div id="value-box" class="metric-display"></div>
```

**CSS:**
```css
.metric-display {
  font-size: 48px;
  font-weight: bold;
  text-align: center;
  padding: 20px;
}
```

**onRender:**
```js
// Get last value from first series
const field = htmlGraphics.data.series[0].fields[1];
const value = field.values.get(field.values.length - 1);

// Update display
const box = htmlGraphics.htmlNode.getElementById('value-box');
box.textContent = value.toFixed(2);
```

## htmlGraphics API (Global Object)

All refs live in `htmlGraphics`:

| Property | Type | Purpose |
|----------|------|---------|
| `htmlNode` | ShadowRoot | DOM access (like `document`) |
| `data` | PanelData | Grafana metrics/series |
| `theme` | GrafanaTheme2 | Colors, typography |
| `options` | Object | Panel config |
| `width` / `height` | number | Panel dimensions (px) |
| `getTemplateSrv()` | Function | Access variables |
| `replaceVariables()` | Function | Replace `$var` in strings |
| `updateVariable()` | Function | Set variable values |
| `eventBus` | EventBus | Panel-to-panel events |
| `getFieldDisplayValues()` | Function | Formatted values with thresholds |
| `fieldReducers` | Object | Calc functions (mean, max, etc.) |

**Deep refs:** See [`references/execution-context.md`](references/execution-context.md)

## Common Patterns

Each pattern in [`recipes/`](recipes/):

- **[metric-to-html.md](recipes/metric-to-html.md)** — Display metric values in HTML elements
- **[metric-to-svg.md](recipes/metric-to-svg.md)** — Drive SVG graphics with metrics
- **[grafana-variable.md](recipes/grafana-variable.md)** — Read/write dashboard variables
- **[panel-communication.md](recipes/panel-communication.md)** — Cross-panel events via eventBus
- **[http-requests.md](recipes/http-requests.md)** — Fetch external data
- **[dynamic-sizing.md](recipes/dynamic-sizing.md)** — Responsive layouts

## When to Use

✅ **Use GAPIT when:**
- Built-in panels don't fit your use case
- Need exact design match (brand guidelines, custom layouts)
- Building interactive diagrams (network topology, state machines)
- Combining metrics with external graphics (floor plans, maps)
- Clickable elements that update variables or navigate

❌ **Don't use when:**
- Built-in panel works (simpler, faster, better UX)
- Need high-performance time-series rendering (use native Graph panel)
- No HTML/SVG/JS knowledge in team

## Performance

From [`patterns/performance.md`](patterns/performance.md):

1. **Minimize onRender work** — only update changed elements
2. **Cache DOM refs in onInit** — query once, reuse
3. **Calcs mutation = "No mutation"** — skip extra calcs if not needed
4. **Keep code small** — execution time ∝ code size
5. **Use `getFieldDisplayValues()` selectively** — expensive for many series

## Gotchas

1. **Use `htmlNode`, not `document`** — plugin runs in ShadowRoot
2. **External scripts blocked** — cannot load CDN libs; bundle in code
3. **Images = data URIs or external URLs** — no file upload
4. **Mutations persist** — `htmlGraphics.data` is mutable; don't modify if you need original later
5. **onRender runs frequently** — optimize for speed

## Structure Reference

- **[`references/execution-context.md`](references/execution-context.md)** — Full htmlGraphics API
- **[`references/panel-options.md`](references/panel-options.md)** — Plugin config options
- **[`references/data-and-metrics.md`](references/data-and-metrics.md)** — PanelData structure, fields, series
- **[`references/lifecycle.md`](references/lifecycle.md)** — onInit vs onRender, when each runs
- **[`patterns/state-management.md`](patterns/state-management.md)** — Track state across renders
- **[`patterns/performance.md`](patterns/performance.md)** — Optimization techniques

## Links

- **Docs:** https://gapit-htmlgraphics-panel.gapit.io/docs/
- **GitHub:** https://github.com/gapitio/gapit-htmlgraphics-panel
- **Marketplace:** https://grafana.com/grafana/plugins/gapit-htmlgraphics-panel/
