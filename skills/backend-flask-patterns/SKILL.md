---
name: backend-flask-patterns
description: Flask, Jinja2, HTMX, and route-design patterns: blueprints, app factories, extensions, template inheritance, macros, load-triggered fetches, shell plus fragment routes, guard decorators. Use for "add a route", "load this page's data with htmx", "add a new template".
---

# Flask, Jinja2, and HTMX patterns

This is a pattern catalog for a server-rendered Flask app. The app uses Jinja2
templates and HTMX for partial-page interactivity. Each entry names one
recurring situation and shows the standard code shape for it. Where a real
tradeoff exists, the entry also names a documented alternative with its own
source. An entry with no alternative already reflects the recommended
approach. A different solution to a covered problem still works, such as a
full page reload instead of an HTMX fragment swap. It drifts from the
codebase. Match the existing shape unless the task needs something new.

## How to use this catalog

1. Find which part of the stack the task touches: app or route structure,
   templates, or client-side interactivity. Open the matching reference file.
2. Scan that file's headings for the entry closest to the task.
3. Follow the code shape shown. An Alternative approach section names a real
   tradeoff. Pick based on whether the project already depends on the library
   named, or whether the simple case applies.
4. "See entry N" points to a related pattern. Follow it when a task spans more
   than one file. An HTMX-loaded data fragment touches route design entry 19,
   HTMX entry 14, and HTMX entry 16 at once.

## Reference files

| File                                                     | Covers                                                                                                                                             |
| -------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| [references/flask.md](references/flask.md)               | App structure: blueprints, app factories, extension singletons, context processors, error handlers, route segments, config-before-import ordering. |
| [references/jinja2.md](references/jinja2.md)             | Templates: inheritance, includes, macros, comments, filters, url_for.                                                                              |
| [references/htmx.md](references/htmx.md)                 | Partial updates: load-triggered fetches, target and swap, fragment responses, cache headers.                                                       |
| [references/route-design.md](references/route-design.md) | Routes in a blueprint: resource naming, shell plus fragment splits, guard and abort, decorator guards.                                             |

Each file stands on its own. Open only the file relevant to the task.

For general Python backend patterns, use the `backend-python-patterns` skill.
It also defines how to read the Example, Source, and Notes labels. They have
the same meaning here.
