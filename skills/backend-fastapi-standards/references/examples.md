# Examples

The examples use the domain names `product`, `order`, and `user`. The same
structure applies to any domain. Rules behind each pattern are in
[standards.md](standards.md). File placement is in [files.md](files.md).

## Route handler with all dependencies

This route handler shows dependency injection, explicit status codes,
response models, and the unused authentication dependency pattern.

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
    product_service.delete_product(db_session, product_id)
```

The route examples use these schemas.

Example: `schemas/product.py`.

```python
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
```

## Route ordering: specific before parameterized

This router defines the literal `/all` path before the parameterized
`/{product_id}` path. The order prevents FastAPI from matching "all" as a
parameter.

```python
router = APIRouter(prefix="/products", tags=["products"])


@router.get(
    "/all",
    response_model=ProductsGetResponse,
    status_code=status.HTTP_200_OK,
)
def get_products(...):
    pass


@router.get(
    "/{product_id}",
    response_model=ProductGetResponse,
    status_code=status.HTTP_200_OK,
)
def get_product(...):
    pass
```

## Service method with exception handling

This service method shows business validation, domain exceptions, session
refresh, and exception chain preservation.

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
    def __init__(self, db: UserDatabase):
        self.db = db

    def update_user(
        self, db_session: Session, user_id: UUID, user_data: UserUpdateRequest
    ) -> User:
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

## Service method with token creation

This service method creates a JWT with a typed payload. The expiration
depends on the token type.

```python
def create_token(self, user: User, token_type: TokenType) -> str:
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

## Repository CRUD methods

These repository methods show create, read, and update patterns with session
management and query building.

```python
from typing import Optional, List
from uuid import UUID
from sqlmodel import Session, select, desc

from models import User, Product, Order
from schemas.auth import AuthRegisterRequest
from schemas.user import UserUpdateRequest
from schemas.product import ProductCreateRequest, ProductUpdateRequest


class UserDatabase:
    def create_user(
        self, db_session: Session, user_data: AuthRegisterRequest, hashed_password: str
    ) -> User:
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
        statement = select(User).where(User.id == user_id)

        return db_session.exec(statement).first()

    def update_user(
        self, db_session: Session, user: User, user_data: UserUpdateRequest
    ) -> User:
        update_dict = user_data.model_dump(exclude_unset=True)
        for key, value in update_dict.items():
            setattr(user, key, value)

        db_session.add(user)
        db_session.commit()
        db_session.refresh(user)

        return user


class ProductDatabase:
    def get_all_products_by_user_id(
        self, db_session: Session, user_id: UUID
    ) -> List[Product]:
        statement = (
            select(Product).where(Product.user_id == user_id)
        ).order_by(desc(Product.created_at))

        return list(db_session.exec(statement).all())

    def create_product(
        self, db_session: Session, user_id: UUID, product_data: ProductCreateRequest
    ) -> Product:
        product = Product(
            **product_data.model_dump(),
            user_id=user_id,
        )
        db_session.add(product)
        db_session.commit()
        db_session.refresh(product)

        return product
```

## Schema definitions

These schemas show request and response naming, optional fields for partial
updates, and internal schemas.

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

## Dependency injection

These dependency factory functions, type aliases, and the authentication
dependency show the injection pattern. The authentication dependency reads
the JWT from an HTTP-only cookie and returns the current user.

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
    return UserDatabase()


def get_user_service(
    db: Annotated[UserDatabase, Depends(get_user_db)],
) -> UserService:
    return UserService(db=db)


UserServiceDep = Annotated[UserService, Depends(get_user_service)]
DBSessionDep = Annotated[Session, Depends(get_db_session)]


def get_authenticated_user(
    request: Request,
    auth_service: Annotated[AuthService, Depends(get_auth_service)],
    db_session: Annotated[Session, Depends(get_db_session)],
) -> User:
    token = request.cookies.get(ACCESS_TOKEN_COOKIE_NAME)

    return auth_service.verify_authentication(db_session, token)


AuthenticatedUserDep = Annotated[User, Depends(get_authenticated_user)]
```

## Exception handling

These exception definitions each carry a status code and a default message.
Services that raise them are in the service method examples above.

```python
from fastapi import HTTPException, status


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
```

## Router aggregation

Example: `routes/__init__.py`. This file collects every router into one
`api_router`.

```python
from fastapi import APIRouter

from .auth import router as auth_router
from .user import router as user_router
from .product import router as product_router

api_router = APIRouter()

api_router.include_router(auth_router)
api_router.include_router(user_router)
api_router.include_router(product_router)
```
