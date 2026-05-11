# Code Examples

**Note:** Examples use specific domain names (e.g., "product", "order", "user") for clarity. These patterns apply to any domain - replace domain-specific names with your project's entities while following the same structural patterns.

## Route Handler with All Dependencies

Complete route handler demonstrating proper dependency injection, status codes, response models, and unused authentication dependency pattern.

```python
from uuid import UUID
from fastapi import APIRouter, status

from schemas.product import (
    ProductCreateRequest,
    ProductCreateResponse,
    ProductGetResponse,
)
from custom_types.dependencies import (
    AuthenticatedUserDep,
    DBSessionDep,
    ProductServiceDep,
)

router = APIRouter(prefix="/products", tags=["products"])


@router.post(
    "/",
    response_model=ProductCreateResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_product(
    request_data: ProductCreateRequest,
    authenticated_user: AuthenticatedUserDep,
    product_service: ProductServiceDep,
    db_session: DBSessionDep,
):
    """Create a new product."""
    user_id = authenticated_user.id
    product = product_service.create_product(db_session, user_id, request_data)

    return ProductCreateResponse(product=product)


@router.get(
    "/{product_id}",
    response_model=ProductGetResponse,
    status_code=status.HTTP_200_OK,
)
def get_product(
    product_id: UUID,
    _: AuthenticatedUserDep,
    product_service: ProductServiceDep,
    db_session: DBSessionDep,
):
    """Get a product by ID."""
    product = product_service.get_product_by_id(db_session, product_id)

    return ProductGetResponse(product=product)


@router.delete(
    "/{product_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def delete_product(
    product_id: UUID,
    _: AuthenticatedUserDep,
    product_service: ProductServiceDep,
    db_session: DBSessionDep,
):
    """Delete a product."""
    product_service.delete_product(db_session, product_id)
```

## Route Ordering: Specific Before Parameterized

Router configuration showing correct route ordering to prevent FastAPI from matching specific paths as parameters.

```python
router = APIRouter(prefix="/products", tags=["products"])


@router.get(
    "/all",
    response_model=ProductsGetResponse,
    status_code=status.HTTP_200_OK,
)
def get_products(...):
    """Get all products."""
    pass


@router.get(
    "/{product_id}",
    response_model=ProductGetResponse,
    status_code=status.HTTP_200_OK,
)
def get_product(...):
    """Get a product by ID."""
    pass
```

## Service Method with Exception Handling

Service method demonstrating business logic validation, exception handling, session refresh, and exception chain preservation.

```python
from uuid import UUID
from sqlmodel import Session

from models import User
from schemas.user import UserUpdateRequest
from database.user import UserDatabase
from custom_types.exceptions import (
    UserNotFoundError,
    EmailAlreadyExistsError,
    DatabaseError,
)


class UserService:
    """Service for user-related business logic."""

    def __init__(self, db: UserDatabase):
        """Initialize UserService with a database dependency."""
        self.db = db

    def update_user(
        self, db_session: Session, user_id: UUID, user_data: UserUpdateRequest
    ) -> User:
        """Update a user with validation."""
        user = self.db.get_user_by_id(db_session, user_id)
        if not user:
            raise UserNotFoundError

        if user_data.email and user_data.email != user.email:
            existing_user = self.db.get_user_by_email(db_session, user_data.email)
            if existing_user:
                raise EmailAlreadyExistsError

        try:
            updated_user = self.db.update_user(db_session, user, user_data)
            db_session.refresh(updated_user)
        except Exception as e:
            raise DatabaseError("Failed to update user") from e

        return updated_user
```

## Service Method with Token Creation

Service method demonstrating JWT token creation with type-safe token handling and environment-aware expiration.

```python
def create_token(self, user: User, token_type: TokenType) -> str:
    """Create an access / refresh token for a user."""
    expiration_time = (
        COOKIE_MAX_AGE_ACCESS
        if token_type == TokenType.ACCESS
        else COOKIE_MAX_AGE_REFRESH
    )
    payload = TokenPayload(
        sub=str(user.id),
        email=user.email,
        type=user.type,
        exp=datetime.now(timezone.utc) + timedelta(seconds=expiration_time),
        token_type=token_type,
    )

    return jwt.encode(
        payload.model_dump(),
        JWT_SECRET,
        algorithm=JWT_ALGORITHM,
    )
```

