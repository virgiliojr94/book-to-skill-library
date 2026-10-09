# Recipe: Change an SVG Attribute from a Variable

This reproduces the documented variable-driven SVG pattern. For Grafana v8.3.0+, put the variable in Custom properties with `${...}` wrapping. The update listener and its DOM reference live in the same `onInit` execution.

**HTML/SVG**

```html
<svg width="100" height="100">
  <circle cx="50" cy="50" r="40" fill="red"></circle>
</svg>
```

**Custom properties**

```json
{
  "testVariable": "${testVariable}"
}
```

**onInit**

```js
const circle = htmlNode.querySelector('circle');

function getGrafanaVariableValue(variable) {
  return getTemplateSrv().replace(variable);
}

htmlNode.addEventListener('panelupdate', () => {
  if (!circle) return;

  circle.setAttribute(
    'fill',
    getGrafanaVariableValue(customProperties.testVariable) == 'a' ? 'blue' : 'green'
  );
});
```

Source: official [`website/docs/examples/change-svg-attributes-with-grafana-variables-example.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/examples/change-svg-attributes-with-grafana-variables-example.md).
