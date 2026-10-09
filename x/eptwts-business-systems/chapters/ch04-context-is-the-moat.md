# Chapter 4: Data Is the Moat; Give Agents a Living Source of Truth

## Core Idea

Generic AI capability becomes specialized through context. The author repeatedly treats domain data, indexed markdown, operating instructions, and continual updates as the layer that makes agents more useful and less likely to reason from irrelevant defaults. ([Apr 7](https://x.com/eptwts/status/2041524052364329313), [Aug 18](https://x.com/eptwts/status/2089716735146340481))

## Frameworks Introduced

### “Data is the moat”

Use this when a generic model produces mediocre results in a specialized domain. The author's thumbnail example argues that a focused SaaS can outperform access to the same base model because it supplies knowledge of what good output looks like. Customers are paying for packaged specialty and dependable context, not merely API access. ([Apr 7](https://x.com/eptwts/status/2041524052364329313))

### Living knowledge base

Use a portable file-based source of truth when agents need durable project, team, or personal context.

1. Store detailed knowledge in readable files rather than relying on model memory.
2. Create a main index that tells agents where to look.
3. Add operating instructions for conventions and update behavior.
4. Link related concepts so retrieval can follow the work's structure.
5. Provide a low-friction inbox or braindump path.
6. Update the knowledge base as work happens so the asset compounds.
7. Make agents retrieve from it before giving consequential answers or taking action.

The April implementation uses Obsidian, a main index, `CLAUDE.md`, interlinked concepts, and `BRAINDUMP.md`; July extends the pattern to an always-on assistant and team communication; August calls the centralized source of truth an anti-hallucination layer. ([Apr 12](https://x.com/eptwts/status/2043347089438986609), [Jul 23](https://x.com/eptwts/status/2080252809916633454), [Jul 25](https://x.com/eptwts/status/2081020582728990734), [Aug 18a](https://x.com/eptwts/status/2089715930024595939), [Aug 18b](https://x.com/eptwts/status/2089716735146340481))

### Process knowledge before automation

An agent is not a substitute for knowing the process. First understand what must happen and where automation can or cannot help; then encode that knowledge into the system. ([Apr 2](https://x.com/eptwts/status/2039705767113302260))

## Mental Models

- **Model as engine, context as steering**: raw capability needs domain-specific direction.
- **Files as durable truth, memory as routing**: keep detailed state in inspectable artifacts.
- **Compounding context**: every captured decision or result should reduce future explanation cost.
- **Automation follows understanding**: automate known processes; investigate unknown ones.

## Anti-patterns

- **Prompt-only specialization**: expecting generic instructions without source material to encode real domain taste.
- **Scattered context**: leaving facts across unrelated chats and repositories where agents cannot retrieve them reliably. ([Jul 23](https://x.com/eptwts/status/2080252809916633454))
- **Agent omniscience**: delegating a process the operator does not understand and cannot evaluate. ([Apr 2](https://x.com/eptwts/status/2039705767113302260))
- **Static documentation**: a source of truth that is not updated as work changes stops compounding.

## Evolution and Boundary

The theme expands from niche product context and a personal Obsidian vault in April to organizational and always-on agent workflows in July and August. The stable idea is not a specific app: it is a maintained, retrievable context layer. ([Apr 7](https://x.com/eptwts/status/2041524052364329313), [Jul 25](https://x.com/eptwts/status/2081020582728990734), [Aug 18a](https://x.com/eptwts/status/2089715930024595939))

## Key Takeaways

1. Package domain knowledge, not just model access.
2. Keep authoritative context in portable, inspectable files.
3. Give agents an index and explicit operating rules.
4. Capture updates where work already happens.
5. Understand and validate a process before automating it.

## Connects To

- **Ch 3**: retrieve only the information relevant to the active problem.
- **Ch 5**: a maintained playbook is the knowledge layer that lets expertise scale.
