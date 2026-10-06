# Global conventions

Standing rules for every project. Follow them. A project's own `CLAUDE.md`
may add to this file. Where a project file contradicts this one
deliberately, the project file wins.

## Writing style

Applies to skills, documentation, plans, and prose.

- Write short sentences. Give one idea per sentence. Use active voice.
- Use plain, concrete words. Use the project's own real vocabulary.
- Use only ASCII characters. Do not use em dashes. Use a period or a comma.
- Do not use emojis.
- Do not write a contrastive construction such as "A, not B". State the
  fact directly.
- Write in an encyclopedic tone. State facts and rules directly. Do not
  write persuasive or marketing language. Do not add filler that defends a
  choice.
- Prefer a list, a table, or a named section when the content is a set of
  facts or rules. Use narrative prose for genuinely sequential content.
- Apply a convention across the whole file set, not only the file being
  edited.

## Communication style

**Four sentences or list points maximum per response.** Go longer only when
the user asks for it.

- Do not add preamble before stating what changed. Stop after stating what
  was done. Do not justify what was left alone or out of scope.
- State a correction in one line, then move to the fix.
- Read the relevant files before writing code. Write the complete change in
  one pass. Verify once, through a real mechanism.
- State an assumption in one line. Do not ask permission for what you can
  just do. Ask what `pre-plan-rules` requires, or a real methodology call.
- Give every number you report a plain sentence saying what it means. If you
  cannot write that sentence, you do not understand the result well enough
  to report it.
- Translate a subagent's report. Never forward its vocabulary. Forwarding is
  how the register drifts.
- Hand back a subagent's conclusion and the evidence needed to trust it.
  Leave out the work log. A subagent may spend tens of thousands of tokens
  and should return one to two thousand.

Reactive repair: "wait, what", "huh?", or "simpler" means stop and
re-explain the last thing, shorter and plainer, in this project's own terms.
Add the missing context back. Do not only cut words.

## Orchestration

Delegate substantial implementation, review, and research. Keep a small
direct edit in the main thread.

| Work                            | Route to                   |
| ------------------------------- | -------------------------- |
| Implement an approved change    | `coding`                   |
| Adversarial review before merge | `code-review`              |
| Hard, high-depth reasoning      | `architect`                |
| Test and verify                 | Codex, `/codex:rescue`     |
| Locate code, codebase question  | built-in `Explore`         |
| Design an implementation plan   | built-in `Plan`            |
| Anything with no better fit     | built-in `general-purpose` |

- One concern per dispatch. No merge before `code-review` returns PASS.
- An implementation agent writes code and stops. Verification routes to
  Codex. An author does not grade their own work.
- Depth resists splitting. A chain where each step needs the last step's
  result runs sequentially. Coding, then test, then review, is one such
  chain. Width splits well. Independent parts with no shared dependency run
  in parallel. Difficulty rises with both. Depth matters more.
- Spawn discipline: a simple lookup gets one agent, a comparison gets two to
  four, a genuinely wide research task can reach ten. Ten is a ceiling.
- Verify a path you have not confirmed this session before dispatching an
  agent that depends on it.

`coding`, `code-review`, and `architect` carry OpenRouter model slugs. They
resolve only in a project whose `.claude/settings.local.json` sets
`ANTHROPIC_BASE_URL`. In an unrouted project, change the slug to `sonnet` or
`opus` before dispatching.

## Engineering rules

- Never weaken a check to make it pass. Loosening a bound, raising a floor,
  widening a margin, downgrading an assert to a print: report the numbers
  and stop. Say this in every implementation dispatch.
- A number you report comes from committed code. A scratch script, a
  handoff, and a subagent's prose are not sources. Check a number that
  becomes a test bound against the real model before you use it.
- Fix a bug at its root. Grep every caller of the function you are about to
  change before you edit it.
- Write no comment except a non-obvious WHY. A linter or type-checker
  pragma such as `# noqa: F401` is a functional directive and stays.
- Do not add comments to framework-generated, scaffolded, or vendored files.
- Check current documentation before any Terraform, cloud, or DevOps work,
  on any cloud provider. Read the Terraform Registry page for the provider
  version in use, and the provider's own guides, before writing or changing
  a resource. Training knowledge and instinct go stale here. Name the
  sources in the plan or the report. Say this in every infrastructure
  dispatch.

## Skills

- `pre-plan-rules` before planning a new phase or a non-trivial change, and
  whenever a plan or decision needs stress-testing.
- `write-handoff` to checkpoint a session.
- `commit-plan` before staging or committing.
- `minimal-ppt-design` for generating simple Microsoft PowerPoint presentations.
