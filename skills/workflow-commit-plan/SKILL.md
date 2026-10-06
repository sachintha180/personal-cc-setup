---
name: workflow-commit-plan
description: Split the current uncommitted changes into single-concern commits, each with a git add and a Conventional Commits subject. Read-only. Use before staging or committing.
---

# Commit plan

Turn a repo's uncommitted changes into an ordered list of commits: one
`git add` command and one Conventional Commits subject line per commit.
Never run `git add` or `git commit` yourself, only propose the plan.

## 1. Read the change set

Run `git status --short --untracked-files=all`, `git diff`, and
`git diff --cached` to see every changed, added, deleted, and
untracked file and its actual content. Staged and unstaged both count;
the plan re-stages everything explicitly. Stop and say so if there is
no git repo here, or nothing to commit.

## 2. Match this repo's commit style

Run `git log --oneline -30`. From the subjects, work out whether
commits use `type(scope): subject` or plain `type: subject`, which
types actually appear, what a scope stands for here, and the usual
capitalization and length. No history yet: default to lowercase
`type: subject`, no scope. The Conventional Commits format itself is
fixed either way; only the scope, tone, and length come from history.

## 3. Group files by concern

Read every file's diff, not just its name. Merge everything serving
the same concern into one commit, however many files that takes;
start a new commit only for a genuinely different concern, so fewer
commits beats more as long as none of them mixes concerns. A file
whose diff mixes two concerns still goes entirely into one group,
since `git add` cannot split a file below the file level. Put a
prerequisite change, such as a new module a later commit's code
imports, before the commit that depends on it; otherwise order is
free.

## 4. Write each commit

One `git add <files>` per group, relative paths, space-separated,
quoted if a path has spaces. One imperative subject line, no period,
no body: `feat` for a new capability, `fix` for a bug fix, `refactor`
for a behavior-preserving restructure, and so on, chosen from what the
diff actually does.

## Output format

```
1. git add path/to/file_a.py path/to/file_b.py
   fix: guard against a null card on submit

2. git add path/to/new_module.py path/to/routes.py
   feat: add stage filtering to the review queue
```

Nothing else, unless asked to explain the grouping.
