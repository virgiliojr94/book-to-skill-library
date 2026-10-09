# Jagged Intelligence

## Core Idea

His coined term for capability that is spiky rather than uniform: state-of-the-art
models perform extremely impressive tasks while simultaneously failing trivial ones.

Source: [2024-07-25](https://x.com/karpathy/status/1816531576228053133)

## In his words

> "The word I came up with to describe the (strange, unintuitive) fact that state
> of the art LLMs can both perform extremely impressive tasks (e.g. solve complex
> math problems) while simultaneously struggle with some very dumb problems."

His examples, from the post:

| Succeeds at | Fails at |
|---|---|
| Complex math problems | Which is bigger, 9.11 or 9.9 |
| Identifying thousands of dog/flower species | Telling if two circles overlap |
| — | Counting the "r"s in "barrier" (claimed 2) |
| — | Playing tic-tac-toe coherently |

## Why it matters operationally

> "Some things work extremely well (by human standards) while some things fail
> catastrophically (again by human standards), and **it's not always obvious which
> is which**, though you can develop a bit of intuition over time."

The contrast he draws with humans is the load-bearing part:

> "Different from humans, where a lot of knowledge and problem solving
> capabilities are all highly correlated and improve linearly all together, from
> birth to adulthood."

**Consequence:** human-calibrated inference breaks. With a person, strong
performance on a hard task licenses confidence on an easier one. With a model,
it licenses nothing. Competence must be verified per-task, not extrapolated.

## His stated guidance

> "For now, this is something to be aware of, especially in production settings.
> Use LLMs for the tasks they are good at but be on a lookout for jagged edges,
> and keep a human in the loop."

## Is it fundamental?

He says no:

> "Personally I think these are not fundamental issues. They demand more work
> across the stack, including not just scaling. The big one I think is the present
> lack of 'cognitive self-knowledge'"

i.e. the model not knowing what it doesn't know — which he frames as a
post-training problem, not a scaling one.

## Anti-patterns

- Reasoning "it solved the hard one, so the easy one is safe." That inference is human-shaped and does not hold.
- Treating a trivial failure as proof of general incapability. Jaggedness cuts both ways.

## Connects To

- `moravec-evals.md` — the same gap seen from the benchmark side
- `data-labeler.md` — where the unevenness comes from
