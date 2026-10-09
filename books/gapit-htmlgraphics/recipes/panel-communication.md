# Recipe: Communicate Between Panels

The official example dispatches a `CustomEvent` on `document`; another panel listens on `document` and removes that listener through `htmlNode.onpanelwillunmount`. Use `textContent` for the transferred value.

## Dispatcher

**HTML/SVG**

```html
<button>Send value <strong></strong></button>
```

**onRender**

```js
const valueElement = htmlNode.querySelector('strong');
const valueField = data.series[0]?.fields[1];

if (valueElement && valueField && valueField.values.length > 0) {
  valueElement.textContent = valueField.values.get(valueField.values.length - 1);
} else if (valueElement) {
  valueElement.textContent = 'No data';
}
```

**onInit**

```js
const button = htmlNode.querySelector('button');
const valueElement = htmlNode.querySelector('strong');

if (button && valueElement) {
  button.onclick = () => {
    document.dispatchEvent(new CustomEvent('htmlgraphics', { detail: valueElement.textContent }));
  };
}
```

## Receiver

**HTML/SVG**

```html
<div>Received value: <strong></strong></div>
```

**onInit**

```js
const valueElement = htmlNode.querySelector('strong');

const receiveValue = (event) => {
  if (valueElement) valueElement.textContent = event.detail;
};

document.addEventListener('htmlgraphics', receiveValue);

htmlNode.onpanelwillunmount = () => {
  document.removeEventListener('htmlgraphics', receiveValue);
};
```

Source: official [`website/docs/examples/communicate-between-panels.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/examples/communicate-between-panels.md).
