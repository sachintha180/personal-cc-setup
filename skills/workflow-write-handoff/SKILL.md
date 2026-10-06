---
name: workflow-write-handoff
description: Write a session handoff so a fresh session can resume with full context. Use at a stopping point, before a context limit, or as a checkpoint.
argument-hint: "[reason - why this handoff is being written]"
---

Write a single markdown file that lets a fresh session resume this work
without re-reading the whole conversation. Nothing auto-loads this file at
session start. A resumed session finds it by checking the handoff location
manually, so the filename's timestamp is for humans browsing the directory,
not for any automated lookup.

## Find where handoffs belong

Do this before writing anything.

1. Search the repo for an existing handoff convention: a directory
   named `handoffs` at any depth, or files matching `*handoff*.md`. If one
   exists, use it.
2. If none exists, look at the top level of the current working directory
   for a docs-like directory (`docs/`, `references/`, or similar). Use a
   `handoffs/` subdirectory inside the first one you find.
3. If nothing suggests a convention, ask the user where the handoff should
   go. Do not pick a path silently.
4. Create the directory if it does not exist yet.

Reuse whatever location you land on for the rest of this task. Writing the
first file there also establishes the convention that step 1 finds next
time.

## Filename

`YYYYMMDD-HHMMSS-<short-slug>.md`. Get the timestamp from the shell (for
example `date +%Y%m%d-%H%M%S`), not from memory. The slug is a few words
describing the work.

## What to include

Keep this dense and factual. The next session pays full price to read it,
so do not pad it. Prefer pointers over duplication: reference existing
files (a roadmap or status doc, a plan file, a specific commit) rather than
re-explaining their content.

1. Why this handoff exists: the reason given as an argument (context
   threshold, manual checkpoint, usage-limit insurance), otherwise infer it.

2. What was being worked on: the task, and which repo or area it is in if
   that is not obvious from context. If the session touched more than one
   repo, state that plainly near the top.

3. Current state: done, in progress, not started. Be specific. Write
   "the login form validates client-side, server-side validation not yet
   started" rather than "made progress on the login form."

4. Decisions made this session: especially anything that took a
   clarifying-question round or touched a sensitive file or convention.
   Include the reasoning, not just the conclusion. The next session needs
   to know why, not just what.

5. Files touched: paths only, not diffs. `git status --short` and
   `git diff --stat` against the session's start point are enough.

6. Open questions or blockers: anything mid-clarification, or anything
   explicitly deferred (for example, "rate limiting was raised but not
   started, per the user's earlier scope decision").

7. Suggested next step: the single most useful thing the resumed session
   should do first. Not a full plan re-derivation, just the next action.

## After writing

Output one line the user can copy into a fresh session to resume,
reusing item 7's suggested next step rather than writing a second summary:

`Resume from <path> - <suggested next step>`
