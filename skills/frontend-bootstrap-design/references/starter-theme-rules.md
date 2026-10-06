# Starter theme rules

These rules go with `assets/theme.css` and `assets/base.css`. They are defaults
for the starter theme. A project may override any of them. If the project has
its own token file, that file wins.

## Color roles

| Variable         | Hex       | Semantic role                                |
| ---------------- | --------- | -------------------------------------------- |
| `--bs-primary`   | `#2a2a3c` | Headings, primary body text, primary actions |
| `--bs-secondary` | `#646488` | Subtitles, labels, secondary actions         |
| `--bs-success`   | `#4a9e62` | Positive states, confirmations, completion   |
| `--bs-danger`    | `#e35e8f` | Errors, destructive actions, warnings        |
| `--bs-warning`   | `#c47d1a` | Caution states, in-progress indicators       |
| `--bs-info`      | `#1878cc` | Informational states, neutral highlights     |
| `--bs-light`     | `#f4f4f4` | Page background, light surface backgrounds   |
| `--bs-dark`      | `#2a2a3c` | Dark surface backgrounds (same as primary)   |

Bootstrap 5.3 text-hierarchy variables:

| Variable                | Hex       | Role                                      |
| ----------------------- | --------- | ----------------------------------------- |
| `--bs-body-color`       | `#2a2a3c` | Default body text                         |
| `--bs-secondary-color`  | `#646488` | Secondary body text                       |
| `--bs-tertiary-color`   | `#666666` | Metadata, captions, reduced-emphasis text |
| `--bs-link-color`       | `#0e7ad0` | Hyperlinks and CTA backgrounds            |
| `--bs-link-hover-color` | `#0a5fa0` | Hyperlink hover                           |
| `--bs-body-bg`          | `#f4f4f4` | Page background                           |
| `--bs-border-color`     | `#d1d5db` | Default borders                           |

Accent extensions:

| Variable    | Hex       | Role                                   |
| ----------- | --------- | -------------------------------------- |
| `--ds-warm` | `#e59e55` | Warm orange - categorisation accent    |
| `--ds-cool` | `#369def` | Cool cyan/blue - categorisation accent |

Accent cycling order. When assigning colors to a sequence of grouped items,
cycle through these in order:

```
primary -> secondary -> warning -> info -> success -> danger -> warm -> cool
```

## Typography

| Variable               | Value                     | Usage                                   |
| ---------------------- | ------------------------- | --------------------------------------- |
| `--bs-font-sans-serif` | `"Manrope", sans-serif`   | All headings and body text              |
| `--bs-font-monospace`  | `"Space Mono", monospace` | Code, technical, monospace content only |

No other font families. Apply via Bootstrap's text utilities (`font-monospace`)
or let the body font cascade.

| Weight | Bootstrap class | Usage                           |
| ------ | --------------- | ------------------------------- |
| 400    | `fw-normal`     | Body text                       |
| 500    | `fw-medium`     | Titles, headings                |
| 600    | `fw-semibold`   | Button labels, strong UI labels |
| 700    | `fw-bold`       | Maximum emphasis                |

Manrope supports 200 to 800. The starter theme limits use to 400, 500, 600, and
700.

Type scale:

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

`.text-caption` is a one-line addition in `base.css` if needed. It is not a
Bootstrap native class.

## Layout conventions

| Convention              | Classes        | Value        |
| ----------------------- | -------------- | ------------ |
| Page horizontal padding | `px-4 px-md-5` | 24px -> 48px |
| Page vertical padding   | `py-4 py-md-5` | 24px -> 48px |
| Section gap             | `gap-4`        | 24px         |
| Inline item gap         | `gap-2`        | 8px          |

## Responsive layout

- Design mobile-first. Enhance at `md` (768px) and `xl` (1280px).
- The primary layout split is `xl`. Section-level responsiveness uses `md`.
- Enhance with breakpoint-suffixed classes such as `col-md-*`, `d-md-block`, and
  `px-md-5`.

## Border radius

`--bs-border-radius` is `0`. All structural elements are sharp by default.

- `rounded-1` through `rounded-5` are prohibited on structural elements.
  `rounded`, `rounded-lg`, and `rounded-xl` are also prohibited.
- `rounded-pill` is only for version tags and count indicators. Status badges
  and category badges stay sharp.
- `rounded-circle` is only for dot indicators and avatar elements.

## Animation

Two durations only.

| Purpose                              | Duration | Bootstrap utility                              |
| ------------------------------------ | -------- | ---------------------------------------------- |
| State changes (hover, focus, active) | 150ms    | Use Bootstrap's built-in component transitions |
| Motion (translate, reveal, expand)   | 300ms    | `transition` with `ease-in-out`                |

Always use `ease-in-out` as the timing function. Do not use `linear`, `ease-in`,
or `ease-out`.

## Dark mode

The accent colors (success, danger, warning, info) keep their light-mode values
in dark mode on purpose. Do not override them unless a specific contrast failure
is identified and documented.
