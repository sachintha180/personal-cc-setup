# Coding Standards and Style Guide

## Code Formatting

### Code Spacing

**Rule:** There must be one blank line ALWAYS between the method body and the return statement. The remaining blocks of code must be spaced out semantically.

**Example:**

```python
# Good
def example_function():
    # Method body logic
    result = some_operation()

    return result

# Bad - no blank line before return
def example_function():
    result = some_operation()
    return result

# Good - semantic spacing
def complex_function():
    # First logical block
    user = get_user()

    # Second logical block
    if user:
        process_user(user)

    # Return statement
    return user
```

**Implementation:**

- Always have one blank line before `return` statement
- Group related code blocks together
- Separate logical sections with blank lines
- Maintain consistent spacing throughout the codebase

## Naming Conventions

### Schema Naming Convention

**Rule:** Route schemas must follow the pattern `<Service><Method><Request/Response>`. The service name comes from the route prefix, the method is the HTTP verb (capitalized), and it ends with Request or Response. Internal/non-route schemas in the same file should be given descriptive names without service prefix.

**Pattern:** `<Service><Method><Request/Response>`

- **Service:** Route prefix capitalized (`/auth` -> `Auth`, `/users` -> `User`)
- **Method:** HTTP verb capitalized (`GET` -> `Get`, `POST` -> `Post`, `PATCH` -> `Update`, `DELETE` -> `Delete`)
- **Type:** `Request` for request bodies, `Response` for responses

**Examples:**

- `/auth/login` POST -> `AuthLoginRequest`, `AuthLoginResponse`
- `/auth/register` POST -> `AuthRegisterRequest`, `AuthRegisterResponse`
- `/users/{user_id}` GET -> `UserGetResponse`
- `/users/{user_id}` PATCH -> `UserUpdateRequest`, `UserUpdateResponse`
- Internal schema in `auth.py` -> `TokenPayload` (not `AuthTokenPayload`)

**Bad Examples:**

- `/users/{user_id}` GET -> `GetUserResponse` (wrong order)
- `/auth/login` -> `LoginRequest` (missing service prefix)

**Implementation:**

- Internal/non-route schemas get descriptive names without service prefix
- Keep schemas organized by route group in schema files

### Request/Response Suffix

**Rule:** All route data schemas MUST be suffixed with `Request` or `Response` respectively.

**Examples:**

- **Good:** `AuthLoginRequest`, `AuthLoginResponse`
- **Good:** `UserUpdateRequest`, `UserGetResponse`
- **Bad:** `AuthLogin`, `UserUpdate` (without suffix)

**Implementation:**

- Request schemas: `{RouteName}Request` (e.g., `AuthRegisterRequest`)
- Response schemas: `{RouteName}Response` (e.g., `AuthRegisterResponse`)
- Nested schemas used within responses don't need Request/Response suffix (e.g., `AuthVerifyUser`)

### Parameter Naming Convention

**Rule:** Parameters must be prefixed with appropriate names suiting their use case. Generic names like `service` or `session` are not allowed. This applies to all layers: routes, services, and database.

**Examples:**

- **Good:** `auth_service: AuthServiceDep`, `user_service: UserServiceDep`
- **Good:** `db_session: DBSessionDep` (in routes)
- **Good:** `db_session: Session` (in services and database layer)
- **Good:** `request_data: AuthLoginRequest`
- **Bad:** `service: AuthServiceDep` (too generic)
- **Bad:** `session: DBSessionDep` or `session: Session` (too generic, must be `db_session`)
- **Bad:** `data: AuthLoginRequest` (too generic)

**Implementation:**

- Service dependencies: Prefix with service type (`auth_service`, `user_service`)
- Database session: **Always** prefix with `db_` (`db_session`) in routes, services, and database layer
- Request data: Use descriptive name (`request_data`, `user_data`)
- Request object: Use `request: Request`
- Response object: Use `response: Response`
- All parameters should clearly indicate their purpose and type
- Consistency across all layers: routes, services, and database must all use `db_session` for database session parameters

