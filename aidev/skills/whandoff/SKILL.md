---
name: whandoff
description:
  Packages this conversation's context into a self-contained prompt for a fresh, context-free agent to pick up
  later. Writes it to /tmp/whandoff, overwriting whatever was there. Analysis only, makes no edits.
argument-hint: the question or task to hand off (defaults to whatevers in this current prompt)
---

## Purpose

The developer has a question or task that depends on context built up over this conversation — file locations,
line numbers, prior art already found, decisions already made. Instead of answering it now, capture that context
into a prompt that a brand-new agent with no memory of this conversation could pick up and run with.

Do not answer the question, solve it, or implement anything. The output is the prompt itself.

## Process

1. **Identify the target.** Use the argument if given
2. **Re-verify, don't just recall.** Before writing anything down, confirm every file path, line number, and claim
   against the actual codebase (Read/Grep) — conversation memory of "line 243" may already be stale.
3. **Write the handoff prompt**, containing:
   - The problem or question, restated so it stands alone — no "as I mentioned," no pronouns without antecedents.
   - The relevant context this conversation already dug up: exact `file:line` references, the mechanism involved,
     any prior art or existing pattern found that applies.
   - The ask — precise and scoped. If the conversation surfaced open design questions that weren't resolved, carry
     those forward as open questions rather than deciding them here.
4. Write the result to `/tmp/whandoff`, overwriting whatever is already there.

## What NOT to do

- Don't answer the question or propose a solution — that's for the pickup conversation, not this one.
- Don't pad it with irrelevant history from earlier in the conversation — only what's needed to act on the ask.
- Don't invent unresolved decisions just to sound thorough — leave genuinely open questions open.

## Output

Write the completed prompt to `/tmp/whandoff`. Confirm briefly that it's written — don't repeat the whole prompt
back in chat.
