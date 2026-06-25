---
name: warch
description: Used when auditing a scoped target for architectural smells. Produces a prioritized, evidence-backed report. Analysis only, makes no edits.
argument-hint: target-path
---

## Purpose

Audit a scoped part of the codebase for architectural problems and report them. This is an analysis, not a
refactor. Make no edits. The output is a prioritized list of findings the developer can act on.

Look at the existing structure as a whole within the given scope.

## Stance: cost-first, evidence required

The principles in play pull in opposite directions. SOLID and Design Patterns push toward more abstraction; YAGNI
and KISS push toward less. Resolve the tension in favor of YAGNI and KISS unless there is concrete evidence of
present pain.

- A finding only counts if there is **demonstrated, present cost**: duplication that already exists, a change that
  already required edits in many places, a dependency that already makes something untestable. Speculative "you
  might need to extend this someday" is forbidden.
- **Over-abstraction is a first-class smell**, not the absence of one. Recommend an abstraction only against actual
  repetition or actual coupling pain. Per Sandi Metz, duplication is far cheaper than the wrong abstraction.
- If the cure costs more than the disease, it is not a finding.

## Process

### 1. Establish scope (main agent)

The user names a target path or module. If none is given, ask. Never default to the whole repository, a
whole-codebase is too wide of a surface to audit.

### 2. Map before judging (main agent)

Build a model of the target before looking for any problems. No findings in this step.

- Its public surface (what it exposes to the rest of the system)
- Its dependencies, both incoming and outgoing
- Its responsibilities

### 3. Hunt smells (one subagent per category)

Dispatch one subagent per smell category below, in parallel. Give each subagent the map from step 2 and the named
smells for its category as its checklist.

Every finding a subagent returns must cite **concrete evidence**: the specific callers, the specific duplicated
blocks, the specific change that would amplify across files. No evidence, no finding.

### 4. Filter for ROI and report (main agent)

Collect all subagent findings. Then:

- Drop anything speculative or where the cure costs more than the disease.
- Consolidate findings that describe the same underlying problem.
- Sort by impact × effort so cheap, high-impact fixes surface first.

## Smell categories

Each subagent owns one category and hunts the named smells within it.

1. **Coupling & dependencies** — rigid dependencies, circular dependencies, inappropriate intimacy, feature envy.
   _Clean Architecture (dependency rule); Refactoring; SOLID (D, I)._
2. **Cohesion & responsibility** — god object, divergent change, shotgun surgery, large class / long method.
   _SOLID (S); Refactoring._
3. **Abstraction health** — leaky abstraction, shallow abstraction, speculative generality, wrong abstraction,
   needless indirection. _KISS, YAGNI; Metz "The Wrong Abstraction" / AHA; Refactoring; SOLID (O, L) where misused._
4. **Duplication & knowledge** — true duplication vs. coincidental duplication, DRY violations. _The Pragmatic
   Programmer._
5. **Data & scale** — chatty / N+1 data access, missing boundaries, persistence leaking into the domain.
   _Designing Data-Intensive Applications; Clean Architecture._
6. **Testability** — hard-to-seam dependencies, hidden temporal coupling, reliance on global state. _Working
   Effectively with Legacy Code._
7. **Error handling** — swallowed errors, inconsistent error model, error handling tangled with business logic.
   _Clean Code; The Pragmatic Programmer._
8. **Naming & readability** — misleading or vague names, inconsistent vocabulary, primitive obsession. _Clean Code;
   Refactoring._

## Finding format

Each finding contains:

- **Smell** — the named smell (e.g. "God Object", "Wrong Abstraction").
- **Location** — `file:line` or module.
- **Cost** — the concrete present pain: what is hard to change, test, or understand because of this, with evidence.
- **Violates** — the relevant SOLID/YAGNI/KISS principle plus the single most relevant book citation.
- **Direction** — the refactoring move that would address it. A direction, not a full rewrite, this skill does not
  edit.
- **Impact × Effort** — both tagged (e.g. High impact / Low effort).

## Expected output

A single prioritized list of findings, sorted by impact × effort, cheap high-impact wins first. If the scope is clean, say so rather than manufacturing findings.

Do not invent attributions.