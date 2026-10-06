# Test examples

The examples use generic domain names. Replace them with the project's
entities. Keep the same structure. Rules behind these patterns are in
`references/testing-rules.md`.

## Test directory structure

Example: a test suite for a game backend.

```
tests/
|-- conftest.py          # Shared fixtures
|-- test_auth.py         # Authentication tests
|-- test_game_setup.py   # Game creation tests
|-- test_gameplay.py     # Gameplay loop tests
`-- test_errors.py       # Error handling tests
```

## Fixture composition

The database session, the test client with a dependency override, and a
domain fixture are composed together.

Example: `tests/conftest.py`.

```python
import pytest
from fastapi.testclient import TestClient

from app import app
from config.database import get_db_session


@pytest.fixture(scope="function")
def test_db_session():
    session = create_test_session()
    yield session
    cleanup_database(session)


@pytest.fixture(scope="function")
def test_client(test_db_session):
    def override_get_db():
        yield test_db_session

    app.dependency_overrides[get_db_session] = override_get_db
    client = TestClient(app)
    yield client
    app.dependency_overrides.clear()


@pytest.fixture(scope="function")
def registered_user(test_db_session, test_client):
    response = test_client.post("/api/auth/register", json=user_data)
    assert response.status_code == 201

    return response.json()["user"]
```

## Authentication fixture

```python
@pytest.fixture(scope="function")
def authenticated_client(test_client, registered_user):
    login_response = test_client.post("/api/auth/login", json=login_data)
    assert login_response.status_code == 200

    token = login_response.json()["token"]
    test_client.cookies[SESSION_COOKIE_NAME] = token

    return test_client
```

## Database cleanup

```python
@pytest.fixture(scope="function")
def test_db_session():
    session = create_test_session()
    yield session
    # Reverse dependency order: child rows reference parent rows
    session.query(ChildModel).delete()
    session.query(ParentModel).delete()
    session.commit()
```

## Dynamic parametrization

```python
def pytest_generate_tests(metafunc):
    if "test_case" in metafunc.fixturenames:
        test_cases = load_test_cases_from_file("test_data.json")
        metafunc.parametrize("test_case", test_cases)


def test_operation_with_multiple_cases(test_client, test_case):
    response = test_client.post("/api/operation", json=test_case["input"])

    assert response.status_code == test_case["expected_status"]
    assert response.json() == test_case["expected_output"]
```

## Reference data comparison

```python
@pytest.fixture(scope="module")
def reference_data():
    with open("tests/fixtures/reference/expected_output.json") as f:
        return json.load(f)


def test_complex_operation_matches_reference(test_client, reference_data):
    result = []
    for input_data in reference_data["inputs"]:
        response = test_client.post("/api/operation", json=input_data)
        assert response.status_code == 200
        result.append(response.json())

    for actual, expected in zip(result, reference_data["outputs"]):
        # IDs differ per run, so check presence only
        assert actual["id"] is not None
        assert actual["computed_value"] == expected["computed_value"]
```

## Basic test structure

```python
class TestFeature:
    def test_basic_operation_succeeds(self, test_client, authenticated_client):
        response = test_client.post("/api/feature", json=valid_data)

        assert response.status_code == 201
        data = response.json()
        assert data["id"] is not None
        assert data["status"] == "active"

    def test_operation_fails_with_invalid_data(self, test_client):
        response = test_client.post("/api/feature", json=invalid_data)

        assert response.status_code == 400
        assert "validation" in response.json()["detail"].lower()
```

## Assertion patterns

```python
def test_operation_creates_resource(test_client, authenticated_client):
    response = test_client.post("/api/resources", json=resource_data)

    assert response.status_code == 201

    data = response.json()
    assert data["resource"]["id"] is not None
    assert data["resource"]["status"] == "active"
```

## State verification

```python
def test_operation_updates_database_state(test_client, test_db_session, authenticated_client):
    initial_count = test_db_session.query(Resource).count()

    response = test_client.post("/api/resources", json=resource_data)
    assert response.status_code == 201

    final_count = test_db_session.query(Resource).count()
    assert final_count == initial_count + 1

    created_resource = test_db_session.query(Resource).filter_by(
        id=response.json()["id"]
    ).first()
    assert created_resource is not None
    assert created_resource.status == "active"
```

## Error scenario testing

```python
def test_operation_handles_error_conditions(test_client, authenticated_client):
    response = test_client.get("/api/resources/nonexistent-id")
    assert response.status_code == 404

    unauthorized_client = TestClient(app)
    response = unauthorized_client.get("/api/resources/some-id")
    assert response.status_code == 401

    response = test_client.post("/api/resources", json=invalid_data)
    assert response.status_code == 400
```

## End-to-end workflow testing

```python
def test_complete_workflow(test_client, authenticated_client):
    create_response = test_client.post("/api/resources", json=resource_data)
    assert create_response.status_code == 201
    resource_id = create_response.json()["id"]

    update_response = test_client.patch(
        f"/api/resources/{resource_id}",
        json=update_data,
    )
    assert update_response.status_code == 200

    get_response = test_client.get(f"/api/resources/{resource_id}")
    assert get_response.status_code == 200
    assert get_response.json()["status"] == "updated"
```