### Class Naming Conventions

**Rule:** Follow consistent naming patterns for classes across the application.

**Patterns:**

- Service classes: `{Domain}Service` (e.g., `UserService`, `AuthService`)
- Repository/Database classes: `{Domain}Database` (e.g., `UserDatabase`, `ProductDatabase`)
- Model classes: Use domain names (e.g., `User`, `Product`, `Order`)

## Import Organization

### Import Placement

**Rule:** All imports MUST be at the top of the file. No importing in the middle of code unless it breaks the program due to circular imports.

**Examples:**

- **Good:** All imports at top of file
- **Bad:** `from fastapi import HTTPException` inside a function
- **Bad:** `import os` in the middle of a class method

**Implementation:**

- All imports go at the top of the file
- Group imports: standard library, third-party, local imports
- Only exception: circular import issues that genuinely break the program

**Example:**

```python
# Standard library imports
from typing import Optional, List
from uuid import UUID
from datetime import datetime

# Third-party imports
from fastapi import APIRouter, status
from sqlmodel import Session, select
from pydantic import BaseModel, EmailStr

# Local imports
from models import User
from schemas.user import UserUpdateRequest
from database.user import UserDatabase
from custom_types.exceptions import UserNotFoundError
```

## Route Organization

### Route Ordering

**Rule:** Specific routes (literal paths) **MUST** be defined before parameterized routes (path parameters) in the same router. Web frameworks match routes in order, and if a parameterized route comes first, it will try to match specific paths as parameters, causing validation errors.

**Examples:**

- **Good:** `/all` route defined before `/{product_id}` route
- **Good:** `/search` route defined before `/{id}` route
- **Good:** `/me` route defined before `/{user_id}` route
- **Bad:** `/{product_id}` route defined before `/all` route - framework tries to parse "all" as UUID -> 422 error
- **Bad:** `/{id}` route defined before `/search` route - framework tries to parse "search" as parameter -> validation error

**Implementation:**

- Always define specific/literal routes before parameterized routes
- Order routes from most specific to least specific
- Pattern: `/specific-path` -> `/{parameter}` -> `/{param1}/{param2}`
- If you get 422 validation errors on specific routes, check route ordering first

### Route Prefix and Filename Consistency

**Rule:** Route file names should be singular (e.g., `user.py`), while the router prefix must be plural (e.g., `/users`). This follows REST API conventions where endpoints are pluralized.

**Examples:**

- **Good:** File `routes/user.py` with `prefix="/users"`
- **Good:** File `routes/auth.py` with `prefix="/auth"` (auth is already a collective noun)
- **Good:** File `routes/lesson.py` with `prefix="/lessons"`
- **Bad:** File `routes/users.py` with `prefix="/users"` (filename should be singular)
- **Bad:** File `routes/user.py` with `prefix="/user"` (prefix should be plural)

**Implementation:**

- Route files use singular nouns: `user.py`, `lesson.py`, `post.py`
- Router prefixes use plural nouns: `/users`, `/lessons`, `/posts`
- Exceptions: collective nouns like `auth` remain singular in both filename and prefix

## Exception Handling Standards

### No HTTPExceptions in Routes

**Rule:** Routes must not directly raise HTTPExceptions. All complex business logic and exception handling must be handled in services. All exceptions must be defined in a centralized exceptions module (e.g., `custom_types/exceptions.py`).

**Examples:**

- **Good:** Route calls `auth_service.verify_authentication()` which raises `NotAuthenticatedError`
- **Good:** Route calls `user_service.get_user_by_id()` which raises `UserNotFoundError` if user doesn't exist
- **Bad:** Route directly raises `HTTPException(status_code=401, detail="Not authenticated")`
- **Bad:** Route contains `if not user: raise HTTPException(status_code=404, detail="User not found")`

**Implementation:**

- Routes should be thin - they call services and return responses
- Services contain all business logic and raise appropriate exceptions
- All custom exceptions inherit from framework HTTP exceptions and are defined in a centralized exceptions module

