---
name: wcode-review
description: Used when reviewing working changes or a pull request for correctness and quality.
argument-hint: optional instructions on what to review (e.g. a base branch, specific commits, or files)
---

## Purposes of code reviews

Code reviews have multiple purposes. They help catch bugs. They help ensure SOLID, YAGNI, KISS principles are being
followed. They catch security risks added with changes. They ensure maintainability, extensibility, and readability.

## What to review

The current branch is always the one being reviewed. Pick the first rule that applies:

1. **The user gave instructions**: they override the rules below. A bare branch name is the base branch to diff against.
2. **Uncommitted changes exist**: review only those. That's `git diff HEAD` plus untracked files from
   `git status --short`. Ignore committed changes.
3. **Otherwise**: review `$(git merge-base <base> HEAD)..HEAD`, where `<base>` is origin's default branch from
   `git symbolic-ref refs/remotes/origin/HEAD`. Use the remote-tracking ref, local branches are often stale.

If the chosen rule yields nothing to review, say so and stop. Don't give a verdict.

## Instructions

When reviewing commits, go through each commit message to gain context on why a change was made. Then look at that
commit's changes. Once you've gone through all the commits, do one final check of all the changes to make sure they're
coherent. Don't make comments about issues that are transitive and not in the final state of the branch

When reviewing uncommitted changes, there are no commit messages. Get context from the surrounding code and recent
commits touching the same files.

Don't worry about running tests or linters. Assume those will happen at another part of the process

## Expected output

State which rule picked the changes under review and what range or files that covered.

The output of a code review should be a priority sorted list of items falling into either **Must Fix** or **Nice to
have** with a suggestion at the end of **Approve** or **Request Changes**. If your unsure of the priority of the issue,
flag it for the developer.
