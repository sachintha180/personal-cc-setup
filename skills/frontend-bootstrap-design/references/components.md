# Component library

This file lists the approved components. Each entry gives the purpose, the
Bootstrap classes, any token overrides, and the behavior. It has no code
examples.

Every token named below, such as `--bs-primary` or `--ds-warm`, means the value
the project assigned during setup. See `setup.md` if the project has no token
file. The process to add a component is in `standards.md`.

## Icons

**Purpose:** Directional and state-indicator icons, not decoration. Bootstrap
ships no icon set.

**Library:** Bootstrap Icons, loaded through a pinned CDN `<link>` in the base
page layout. Use the `<i class="bi bi-*">` form and never inline SVG, so every
icon stays a one-class swap.

**Token overrides:** None. Icons inherit `currentColor` or a text-utility class
such as `text-body-secondary`.

**Behavior:**
- Use an icon only for a real affordance. Examples are a navigable list row
  (`bi-chevron-right`) and a primary creation action (`bi-plus-lg` before the
  label on a button that adds a record, such as "Add Item" or "New Note").
- Every icon gets `aria-hidden="true"`. The adjacent text carries the meaning.
  No icon is the only label for an action.
- Before you add an icon spot, check whether an existing one covers the pattern.
  Do not add a second glyph for the same affordance.
- **Do not add a custom chevron to a native `<details>/<summary>` disclosure.**
  The browser already renders an open/closed marker on `<summary>`. A
  `bi-chevron-down` duplicates it.

## Navigation

### Navbar

**Purpose:** Site-level navigation bar. Collapses to a toggler button on mobile.

**Bootstrap classes:**
- Outer: `navbar navbar-expand-md`
- Background and text: `bg-dark navbar-dark` for a dark surface, or `bg-light`
  for a light surface
- Container: `container` or `container-fluid` inside the navbar
- Brand: `navbar-brand`
- Toggler: `navbar-toggler` with `navbar-toggler-icon` inside
- Collapse wrapper: `collapse navbar-collapse`
- Nav links: `nav-item nav-link`
- Active state: `active` on the current `nav-link`

**Token overrides:** None. `--bs-dark` or `--bs-light` resolve through the token
file.

**Behavior:**
- Collapses below `md`. Nav links stack vertically on mobile.
- The active `nav-link` uses Bootstrap's default active contrast.
- The toggler animates through Bootstrap's collapse behavior. No custom
  animation is needed.

### Breadcrumb

**Purpose:** Wayfinding trail on a nested page, from the top-level index to the
current page. It is the only back-navigation element on a page. Do not pair it
with a chevron back-link.

**Bootstrap classes:**
- Wrapper: `<nav aria-label="Breadcrumb">` around `ol.breadcrumb.mb-2`
- Each ancestor: `li.breadcrumb-item` containing a plain `<a>`
- Current page: `li.breadcrumb-item.active` with `aria-current="page"`, plain
  text

**Token overrides:** None. The default `/` divider and link color come from
Bootstrap's breadcrumb variables.

**Behavior:**
- The trail starts at the top-level index. Home is the navbar brand link, so it
  is never a crumb.
- The last crumb is the current page and has no link.
- Use it on nested content pages and editors. A step-by-step flow page gets no
  breadcrumb. It keeps its own explicit exit actions.

### Nav Tabs

**Purpose:** Tabbed content switching within a page section. Shows or hides
related content panels.

**Bootstrap classes:**
- Tab list: `nav nav-tabs`
- Individual tab: `nav-item`
- Tab link: `nav-link`, with `active` on the selected tab
- Content area: `tab-content`
- Individual panel: `tab-pane fade`, with `show active` on the visible panel

**Token overrides:** None.

**Behavior:**
- Tab switching uses Bootstrap's tab JS plugin (`data-bs-toggle="tab"`).
- Inactive tabs use muted text (`--bs-secondary-color`).
- The active tab has a bottom border in `--bs-primary`.

## Content

### Card

**Purpose:** General-purpose content container for entries, previews, and
grouped information.

**Bootstrap classes:**
- Wrapper: `card`
- Optional header: `card-header`
- Body: `card-body`
- Title: `card-title`
- Subtitle: `card-subtitle text-body-secondary`
- Text: `card-text`
- Footer: `card-footer`

