# Conventions

This file lists stack-neutral rules for a layered Python backend.

## Layer separation

A backend has three layers. Each layer has one job.

| Layer                  | Job                                                             |
| ---------------------- | --------------------------------------------------------------- |
| Routes or controllers  | Handle HTTP concerns: request, response, status codes, headers. |
| Services               | Hold business logic and validation.                             |
| Database or repository | Handle data access only.                                        |

Rules:

- Never mix concerns between layers.
- Routes call services. Services call the database layer.
- Keep protocol-specific error handling out of the logic layer.
- Build a feature top-down. Write the route first with hypothetical service
  calls. Then write the service with hypothetical database calls. Then write
  only the database methods that the service needs.
- Pass the database session as a parameter to every method that needs it.

Suggested layout:

| Directory   | Holds                                                      |
| ----------- | ---------------------------------------------------------- |
| `routes/`   | One file per resource.                                     |
| `services/` | One service class per domain.                              |
| `database/` | One data-access class per entity.                          |
| `config/`   | One file per concern, such as auth, database, environment. |

## Typed schemas

Define the shape of data in a schema class. See entry 5 in
`design-patterns.md` for the `TypedDict` tradeoff against `pydantic`.

- Give every schema a descriptive name.
- Prefix parameters with their purpose. Do not use generic names such as
  `service`, `session`, or `data`.
- For FastAPI naming rules, see the `backend-fastapi-standards` skill.

## Enums

Use an `Enum` for every closed set of values. See entry 6 in
`design-patterns.md`.

- Keep enums in one central module. Example: `custom_types/enums.py` with
  `UserType`, `Status`, `FileType`.

## Config via os.getenv with defaults

Read configuration from environment variables with `os.getenv()`. Give every
variable a sensible default.

```python
PORT = int(os.getenv("PORT", "8000"))
CORS_ORIGINS = os.getenv("CORS_ORIGINS", "http://localhost:3000").split(",")
```

- Keep one config file per concern. Example: `auth.py` for token secrets and
  expiry, `database.py` for connection strings, `environment.py` for CORS
  origins and port.
- See entry 9 in `config-and-io.md` for loading a flat YAML file into
  `os.environ`.

## Import organization

Place all imports at the top of the file. The only exception is an import that
breaks the program through a circular import.

Group imports in this order, with one blank line between groups:

1. Standard library.
2. Third-party packages.
3. Local modules.

```python
from datetime import datetime
from typing import Optional
from uuid import UUID

from pydantic import BaseModel, EmailStr

from models import User
from schemas.user import UserUpdateRequest
```

## Code spacing

Put one blank line between the body of a function and its `return` statement.
Separate other blocks by meaning, one blank line each.

```python
def get_user_name(user_id: UUID) -> str:
    user = get_user(user_id)
    name = user.name.strip()

    return name
```

## Type safety

Use full type hints.

- Type every function parameter and return value.
- Use `Optional` for nullable values and a typed collection for lists and
  dictionaries.
- Use an `Enum` or a custom type for a restricted set of values.
