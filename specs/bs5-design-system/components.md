# Component Library

Components derived from patterns demonstrably used in production. Each entry specifies: purpose, Bootstrap classes, token overrides (if any), and behaviour. No code examples.

If a needed component is absent, ask human. See `standards.md` for the extending pattern.

## Navigation

### Navbar

**Purpose:** Site-level navigation bar. Collapses to a toggler button on mobile.

**Bootstrap classes:**
- Outer: `navbar navbar-expand-md`
- Background and text: `bg-dark navbar-dark` (dark navy) or `bg-light` for light surface
- Container: `container` or `container-fluid` inside the navbar
- Brand: `navbar-brand`
- Toggler: `navbar-toggler` with `navbar-toggler-icon` inside
- Collapse wrapper: `collapse navbar-collapse`
- Nav links: `nav-item nav-link`
- Active state: `active` on the current `nav-link`

**Token overrides:** None required. `--bs-dark` resolves to `#2a2a3c` via `theme.css`.

**Behaviour:**
- Collapses below `md` (768px). Nav links stack vertically in mobile.
- Active `nav-link` uses Bootstrap's default active contrast against the navbar background.
- Toggler animates via Bootstrap's collapse JS - no custom animation needed.

### Nav Tabs

**Purpose:** Tabbed content switching within a page section. Used to show/hide related content panels.

**Bootstrap classes:**
- Tab list: `nav nav-tabs`
- Individual tab: `nav-item`
- Tab link: `nav-link` with `active` on the selected tab
- Content area: `tab-content`
- Individual panel: `tab-pane fade` with `show active` on the visible panel

**Token overrides:**
- Active tab underline / border inherits `--bs-primary` for border color via Bootstrap's component variables.

**Behaviour:**
- Tab switching via Bootstrap's tab JS plugin (`data-bs-toggle="tab"`).
- Inactive tabs render with muted text (`--bs-secondary-color`).
- Active tab has a bottom border in `--bs-primary`.

## Content

### Card

**Purpose:** General-purpose content container. Used for project entries, post previews, and grouped information blocks.

**Bootstrap classes:**
- Wrapper: `card`
- Optional header: `card-header`
- Body: `card-body`
- Title: `card-title`
- Subtitle: `card-subtitle text-body-secondary`
- Text: `card-text`
- Footer: `card-footer`

**Token overrides:**
- No explicit overrides needed. Card border color inherits `--bs-border-color` (`#d1d5db`).
- Card background defaults to `--bs-body-bg` (`#f4f4f4`) or `--bs-body-bg` with a `bg-white` override for surface contrast.

**Behaviour:**
- No hover effect by default. Interactive cards (using `stretched-link`) add a border-color transition at 150ms.
- Card headers accept a `--bs-primary` background for accent styling.

### Badge

**Purpose:** Inline label for tags, status indicators, version numbers, and category markers.

**Bootstrap classes:**
- Base: `badge`
- Semantic background: `text-bg-primary`, `text-bg-secondary`, `text-bg-success`, `text-bg-danger`, `text-bg-warning`, `text-bg-info`
- Pill variant (only permitted shape exception): add `rounded-pill`

**Token overrides:** None. Semantic colors apply through `text-bg-*` classes via `theme.css` overrides.

**Behaviour:**
- Use `rounded-pill` only for version tags and count indicators. Status and category badges remain sharp.
- Badge text uses `--bs-body-bg` for contrast against the semantic background.

### Button

**Purpose:** Primary and secondary user actions.

**Bootstrap classes:**
- Base: `btn`
- Semantic fill: `btn-primary`, `btn-secondary`, `btn-success`, `btn-danger`, `btn-warning`, `btn-info`
- Outline variant: `btn-outline-primary`, `btn-outline-secondary`, etc.
- Size: `btn-sm` for compact contexts; default size for standard actions
- Disabled: `disabled` attribute or `btn disabled` class

**Token overrides:** None. Semantic colors apply through `btn-*` classes via `theme.css` overrides.

**Behaviour:**
- Focus ring uses `--bs-link-color` via Bootstrap's `--bs-focus-ring-color`.
- Disabled state: 50% opacity (Bootstrap default).
- Loading state: replace label content with `spinner-border spinner-border-sm` and a `visually-hidden` status text.

## Lists

### List Group

**Purpose:** Vertical list of items - used for navigation lists, resource links, and item collections.

**Bootstrap classes:**
- Wrapper: `list-group`
- Item: `list-group-item`
- Active item: `list-group-item active`
- Interactive item: `list-group-item list-group-item-action`
- Flush variant (no outer border): `list-group list-group-flush`

