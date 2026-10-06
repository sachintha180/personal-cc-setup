# Standards

Rules for a layered FastAPI backend. Examples use the real domain names
`User`, `Product`, and `Auth`. Working code for each rule is in
[examples.md](examples.md). File placement is in [files.md](files.md).
Stack-neutral rules (layer separation, import order, code spacing, type hints)
are in the backend-python-patterns skill, `references/conventions.md`.

## Architecture

### Top-down development

Build every feature in this order:

1. Define routes with the service methods and schemas they need.
2. Implement the service methods with the database calls they need.
3. Implement only the database methods that a service calls.
4. Define the exceptions that services raise.

This order prevents unused code.

### Layer separation

| Layer    | Owns                                          | Does not own                  |
| -------- | --------------------------------------------- | ----------------------------- |
| Route    | Request, response, status codes, headers      | Business logic, data access   |
| Service  | Business logic, validation, exception raising | HTTP concerns, SQL statements |
| Database | Queries and data access                       | Business rules, HTTP concerns |

### Performance

- Consider query efficiency when writing a database method.
- Add indexes for columns that queries filter on.
- Avoid N+1 queries.

## Dependency injection

- Use the framework's dependency injection system.
- Declare every dependency as a function parameter with a type annotation.
- Do not use router-level or global dependencies. Do not write
  `APIRouter(dependencies=[Depends(...)])`. A router-level or global
  dependency does not inject its return value into the route function. This
  causes resolution conflicts and validation errors.
- Name an unused dependency parameter `_`. Example:
  `_: AuthenticatedUserDep` when authentication is required but the user
  object is not used.
- Do not name a dependency parameter and then leave it unused.
- Do not build bundled dependency factories. Each dependency returns one
  focused value. Example: `get_authenticated_user()` returns `User`. A
  function that returns a NamedTuple of user and session is not allowed.
- Define type aliases for dependencies, such as `UserServiceDep`,
  `DBSessionDep`, and `AuthenticatedUserDep`.

## Exception handling

- Routes never raise `HTTPException` or any other framework exception
  directly. Services raise all exceptions.
- Define every exception in one central exceptions module. Example:
  `custom_types/exceptions.py`.
- Each custom exception inherits from the framework HTTP exception and
  carries its own status code.
- Do not write `if not user: raise HTTPException(...)` in a route. Call a
  service that raises `UserNotFoundError`.
- Do not pass a detail string that matches the exception's default message.
  Write `raise UserNotFoundError`, not
  `raise UserNotFoundError("User not found")`.
- Pass a detail string only when the message differs from the default.
  Example: `raise UserNotFoundError("User with ID 123 not found")`.
- When a service wraps a lower-level failure, preserve the chain with
  `raise DatabaseError("Failed to update user") from e`.

## Session management

- Manage the session at the route handler level through dependency injection.
- Refresh the session after every CREATE and UPDATE to load database-generated
  fields.

## API design

### Explicit status codes

- Set `status_code` in the decorator of every route.
- Never rely on framework defaults.
- Use `status.HTTP_200_OK`, `status.HTTP_201_CREATED`, and
  `status.HTTP_204_NO_CONTENT` as the case requires.

### No unnecessary data returns

- Return only the data the client needs.
- Return 204 No Content when an operation needs no response data. Example:
  DELETE.
- Do not return success messages such as `{"message": "Operation successful"}`.
- Return data after registration or login, because the client needs it.

## Route organization

### Route ordering

- Define literal paths before parameterized paths in the same router.
- Order routes from most specific to least specific: `/specific-path`, then
  `/{parameter}`, then `/{param1}/{param2}`.
- Example: define `/all` before `/{product_id}`. Define `/me` before
  `/{user_id}`. Define `/search` before `/{id}`.
- The framework matches routes in order. A parameterized route that comes
  first treats "all" as a UUID. The result is a 422 error.
- When a literal route returns 422, check route ordering first.

### Route prefix and filename

| Item            | Form     | Example                              |
| --------------- | -------- | ------------------------------------ |
| Route file name | Singular | `routes/user.py`, `routes/lesson.py` |
| Router prefix   | Plural   | `/users`, `/lessons`, `/posts`       |

- A collective noun stays singular in both places. Example: `routes/auth.py`
  with `prefix="/auth"`.
- `routes/users.py` with `prefix="/users"` is wrong. The file name must be
  singular.
- `routes/user.py` with `prefix="/user"` is wrong. The prefix must be plural.

## Naming

### Route schemas

Pattern: `<Service><Method><Request|Response>`.

| Part    | Rule                                                                                                         |
| ------- | ------------------------------------------------------------------------------------------------------------ |
| Service | The route prefix, capitalized and singular. `/auth` gives `Auth`. `/users` gives `User`.                     |
| Method  | The HTTP verb, capitalized. GET gives `Get`. POST gives `Post`. PATCH gives `Update`. DELETE gives `Delete`. |
| Type    | `Request` for a request body. `Response` for a response.                                                     |

Correct examples:

- `/auth/login` POST: `AuthLoginRequest`, `AuthLoginResponse`
- `/auth/register` POST: `AuthRegisterRequest`, `AuthRegisterResponse`
- `/users/{user_id}` GET: `UserGetResponse`
- `/users/{user_id}` PATCH: `UserUpdateRequest`, `UserUpdateResponse`

Wrong examples:

- `GetUserResponse` has the wrong order.
- `LoginRequest` has no service prefix.

### Request and Response suffix

- Every route data schema ends in `Request` or `Response`. `AuthLogin` and
  `UserUpdate` are wrong.
- A nested schema used inside a response needs no suffix. Example:
  `AuthVerifyUser`.
- An internal schema, one that is not tied to a route, gets a descriptive name
  with no service prefix. Example: `TokenPayload` in `auth.py`, not
  `AuthTokenPayload`.

### Parameters

Use a descriptive prefix on every parameter. Generic names such as `service`,
`session`, and `data` are not allowed. Apply this in routes, services, and the
database layer.

| Parameter          | Name                                                                                            |
| ------------------ | ----------------------------------------------------------------------------------------------- |
| Service dependency | `auth_service: AuthServiceDep`, `user_service: UserServiceDep`                                  |
| Database session   | `db_session: DBSessionDep` in routes. `db_session: Session` in services and the database layer. |
| Request body       | `request_data: AuthLoginRequest`, `user_data: UserUpdateRequest`                                |
| Request object     | `request: Request`                                                                              |
| Response object    | `response: Response`                                                                            |

### Classes

| Kind           | Pattern            | Example                           |
| -------------- | ------------------ | --------------------------------- |
| Service class  | `{Domain}Service`  | `UserService`, `AuthService`      |
| Database class | `{Domain}Database` | `UserDatabase`, `ProductDatabase` |
| Model class    | The domain name    | `User`, `Product`, `Order`        |

## Edge cases

- Implement edge cases as needed.
- Do not over-engineer for hypothetical scenarios.
