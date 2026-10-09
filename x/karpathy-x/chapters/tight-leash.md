# The tight leash — AI-assisted coding for code that matters

## Core Idea

The deliberate counterpart to vibe coding. He states the distinction himself:
this is the rhythm for "code I actually and professionally care about, contrast
to vibe code."

Source: [2025-04-25](https://x.com/karpathy/status/1915581920022585597)

## The loop, as he wrote it

1. **Stuff everything relevant into context.** For small projects, stuff
   everything — he cites `files-to-prompt . -e ts -e tsx -e css -e md --cxml
   --ignore node_modules -o prompt.xml`.
2. **Describe the next single, concrete incremental change.** One change.
3. **Don't ask for code — ask for a few high-level approaches, pros/cons.**
   His reason: "There's almost always a few ways to do thing and the LLM's
   judgement is not always great."
4. **Pick one approach, ask for first draft code.**
5. **Review / learning phase.** Manually pull up API docs in a side browser for
   functions he hasn't called before; ask for explanations; wind back and try a
   different approach if needed.
6. **Test.**
7. **Git commit.**
8. Ask what to implement next. Repeat.

## Why the leash

> "The emphasis is on keeping a very tight leash on this new over-eager junior
> intern savant with encyclopedic knowledge of software, but who also bullshits
> you all the time, has an over-abundance of courage and shows little to no
> taste for good code."

The posture he names: **"slow, defensive, careful, paranoid, and on always
taking the inline learning opportunity, not delegating."**

## The step people skip

Step 3 is the load-bearing one. Asking for approaches with trade-offs *before*
asking for code is what keeps the model's poor judgement from silently becoming
your architecture. Jumping straight to "write the code" surrenders the decision.

Step 5 is the second: he pulls up **real API docs manually**, rather than
trusting the model's account of an unfamiliar function.

## His own caveat

> "Many of these stages are clunky and manual and aren't made explicit or super
> well supported yet in existing tools. We're still very early and so much can
> still be done on the UI/UX of AI assisted coding."

The loop is his working practice, not a claim that tooling supports it well.

## Anti-patterns

- Delegating instead of learning inline — he explicitly names this as the thing to avoid.
- Accepting a first draft without pulling the real docs for unfamiliar calls.
- Batching many changes per turn. The loop is one concrete incremental change.

## Connects To

- `vibe-coding.md` — the other mode, for throwaway work
- `data-labeler.md` — why the model's confidence isn't evidence
