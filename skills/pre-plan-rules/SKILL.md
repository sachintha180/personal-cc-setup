---
name: pre-plan-rules
description: The planning ritual before any new phase, feature, or non-trivial change. Also use to grill a plan, design, or decision with no implementation planned.
argument-hint: "[what is being planned or grilled]"
allowed-tools: Agent(Explore)
---

Process rules, made procedural. This skill has two entry points. Pick one
before you start.

| Entry point   | Use when                                          | Do          |
| ------------- | ------------------------------------------------- | ----------- |
| Full ritual   | Implementation follows the planning               | Steps 1 - 6 |
| Grill only    | The user wants thinking tested, with no build     | Step 2 only |

The question discipline in step 2 is the core of both. Read it either way.

## 1. Enter plan mode

Enter plan mode before you design anything. Do not propose a plan, write a
plan file, or touch any file until steps 1 through 3 are done.

## 2. Ask clarifying questions

### How to ask

Put every question through the harness's own interactive question tool,
`AskUserQuestion`. This is a hard rule. Fall back to plain prose in the chat
only when that tool is unavailable in the current harness, and say that is
why when you do.

- Up to 4 questions per call. 2 to 4 options each.
- Put your recommended option first. End its label with "(Recommended)".
- The question body carries the framing. The option descriptions carry the
  trade-offs, including the cost of each choice.
- Leave out an "Other" option. The tool supplies one.
- More than 4 questions ready: make consecutive calls in the same round.
  Never defer a question that is already ready.
- Ask across several rounds when an early answer raises a new question.
  Guessing instead is the failure this step exists to prevent.

### How many

| Task                                                            | Minimum |
| --------------------------------------------------------------- | ------- |
| An ordinary feature, phase, or refactor                          | 5       |
| A new subsystem, an architecture decision, or a stack choice      | 10      |
| Anything the user calls large, or anything spanning many sessions | 10      |

These are floors. Keep asking past the floor while a real decision remains
open. Stop when every remaining choice is routine and reversible.

### What to ask about

Weight your questions toward:

- Anything that would write outside what the user already approved.
- Any schema, data-model, or interface decision.
- Any methodology decision, meaning a choice about what counts as correct,
  passing, or done.
- Any choice that is expensive to reverse later.
- A conflict between two answers you already have. Surface it and let the
  user resolve it.

Routine, reversible implementation detail needs no question. When in doubt,
ask.

### Grill-only mode

Stop after this step. Report what the answers settled and what they exposed.
Write no plan file and enter no plan mode. If the answers reveal that
implementation should follow after all, say so and offer the full ritual.

## 3. Explore the codebase

Read the relevant files before you design the plan. Dispatch built-in
`Explore` agents in parallel, one pass per concern area. Avoid one large pass
over everything.

Start with the project's root `CLAUDE.md` and whatever it points at. Route
each dispatch by what the task actually touches: the data model, the request
or routing layer, a shared utility, the test setup, the build or deploy
path, whatever the project's own docs name.

## 4. Write the plan file

Find where plans belong before writing one.

1. Search the repo for an existing convention: a `plans` directory at any
   depth, or files matching `*plan*.md`. Use it if one exists.
2. If none exists, use the plan file that plan mode itself provides.
3. Create no new directory tree that the repo has not already established.

The plan must include:

- The decision and the reasoning behind it, including what the clarifying
  answers ruled in and ruled out.
- A verification section naming the real mechanism for this task: the
  project's own test suite through Codex, a migration run in both
  directions, a manual check in the running app. Avoid a generic "add
  tests".
- Which agent each piece of work routes to, per the root `CLAUDE.md`
  orchestration table.

If the repo has a committed plans convention, commit the file. A plan nobody
commits is a plan the next session cannot find.

Writing the plan file before approval is the one write that plan mode
allows, because the file has to exist before it can be approved.

## 5. Exit plan mode for approval

Call `ExitPlanMode` and wait. Do no implementation and update no tracking
document until the user approves.

## 6. Record the task before writing code

The first step after approval is to record the new phase or task in whatever
the project already uses to track work, before any code changes. Use the
file the project already has. Do not invent a parallel tracking file that
the project does not use. If the project tracks nothing, skip this step.
