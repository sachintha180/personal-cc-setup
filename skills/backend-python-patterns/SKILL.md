---
name: backend-python-patterns
description: Framework-neutral Python backend patterns and conventions: strategy, registry, TTL cache, streaming, TypedDict, Enum, singleton clients, YAML env config, layering. Use for "cache this result", "stream this file", "load config from the environment", "where should this logic live".
---

# Python backend patterns

This is a pattern catalog for a layered Python backend. The patterns apply to
any web framework. Each entry names one recurring situation and shows the
standard code shape for it. Where a real tradeoff exists, the entry also names
a documented alternative with its own source. An entry with no alternative
already reflects the recommended approach. A different solution to a covered
problem still works, but it drifts from the codebase. Match the existing shape
unless the task needs something new.

For Flask routes, Jinja2 templates, and HTMX interactions, use the
`backend-flask-patterns` skill. For FastAPI-specific rules, such as exception
handling, dependency injection, and schema naming, use the
`backend-fastapi-standards` skill.

## How to use this catalog

1. Find which part of the backend the task touches: general structure,
   configuration or I/O, or code style. Open the matching reference file.
2. Scan that file's headings for the entry closest to the task.
3. Follow the code shape shown. An Alternative approach section names a real
   tradeoff. Pick based on whether the project already depends on the library
   named, or whether the simple case applies.
4. "See entry N" points to a related pattern. Follow it when a task spans more
   than one file.

## Reference files

| File                                                           | Covers                                                                                   |
| -------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| [references/design-patterns.md](references/design-patterns.md) | Strategy, registry, TTL caching, streaming generators, TypedDict, Enum, pure transforms. |
| [references/config-and-io.md](references/config-and-io.md)     | Singleton clients, flat-YAML environment config, range-request streaming.                |
| [references/conventions.md](references/conventions.md)         | Layers, typed schemas, enums, `os.getenv` config, imports, spacing, type safety.         |

Each file stands on its own. Open only the file relevant to the task.

## How to read an entry

- **Example:** a plausible file path that shows where this kind of code
  usually lives, such as `blueprints/the_cs_class/utils.py`. It is
  illustrative. It does not cite a line in a specific repository.
- **Source:** a citation to external documentation or a specification, used
  when a claim rests on that source.
- **Notes:** the reasoning behind the pattern. Read the notes before copying
  the code shape. They usually name the condition under which the pattern
  stops being the right choice.
