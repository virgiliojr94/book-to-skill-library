# Mixed autonomy — humans as high-level supervisors

## Core Idea

Computer-use agents and humanoid robots are the same bet in different substrates:
one general interface originally designed for humans, gradually absorbing
arbitrary tasks — with the human moving up to supervision.

Source: [2025-01-23](https://x.com/karpathy/status/1882544526033924438)

## In his words

> "Projects like OpenAI's Operator are to the digital world as Humanoid robots are
> to the physical world. One general setting (monitor keyboard and mouse, or human
> body) that can in principle gradually perform arbitrarily general tasks, via an
> I/O interface originally designed for humans."

And the destination:

> "In both cases, it leads to a gradually mixed autonomy world, where humans
> become **high-level supervisors of low-level automation**. A bit like a driver
> monitoring the Autopilot."

The analogy is not decorative — he spent years on driver-monitored autonomy at
Tesla, and reaches for it deliberately.

## Why digital moves first

> "This will happen faster in digital world than in physical world because
> flipping bits is somewhere around 1000X less expensive than moving atoms.
> Though the market size and opportunity feels a lot bigger in physical world."

Two claims worth keeping separate: **digital arrives sooner**, **physical is
worth more**.

## The sequencing lesson

> "We actually worked on this idea in very early OpenAI (see Universe and World
> of Bits projects), but it was **incorrectly sequenced** — LLMs had to happen
> first."

A right idea attempted before its prerequisite existed. He does not present the
earlier attempt as wrong, but as early.

## His hedge, stated plainly

> "Even now I am not 100% sure if it is ready. Multimodal (images, video, audio)
> just barely got integrated with LLMs last 1-2 years, often bolted on as
> adapters. Worse, we haven't really been to the territory of very very long task
> horizons."

Keep the hedge attached to the claim. As of this post he flagged long task
horizons as unexplored territory — the same gap named in `moravec-evals.md`.

## The transferable rule

"Mixed autonomy" is the honest description of the intermediate state: not full
automation, not manual work, but a human accountable for output they did not
produce step-by-step. The Autopilot analogy carries the known hazard with it —
supervisory attention degrades precisely as the automation gets good enough to
trust.

## Anti-patterns

- Quoting the mixed-autonomy frame as a prediction of imminent full autonomy. He hedged it in the same post.
- Treating supervision as free. The driver-monitoring analogy is a warning, not just a description.

## Connects To

- `moravec-evals.md` — long autonomous horizons as the unsolved part
- `tight-leash.md` — what supervision actually looks like in practice, at the code level