**Token overrides:**
- None needed. The card border inherits `--bs-border-color`.
- The card background defaults to `--bs-body-bg`. Add `bg-white` for surface
  contrast.

**Behavior:**
- No hover effect by default. An interactive card, using `stretched-link`, adds
  a border-color transition at the project's state-change duration.
- A card header accepts a `--bs-primary` background for accent styling.

### Badge

**Purpose:** Inline label for tags, status indicators, version numbers, and
category markers.

**Bootstrap classes:**
- Base: `badge`
- Semantic background: `text-bg-primary`, `text-bg-secondary`,
  `text-bg-success`, `text-bg-danger`, `text-bg-warning`, `text-bg-info`
- Pill variant: add `rounded-pill`

**Token overrides:** None. Semantic colors apply through `text-bg-*` classes.

**Behavior:**
- Badge text uses `--bs-body-bg` for contrast against the semantic background.
- **Dot-only variant:** a status dot with no text is a plain `span` with
  `rounded-circle`, a semantic `bg-*` class, and a `visually-hidden` label that
  names the state. To place it on a corner, such as of a card, add
  `position-absolute top-0 start-100 translate-middle` and give the parent
  `position-relative`.
- Padding-only sizing (`p-1 rounded-circle`, no fixed width or height) is
  Bootstrap's documented technique for a dot. It is not reliable in every
  context. An empty inline element takes its height from its line-height and its
  width from its padding. Beside text in a `d-flex` row, the two can differ, and
  the dot renders as an oval. Use padding-only sizing when it is reliable in
  context. Otherwise use a small utility class with equal fixed `width` and
  `height`. Bootstrap's spinner makes the same exception. Compare the rendered
  `width` and `height` to check.
- **Sequential-state badge:** for an item that moves through an ordered set of
  states toward completion, map the states across the semantic ramp in order. Do
  not pick colors per state. Not-yet-available states use `text-bg-secondary`.
  The current state uses `text-bg-primary`. The completed state uses
  `text-bg-success`. A failure or blocked state uses `text-bg-danger`, wherever
  it falls in the sequence. Use this ramp for every new ordered-state list.

### Button

**Purpose:** Primary and secondary user actions.

**Bootstrap classes:**
- Base: `btn`
- Semantic fill: `btn-primary`, `btn-secondary`, `btn-success`, `btn-danger`,
  `btn-warning`, `btn-info`
- Outline variant: `btn-outline-primary`, `btn-outline-secondary`, and so on
- Size: `btn-sm` for compact contexts. The default size for standard actions.
- Disabled: `disabled` attribute or `btn disabled` class

**Token overrides:** None. Semantic colors apply through `btn-*` classes.

**Behavior:**
- The focus ring uses `--bs-link-color` through Bootstrap's
  `--bs-focus-ring-color`.
- Disabled state: 50% opacity, a Bootstrap default.
- Loading state: replace the label content with
  `spinner-border spinner-border-sm` and a `visually-hidden` status text.

## Lists

### List Group

**Purpose:** Vertical list of items for navigation lists, resource links, and
item collections.

**Bootstrap classes:**
- Wrapper: `list-group`
- Item: `list-group-item`
- Active item: `list-group-item active`
- Interactive item: `list-group-item list-group-item-action`
- Flush variant, with no outer border: `list-group list-group-flush`

**Token overrides:**
- Active item background: Bootstrap derives it from `--bs-primary`. Active text
  color is `--bs-light`.
- Border color: `--bs-border-color`.

**Behavior:**
- `list-group-item-action` shows a hover background using `--bs-tertiary-bg`. It
  transitions over the project's state-change duration. This is Bootstrap
  built-in behavior.

## Forms

### Form

**Purpose:** User input for contact forms, search, settings, and data entry.

**Bootstrap classes:**
- Label: `form-label`
- Text input: `form-control`
- Select: `form-select`
- Textarea: `form-control` with a `rows` attribute
- Validation error border: `is-invalid` on the input element
- Validation error message: `invalid-feedback` on a sibling element
- Validated form: `was-validated` on the `<form>` element

**Token overrides:**
- Focus ring: Bootstrap's `--bs-focus-ring-color` inherits `--bs-link-color`.
- Invalid border: `--bs-form-invalid-border-color` resolves to `--bs-danger`.
- Invalid feedback text: `--bs-form-invalid-color` resolves to `--bs-danger`.

