# RLHF is just barely RL

## Core Idea

RLHF is not RL in the sense that made AlphaGo work. It optimizes a proxy — a
model of what humans *like* — rather than a ground-truth objective.

Source: [2024-08-07](https://x.com/karpathy/status/1821277264996352246)

## The thesis

> "My rant on RLHF is that it is just barely RL, in a way that I think is not too
> widely appreciated. **RL is powerful. RLHF is not.**"

His framing of where it sits: the third and last major stage of LLM training,
after pretraining and supervised finetuning.

## The AlphaGo argument

Real RL: the computer played Go and trained on rollouts maximizing the actual
reward — **winning the game** — eventually surpassing the best humans.

> "AlphaGo was not trained with RLHF. If it were, it would not have worked nearly
> as well."

RLHF-flavored AlphaGo would instead show labelers two board states, ask which
they prefer, collect ~100,000 comparisons, train a Reward Model to imitate that
"vibe check", then optimize against the vibe. "Clearly, this would not have led
anywhere too interesting in Go."

## The two failure modes he names

1. **The proxy is wrong.** "The vibes could be misleading — this is not the actual
   reward (winning the game). This is a crappy proxy objective."
2. **The optimizer attacks the proxy.** "Your RL optimization goes off rails as it
   quickly discovers board states that are adversarial examples to the Reward
   Model. [...] There are board states that are 'out of distribution' to its
   training data, which are not actually good states, yet by chance they get a
   very high reward from the RM."

The second is the sharper one: the stronger the optimizer, the faster it finds
the reward model's blind spots.

## Applied to LLMs

> "The RM we train for LLMs is just a vibe check in the exact same way. It gives
> high scores to the kinds of assistant responses that human raters statistically
> seem to like. It's not the 'actual' objective of correctly solving problems,
> it's a proxy objective of what looks good to humans."

Hence the hard operational limit:

> "You can't even run RLHF for too long because your model quickly learns to game
> the reward model."

His example of the degenerate output: responses like **"The the the the the the"**
scoring well while being nonsense.

He adds that he's "a bit surprised RLHF works for LLMs at all."

## The transferable rule

Any metric that is a *learned imitation of preference* degrades under sustained
optimization pressure. Optimize it long enough and you get the artifact, not the
thing. The failure looks like a high score, which is why it's dangerous.

## Anti-patterns

- Reading a high reward-model / preference score as evidence of correctness. It measures resemblance to what raters liked.
- Assuming more RL always helps. He states the opposite: run it too long and it games the RM.

## Connects To

- `data-labeler.md` — he references this argument there as a caveat
- `moravec-evals.md` — same theme: the measured proxy vs the real capability