## Repository CRUD Methods

Repository methods demonstrating create, read, update patterns with proper session management and query building.

```python
from typing import Optional, List
from uuid import UUID
from sqlmodel import Session, select, desc

from models import User, Product, Order
from schemas.auth import AuthRegisterRequest
from schemas.user import UserUpdateRequest
from schemas.product import ProductCreateRequest, ProductUpdateRequest


class UserDatabase:
    """Database layer for user operations."""

    def create_user(
        self, db_session: Session, user_data: AuthRegisterRequest, hashed_password: str
    ) -> User:
        """Create a new user in the database."""
        user = User(
            **user_data.model_dump(
                exclude={"password"},
            ),
            password=hashed_password,
        )
        db_session.add(user)
        db_session.commit()
        db_session.refresh(user)

        return user

    def get_user_by_id(self, db_session: Session, user_id: UUID) -> Optional[User]:
        """Get a user by ID."""
        statement = select(User).where(User.id == user_id)

        return db_session.exec(statement).first()

    def update_user(
        self, db_session: Session, user: User, user_data: UserUpdateRequest
    ) -> User:
        """Update a user in the database."""
        update_dict = user_data.model_dump(exclude_unset=True)
        for key, value in update_dict.items():
            setattr(user, key, value)

        db_session.add(user)
        db_session.commit()
        db_session.refresh(user)

        return user


class ProductDatabase:
    """Database layer for product operations."""

    def get_all_products_by_user_id(
        self, db_session: Session, user_id: UUID
    ) -> List[Product]:
        """Get all products for a user, sorted by the latest created first."""
        statement = (
            select(Product).where(Product.user_id == user_id)
        ).order_by(desc(Product.created_at))

        return list(db_session.exec(statement).all())

    def create_product(
        self, db_session: Session, user_id: UUID, product_data: ProductCreateRequest
    ) -> Product:
        """Create a new product in the database."""
        product = Product(
            **product_data.model_dump(),
            user_id=user_id,
        )
        db_session.add(product)
        db_session.commit()
        db_session.refresh(product)

        return product
```

## Schema Definitions

Schema definitions demonstrating request/response naming conventions, optional fields for updates, and internal schemas.

```python
from typing import Optional
from pydantic import BaseModel, EmailStr
from uuid import UUID
from datetime import datetime

from custom_types.enums import UserType, TokenType
from models import User


class AuthRegisterRequest(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr
    password: str
    type: UserType


class AuthLoginResponse(BaseModel):
    user: User


class UserUpdateRequest(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    type: Optional[UserType] = None


class TokenPayload(BaseModel):
    sub: str
    email: EmailStr
    type: UserType
    exp: datetime
    token_type: TokenType


class AuthVerifyUser(BaseModel):
    id: UUID
    email: EmailStr
    first_name: str
    last_name: str
    type: UserType
```

## Dependency Injection

Dependency factory functions, type aliases, and authentication dependency demonstrating the dependency injection pattern.

```python
from typing import Annotated
from fastapi import Depends, Request
from sqlmodel import Session

from models import User
from database.user import UserDatabase
from services.user import UserService
from services.auth import AuthService
from config.database import get_db_session
from config.auth import ACCESS_TOKEN_COOKIE_NAME
from api.dependencies import get_auth_service


def get_user_db() -> UserDatabase:
    """Dependency factory for user database."""
    return UserDatabase()


def get_user_service(
    db: Annotated[UserDatabase, Depends(get_user_db)],
) -> UserService:
    """Dependency factory for user service."""
    return UserService(db=db)


UserServiceDep = Annotated[UserService, Depends(get_user_service)]
DBSessionDep = Annotated[Session, Depends(get_db_session)]


def get_authenticated_user(
    request: Request,
    auth_service: Annotated[AuthService, Depends(get_auth_service)],
    db_session: Annotated[Session, Depends(get_db_session)],
) -> User:
    """Dependency that verifies JWT token from HTTP-only cookie and returns the current authenticated user."""
    token = request.cookies.get(ACCESS_TOKEN_COOKIE_NAME)

    return auth_service.verify_authentication(db_session, token)


AuthenticatedUserDep = Annotated[User, Depends(get_authenticated_user)]
```

