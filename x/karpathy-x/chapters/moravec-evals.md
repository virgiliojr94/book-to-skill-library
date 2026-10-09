# Moravec's paradox in LLM evals

## Core Idea

Benchmark position and job readiness are different axes. Models reach "top
expert territory" on evals while remaining unhireable for menial work.

Source: [2024-11-10](https://x.com/karpathy/status/1855659091877937385)

## The observation

> "Even though by many accounts (/evals), LLMs are inching well into top expert
> territory (e.g. in math and coding etc.), **you wouldn't hire them over a person
> for the most menial jobs.**"

The mechanism he names:

> "They can solve complex closed problems if you serve them the problem
> description neatly on a platter in the prompt, but they struggle to coherently
> string together long, autonomous, problem-solving sequences in a way that a
> person would find very easy."

Two conditions do the work: **problem served on a platter**, and **short horizon**.
Benchmarks supply both. Real work supplies neither.

## Why Moravec

Moravec observed 30+ years ago that what is easy/hard for humans can be very
different from what is easy/hard for computers. His example: humans are impressed
by computers playing chess, but chess is easy for computers — "a closed,
deterministic system with a discrete action space, full observability." Meanwhile
tying a shoe or folding a shirt, which humans dismiss, challenges the state of
the art in both hardware and software.

Benchmarks are chess-shaped: closed, well-specified, discrete, fully observable.
The paradox says that's exactly the wrong place to read general competence from.

## The context that triggered it

He was reacting to a new frontier-math benchmark where LLMs solved only 2% — a
benchmark introduced precisely *because* models were crushing the existing ones.
The escalation itself is the tell: benchmark saturation kept moving while the
menial-job gap did not close.

## The transferable rule

When evaluating a model for real work, the eval score answers the wrong question.
Ask instead:

- Does the task arrive **pre-specified**, or must it be discovered?
- Is the horizon **one step**, or a long autonomous chain?

The further from "served on a platter", the less the benchmark predicts.

## Anti-patterns

- Reading benchmark parity with experts as readiness for autonomous work.
- Assuming a new, harder benchmark fixes this. He notes the harder benchmark was itself a response to saturation — the gap it measures is not the gap that matters.

## Connects To

- `jagged-intelligence.md` — the same non-transfer, seen per-task
- `rlhf-barely-rl.md` — proxy objectives diverging from real ones
