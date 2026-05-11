# Design Standards

## Color System

### Semantic Colors (`--bs-*`)

These variables override Bootstrap's defaults globally at `:root`. Apply them through Bootstrap's semantic utility classes (`text-primary`, `bg-success`, `btn-danger`, etc.) - never as raw hex values.

| Variable         | Hex       | Semantic Role                                |
| ---------------- | --------- | -------------------------------------------- |
| `--bs-primary`   | `#2a2a3c` | Headings, primary body text, primary actions |
| `--bs-secondary` | `#646488` | Subtitles, labels, secondary actions         |
| `--bs-success`   | `#4a9e62` | Positive states, confirmations, completion   |
| `--bs-danger`    | `#e35e8f` | Errors, destructive actions, warnings        |
| `--bs-warning`   | `#c47d1a` | Caution states, in-progress indicators       |
| `--bs-info`      | `#1878cc` | Informational states, neutral highlights     |
| `--bs-light`     | `#f4f4f4` | Page background, light surface backgrounds   |
| `--bs-dark`      | `#2a2a3c` | Dark surface backgrounds (same as primary)   |

Bootstrap 5.3 also exposes text-hierarchy variables:

| Variable                | Hex       | Role                                      |
| ----------------------- | --------- | ----------------------------------------- |
| `--bs-body-color`       | `#2a2a3c` | Default body text                         |
| `--bs-secondary-color`  | `#646488` | Secondary body text                       |
| `--bs-tertiary-color`   | `#666666` | Metadata, captions, reduced-emphasis text |
| `--bs-link-color`       | `#0e7ad0` | Hyperlinks and CTA backgrounds            |
| `--bs-link-hover-color` | `#0a5fa0` | Hyperlink hover                           |
| `--bs-body-bg`          | `#f4f4f4` | Page background                           |
| `--bs-border-color`     | `#d1d5db` | Default borders                           |

### Accent Extensions (`--ds-*`)

These two variables have no Bootstrap semantic equivalent. Use them for categorisation and accent cycling across grouped content (timelines, card grids, icon sets).

| Variable    | Hex       | Role                                   |
| ----------- | --------- | -------------------------------------- |
| `--ds-warm` | `#e59e55` | Warm orange - categorisation accent    |
| `--ds-cool` | `#369def` | Cool cyan/blue - categorisation accent |

**Accent cycling order** - when assigning colors to a sequence of grouped items, cycle through these in order:

```
primary -> secondary -> warning -> info -> success -> danger -> warm -> cool
```

### Color Rules

**Rule:** Never use raw hex values, rgb() literals, or named CSS colors in markup or custom CSS.

**Good:**
- Bootstrap class: `class="text-primary"`, `class="bg-success"`
- Scoped CSS variable override: `style="--bs-border-color: var(--ds-warm)"`
- Opacity via RGB variable: `rgba(var(--bs-primary-rgb), 0.1)`

**Bad:**
- Raw hex inline: `style="color: #2a2a3c"`
- Arbitrary Tailwind color: `class="text-gray-700"`
- Hardcoded value in CSS: `color: #646488;`

**Rule:** Do not apply accent colors for decoration. Every use of `--ds-warm`, `--ds-cool`, or any semantic color must signal a category or state to the user.

## Typography

### Font Stacks

| Variable               | Value                     | Usage                                   |
| ---------------------- | ------------------------- | --------------------------------------- |
| `--bs-font-sans-serif` | `"Manrope", sans-serif`   | All headings and body text              |
| `--bs-font-monospace`  | `"Space Mono", monospace` | Code, technical, monospace content only |

No other font families. Apply via Bootstrap's text utilities (`font-monospace`) or let the body font cascade.

### Font Weights

| Weight | Bootstrap class | Usage                           |
| ------ | --------------- | ------------------------------- |
| 400    | `fw-normal`     | Body text                       |
| 500    | `fw-medium`     | Titles, headings                |
| 600    | `fw-semibold`   | Button labels, strong UI labels |
| 700    | `fw-bold`       | Maximum emphasis                |

Do not use weights outside 400 / 500 / 600 / 700. Manrope supports 200–800 but the design system constrains to these four.

### Typography Scale

Map semantic roles to Bootstrap's heading and text utilities:

| Semantic role           | Bootstrap class           | Approximate size |
| ----------------------- | ------------------------- | ---------------- |
| Page title / H1         | `h1` or `display-5`       | 2.25rem / 36px   |
| Section heading / H2    | `h2`                      | 1.75rem / 28px   |
| Sub-section / H3        | `h3`                      | 1.5rem / 24px    |
| UI element heading / H4 | `h4`                      | 1.25rem / 20px   |
| Emphasized body / lead  | `lead`                    | 1.125rem / 18px  |
| Default body            | `p` (default)             | 1rem / 16px      |
| Small / metadata        | `small` or `text-body-sm` | 0.875rem / 14px  |
| Caption                 | `.text-caption` (custom)  | 0.75rem / 12px   |