### Exception Detail Messages

**Rule:** Do not pass detail strings to exceptions if they match the default message defined in the exception class. Only pass a detail parameter when you need a custom message that differs from the default.

**Examples:**

- **Good:** `raise UserNotFoundError()` when the default message "User not found" is appropriate
- **Good:** `raise UserNotFoundError("User with ID 123 not found")` when a more specific message is needed
- **Bad:** `raise UserNotFoundError("User not found")` when it matches the default exactly

**Implementation:**

- Check the exception class definition for the default detail message
- Only pass a `detail` parameter if you need a message that differs from the default

## API Design Standards

### No Unnecessary Data Returns

**Rule:** Routes should not return unnecessary data. Only return data that is absolutely necessary for the client.

**Examples:**

- **Good:** Return user data after registration/login (necessary)
- **Good:** No return body for DELETE operations (204 No Content)
- **Bad:** Return success messages like `{"message": "Operation successful"}`

**Implementation:**

- If an operation succeeds but doesn't need to return data, use `204 No Content` status code
- Only return data that the frontend/client actually needs

### Explicit Status Codes

**Rule:** All routes must have an explicit status code defined.

**Examples:**

- **Good:** `status_code=status.HTTP_200_OK`
- **Good:** `status_code=status.HTTP_201_CREATED`
- **Good:** `status_code=status.HTTP_204_NO_CONTENT`
- **Bad:** Relying on framework defaults without explicit declaration

**Implementation:**

- Always include `status_code` parameter in route decorator
- Use appropriate HTTP status codes for each operation

## Dependency Injection Standards

### No Router-Level Dependencies

**Rule:** Router-level dependencies (`dependencies=[Depends(...)]` in router configuration) **MUST NOT** be used. Router-level dependencies do not inject return values into route functions, which causes dependency resolution conflicts and validation errors.

**Examples:**

- **Good:** All dependencies declared as function parameters: `def route(authenticated_user: AuthenticatedUserDep, service: ServiceDep)`
- **Good:** Unused dependencies replaced with underscore: `def route(_: AuthenticatedUserDep, service: ServiceDep)` when authentication is needed but user object isn't used
- **Bad:** `router = APIRouter(dependencies=[Depends(get_authenticated_user)])` - return value not injected
- **Bad:** `def route(authenticated_user: AuthenticatedUserDep, ...)` when `authenticated_user` is never used in the function body (should be `_: AuthenticatedUserDep`)

**Implementation:**

- **Never** use `dependencies` parameter in router constructor
- Always declare dependencies as function parameters in route handlers
- If a dependency is required for side effects but its return value is not used, replace the parameter name with underscore: `_: AuthenticatedUserDep`

### No Bundled Dependency Factories

**Rule:** Don't build any bundled dependency factories. Use individual dependencies instead.

**Examples:**

- **Good:** `get_current_user()` dependency that returns `User`
- **Good:** Routes use `current_user: CurrentUserDep` and `session: DBSessionDep` separately
- **Bad:** `get_authenticated_context()` that returns a NamedTuple with both user and session

**Implementation:**

- Each dependency should return a single, focused value
- Avoid creating wrapper dependencies that bundle multiple values

## Documentation Standards

### Docstrings

**Rule:** All classes and methods must have single-line docstrings.

**Example:**

```python
class UserService:
    """Service for user-related business logic."""

    def get_user_by_id(self, db_session: Session, user_id: UUID) -> User:
        """Get a user by ID."""
        pass
```

### Comments

**Rule:** Use "NOTE:" comments for important implementation details. Include inline comments for complex logic. Document cascade delete behaviors and architectural decisions.

**Example:**

```python
# NOTE: If you use sa_column here, created_at/updated_at columns will be instantiated and
#       then SQLAlchemy will try to set the same column to several tables which is not allowed.
class TimestampedModel(SQLModel):
    pass
```

## See Also

- `examples.md` - Code examples demonstrating these standards in practice
- `developer.md` - Developer persona and workflow
- `files.md` - Recommended file structure and organization
