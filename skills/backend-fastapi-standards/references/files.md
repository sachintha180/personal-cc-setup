# File structure

This file defines where each file goes. Rules for the code inside the files
are in [standards.md](standards.md). Code for each pattern is in
[examples.md](examples.md). Naming rules for routes, schemas, and classes are
in `standards.md`, section Naming.

## Complete directory tree

```
backend/
|-- .git/                    # Git version control
|-- .venv/                   # Python virtual environment
|-- __pycache__/             # Python bytecode cache
|-- api/                     # API-level dependencies and utilities
|-- config/                  # Configuration files (auth, database, environment)
|-- custom_types/            # Custom type definitions (enums, exceptions, dependencies)
|-- data/                    # Data storage (database files)
|-- database/                # Database access layer (CRUD operations)
|-- routes/                  # API route definitions
|-- schemas/                 # Request/response validation schemas
|-- services/                # Business logic layer
|-- app.py                   # Main application entry point
|-- models.py                # Database model definitions
|-- requirements.txt         # Python dependencies
|-- .python-version          # Python version specification
`-- .gitignore               # Git ignore rules
```

## Root directory files

- **`app.py`**: Main application entry point. Configures the web framework,
  middleware, and CORS. Registers routers.
- **`models.py`**: Database model definitions (ORM models). Holds all database
  models and base classes.
- **`requirements.txt`**: Python package dependencies. Lists all third-party
  packages.
- **`.python-version`**: Python version specification. Use it with pyenv or a
  similar version manager.
- **`.gitignore`**: Git ignore rules. Excludes build artifacts, virtual
  environments, and database files.

## `/api` directory

Purpose: API-level dependency injection and shared API concerns.

- **`dependencies.py`**: API-level dependency injection functions.
  Centralizes dependency factories for database sessions, services, and
  authentication.

This directory is optional when the framework handles dependencies
differently. Use it for centralized dependency management at the API layer.

## `/config` directory

Purpose: Application configuration and environment settings.

- **`auth.py`**: Authentication configuration. JWT secrets, token expiration,
  cookie settings.
- **`database.py`**: Database configuration. Connection strings, engine setup,
  session management.
- **`environment.py`**: Environment variable management. CORS origins, port,
  reload settings, environment detection.

Pattern: Each configuration file handles one concern. Use `os.getenv()` with
sensible defaults.

## `/custom_types` directory

Purpose: Custom type definitions, enums, and shared type utilities.

- **`dependencies.py`**: Dependency type aliases. Example: `UserServiceDep`,
  `DBSessionDep`, `AuthenticatedUserDep`.
- **`enums.py`**: Enumeration types. Example: `UserType`, `Status`, `FileType`.
- **`exceptions.py`**: Custom exception classes that inherit from framework
  HTTP exceptions.

Pattern: Centralize all custom types, enums, and exceptions.

## `/data` directory

Purpose: Data storage. Database files and static data.

- **`*.db`**: Database files such as SQLite. Add production databases to
  `.gitignore`.
- Other data files as needed.

This directory is not needed when the project uses an external database
service or cloud storage.

## `/database` directory

Purpose: Repository and data access layer. Encapsulates all database operations.

- **`{domain}.py`**: Domain-specific database operations. Example: `user.py`,
  `product.py`, `order.py`.
- Each file holds one repository class with CRUD methods. Example:
  `UserDatabase`, `ProductDatabase`, `OrderDatabase`.

Pattern:

- One file per domain or entity.
- Methods receive `db_session` as the first parameter.
- All database queries and operations live here.

Example:

```
/database
  |-- user.py          # UserDatabase class
  |-- product.py       # ProductDatabase class
  `-- order.py         # OrderDatabase class
```

## `/routes` directory

Purpose: API route definitions (HTTP endpoints).

- **`__init__.py`**: Route module initialization. Aggregates all routers and
  exports the main API router.
- **`{domain}.py`**: Domain-specific routes. Example: `auth.py`, `user.py`,
  `product.py`.

Pattern:

- One file per domain or resource.
- Each file defines one `APIRouter` with the routes for that domain.

Example:

```
/routes
  |-- __init__.py      # Router aggregation
  |-- auth.py          # Authentication routes (prefix: /auth)
  |-- user.py          # User routes (prefix: /users)
  `-- product.py       # Product routes (prefix: /products)
```

## `/schemas` directory

Purpose: Request and response validation schemas (Pydantic models).

- **`{domain}.py`**: Domain-specific schemas. Example: `auth.py`, `user.py`,
  `product.py`.

Pattern: one file per route group. The file names match the route files.

Example:

```
/schemas
  |-- auth.py          # AuthLoginRequest, AuthRegisterResponse, etc.
  |-- user.py          # UserGetResponse, UserUpdateRequest, etc.
  `-- product.py       # ProductCreateRequest, ProductListResponse, etc.
```

## `/services` directory

Purpose: Business logic layer. Holds all business rules and orchestration.

- **`{domain}.py`**: Domain-specific business logic. Example: `auth.py`,
  `user.py`, `product.py`.
- **`{utility}.py`**: Utility services. Example: `password.py` for password
  hashing, `email.py` for email sending.

Pattern:

- One file per domain.
- Methods receive `db_session` and call the database layer.
- All business logic, validation, and exception raising happens here.

Example:

```
/services
  |-- auth.py          # AuthService class
  |-- user.py          # UserService class
  |-- product.py       # ProductService class
  |-- password.py      # PasswordService utility class
  `-- email.py         # EmailService utility class
```