`.text-caption` is a one-line addition in `base.css` if needed. It is not a Bootstrap native class.

### Typography Rules

**Rule:** Do not use Bootstrap's display classes (`display-1` through `display-4`) as general headings. They are reserved for hero-level page titles only.

**Rule:** Do not use `font-monospace` for body content. Reserve it for code blocks, file paths, and technical strings.

**Rule:** Do not mix font weights outside 400 / 500 / 600 / 700.

## Spacing

Bootstrap's spacing scale is based on `$spacer = 1rem` with multipliers:

| Suffix | Value         |
| ------ | ------------- |
| `0`    | 0             |
| `1`    | 0.25rem / 4px |
| `2`    | 0.5rem / 8px  |
| `3`    | 1rem / 16px   |
| `4`    | 1.5rem / 24px |
| `5`    | 3rem / 48px   |

Apply via Bootstrap's `m-*` / `p-*` / `gap-*` utilities. Do not hardcode pixel values.

### Layout-Level Conventions

These conventions must be applied consistently across all page and section layouts:

| Convention              | Classes        | Value        |
| ----------------------- | -------------- | ------------ |
| Page horizontal padding | `px-4 px-md-5` | 24px -> 48px |
| Page vertical padding   | `py-4 py-md-5` | 24px -> 48px |
| Section gap             | `gap-4`        | 24px         |
| Inline item gap         | `gap-2`        | 8px          |

## Border Radius

`--bs-border-radius` is globally `0`. All structural elements are sharp by default.

Permitted exceptions:
- `rounded-pill` - badge pill labels only
- `rounded-circle` - dot indicators and avatar elements only

**Rule:** `rounded`, `rounded-1` through `rounded-5`, `rounded-lg`, `rounded-xl` are prohibited on structural elements.

## Animation

Two durations only. No exceptions without human approval.

| Purpose                              | Duration | Bootstrap utility                              |
| ------------------------------------ | -------- | ---------------------------------------------- |
| State changes (hover, focus, active) | 150ms    | Use Bootstrap's built-in component transitions |
| Motion (translate, reveal, expand)   | 300ms    | `transition` with `ease-in-out`                |

**Rule:** Use Bootstrap's built-in transition utilities where available. Do not write custom `transition` CSS when Bootstrap components already handle it.

**Rule:** Do not add keyframe animations (`@keyframes`), spring physics, or sequences. Motion vocabulary is limited to: translate, opacity, scale.

**Rule:** Always use `ease-in-out` as the timing function. Do not use `linear`, `ease-in`, or `ease-out`.

## Dark Mode

Bootstrap 5.3's color mode system is used. No separate dark-mode stylesheet.

**Activation:** Apply `data-bs-theme="dark"` to `<html>` for global dark mode. Apply it to any subtree element for scoped dark mode.

**Tokens:** Dark mode token overrides are in `theme.css` under `[data-bs-theme="dark"]`. Bootstrap derives component-level overrides from these root variables automatically.

**Rule:** Never create a separate dark-mode stylesheet. All dark mode overrides belong in the `[data-bs-theme="dark"]` block in `theme.css`.

**Rule:** The semantic accent colors (success, danger, warning, info) intentionally retain their light-mode values in dark mode. Do not override them unless a specific contrast failure is identified and documented.

## Extending the Design System

This pattern applies whenever a new component or layout is needed that is not already in `components.md`.

### Step 1: Check Bootstrap first

Determine whether Bootstrap already provides a component, utility combination, or CSS variable that satisfies the design need. Prefer composition of existing Bootstrap classes over writing custom CSS. If Bootstrap covers it, document the composition in `components.md` and stop here.

### Step 2: Identify token needs

If Bootstrap's existing classes need visual adjustment for this design system, apply the relevant `--bs-*` token override at the component scope (inline style or a scoped CSS rule). Do not modify `theme.css` global tokens for component-specific adjustments.

**Good:** `style="--bs-border-color: var(--ds-warm)"` on a specific timeline element.
**Bad:** Adding a new global token to `:root` in `theme.css` for a single component's needs.

### Step 3: Introduce `--ds-*` only when necessary

If the semantic role is genuinely absent from Bootstrap's variable set, define a new `--ds-*` variable in `theme.css`. Ask human before adding it. Document its semantic role in `standards.md`.

### Step 4: Document in `components.md`

After human approval, add the new component to `components.md` with:
- Purpose - what it does and when to use it
- Bootstrap classes - the class composition
- Token overrides - any `--bs-*` or `--ds-*` overrides applied
- Behaviour - hover, focus, responsive, loading, error states as applicable

### What never belongs in the design system

- Application-specific CSS (route-specific styles, page IDs, feature flags)
- Framework or template syntax (JSX, Vue directives, Jinja2 blocks)
- Business logic (data fetching patterns, state management, event handlers)
- Any import of a CSS framework other than Bootstrap

## See Also

- `designer.md` - Designer persona, workflow, and constraints
- `components.md` - Approved component specifications
- `theme.css` - All token definitions
- `base.css` - Font loading
