---
name: wgrill-with-docs
description:
  Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates
  documentation (GLOSSARY.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against
  their project's language and documented decisions.
---

<what-to-do>

Interview me relentlessly about every aspect of this this plan until we reach a shared understanding. Walk down each branch of the design tree,
resolving dependencies between decisions one-by-one.

Only ask a question when the answer has to come out of my head: product intent, scope, priorities, risk appetite,
naming/wording, ownership, or history. Never manufacture a question to keep the interview going — only bring up actual
ambiguity.

Before asking anything, try to kill the question:

- If the codebase, docs, or git history can answer it, go read them instead.
- If a quick spike or run can answer it, run it instead.
- If you have a recommendation and the alternatives are clearly worse, don't ask — state the decision and its one-line
  rationale as an assumption.

When you do ask: one question at a time, with your recommended answer, waiting for feedback before continuing. Never
pad the options with an alternative you've already argued against in the question itself — if only one option is sane,
it isn't a question.

</what-to-do>

<supporting-info>

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Most repos have a single glossary:

```
/
├── GLOSSARY.md
├── docs/
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If a `GLOSSARY-MAP.md` exists at the root, the repo has multiple contexts. The map points to where each one lives:

```
/
├── GLOSSARY-MAP.md
├── docs/
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   ├── GLOSSARY.md
│   │   └── docs/adr/                 ← glossary-specific decisions
│   └── billing/
│       ├── GLOSSARY.md
│       └── docs/adr/
```

Create files lazily — only when you have something to write. If no `GLOSSARY.md` exists, create one when the first term
is resolved. If no `docs/adr/` exists, create it when the first ADR is needed.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in `GLOSSARY.md`, call it out immediately. "Your
glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean
the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe
edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your
code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update GLOSSARY.md inline

When a term is resolved in conversation with the developer, update `GLOSSARY.md` right there — don't ask permission
first. Don't batch these up — capture them as they happen. Use the format in [GLOSSARY-FORMAT.md](./GLOSSARY-FORMAT.md).

Only record terms the developer has used, confirmed, or agreed to in the dialogue. Vocabulary you lifted from the code
is not resolved language — surface it as a question first ("the code calls this X — is that the word you use?") and let
the answer decide the entry.

`GLOSSARY.md` should be totally devoid of implementation details. Do not treat `GLOSSARY.md` as a spec, a scratch pad,
or a repository for implementation decisions. It is a glossary and nothing else.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without glossary** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

</supporting-info>