**Token overrides:**
- Active item background: Bootstrap derives from `--bs-primary`. Active text color is `--bs-light`.
- Border color: `--bs-border-color` (`#d1d5db`).

**Behaviour:**
- `list-group-item-action` shows a hover background using `--bs-tertiary-bg` at 150ms (Bootstrap built-in).

## Forms

### Form

**Purpose:** User input - contact forms, search, settings, and data entry.

**Bootstrap classes:**
- Label: `form-label`
- Text input: `form-control`
- Select: `form-select`
- Textarea: `form-control` (with `rows` attribute)
- Validation error border: `is-invalid` on the input element
- Validation error message: `invalid-feedback` on a sibling element
- Validated form: `was-validated` on the `<form>` element to show validation states

**Token overrides:**
- Focus ring: Bootstrap's `--bs-focus-ring-color` inherits `--bs-link-color` (`#0e7ad0`).
- Invalid border: `--bs-form-invalid-border-color` resolves through Bootstrap's danger variable to `--bs-danger` (`#e35e8f`).
- Invalid feedback text: `--bs-form-invalid-color` resolves to `--bs-danger`.

**Behaviour:**
- Validation errors display via `invalid-feedback` when the parent has `was-validated` or the input has `is-invalid`.
- Form labels render at `--bs-secondary-color`.
- Disabled inputs: 50% opacity (Bootstrap default).

### Submit Button

**Purpose:** Primary form submission action, with a loading state during async operations.

**Bootstrap classes:**
- Base: `btn btn-primary`
- Loading state: replace label content with `spinner-border spinner-border-sm` and a `visually-hidden` status text
- Disabled during loading: `disabled` attribute

**Token overrides:** Inherits from Button (see above).

**Behaviour:**
- Disabled immediately on submission; re-enabled on completion (success or error).
- Loading state: spinner inline with or replacing the label text.

### Alert

**Purpose:** Inline contextual feedback - form submission results, operation confirmations, error messages.

**Bootstrap classes:**
- Base: `alert`
- Semantic variant: `alert-success`, `alert-danger`, `alert-warning`, `alert-info`
- Dismissible: `alert alert-dismissible fade show` with a `btn-close` inside

**Token overrides:** None. Semantic colors apply through `alert-*` classes via `theme.css`.

**Behaviour:**
- Displayed inline within the form or content section - not as a toast or modal.
- Dismissible alerts use `data-bs-dismiss="alert"`. Non-dismissible alerts are removed from the DOM programmatically.

## Feedback

### Spinner

**Purpose:** Loading indicator for async operations.

**Bootstrap classes:**
- Standard: `spinner-border`
- Small inline variant: `spinner-border spinner-border-sm`
- Alternative grow variant: `spinner-grow` (use sparingly - prefer `spinner-border`)

**Accessibility requirement:** Always include a `visually-hidden` sibling or child element with a meaningful loading label (e.g. "Loading..."). Screen readers do not announce a spinner without it.

**Token overrides:** Spinner color inherits `currentColor`. Set text color on the parent or the spinner element via `text-primary`, `text-secondary`, or `text-info` as appropriate for context.

**Behaviour:**
- Inline spinners (`spinner-border-sm`) appear inside buttons or alongside label text.
- Standalone spinners appear centered within their containing section.
- Do not combine a spinner with a progress bar for the same operation.

## Custom Components

### Timeline

**Purpose:** Vertical chronological list with a left accent line and dot indicators. Used for experience and history sections. No Bootstrap native equivalent - built from Bootstrap utilities.

**Bootstrap classes and structure:**
- Outer list: `list-unstyled position-relative`
- Accent line: `border-start border-2` on the outer list; color applied via scoped `--bs-border-color` override
- Each item: `position-relative ms-4 mb-4`
- Dot indicator: a small `position-absolute` element with `rounded-circle`, sized `1rem × 1rem`, offset to sit on the accent line (`start-0 translate-middle-x`)
- Item content: block-level siblings of the dot within each list item

**Token overrides:**
- Accent line color and dot color are scoped overrides applied at the outer list element:
  `style="--bs-border-color: var(--ds-warm)"` (or any semantic color)
- Dot background matches the line color via the same scoped variable.

**Accent cycling:** When multiple timelines or timeline sections use color to differentiate categories, cycle through in this order:
```
primary -> secondary -> warning -> info -> success -> danger -> warm -> cool
```

**Behaviour:**
- The last item in a timeline uses a distinct end marker (e.g. upward chevron icon or a different dot style) to signal the earliest entry.
- Timeline is fully responsive - the left accent line and dot remain visible at all breakpoints.
- No hover effects on individual items unless the item is explicitly interactive.
- Interactive items follow the List Group hover pattern (150ms `ease-in-out` background transition).
