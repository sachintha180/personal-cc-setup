---
name: backend-fastapi-standards
description: Conventions for a layered FastAPI backend with SQLModel, Pydantic, and JWT cookie auth: routes, services, database layer, dependency injection, exceptions, schema naming, file placement. Use when asked to add a FastAPI route, service, SQLModel table, schema, or exception, or where a file goes.
---

# FastAPI layered backend

This skill defines the architecture and conventions of a layered FastAPI
backend. Code flows through three layers: routes, services, and a database
layer. Each layer has one job. The skill also covers route ordering, session
management, and JWT cookie authentication.

Stack-neutral Python rules live in the backend-python-patterns skill. Tests
live in the backend-fastapi-testing skill.

## Reference files

| File                                               | Load when                                                                                                      |
| -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| [references/standards.md](references/standards.md) | Writing or reviewing any route, service, database method, schema, dependency, or exception. Holds the rules.   |
| [references/examples.md](references/examples.md)   | Writing new code. Holds working code for each pattern: route, service, repository, schema, DI, exception.      |
| [references/files.md](references/files.md)         | Deciding where a file goes, or creating a new file or directory. Holds the directory tree and naming per file. |

## Core rules

- Declare every dependency as a function parameter. Do not use router-level
  dependencies.
- Every route sets an explicit `status_code`.
- Services raise domain exceptions from one central exceptions module. Routes
  never raise `HTTPException`.

## How to approach a task

1. Read `references/standards.md` for the rules that apply.
2. Find the matching pattern in `references/examples.md` and follow it.
3. Check `references/files.md` for where each new file goes.
4. Write routes, then services, then database methods, then exceptions.
5. Check the result against `references/standards.md` before handing it over.
