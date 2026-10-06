---
name: workflow-autoresearch-loop
description: Runs an autonomous experiment loop on a git branch. A cheaper subagent runs each experiment, and a change is kept only if the target metric improves. Use to "run an experiment loop", "optimize a metric autonomously", or "start an autoresearch run".
---

## Setup

To set up a new experiment, work with the user to:

1. **Agree on a run tag**: propose a tag based on today's date (e.g. `mar5`).
   The branch `autoresearch/<tag>` must not already exist. This is a fresh
   run.
2. **Create the branch**: `git checkout -b autoresearch/<tag>` from current
   master.
3. **Read the in-scope files**.
4. **Verify data exists**.
5. **Initialize a result file, if one doesn't already exist**.

Once you get confirmation, kick off the experimentation.

## Experimentation

Each experiment runs within a fixed time budget, agreed during setup (wall
clock time, excluding startup and any one-time setup cost).

**What you CAN do:**

- Modify the files agreed as in scope during setup. Everything within them is
  fair game: design, parameters, structure, configuration, whatever the
  experiment covers.

**What you CANNOT do:**

- Modify any file marked read-only during setup. This typically covers
  evaluation, data loading, and fixed constants such as the time budget.
- Install new packages or add dependencies. Use only what is already
  available in the project.
- Modify whatever computes the target metric, wherever it lives. That logic
  must stay fixed for every experiment in the run, or the results stop being
  comparable.

**The goal is simple: get the lowest value of the target metric.** Since the
time budget is fixed, you do not need to worry about how long a run takes: it
is always the same budget. Everything in scope is fair game. The only
constraint is that the code runs without crashing and finishes within the
time budget.

**Simplicity criterion**: all else being equal, simpler is better. A small
improvement that adds ugly complexity is not worth it. Conversely, removing
something and getting equal or better results is a great outcome: that is a
simplification win. When you decide whether to keep a change, weigh the
complexity cost against the improvement. A tiny improvement in the target
metric that adds twenty lines of hacky code is probably not worth it. The
same tiny improvement from deleting code is worth keeping. An improvement of
about zero, but with much simpler code, is also worth keeping.

**The first run**: your very first run should always be to establish the
baseline. Run the experiment as is, unmodified.

## Output format

Once the run finishes, it should print a short summary of results, at minimum
the target metric and how long the run took. Redirect this output to a log
file rather than letting it stream into your context.

Extract the target metric from the log file with a targeted search, for
example a grep for the line that reports it. Never read a whole log file.

The exact numbers may vary by run, since they depend on the machine the
experiment runs on. Judge each experiment against the others in the same run,
not against numbers from a different machine.

## Logging results

When an experiment is done, log it to `results.csv` (tab-separated, not
comma-separated: commas break the description field).

The CSV has a header row and 4 columns:

```
commit	metric	status	description
```

1. git commit hash (short, 7 characters)
2. the target metric achieved (use 0 for crashes)
3. status: `keep`, `discard`, or `crash`
4. short text description of what this experiment tried

## The experiment loop

The experiment runs on a dedicated branch (e.g. `autoresearch/mar5`).

LOOP FOREVER:

1. Look at the git state: the current branch and commit you are on.
2. Tune the in-scope files with an experimental idea, by directly hacking the
   code.
3. git commit.
4. Dispatch the experiment run to a subagent (see Delegation). The subagent
   redirects all output to a log file.
5. Read out the result: search the log file for the target metric.
6. If the search comes back empty, the run crashed. Read the last lines of
   the log to find the error, and attempt a fix. If you cannot get things to
   work after more than a few attempts, give up.
7. Record the result in the CSV.
8. If the target metric improved (lower), advance the branch, keeping the git
   commit.
9. If the target metric is equal or worse, git reset back to where you
   started.

You are a completely autonomous researcher trying things out. You advance the
branch so you can keep iterating. If you feel stuck, you can rewind, but do
this sparingly, if ever.

**Timeout**: each experiment should take about as long as the agreed time
budget, plus a few seconds of startup and evaluation overhead. If a run takes
more than twice the time budget, kill it and treat it as a failure: discard
and revert.

**Crashes**: if a run crashes (a bug, a resource limit, or similar), use your
judgment. If it is something small and easy to fix, for example a typo or a
missing import, fix it and rerun. If the idea itself is fundamentally broken,
skip it, log `crash` as the status in the CSV, and move on.

**NEVER STOP**: once the experiment loop has begun, after the initial setup,
do not pause to ask the human if you should continue. Do not ask "should I
keep going?" or "is this a good stopping point?". The human might be away
from the computer and expects you to keep working indefinitely until you are
manually stopped. You are autonomous. If you run out of ideas, think harder:
re-read the in-scope files for new angles, read any reference material
available in the project, try combining previous near-misses, try more
radical changes. The loop runs until the human interrupts you, period.

As an example, if each experiment takes 5 minutes, a user leaving you running
overnight could get on the order of 100 completed experiments back by
morning.

## Delegation

The orchestrator does not run an experiment itself. Each experiment run is
grunt work and goes to a cheaper subagent.

- The orchestrator chooses the idea, edits the in-scope files or briefs the
  edit, commits, and reads the metric back.
- The subagent runs the fixed command, waits for it, greps the target metric
  from the log, and returns the metric, the wall-clock time, and the last
  twenty log lines on a crash. It returns nothing else.
- Use the `coding` agent with `model: sonnet` for an edit plus run. Use
  `general-purpose` with `model: haiku` for a run only.
- Give the subagent the absolute repo path, the exact command, the log path,
  the grep pattern, and the timeout. Tell it not to edit any file, not to
  install anything, and not to retry a crashed run.
- The orchestrator keeps its context small (see Output format).

## Remote compute

Runs that need a GPU, or that would exceed the local memory limit, can go to
RunPod through `runpodctl`. State the hourly price before a pod is created.
Delete the pod when the run ends. The MCP read tools serve list and status
queries. A pod is billed while it exists, so do not leave one idle between
experiments.
