# Own your data, ask questions directly

## Core Idea

Collect raw data into owned infrastructure first; query it directly with Claude Code. The dashboard is a byproduct; the durable asset is the data and the ability to question it.

## In his words

> "I didn't even go to my own site Hotelist, I just asked Claude Code on my Hotelist VPS server to find me a hotel... Also some thing I forgot to add... For years I wanted to know the correlation between stuff I do and my workouts and sleep... I just ask Claude Code to build a little web app for me that pulls all my data in from my WHOOP, and what I eat, my @wip logs when I go to sauna, or go tan, or go gym etc. It just pulls all the data in and gives me the answers to questions I have. Half the time I don't even use the web app it generates, I just ask it directly."
> — [2026-07-20](https://x.com/levelsio/status/2079289397845938480)

> "Once you have all the data collected, you can ask Claude Code lots of questions directly about your finances and learn stuff, like I learned: I was paying for some subscriptions for 2 years I forgot about... My US stocks charge me withholding tax (30%)... The best part isn't the dashboard it makes but that once you have all the data collected, you can ask Claude Code lots of questions directly."
> — [2026-08-11](https://x.com/levelsio/status/2087205464987607371)

## What it says

The value is not in the UI; it is in aggregating raw data into a place you control. Once WHOOP, food, gym, sauna, financial, and server data sit together on owned infrastructure, Claude Code becomes the interface: ask it questions directly, get answers without building a dashboard. When a dashboard does appear, it is a side effect of collection, not the point.

The durable asset is the data itself and the ability to query it. Dashboards are disposable.

## What changed

| When | Position |
|---|---|
| 2026-07-20 | Introduces the pattern with WHOOP, food, sauna, gym, Hotelist |
| 2026-08-11 | Extends to full financial history (bank CSVs, Grok categorization) — same principle, different domain |

Both posts arrive at the same conclusion from different directions: collect first, question second, build UI third.

## Anti-patterns

- Building the dashboard before the data pipeline. The data pipeline is the product.
- Using a third-party SaaS as the data owner. WHOOP's journal was "practically unusable" because WHOOP owns the UX; once the data is extracted, Claude Code can answer freely.
- Assuming correlation equals causation. Health data correlations are noted as provisional ("not enough data to know").

## Connects To

- `ship-complex.md` — owning data enables the complex products you build
- `terminal-agents.md` — owned servers are where the data lives