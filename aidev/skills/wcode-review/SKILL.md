---
name: wcode-review
description: Used when reviewing working changes or a pull request for correctness and quality.
argument-hint: base-branch
---

## Purposes of code reviews

Code reviews have multiple purposes. They help catch bugs. They help ensure SOLID, YAGNI, KISS principles are being
followed. They catch security risks added with changes. They ensure maintainability, extensibility, and readability.

## Instructions

Assume the current branch is the one being reviewed. Using the base-branch the user mentions, find the commits that
differ from that branch and the current branch you're on. Go through each commit message to gain context on why a change
was made. Then look at that commits changes. Once you've gone through all the commits, do one final check of all the
changes to make sure they're coherent. Don't make comments about issues that are transitive and not in the final state
of the branch

Don't worry about running tests or linters. Assume those will happen at another part of the process

## Expected output

The output of a code review should be a priority sorted list of items falling into either **Must Fix** or **Nice to
have** with a suggestion at the end of **Approve** or **Request Changes**. If your unsure of the priority of the issue,
flag it for the developer.
