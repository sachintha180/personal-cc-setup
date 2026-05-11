# Test Examples

**Note:** Examples use generic domain names. Replace with your project's entities while following the same structural patterns.

## Test Directory Structure

```
tests/
├── conftest.py          # Shared fixtures
├── test_auth.py         # Authentication tests
├── test_game_setup.py   # Game creation tests
├── test_gameplay.py     # Gameplay loop tests
└── test_errors.py       # Error handling tests
```

## Fixture Composition

Database session, test client with dependency override, and domain-specific fixtures composed together.

```python
# conftest.py
import pytest
from fastapi.testclient import TestClient

from app import app
from config.database import get_db_session


@pytest.fixture(scope="function")
def test_db_session():
    """Create a test database session with cleanup."""
    session = create_test_session()
    yield session
    cleanup_database(session)


@pytest.fixture(scope="function")
def test_client(test_db_session):
    """Test client with database dependency override."""
    def override_get_db():
        yield test_db_session

    app.dependency_overrides[get_db_session] = override_get_db
    client = TestClient(app)
    yield client
    app.dependency_overrides.clear()


@pytest.fixture(scope="function")
def registered_user(test_db_session, test_client):
    """Create a registered user via API."""
    response = test_client.post("/api/auth/register", json=user_data)
    assert response.status_code == 201

    return response.json()["user"]
```

## Authentication Fixture

```python
@pytest.fixture(scope="function")
def authenticated_client(test_client, registered_user):
    """Test client with authenticated user session."""
    login_response = test_client.post("/api/auth/login", json=login_data)
    assert login_response.status_code == 200

    token = login_response.json()["token"]
    test_client.cookies[SESSION_COOKIE_NAME] = token

    return test_client
```

## Database Cleanup

```python
@pytest.fixture(scope="function")
def test_db_session():
    """Database session with comprehensive cleanup."""
    session = create_test_session()
    yield session
    # Cleanup in reverse dependency order
    session.query(ChildModel).delete()
    session.query(ParentModel).delete()
    session.commit()
```

## Dynamic Parametrization

```python
def pytest_generate_tests(metafunc):
    """Generate test parameters from test data file."""
    if "test_case" in metafunc.fixturenames:
        test_cases = load_test_cases_from_file("test_data.json")
        metafunc.parametrize("test_case", test_cases)


def test_operation_with_multiple_cases(test_client, test_case):
    """Test operation with various test cases."""
    response = test_client.post("/api/operation", json=test_case["input"])

    assert response.status_code == test_case["expected_status"]
    assert response.json() == test_case["expected_output"]
```

## Reference Data Comparison

```python
@pytest.fixture(scope="module")
def reference_data():
    """Load reference data for comparison."""
    with open("tests/fixtures/reference/expected_output.json") as f:
        return json.load(f)


def test_complex_operation_matches_reference(test_client, reference_data):
    """Test that operation produces reference results."""
    result = []
    for input_data in reference_data["inputs"]:
        response = test_client.post("/api/operation", json=input_data)
        assert response.status_code == 200
        result.append(response.json())

    for actual, expected in zip(result, reference_data["outputs"]):
        assert actual["id"] is not None  # Non-deterministic - verify presence only
        assert actual["computed_value"] == expected["computed_value"]  # Deterministic
```

## Basic Test Structure

```python
class TestFeature:
    """Test suite for feature functionality."""

    def test_basic_operation_succeeds(self, test_client, authenticated_client):
        """Test that basic operation works correctly."""
        response = test_client.post("/api/feature", json=valid_data)

        assert response.status_code == 201
        data = response.json()
        assert data["id"] is not None
        assert data["status"] == "active"

    def test_operation_fails_with_invalid_data(self, test_client):
        """Test that invalid data returns error."""
        response = test_client.post("/api/feature", json=invalid_data)

        assert response.status_code == 400
        assert "validation" in response.json()["detail"].lower()
```

## Assertion Patterns

```python
def test_operation_creates_resource(test_client, authenticated_client):
    """Demonstrate assertion patterns for status, body, and database state."""
    response = test_client.post("/api/resources", json=resource_data)

    # Status code verification
    assert response.status_code == 201

    # Response body verification
    data = response.json()
    assert data["resource"]["id"] is not None
    assert data["resource"]["status"] == "active"
```

## State Verification

```python
def test_operation_updates_database_state(test_client, test_db_session, authenticated_client):
    """Test that operation correctly updates database."""
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

## Error Scenario Testing

```python
def test_operation_handles_error_conditions(test_client, authenticated_client):
    """Test error handling for not found, unauthorized, and validation errors."""
    # Not found error
    response = test_client.get("/api/resources/nonexistent-id")
    assert response.status_code == 404

    # Unauthorized error
    unauthorized_client = TestClient(app)
    response = unauthorized_client.get("/api/resources/some-id")
    assert response.status_code == 401

    # Validation error
    response = test_client.post("/api/resources", json=invalid_data)
    assert response.status_code == 400
```

## End-to-End Workflow Testing

```python
def test_complete_workflow(test_client, authenticated_client):
    """Test complete user workflow end-to-end."""
    # Step 1: Create resource
    create_response = test_client.post("/api/resources", json=resource_data)
    assert create_response.status_code == 201
    resource_id = create_response.json()["id"]

    # Step 2: Update resource
    update_response = test_client.patch(
        f"/api/resources/{resource_id}",
        json=update_data,
    )
    assert update_response.status_code == 200

    # Step 3: Verify final state
    get_response = test_client.get(f"/api/resources/{resource_id}")
    assert get_response.status_code == 200
    assert get_response.json()["status"] == "updated"
```
