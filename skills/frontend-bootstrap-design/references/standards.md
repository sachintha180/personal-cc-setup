# Design standards

These rules cover the correct use of a project's tokens. They hold for any
values a project chose.

## Color

### Rule: tokens only, never raw values

Never use raw hex values, `rgb()` literals, or named CSS colors in markup,
inline styles, or custom CSS. Every color comes from a `--bs-*` or `--ds-*`
token. Apply it through Bootstrap's semantic utility classes (`text-primary`,
`bg-danger`, `btn-success`) or a scoped CSS variable override.

**Good:**
- Bootstrap class: `class="text-primary"`, `class="bg-success"`
- Scoped CSS variable override: `style="--bs-border-color: var(--ds-warm)"`
- Opacity via RGB variable: `rgba(var(--bs-primary-rgb), 0.1)`

**Bad:**
- Raw hex inline: `style="color: #112233"`
- Arbitrary Tailwind color: `class="text-gray-700"`
- Hardcoded value in CSS: `color: #445566;`

### Rule: semantic color, never decorative color

Every use of an accent or semantic color must signal a category or a state. Do
not apply a color for visual interest alone.

### Bootstrap's semantic color roles

Bootstrap defines eight core semantic roles: primary, secondary, success,
danger, warning, info, light, dark. Bootstrap 5.3 also exposes text-hierarchy
roles: body-color, secondary-color, tertiary-color, link-color,
link-hover-color, body-bg, border-color. A project's token file assigns each
role a value during setup. Design against the role name, such as `--bs-primary`
or `text-danger`, never against the value.

### Extension colors

A project may define `--ds-*` variables for a color role Bootstrap has no name
for, such as an accent for categorizing grouped content. Check Bootstrap's roles
first. Use an extension token only when the role does not exist there.

To cycle colors through categories, for example in a timeline or a card grid,
use the semantic roles before the extension roles. Follow the order the project
set during setup.

## Typography

### Rule: a fixed, small set of font stacks

Define at most two font stacks: one for body and headings, and optionally one
for code or technical content. Do not add a third stack without the user's
approval. The font names live in the token file, typically as
`--bs-font-sans-serif` and `--bs-font-monospace`.

### Rule: a fixed, small set of font weights

Use only the weights the project chose during setup. Do not use another weight,
even if the font file supports it.

### Mapping semantic roles to Bootstrap classes

Map content to Bootstrap's heading and text utilities by role, whatever sizes
the fonts render at. Use `h1` or `display-5` for a page title, `h2` to `h4` for
headings, `lead` for emphasized text, `p` for body text, and `small` for
metadata. The starter mapping with sizes is in `starter-theme-rules.md`.

Reserve `display-1` through `display-4` for hero-level page titles only. Reserve
the monospace stack for code, file paths, and technical strings.

## Spacing

Bootstrap's spacing scale is based on `$spacer = 1rem`. Multipliers 0 through 5
map to the `m-*`, `p-*`, and `gap-*` utilities. Use these utilities. Do not
hardcode pixel values. A project may set its own convention for page padding,
section gaps, or inline item gaps during setup. Apply it consistently.

## Layout

### Token precedence

A token's value can be set at three levels, in order: the global `:root` block
in the token file, a scoped override at the component level, and an inline
style. A later level wins. Prefer a scoped override to an inline style when the
override applies to more than one instance of a component.

### Container width

Use `container` for a page or section with a fixed maximum width at each
breakpoint. Use `container-fluid` when the content spans the full viewport width
at every breakpoint, such as inside a navbar that reaches both screen edges.

### Breakpoints

Use Bootstrap's default breakpoints (sm, md, lg, xl, xxl) unless the project set
its own primary layout-split point during setup. Do not introduce a breakpoint
outside the project's set.

Design for the smallest viewport first. Never hide content on mobile as the
default. Hide it at larger breakpoints only when it is secondary.

## Border radius

The project sets its radius policy once, through `--bs-border-radius` and its
size variants. The policy is sharp, subtly rounded, or fully rounded. Apply
`rounded-*` classes only in line with that policy. `rounded-pill` on badges and
`rounded-circle` on dot indicators or avatars are common exceptions under a
sharp policy. Confirm with the token file or the user that they apply.

## Animation

The project decides during setup whether it uses animation, and how fast state
changes and larger motion feel. Use Bootstrap's built-in transition utilities.
Do not write custom `transition` CSS where Bootstrap already handles it. Avoid
keyframe animations, spring physics, and sequences unless the project asked for
them. The default motion vocabulary is translate, opacity, and scale.
`ease-in-out` is the default timing function unless the project specifies
another.

## Dark mode

Bootstrap 5.3's color-mode system activates dark mode with
`data-bs-theme="dark"` on `<html>` or on any subtree. Overrides come from a
`[data-bs-theme="dark"]` block. Use this mechanism. Do not add a separate
dark-mode stylesheet. Setup decides whether the project needs dark mode, which
token values change, and which stay the same. Semantic accent colors often stay
constant across modes. Confirm this with the project.

## Extending the design system

Use this process when a component or layout is not in `components.md`.

### Step 1: Check Bootstrap first

Check whether Bootstrap has a component, a utility combination, or a CSS
variable that meets the need. If it does, document the composition in
`components.md` and stop.

### Step 2: Identify token needs

If Bootstrap's classes need a visual adjustment, apply the `--bs-*` override at
the component scope, as an inline style or a scoped CSS rule. Do not change the
global tokens for one component.

**Bad:** Adding a global token to `:root` for the needs of one component.

### Step 3: Introduce `--ds-*` only when necessary

If Bootstrap's variable set has no variable for the semantic role, define a new
`--ds-*` variable in the token file. Document its role in this file.

### Step 4: Document in components.md

After the user approves, add the component to `components.md` with:
- Purpose - what it does and when to use it
- Bootstrap classes - the class composition
- Token overrides - any `--bs-*` or `--ds-*` overrides applied
- Behavior - hover, focus, responsive, loading, and error states as applicable

### What never belongs in the design system

- Application-specific content, such as a route, a page ID, an API endpoint, a
  database field, or a feature flag
- Framework or template syntax, such as JSX, Vue directives, or Jinja2 blocks
- Business logic, such as data-fetching patterns, state management, or event
  handlers
- An import of a CSS framework other than Bootstrap
