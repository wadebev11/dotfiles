---
name: wblindspotpass
description:
  Used before implementing or debugging in unfamiliar territory. Surfaces the unknowns the developer doesn't know to ask
  about, backed by evidence from the code. Analysis only, makes no edits.
argument-hint: what you're doing and what you don't know
---

## Purpose

The developer is entering territory they don't know well — a module they've never touched, a bug whose mechanism they're
guessing at, or a pattern they're about to establish for the first time. They can't ask the right questions yet. This
skill finds the questions for them.

Make no edits and write no implementation plan. The output is knowledge, so they know what to ask next.

## Stance: read first, evidence required

- **Verify the premise before anything else.** The developer's stated hypothesis may be wrong, and the README, comments,
  or docstrings may be stale. Confirm or correct it with evidence and lead with that. A blind spot pass built on top of a
  false premise is worthless.
- **Every blind spot cites evidence**: `file:line`, actual command or query output, a specific caller. No evidence, no
  blind spot. Speculative "you might want to consider..." is forbidden.
- **Ask nothing the codebase can answer.** The developer already said they don't know this area, so questioning them is
  pointless. Go read. Run a spike if that settles it faster.
- Say what is *not* a problem too. Ruling out a plausible fear is as useful as naming a real risk.

## Process

### 1. Take the premise apart

Identify what the developer has stated as fact versus what they're guessing at. Both need checking.

### 2. Read the territory

Map the thing itself, then everything touching it: callers, consumers, the write path and the read path, the tests, the
docs that claim to describe it. Reproduce or confirm the mechanism directly where possible.

### 3. Sweep for where blind spots hide

Unknown unknowns cluster in predictable places. Check each against what you read:

- **The stated premise** — stale docs, a comment describing old behavior, a hypothesis that's close but wrong.
- **Blast radius** — who else reads or writes this, and what breaks for them.
- **The other path** — read vs. write, import time vs. runtime, first request vs. subsequent, sync vs. async, cold vs.
  warm.
- **Delayed failure** — caches and TTLs, retries, replay, migrations, expiry. Things that look fine now and break later.
- **Naive fix fallout** — the obvious fix, and what it silently destroys.
- **Same root cause elsewhere** — adjacent code with the identical flaw, worth fixing in one pass.
- **Outside the code** — build steps, deploy steps, config, catalogs, generated artifacts.
- **Existing convention** — if a pattern is about to be established, whether the repo already established one nearby.

Drop anything the sweep doesn't turn up evidence for. Do not report a category as a finding just because it's on the
list.

## Expected output

1. **The premise** — confirmed with evidence, or corrected. Lead with this.
2. **Blind spots** — numbered, most dangerous first. Each one: what the developer doesn't know, the evidence, and why it
   matters to what they're about to do.
3. **Ruled out** — plausible worries the evidence clears, so they stop carrying them.

If the territory holds no real blind spots, say so rather than manufacturing them.
