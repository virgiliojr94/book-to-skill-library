# Pattern: Keep Hook Code Small

The official guidance distinguishes `onInit` (panel load) from `onRender` (new data, including panel load), and advises keeping code efficient and small because code size affects load time. Source: official [`website/docs/performance.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/performance.md).

For calculations, select only needed calcs or use `getFieldDisplayValues` when only a few metrics need changed calculations. The docs say calc mutation has a significant impact when there are many metrics. Source: official [`website/docs/performance.md`](https://github.com/gapitio/gapit-htmlgraphics-panel/blob/f90cc645474b42d7c9aea9888c39c9a3e0cbd32a/website/docs/performance.md).
