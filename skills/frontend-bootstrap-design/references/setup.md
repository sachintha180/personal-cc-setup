# Establishing a project's design system

Every project decides its own palette, fonts, and geometry once. Do this before
you specify anything against tokens that do not exist yet.

## Step 1: Look for an existing token file

Before you ask the user anything, check whether the project defines its tokens.
Look for a CSS file loaded after Bootstrap that sets variables such as
`--bs-primary` or `--bs-font-sans-serif`. It is often named `theme.css`. If one
exists, read it and use its values for every later decision. Do not run the
setup conversation again.

## Step 2: Offer the starter token file

If no token file exists, offer the user an optional starter. This skill ships
`assets/theme.css` and `assets/base.css`. The rules for these files are in
[starter-theme-rules.md](starter-theme-rules.md). Copy the files into the
project only if the user accepts. If the user declines or wants different
values, go to step 3.

## Step 3: Guided setup conversation

If no token file exists and the user did not accept the starter, ask about each
item below before you design anything. Keep it to one focused conversation.

- **Color roles.** What color does each semantic role carry: primary, secondary,
  success, danger, warning, info, light, dark, plus body text, body background,
  link color, and border color? A brand usually has a palette. Ask for it. Do
  not guess a value.
- **Extension colors.** Does the project need a color role Bootstrap has no name
  for, such as an accent that tells categories apart in a list? If so, name each
  one and its role. Bootstrap's own roles are enough for most projects.
- **Font stacks.** How many font stacks, and for what purpose? Most projects
  need one for body and headings, and optionally one for code. Ask for the font
  names.
- **Font weights.** Which weights will be used? A small fixed set keeps the type
  system consistent, for example one for body text, one for headings, and one
  for emphasis.
- **Border radius policy.** Are structural elements such as cards, inputs,
  buttons, and containers sharp, subtly rounded, or fully rounded? Ask whether
  pill badges and circular dots or avatars are exceptions.
- **Motion.** Does the interface use animation? If so, ask how fast state
  changes such as hover and focus should feel. Ask the same for larger motion
  such as a reveal or an expand. Ask for a feel, such as short and snappy or
  slower and deliberate. Do not assume a millisecond value.
- **Breakpoints.** Does the project keep Bootstrap's defaults (sm, md, lg, xl,
  xxl), or does it have its own primary layout-split point? Go deeper only for
  an unusual layout need.
- **Dark mode.** Does the project need dark mode? If so, which roles change, and
  which stay the same?

## Step 4: Write the token file into the project

Write the decided values into a CSS file inside the project's own codebase. Do
not write it inside `.claude/`. Follow Bootstrap's convention. Override `--bs-*`
variables at `:root` for anything Bootstrap already names. Define `--ds-*`
variables only for the extension colors from step 3. Add a
`[data-bs-theme="dark"]` block if the project wants dark mode.

If the project structure does not show where the file belongs, ask the user. For
example, it can sit beside other static assets or wherever the project loads its
CSS.

Tell the user the file path, so a later session can find it.
