---
name: backend-fastapi-testing
description: Rules and patterns for Pytest integration tests of a layered FastAPI backend: fixtures, test client, dependency overrides, auth, database cleanup, reference data, parametrization. Use when asked to write a test, add a fixture, test this endpoint, write pytest for FastAPI, or clean up test data.
---

# FastAPI Pytest testing

This skill holds the rules and patterns for tests of a layered FastAPI
backend. Tests call real API endpoints through the test client. Tests do not
mock and do not call services directly. The skill also covers test naming and
error scenario tests.

The application build rules live in the `backend-fastapi-standards` skill.

## Reference files

| File                                                       | Load it when                                                                                                                                                                   |
| ---------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [references/testing-rules.md](references/testing-rules.md) | You must decide how to test: approach, organization, fixtures, client setup, cleanup, reference data, parametrization, naming, isolation, and the strict rules and guidelines. |
| [references/test-examples.md](references/test-examples.md) | You must write test code: directory structure, fixture composition, authentication, cleanup, parametrization, reference data, assertions, error tests, and end-to-end tests.   |

Load `testing-rules.md` first. Load `test-examples.md` when you write code.
