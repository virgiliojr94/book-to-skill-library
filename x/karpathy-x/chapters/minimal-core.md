# Code is liability; the core is small

## Core Idea

He repeatedly returns to minimal implementations as the thing that actually
teaches, and names configuration sprawl as a specific, describable pathology.

Cluster: 26 substantial posts, 2024-06 → 2026-08

## The core is small

> "These 94 lines of code are everything that is needed to train a neural
> network. Everything else is just efficiency."
> — [2024-06-21](https://x.com/karpathy/status/1803963383018066272), on micrograd

What the 94 lines actually contain: numbers at the leaves (input data and
parameters), a computational graph built with operations like `+` and `*`, a
single value at the end (the loss), then backwards through the graph applying
the chain rule at each node to get gradients.

He uses it as a reset:

> "Sometimes when things get too complicated, I come back to this code and just
> breathe a little."

**His own caveat, in the same post** — the minimal core is not the whole job:

> "But ok ok you also do have to know what the computational graph should be
> (e.g. MLP -> Transformer), what the loss function should be (e.g.
> autoregressive/diffusion), how to best use the gradients for a parameter
> update (e.g. SGD -> AdamW) etc etc. But it is the core of what is mostly
> happening."

So the claim is *"efficiency is separable from essence"*, not *"the rest doesn't
matter."*

## The pathology, named

> "**The if-then-else monster.** Bloated functions that take dozens of kwargs.
> When you read the code you can't even tell what runs because the cross-product
> of all the configurations is beyond human comprehension. Majority of the paths
> are deprecated, unsupported, or unadvisable."
> — [2024-07-10](https://x.com/karpathy/status/1811140282559385758)

Three distinct failures compressed into one image:

1. **Combinatorial unreadability** — the cross-product, not the line count, is what exceeds comprehension.
2. **Unknowable execution** — you cannot tell which path runs by reading.
3. **Dead majority** — most configured paths are deprecated, unsupported, or unadvisable, yet still reachable.

## The transferable rule

Each added flag multiplies the state space rather than adding to it. A function
with a dozen kwargs has no readable behavior — only a behavior per configuration,
most of which nobody has run.

## Anti-patterns

- Adding a flag to preserve an old path instead of deleting it. That's how the dead majority accumulates.
- Reading "94 lines" as anti-rigor. He lists what you still must know in the same post.

## Connects To

- `tight-leash.md` — the review discipline that keeps generated code from becoming the monster