## Exception Handling

Exception definition and usage demonstrating default messages, custom messages, and exception chain preservation.

```python
from fastapi import HTTPException, status
from sqlmodel import Session
from uuid import UUID

from models import User
from database.user import UserDatabase


class UserNotFoundError(HTTPException):
    def __init__(self, detail: str = "User not found"):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=detail,
        )


class DatabaseError(HTTPException):
    def __init__(self, detail: str = "Database operation failed"):
        super().__init__(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=detail,
        )


class UserService:
    def __init__(self, db: UserDatabase):
        self.db = db

    def get_user_by_id(self, db_session: Session, user_id: UUID) -> User:
        """Get a user by ID."""
        user = self.db.get_user_by_id(db_session, user_id)
        if not user:
            raise UserNotFoundError

        return user

    def create_user(self, db_session: Session, user_data, hashed_password: str) -> User:
        """Create a new user."""
        try:
            user = self.db.create_user(db_session, user_data, hashed_password)
            db_session.refresh(user)
        except Exception as e:
            raise DatabaseError("Failed to create user") from e

        return user
```

## Import Organization and Router Configuration

File header demonstrating proper import organization and router aggregation pattern.

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
from custom_types.dependencies import UserServiceDep


# Router aggregation
from fastapi import APIRouter

from .auth import router as auth_router
from .user import router as user_router
from .product import router as product_router

api_router = APIRouter()

api_router.include_router(auth_router)
api_router.include_router(user_router)
api_router.include_router(product_router)
```

## Complete Feature Implementation

Full top-down implementation showing services, database layer, schemas, and exceptions wired together. Routes follow the pattern from the Route Handler example above.

```python
# services/product.py
from uuid import UUID
from sqlmodel import Session

from models import Product
from schemas.product import ProductCreateRequest
from database.product import ProductDatabase
from custom_types.exceptions import (
    ProductNotFoundError,
    DatabaseError,
)


class ProductService:
    """Service for product-related business logic."""

    def __init__(self, db: ProductDatabase):
        """Initialize ProductService with a database dependency."""
        self.db = db

    def create_product(
        self, db_session: Session, category_id: UUID, product_data: ProductCreateRequest
    ) -> Product:
        """Create a new product."""
        try:
            product = self.db.create_product(db_session, category_id, product_data)
            db_session.refresh(product)
        except Exception as e:
            raise DatabaseError("Failed to create product") from e

        return product

    def get_product_by_id(self, db_session: Session, product_id: UUID) -> Product:
        """Get a product by ID."""
        product = self.db.get_product_by_id(db_session, product_id)
        if not product:
            raise ProductNotFoundError

        return product


# database/product.py
from typing import Optional
from uuid import UUID
from sqlmodel import Session, select

from models import Product
from schemas.product import ProductCreateRequest


class ProductDatabase:
    """Database layer for product operations."""

    def create_product(
        self, db_session: Session, category_id: UUID, product_data: ProductCreateRequest
    ) -> Product:
        """Create a new product in the database."""
        product = Product(
            **product_data.model_dump(),
            category_id=category_id,
        )
        db_session.add(product)
        db_session.commit()
        db_session.refresh(product)

        return product

    def get_product_by_id(
        self, db_session: Session, product_id: UUID
    ) -> Optional[Product]:
        """Get a product by ID."""
        statement = select(Product).where(Product.id == product_id)

        return db_session.exec(statement).first()


# schemas/product.py
from decimal import Decimal
from uuid import UUID
from pydantic import BaseModel

from models import Product


class ProductCreateRequest(BaseModel):
    name: str
    description: str
    price: Decimal
    category_id: UUID


class ProductCreateResponse(BaseModel):
    product: Product


class ProductGetResponse(BaseModel):
    product: Product


# custom_types/exceptions.py
from fastapi import HTTPException, status


class ProductNotFoundError(HTTPException):
    def __init__(self, detail: str = "Product not found"):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=detail,
        )
```
