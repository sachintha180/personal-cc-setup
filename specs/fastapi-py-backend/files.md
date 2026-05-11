# Recommended File Structure

## Complete Directory Tree

```
backend/
├── .git/                    # Git version control
├── .venv/                   # Python virtual environment
├── __pycache__/             # Python bytecode cache
├── api/                     # API-level dependencies and utilities
├── config/                  # Configuration files (auth, database, environment)
├── custom_types/            # Custom type definitions (enums, exceptions, dependencies)
├── data/                    # Data storage (database files)
├── database/                # Database access layer (CRUD operations)
├── routes/                  # API route definitions
├── schemas/                 # Request/response validation schemas
├── services/                # Business logic layer
├── app.py                   # Main application entry point
├── models.py                # Database model definitions
├── requirements.txt         # Python dependencies
├── .python-version          # Python version specification
└── .gitignore               # Git ignore rules
```

## Root Directory Files

- **`app.py`** - Main application entry point. Configures the web framework, middleware, CORS, and registers routers.
- **`models.py`** - Database model definitions (ORM models). Contains all database models and base classes.
- **`requirements.txt`** - Python package dependencies. Lists all third-party packages required for the project.
- **`.python-version`** - Python version specification (if using pyenv or similar version managers).
- **`.gitignore`** - Git ignore rules for excluding build artifacts, virtual environments, database files, etc.

## `/api` Directory

**Purpose:** API-level dependency injection and shared API concerns.

- **`dependencies.py`** - API-level dependency injection functions. Centralizes dependency factories for database sessions, services, and authentication.

**Note:** This directory is optional if your framework handles dependencies differently. Use when you need centralized dependency management at the API layer.

## `/config` Directory

**Purpose:** Application configuration and environment settings.

- **`auth.py`** - Authentication configuration (JWT secrets, token expiration, cookie settings).
- **`database.py`** - Database configuration (connection strings, engine setup, session management).
- **`environment.py`** - Environment variable management (CORS origins, port, reload settings, environment detection).

**Pattern:** Each configuration file handles a specific concern. Use `os.getenv()` with sensible defaults.

## `/custom_types` Directory

**Purpose:** Custom type definitions, enums, and shared type utilities.

- **`dependencies.py`** - Custom dependency type aliases (e.g., `UserServiceDep`, `DBSessionDep`, `AuthenticatedUserDep`).
- **`enums.py`** - Enumeration type definitions (e.g., `UserType`, `Status`, `FileType`).
- **`exceptions.py`** - Custom exception classes inheriting from framework HTTP exceptions.

**Pattern:** Centralize all custom types, enums, and exceptions for consistency and reusability.

## `/data` Directory

**Purpose:** Data storage (database files, static data, etc.).

- **`*.db`** - Database files (SQLite, etc.). Add to `.gitignore` for production databases.
- Other data files as needed.

**Note:** This directory may not be needed if using external database services or cloud storage.

## `/database` Directory

**Purpose:** Repository/Data Access Layer. Encapsulates all database operations.

- **`{domain}.py`** - Domain-specific database operations (e.g., `user.py`, `product.py`, `order.py`).
- Each file contains a repository class (e.g., `UserDatabase`, `ProductDatabase`, `OrderDatabase`) with CRUD methods.

**Pattern:**

- One file per domain/entity
- Class-based repositories: `{Domain}Database`
- Methods receive `db_session` as first parameter
- All database queries and operations are encapsulated here

**Example Structure:**

```
/database
  - user.py          # UserDatabase class
  - product.py       # ProductDatabase class
  - order.py         # OrderDatabase class
```

## `/routes` Directory

**Purpose:** API route definitions (HTTP endpoints).

- **`__init__.py`** - Route module initialization. Aggregates all routers and exports the main API router.
- **`{domain}.py`** - Domain-specific routes (e.g., `auth.py`, `user.py`, `product.py`).

**Pattern:**

- One file per domain/resource
- File names are singular (e.g., `user.py`)
- Router prefixes are plural (e.g., `/users`)
- Each file defines an `APIRouter` with routes for that domain

**Example Structure:**

```
/routes
  - __init__.py      # Router aggregation
  - auth.py          # Authentication routes (prefix: /auth)
  - user.py          # User routes (prefix: /users)
  - product.py       # Product routes (prefix: /products)
```

## `/schemas` Directory

**Purpose:** Request/response validation schemas (Pydantic models).

- **`{domain}.py`** - Domain-specific schemas (e.g., `auth.py`, `user.py`, `product.py`).

**Pattern:**

- One file per domain, matching route structure
- Request schemas: `{Service}{Method}Request`
- Response schemas: `{Service}{Method}Response`
- Internal schemas use descriptive names without service prefix

**Example Structure:**

```
/schemas
  - auth.py          # AuthLoginRequest, AuthRegisterResponse, etc.
  - user.py          # UserGetResponse, UserUpdateRequest, etc.
  - product.py       # ProductCreateRequest, ProductListResponse, etc.
```

## `/services` Directory

**Purpose:** Business logic layer. Contains all business rules and orchestration.

- **`{domain}.py`** - Domain-specific business logic (e.g., `auth.py`, `user.py`, `product.py`).
- **`{utility}.py`** - Utility services (e.g., `password.py` for password hashing, `email.py` for email sending).

**Pattern:**

- One file per domain
- Class-based services: `{Domain}Service`
- Methods receive `db_session` and call database layer
- All business logic, validation, and exception raising happens here
- Routes call services, services call database layer

**Example Structure:**

```
/services
  - auth.py          # AuthService class
  - user.py          # UserService class
  - product.py       # ProductService class
  - password.py      # PasswordService utility class
  - email.py         # EmailService utility class
```

## File Naming Conventions

- **Route files:** Singular (`user.py`, `product.py`)
- **Router prefixes:** Plural (`/users`, `/products`)
- **Service classes:** `{Domain}Service` (e.g., `UserService`)
- **Database classes:** `{Domain}Database` (e.g., `UserDatabase`)
- **Schema files:** Match route file names for consistency

## See Also

- `standards.md` - Coding standards and conventions
- `developer.md` - Developer persona and workflow
- `examples.md` - Code examples demonstrating patterns