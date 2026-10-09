# Recipe: Update a Grafana Template Variable

Use the documented location-service write contract exactly.

**HTML/SVG**

```html
<button id="set-variable">Set variable</button>
```

**onInit**

```js
const button = htmlNode.querySelector('#set-variable');
const name = customProperties.variableName;
const value = customProperties.variableValue;

if (button) {
  button.onclick = () => {
    htmlGraphics.locationService.partial({ ['var-' + name]: value }, true);
  };
}
```

**Custom properties**

```json
{
  "variableName": "testVariable",
  "variableValue": "a"
}
```

The `true` replacement argument updates current URL state rather than creating a history entry. Source: official [`website/docs/examples/update-grafana-variable-example.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/examples/update-grafana-variable-example.md) and [`website/docs/references.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/references.md).
