---
name: docs-minimal-ppt-design
description: Build a clean, minimal, content-first instructional slide deck or slide script for any tool (PptxGenJS, python-pptx, Reveal.js, Google Slides). Use to "build a minimal slide deck" or "script a clean instructional presentation".
---

# Minimal Instructional Presentation

**Input:** topic, sections, content per slide, any Q&A pairs, diagram
requirements.
**Output:** working code or markup for the target tool, or a structured slide
script the user can paste into their tool of choice.
**Framework:** apply this spec to whatever tool is in use. See
`pptxgenjs-reference.md` for a ready-made PptxGenJS scaffold.

## Philosophy

Built on one principle: **the content is the design.** No colours, no
decorative elements, no styling choices that distract from what is being
communicated. Suited to educational, professional, and instructional contexts
where clarity beats impression.

## Slide Structure

### Opening Slide (Title)

- Course/topic name in bold, centred, 36pt
- Subtitle in italic mid grey (`666666`), centred, 20pt
- White background, no decorations

### Contents Slide

- Title: "Contents" - left-aligned, bold, 28pt
- Bulleted list of all section names, 15pt body
- No slide numbers in the list

### Section Divider Slides

- Section number in small mid grey (`666666`) text above the title (e.g.
  "Section 3")
- Section name in bold, centred, 36pt
- No other content - breathing room slides
- Use as chapter markers in any recorded medium

### Content Slides

- Title: left-aligned, bold, 28pt
- Section reference: italic, light grey (`AAAAAA`), 11pt - directly below the
  title
- Body: 15pt, left-aligned, max 5 bullet points OR max 5 numbered steps.
  Split across two slides if needed.
- Diagram placeholder (when applicable): grey-bordered box at the bottom of
  the slide, italic, describing what to insert
- Target: 50-75 words of body text per slide maximum

### Q&A / Practice Slides

- Header: "Example Use Cases" - bold, 28pt, left-aligned
- Source reference: italic light grey (`AAAAAA`), 11pt
- Question: bold, 14pt
- Answer: regular weight, 13pt, bulleted
- Question and answer on the same slide

### Closing Slide (Summary Table)

- Title left-aligned, bold, 28pt
- One-line italic summary caption below the title, light grey (`AAAAAA`)
- Full-width table with dark header row

## Typography

| Element           | Font  | Size    | Weight          | Colour                          |
| ----------------- | ----- | ------- | --------------- | ------------------------------- |
| Slide title       | Arial | 28-36pt | Bold            | Black `000000`                  |
| Section reference | Arial | 11pt    | Regular, Italic | Light grey `AAAAAA`             |
| Body text         | Arial | 15pt    | Regular         | Black `000000`                  |
| Q&A question      | Arial | 14pt    | Bold            | Black `000000`                  |
| Q&A answer        | Arial | 13pt    | Regular         | Black `000000`                  |
| Table header      | Arial | 11pt    | Bold            | White `FFFFFF` on dark `333333` |
| Table body        | Arial | 11pt    | Regular         | Black `000000`                  |
| Diagram note      | Arial | 12pt    | Italic          | Mid grey `666666`               |
| Divider number    | Arial | 20pt    | Regular         | Mid grey `666666`               |
| Divider title     | Arial | 36pt    | Bold            | Black `000000`                  |

## Layout & Spacing

All measurements in inches. Slide dimensions: 16:9 (10" x 5.625").

- All margins: minimum 0.5" from slide edges
- Title block: x=0.5, y=0.25, w=9, h=0.65
- Section reference: x=0.5, y=0.88, w=9, h=0.28
- Body text starts: y=1.25 (with ref) or y=1.05 (without ref), x=0.5, w=9
- Body height: 2.8" when diagram present, 4.0" otherwise
- Diagram placeholder box: x=0.5, y=4.35, w=9, h=0.85 - foot of slide
- ~4-6pt spacing between paragraphs
- Never fill every inch - breathing room is part of the design

## Colour Palette

| Use                                       | Hex              |
| ----------------------------------------- | ---------------- |
| Background                                | `FFFFFF` (white) |
| All body text                             | `000000` (black) |
| Light grey (ref/captions)                 | `AAAAAA`         |
| Mid grey (diagram notes, divider numbers) | `666666`         |
| Diagram placeholder fill                  | `F5F5F5`         |
| Diagram placeholder border                | `CCCCCC`         |
| Table header fill                         | `333333`         |
| Table header text                         | `FFFFFF`         |
| Table borders                             | `CCCCCC`         |

No other colours. Do not introduce accent colours, highlights, branded
palettes, or coloured shapes.

## Lists

- **Bullet points** - use for concepts, explanations, features, comparisons
- **Numbered lists** - use exclusively for step-by-step processes where order
  matters
- Never mix the two on the same slide
- Never use unicode bullet characters - always use the tool's native
  list/bullet mechanism
- Sub-bullets (one indent level) only when genuinely necessary - never nest
  more than one level deep

## Diagram Placeholders

When a diagram would aid understanding but is to be added manually later,
include a placeholder box at the bottom of the slide:

- Filled with `F5F5F5`, bordered with `CCCCCC` at 1pt
- Text: `[DIAGRAM: <clear description of what to draw>]`
- Italic, mid grey (`666666`), centred within the box
- Description should be specific enough that anyone could draw it without
  asking - include component names, relationships, and directionality

Example:

```
[DIAGRAM: Control loop - Sensor -> ADC -> Processor -> DAC -> Actuator -> Environment -> Sensor (feedback arrow)]
```

## What to Avoid

- No decorative lines, borders around slides, or header/footer bars
- No animations or slide transitions
- No presenter notes (speaker works from the source document)
- No slide numbers embedded in the deck itself
- No images unless added manually post-export
- Never use the slide title as the only content - every content slide must
  have body text

## Invocation Parameters

When a user invokes this skill, gather the following before generating output:

- `title` - string
- `subtitle` - string (optional)
- `sections` - list of section names, in order
- `content` - per section: slide title, optional section reference, up to 5
  bullet points or numbered steps (max 75 words total per slide)
- `diagrams` - list of slides needing a placeholder, each with a description
  of what to draw; or "none"
- `qa_pairs` - list of `{ source, question, answer_bullets }`; omit if none
- `closing_table` - column headers and row data; omit if none
