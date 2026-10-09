# Execution Context

The plugin supplies `htmlGraphics` to hook code. The documented references include `htmlNode`, `data`, `customProperties`, `options`, `theme`, `theme2`, `getTemplateSrv`, `locationService`, `props`, `width`, `height`, and `getFieldDisplayValues`. `htmlNode` is the panel ShadowRoot and supports panel-scoped element lookup. Source: official [`website/docs/references.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/references.md); injected-object implementation: [`src/HTMLPanel.tsx`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/src/HTMLPanel.tsx).

```js
const output = htmlGraphics.htmlNode.querySelector('#output');

if (output) {
  output.textContent = customProperties.text;
}
```

## Hook boundary

`onInit` and `onRender` are each passed to a separate `new Function` execution. A local function or variable declared in one hook does not exist in the other. Re-query the panel DOM in each hook, or put a DOM event handler in `onInit` when the official examples require a persistent interaction. Source: [`src/HTMLPanel.tsx`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/src/HTMLPanel.tsx).

## Custom properties

Custom properties are the parsed JSON object available as `customProperties`; `codeData` is the older equivalent name. Use them for configuration values. Source: official [`website/docs/references.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/references.md).

```json
{
  "text": "Configured label"
}
```

## Panel props passthrough

`htmlGraphics.props` contains the panel `PanelProps`. The source passes `eventBus` and `replaceVariables` through that object, but the official plugin docs do not define a GAPIT API for them. Do not treat either as a documented HTML Graphics method; use the documented `CustomEvent` pattern for cross-panel communication. Source: [`src/HTMLPanel.tsx`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/src/HTMLPanel.tsx); official [`website/docs/examples/communicate-between-panels.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/examples/communicate-between-panels.md).
