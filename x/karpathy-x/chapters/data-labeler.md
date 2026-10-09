# You're asking the data labeler, not "an AI"

## Core Idea

A deflationary frame for model output: it is imitation of human labelers,
lossily compressed — not an oracle being consulted.

Source: [2024-11-29](https://x.com/karpathy/status/1862565643436138619)

## In his words

> "People have too inflated sense of what it means to 'ask an AI' about
> something. The AI are language models trained basically by imitation on data
> from human labelers. Instead of the mysticism of 'asking an AI', think of it
> more as 'asking the average data labeler' on the internet."

And the summary line:

> "TLDR you're not asking an AI, you're asking some mashup spirit of its average
> data labeler."

## His own caveats (stated in the same post)

He qualifies the frame himself rather than overselling it:

- In many domains — **code, math, creative writing** — companies hire *skilled*
  labelers. "So think of it as asking them instead."
- It is "not 100% true when reinforcement learning is involved."
- He cross-references his own RLHF argument, and notes "actual RL" remains
  "too early and/or constrained to domains that offer easy reward functions."

So: the frame is a corrective to mysticism, held "roughly speaking (and today)"
— not a claim that models are merely lookup tables.

## The useful reframe

The question shifts from *"what does the AI know?"* to *"who wrote the data this
is imitating, and were they good at this?"*

That predicts jaggedness: domains with skilled paid labelers (code, math) come
out strong; domains where the training signal is the internet average do not.

## What triggered it

He notes the post was prompted by "someone suggesting we ask an AI how to run
the government." The target is the appeal-to-oracle move, not model usefulness —
he adds, "This can still be super useful of course."

## Anti-patterns

- Citing model agreement as independent confirmation. It's imitation, not a second opinion.
- Reading the frame as "LLMs are useless." He explicitly denies that in the post.

## Connects To

- `rlhf-barely-rl.md` — the RL caveat he references here
- `jagged-intelligence.md` — uneven labeler quality as one source of unevenness