**Behavior:**
- Validation errors show through `invalid-feedback` when the parent has
  `was-validated` or the input has `is-invalid`.
- Form labels render at `--bs-secondary-color`.
- Disabled inputs follow the Button disabled opacity.

### Submit Button

**Purpose:** Primary form submission action, with a loading state during async
operations.

**Bootstrap classes:**
- Base: `btn btn-primary`
- Loading state: as in Button, above, inline with or replacing the label
- Disabled during loading: `disabled` attribute

**Token overrides:** Inherits from Button, above.

**Behavior:**
- Disabled immediately on submission. Re-enabled on completion, whether success
  or error.

### Attachment List

**Purpose:** A small file-upload control paired with a list of attached files,
scoped to one create/edit form.

**Bootstrap classes:**
- Upload control: `form-control form-control-sm`, native `type="file"`, `accept`
  restricted to the permitted extensions, `multiple` where more than one file is
  accepted
- Attached-file list: `list-group list-group-flush`, each item
  `list-group-item d-flex justify-content-between align-items-center`
- File name: plain text, `text-truncate` in a constrained-width flex child
- File-type badge (optional, if more than one file type is accepted):
  `badge text-bg-secondary`

**Token overrides:** None.

**Behavior:**
- Helper text under the control states the accepted file types and the size
  limit, for example "Attach a .md or .txt file, up to 100 KB".
- A rejected file (wrong type or too large) shows an `alert alert-danger` inline
  above the control. It does not use a browser alert.
- Removing a file the user just selected, before submit, uses a plain
  `btn-close btn-sm` on its list item. Removing a file already attached to a
  saved record is a separate capability. Add it only if the project needs it. Do
  not build a post-save delete affordance speculatively.

### Alert

**Purpose:** Inline contextual feedback for form submission results, operation
confirmations, and error messages.

**Bootstrap classes:**
- Base: `alert`
- Semantic variant: `alert-success`, `alert-danger`, `alert-warning`,
  `alert-info`
- Dismissible: `alert alert-dismissible fade show` with a `btn-close` inside

**Token overrides:** None. Semantic colors apply through `alert-*` classes.

**Behavior:**
- Display it inline within the form or content section. Do not use a toast or a
  modal.
- A dismissible alert uses Bootstrap's alert dismiss behavior. A non-dismissible
  alert is removed when the condition clears.
- Use Bootstrap's built-in toggle and dismiss behavior and keep the
  accessibility attributes Bootstrap requires.

## Feedback

### Spinner

**Purpose:** Loading indicator for async operations.

**Bootstrap classes:**
- Standard: `spinner-border`
- Small inline variant: `spinner-border spinner-border-sm`
- Alternative grow variant: `spinner-grow`. Use it sparingly. Prefer
  `spinner-border`.

**Accessibility requirement:** Always include a `visually-hidden` sibling or
child with a meaningful loading label, such as "Loading...". A screen reader
does not announce a spinner without it.

**Token overrides:** The spinner color inherits `currentColor`. Set the text
color on the parent or the spinner with `text-primary`, `text-secondary`, or
`text-info`, as the context needs.

**Behavior:**
- Inline spinners (`spinner-border-sm`) appear inside buttons or beside label
  text.
- Standalone spinners appear centered within their containing section.
- Do not combine a spinner with a progress bar for the same operation.

## Overlays

### Modal

**Purpose:** A focused dialog for a create/edit form or a short confirmation,
layered over the page.

**Bootstrap classes:**
- Outer: `modal fade`, hidden from assistive technology until open, not in the
  tab order while closed
- `modal-dialog` wraps `modal-content`
- `modal-header` (title and `btn-close`), `modal-body` (the form fields or
  message), `modal-footer` (Cancel and primary action)
- Trigger: a button that opens the modal through Bootstrap's modal toggle
  behavior
- Cancel button: `btn btn-outline-secondary`, dismisses the modal
- Primary action button: `btn btn-primary` for a create/save action,
  `btn btn-danger` for a destructive one (see Confirmation modal)

**Token overrides:** None.

**Behavior:**
- One create/edit form serves both create and edit when the fields are
  identical. The title, submit label, and prefilled values change with the mode.
  Do not design two near-duplicate modals.
- A page with exactly one instance of the record renders the modal in the page,
  prefilled.
