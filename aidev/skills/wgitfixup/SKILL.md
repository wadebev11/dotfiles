---
name: wgitfixup
description:
  Folds a fix into the commit on this branch that introduced the code being fixed, instead of adding a new commit.
  Use when the developer says "amend the commit that makes sense", "amend the commit that added X", "amend that
  into the previous commit", or wants a review finding fixed inside the original commit. Rewrites branch history,
  never pushes.
argument-hint: what to fold in and, optionally, the target commit ("fix 4 into the commit that added the schemamod")
---

## Purpose

Make the branch read as if the fix had been there all along

## Process

### 1. Rewritable range

Base is the argument, else the remote-tracking ref of the branch the developer named. Local `master` is often stale.
Candidates are only `$(git merge-base <base> HEAD)..HEAD`.

### 2. The fix

If not already in the working tree, make it. Touch only the lines the fix needs.

### 3. Target commit

Per hunk:

```
git blame -L <start>,<end> <base>..HEAD -- <file>
git log -L <start>,<end>:<file> --oneline <base>..HEAD
```

In order:

1. Developer named the commit: use it.
2. Hunk modifies lines one candidate commit introduced: that commit.
3. Hunk adds new lines: the commit that introduced the thing the new code exercises or sits beside. A new test
   belongs with the commit that added the behavior under test, not the commit that last touched the file.
4. Blame lands at or before the merge base: STOP! Recommend a normal commit via `wcommit`.

Hunks mapping to different commits become one fixup each. Stage by file, or `git apply --cached` a per-target patch
from the scratchpad. Ask one question, with a recommendation, only when blame and meaning disagree.

### 4. Fold

Fixup commit, then autosquash rebase onto the base. Record HEAD after the fixup commit and before the rebase. Stash
any unrelated working changes around the rebase.

### 5. Verify

Diff the recorded HEAD against the new HEAD.  must be empty

### 6. Message

If the fix contradicts a sentence in the target's message, reword that sentence per `wcommit`. If the developer asked
for the reason recorded, add it. Otherwise leave it.

## Never

- Push
- Target outside the branch range, or reorder/squash anything beyond the fixup.
- Add Co-Authored-By, or reference review numbering in the message.
- Expand the fix. Report anything else seen wrong. Do not change it.

## Output

If the commit to be amended wasn't given by the developer, but inferred, explain why that commit was chosen
