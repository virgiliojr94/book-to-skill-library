# Lifecycle

`onInit` runs when the panel loads. `onRender` runs when new data is available and can also run when the panel is first loaded. Source: official [`website/docs/quick-start.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/quick-start.md) and [`website/docs/options.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/options.md).

## `panelupdate`

`panelupdate` targets `htmlNode` and fires when new data is available. Register it with either documented form:

```js
const onPanelUpdate = () => {
  const output = htmlNode.querySelector('#output');
  if (output) output.textContent = 'Updated';
};

htmlNode.addEventListener('panelupdate', onPanelUpdate);
htmlNode.onpanelupdate = onPanelUpdate;
```

Source: official [`website/docs/references.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/references.md).

## `panelwillunmount`

`panelwillunmount` targets `htmlNode` and fires when the panel will unmount. Register it with either documented form:

```js
const onPanelWillUnmount = () => {
  const output = htmlNode.querySelector('#output');
  if (output) output.textContent = 'Unmounting';
};

htmlNode.addEventListener('panelwillunmount', onPanelWillUnmount);
htmlNode.onpanelwillunmount = onPanelWillUnmount;
```

Use unmount cleanup for the documented CustomEvent listener pattern in [the communication recipe](../recipes/panel-communication.md). Source: official [`website/docs/references.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/references.md) and [`website/docs/examples/communicate-between-panels.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/examples/communicate-between-panels.md).

## Resize option

Enabling **Trigger onInit on resize** reruns `onInit` when panel width or height changes. The official docs warn that this does not trigger cleanup or `onpanelwillunmount`; it only triggers `onInit`. Source: official [`website/docs/options.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/options.md).
