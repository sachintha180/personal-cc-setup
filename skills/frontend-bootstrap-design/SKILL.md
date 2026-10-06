---
name: frontend-bootstrap-design
description: Design specifications for Bootstrap v5 interfaces, built on per-project design tokens. Output is specs only, never code. Use to design a card, a mobile nav, a status badge, form errors, or any layout or component for a Bootstrap UI, even if the user does not say Bootstrap.
---

# Bootstrap v5 design specification

This skill produces design specifications for Bootstrap v5 interfaces. It does
not produce code: no JSX, no Python, no framework HTML, no templates. A
specification names the component hierarchy, the Bootstrap classes, any token
overrides, responsive behavior, interaction states, and accessibility
requirements. A developer in any stack can implement it.

## First: find or establish the project's tokens

Every project decides its own palette, fonts, and geometry once, and this skill
designs against those values. Before specifying any design, confirm that the
project has design tokens. Read
[references/setup.md](references/setup.md) and follow it. Look for an existing
token file first. Run the guided setup only if none exists. Do this once per
project.

## Reference files

| File                                                                   | Covers                                                                                                |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| [references/setup.md](references/setup.md)                             | How to find or establish a project's tokens. Read first in a project without tokens.                  |
| [references/standards.md](references/standards.md)                     | Universal rules for using tokens: color, typography, spacing, layout, radius, motion, dark mode.      |
| [references/starter-theme-rules.md](references/starter-theme-rules.md) | Default values for the starter `assets/theme.css` and `assets/base.css`. A project may override them. |
| [references/components.md](references/components.md)                   | The approved component library: purpose, classes, token overrides, behavior.                          |

## Core rules

- **Bootstrap classes first.** Compose every component from Bootstrap's utility
  and component classes. Write custom CSS only for a pattern Bootstrap cannot
  express. Document that addition in `components.md`.
- **Tokens, not raw values.** Every color comes from a `--bs-*` or `--ds-*`
  token. See `standards.md`.
- **Use the project's own policy.** Border radius, font stacks, motion timing,
  and breakpoints come from the project's token file. Do not assume sharp
  corners, a font, or a duration.
- **Verify Bootstrap details against current documentation.** Class names and
  defaults change between versions. Check the Bootstrap v5 documentation for
  anything version-sensitive.

## When to ask before proceeding

Ask the user, instead of designing around the gap, when:

- The project has no token file and the needed values are not established.
- The component or layout pattern is not in `components.md`.
- A new `--ds-*` token seems needed. `--ds-*` is reserved for a semantic role
  that Bootstrap has no variable for.
- A design would deviate from the project's border-radius policy, beyond the
  exceptions the project already confirmed.
- A color need cannot be expressed with an existing token.

## How to approach a design task

Find out what the component is for and what happens at each breakpoint. Check
`components.md` for a matching pattern before you invent a composition.

For anything beyond a small change, sketch the approach in a sentence or two
first. A short inline check-in is enough.

Write the specification with:

- The component hierarchy.
- The Bootstrap classes used, and why.
- Scoped token overrides.
- Responsive behavior per breakpoint.
- Interaction states: hover, focus, active, loading, error.
- Accessibility requirements: aria attributes, visually hidden labels, focus
  management.

Before handover, check the specification against `standards.md` and
`components.md`.