- A page that lists many instances of a record carries one empty modal shell,
  not one modal per row. Each row's trigger loads that row's content into the
  shell. The loaded content is the `modal-content` part (header, body, footer),
  not a full `modal` wrapper. It keeps the shell's identity, so the next row's
  trigger still has a target.
- The modal opens only after the correct content has loaded. It never opens
  first and fills later. Opening first can show the previous row's form, or let
  an older response overwrite a newer one, so the form acts on the wrong row. A
  new trigger click cancels any load in flight.
- The form inside a modal submits as a normal full-page submission. The redirect
  on success closes the modal along with the page.
- Every modal has a working Cancel and no separate "discard changes?" prompt.
  Bootstrap's dismiss on backdrop click and Escape is the accepted default.
- Use Bootstrap's built-in toggle and dismiss behavior and keep the
  accessibility attributes Bootstrap requires.

### Confirmation modal

**Purpose:** A destructive action (delete) that cannot be undone always confirms
first. Do not use a bare browser confirm dialog. It has no room for cascade
details.

**Bootstrap classes:** The Modal structure above, with:
- `modal-body` states in plain language exactly what gets deleted, including
  anything that cascades with it (for example "This also deletes its review
  history.")
- The confirming button is `btn btn-danger`, not `btn-primary`. Its label is the
  action itself ("Delete"), not a vague "Confirm".
- The confirming button is a real form submit inside the modal, not a link with
  a client-side handler

**Behavior:**
- Applies to every delete action.
- One instance per page renders in the page. Many instances per page load per
  row, as in Modal.

## Custom Components

### Timeline

**Purpose:** Vertical chronological list with a left accent line and dot
indicators, for experience and history sections. Bootstrap has no native
equivalent. It is built from Bootstrap utilities.

**Bootstrap classes and structure:**
- Outer list: `list-unstyled position-relative`
- Accent line: `border-start border-2` on the outer list, with color from a
  scoped `--bs-border-color` override
- Each item: `position-relative ms-4 mb-4`
- Dot indicator: a small `position-absolute` element with `rounded-circle`,
  sized `1rem` by `1rem`, offset to sit on the accent line
  (`start-0 translate-middle-x`)
- Item content: block-level siblings of the dot within each list item

**Token overrides:**
- The accent line color and dot color are scoped overrides on the outer list
  element. Example: `style="--bs-border-color: var(--ds-warm)"` if the project
  defines `--ds-warm`, or any of the project's semantic color variables.
- The dot background matches the line color through the same scoped variable.

**Accent cycling:** For colors that tell timelines or sections apart, follow the
extension color rule in `standards.md`.

**Behavior:**
- The last item uses a distinct end marker, such as an upward chevron icon or a
  different dot style, to signal the earliest entry.
- The timeline is fully responsive. The accent line and dot stay visible at all
  breakpoints.
- No hover effects on items unless the item is interactive.
- Interactive items follow the List Group hover pattern: a background transition
  over the project's state-change duration, using `ease-in-out`.

### Chart wrapper

**Purpose:** A sized container for a JS charting library's canvas (for example
Chart.js), which needs a parent with an explicit height. Bootstrap has no chart
component. Only the wrapper's sizing is custom. The chart's own styling follows
the token rules below.

**Structure:**
- A single wrapper `div` around the `<canvas>`, with a fixed `height` in `rem`,
  not `px`, for consistency with the token file. This is the one value here that
  cannot come from a Bootstrap utility, since Bootstrap has no
  fixed-height-in-rem utility.

**Token overrides:**
- The chart library's colors (series lines, points, gridlines, tooltip) read the
  project's Bootstrap or `--ds-*` CSS custom properties at render time, through
  `getComputedStyle`. Do not hardcode hex values in the chart config. Gridlines
  use a neutral token such as `--bs-border-color`, not a library default or a
  magic `rgba()` value.

**Behavior:**
- Smooth a line series with `cubicInterpolationMode: "monotone"`, never
  `tension`. Monotone interpolation stays within the data's range. A bounded
  percentage series such as retention accuracy cannot dip below 0% or rise above
  100% between two points.
- Pair the chart with an accessible fallback by default, for example a `<table>`
  of the same data inside a disclosure. A canvas has no text content for
  assistive tech or copy-paste. Omit the fallback only as a deliberate,
  documented exception.
