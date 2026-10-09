# Recipe: Show Panel Dimensions

Turn on **Dynamic HTMLGraphics** and **Trigger onInit on resize**, then keep the sizing code self-contained in `onInit`.

**HTML/SVG**

```html
<div>
  <p>Height: <span class="height-value"></span></p>
  <p>Width: <span class="width-value"></span></p>
</div>
```

**onInit**

```js
const heightElement = htmlNode.querySelector('.height-value');
const widthElement = htmlNode.querySelector('.width-value');

if (heightElement) heightElement.textContent = htmlGraphics.height;
if (widthElement) widthElement.textContent = htmlGraphics.width;
```

The resize option reruns `onInit` for panel dimension changes. It does not trigger cleanup or `onpanelwillunmount`; only enable it when this reinitialization behavior is acceptable. Source: official [`website/docs/examples/dynamic-height-and-width.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/examples/dynamic-height-and-width.md) and [`website/docs/options.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/options.md).
