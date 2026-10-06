# Testing rules

Rules for Pytest tests of a layered FastAPI backend. Code patterns for each
rule are in `references/test-examples.md`.

## Techniques

### Test the real API

Write tests that verify actual API behavior. Do not test implementation
details. Each test exercises the full request-response cycle through a real
endpoint. Use the test client to make HTTP requests.

- Do not call services or the database directly in place of the API.
- Do not mock HTTP requests or responses.
- Do not bypass the API layer for speed or simplicity.
- Prefer integration tests over unit tests.
- Verify transaction safety.

### Organize tests

Organize tests by feature domain. Each test file covers one area. Group
related tests into test classes. Use descriptive test names.

The recommended directory structure is in `references/test-examples.md`.

### Manage fixtures

- Place all shared fixtures in `conftest.py`. Pytest discovers them
  automatically.
- Place a fixture used by one file in that file.
- Choose a scope: `function`, `class`, `module`, or `session`.
- Compose fixtures from other fixtures.
- Make each fixture clean up after itself, especially database state.
- Provide fixtures in these categories:
  - Database fixtures: a test database session with cleanup.
  - Client fixtures: a test client with dependency overrides.
  - Authentication fixtures: user registration, login, and an authenticated
    client.
  - Data fixtures: test data generators and reference data loaders.
  - Domain fixtures: domain-specific setup.

### Generate test data

- Use fixtures or test data files. Do not hardcode test data.
- Generate unique values, such as emails and IDs. Unique values prevent
  conflicts between test runs.

### Configure the test client

- Override dependencies on the application. Override the database session
  first.
- Point the test client at the test database. Never point it at the
  production database.
- Set authentication cookies or tokens on the client instance.
- Clear the overrides after each test.

### Clean up the database

- Clean up completely between tests.
- Delete records in reverse dependency order. Delete child records before
  parent records.
- Put the cleanup in fixture teardown. Teardown runs even when the test fails.
- A database transaction that rolls back automatically is an acceptable
  strategy.

### Use reference data

- Use a reference data file when an operation gives deterministic results.
- Load the reference data from a JSON file or a fixture.
- Compare actual results against the reference data.
- For non-deterministic values such as timestamps and IDs, verify structure
  and relationships. Do not compare exact values.
- Document any expected variations.

### Parametrize dynamically

- Use the `pytest_generate_tests` hook.
- Generate parameters from fixtures, files, or computed values.
- Do not hardcode parameter lists. The tests then adapt to the available test
  data.

### Authenticate in tests

- Handle authentication in fixtures.
- Create a reusable fixture for an authenticated user.
- Set the cookie or header directly on the test client instance.
- Do not repeat authentication logic in tests.

### Name tests

Use the pattern `test_<action>_<condition>_<expected_result>`. Use
underscores. Do not use abbreviations unless everyone knows them.

Examples:

- `test_create_game_succeeds_with_valid_data`
- `test_create_game_fails_when_active_game_exists`
- `test_rollback_restores_previous_state`

### Isolate tests

- Each test runs alone.
- No test depends on execution order or on the state of another test.
- Fixtures set up the required state.
- Each test cleans up all state changes.

### Write clear assertions

- Use descriptive assertions.
- Add an error message when it helps.
- Verify positive and negative conditions.
- Check the status code, the response body, and the database state as needed.

### Test scenarios and error conditions

- Cover happy path, error conditions, edge cases, state transitions,
  concurrent operations, and boundary conditions.
- Verify that the correct error status code returns.
- Check that error messages are meaningful.
- Test invalid inputs.

## Guidelines

- Cover all API endpoints. Test success paths and failure paths.
- Choose fixture scopes that reduce setup cost. Batch operations when the test
  stays clear.
- Move shared test logic into helper functions or fixtures.
