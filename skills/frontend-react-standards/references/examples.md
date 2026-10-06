# React code examples

The rules for these samples are in [standards.md](standards.md). The samples
use the domain names product, order, and auth. Replace them with your own
entities and keep the structure.

## 1. UI component

Example: `components/ui/custom-link.tsx`. Kebab-case file, default export,
props type, variant prop.

```tsx
import type { AnchorHTMLAttributes } from "react";
import { useNavigate } from "react-router-dom";
import { FiArrowUpRight } from "react-icons/fi";

type CustomLinkVariant = "link" | "text" | "surface";

type CustomLinkProps = AnchorHTMLAttributes<HTMLAnchorElement> & {
  variant?: CustomLinkVariant;
  withIcon?: boolean;
};

export default function CustomLink({
  children,
  variant = "link",
  withIcon = false,
  href,
  onClick,
  ...props
}: CustomLinkProps) {
  const navigate = useNavigate();

  const handleClick = (e: React.MouseEvent<HTMLAnchorElement>) => {
    if (href && href.startsWith("/")) {
      e.preventDefault();
      navigate(href);
    }
    onClick?.(e);
  };

  return (
    <a href={href} onClick={handleClick} {...props}>
      {children}
      {withIcon && <FiArrowUpRight aria-hidden="true" />}
    </a>
  );
}
```

## 2. Domain component

Example: `components/products/ProductCard.tsx`. PascalCase file, composes a UI
component.

```tsx
import type { Product } from "@/types/api";
import CustomLink from "@/components/ui/custom-link";
import { formatPrice } from "@/lib/products/utils";

type ProductCardProps = {
  product: Product;
  onView?: (productId: string) => void;
};

export default function ProductCard({ product, onView }: ProductCardProps) {
  const handleView = () => {
    onView?.(product.id);
  };

  return (
    <div>
      <h3>{product.name}</h3>
      <p>{product.description}</p>
      <div>
        <span>{formatPrice(product.price)}</span>
        <CustomLink href={`/products/${product.id}`} variant="link" onClick={handleView}>
          View Details
        </CustomLink>
      </div>
    </div>
  );
}
```

## 3. Layout component

Example: `components/layouts/MainLayout.tsx`. `Outlet` and conditional
rendering by viewport width.

```tsx
import { Outlet } from "react-router-dom";
import { useWindowSize } from "@/hooks/useWindowSize";

const GRAPHICS_BREAKPOINT = 1024;

export default function MainLayout() {
  const { width: windowWidth } = useWindowSize();
  const renderGraphics = windowWidth >= GRAPHICS_BREAKPOINT;

  return (
    <div>
      {renderGraphics && <div />}

      <main>
        <Outlet />

        <footer>
          <p>(c) {new Date().getFullYear()} Your Company</p>
        </footer>
      </main>
    </div>
  );
}
```

## 4. Protected route

Example: `components/layouts/ProtectedRoute.tsx`. Authentication check, loading
state, redirect.

```tsx
import { Navigate, Outlet } from "react-router-dom";
import { useAuth } from "@/contexts/AuthContext";
import LoadingSkeleton from "@/components/skeletons/LoadingSkeleton";

type ProtectedRouteProps = {
  redirectTo?: string;
};

export default function ProtectedRoute({
  redirectTo = "/auth/login",
}: ProtectedRouteProps) {
  const { isAuthenticated, isLoading } = useAuth();

  if (isLoading) {
    return <LoadingSkeleton />;
  }

  if (!isAuthenticated) {
    return <Navigate to={redirectTo} replace />;
  }

  return <Outlet />;
}
```

## 5. Skeleton component

Example: `components/skeletons/LoadingSkeleton.tsx`. Reusable loading state.

```tsx
import { FiLoader } from "react-icons/fi";

type LoadingSkeletonProps = {
  message?: string;
};

export default function LoadingSkeleton({ message = "Loading" }: LoadingSkeletonProps) {
  return (
    <div>
      <div>{message}</div>
      <FiLoader />
    </div>
  );
}
```

## 6. Context provider

Example: `contexts/AuthContext.tsx`. Provider that combines the State, API, and
Operations hooks.

```tsx
import { createContext, useContext, useEffect, type ReactNode } from "react";
import type { AuthLoginRequest, AuthRegisterRequest } from "@/types/api";
import { useAuthState } from "@/contexts/hooks/useAuthState";
import { useAuthAPI } from "@/contexts/hooks/useAuthAPI";
import { useAuthOperations } from "@/contexts/hooks/useAuthOperations";

type AuthContextType = {
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
  register: (data: AuthRegisterRequest) => Promise<boolean>;
  login: (credentials: AuthLoginRequest) => Promise<boolean>;
  logout: () => Promise<void>;
  verify: () => Promise<boolean>;
};

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: ReactNode }) {
  const state = useAuthState();
  const api = useAuthAPI();
  const operations = useAuthOperations(state, api);

  const { verify } = operations;

  useEffect(() => {
    verify();
  }, [verify]);

  return (
    <AuthContext.Provider value={{ ...state, ...operations }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
}
```

## 7. Context state hook

Example: `contexts/hooks/useAuthState.ts`.

```tsx
import { useState } from "react";

export function useAuthState() {
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  // Starts true so a route guard does not redirect before the first verify call ends.
  const [isLoading, setIsLoading] = useState(true);

  const [error, setError] = useState<string | null>(null);

  return {
    isAuthenticated,
    isLoading,
    error,

    setIsAuthenticated,
    setIsLoading,
    setError,
  };
}
```

## 8. Context API hook

Example: `contexts/hooks/useAuthAPI.ts`. API calls wrapped in `useCallback`.
`register` has the same shape as `login` and is left out.

```tsx
import { api } from "@/lib/api";
import type {
  AuthLoginRequest,
  AuthLoginResponse,
  AuthVerifyResponse,
} from "@/types/api";
import { useCallback } from "react";

export function useAuthAPI() {
  const login = useCallback(
    async (payload: AuthLoginRequest): Promise<AuthLoginResponse> => {
      const { data } = await api.post<AuthLoginResponse>(
        "/auth/login",
        payload
      );
      return data;
    },
    []
  );

  const logout = useCallback(async (): Promise<void> => {
    await api.post("/auth/logout");
  }, []);

  const verify = useCallback(async (): Promise<AuthVerifyResponse> => {
    const { data } = await api.get<AuthVerifyResponse>("/auth/verify");
    return data;
  }, []);

  return {
    login,
    logout,
    verify,
  };
}
```

## 9. Context operations hook

Example: `contexts/hooks/useAuthOperations.ts`. Business logic that combines
state and API. `register` has the same shape as `login` and is left out.

```tsx
import { useCallback } from "react";
import type { AuthLoginRequest } from "@/types/api";
import type { useAuthAPI } from "@/contexts/hooks/useAuthAPI";
import type { useAuthState } from "@/contexts/hooks/useAuthState";

export function useAuthOperations(
  state: ReturnType<typeof useAuthState>,
  api: ReturnType<typeof useAuthAPI>
) {
  const { setIsAuthenticated, setIsLoading, setError } = state;
  const { login: apiLogin, logout: apiLogout } = api;

  const login = useCallback(
    async (credentials: AuthLoginRequest): Promise<boolean> => {
      setIsLoading(true);
      setError(null);

      try {
        await apiLogin(credentials);
        setIsAuthenticated(true);
        return true;
      } catch (error) {
        const errorMessage =
          error instanceof Error ? error.message : "Login failed";
        setError(errorMessage);
        setIsAuthenticated(false);
        return false;
      } finally {
        setIsLoading(false);
      }
    },
    [apiLogin, setIsAuthenticated, setIsLoading, setError]
  );

  const logout = useCallback(async (): Promise<void> => {
    setIsLoading(true);
    setError(null);

    try {
      await apiLogout();
      setIsAuthenticated(false);
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : "Logout failed";
      setError(errorMessage);
    } finally {
      setIsLoading(false);
    }
  }, [apiLogout, setIsAuthenticated, setIsLoading, setError]);

  return {
    login,
    logout,
  };
}
```

## 10. Shared custom hook

Example: `hooks/useWindowSize.ts`. Reusable logic with no domain.

```tsx
import { useLayoutEffect, useState } from "react";

export function useWindowSize() {
  // Reads the window size in the initializer to avoid a flicker on first render.
  const [size, setSize] = useState({
    width: typeof window !== "undefined" ? window.innerWidth : 0,
    height: typeof window !== "undefined" ? window.innerHeight : 0,
  });

  useLayoutEffect(() => {
    const updateSize = () => {
      setSize({ width: window.innerWidth, height: window.innerHeight });
    };
    updateSize();

    window.addEventListener("resize", updateSize);

    return () => window.removeEventListener("resize", updateSize);
  }, []);

  return size;
}
```

## 11. Page component

Example: `pages/products/Home.tsx`. Header, Separator, Content, and a guarded
fetch.

```tsx
import Header from "@/components/products/Header";
import ProductCard from "@/components/products/ProductCard";
import LoadingSkeleton from "@/components/skeletons/LoadingSkeleton";
import Separator from "@/components/ui/separator";
import { useProducts } from "@/contexts/ProductContext";
import { useEffect } from "react";

export default function Home() {
  const { getAllProducts, products, isLoading } = useProducts();

  // products is left out of the dependency array on purpose. It is not
  // referentially stable, and it would trigger a refetch loop.
  useEffect(() => {
    const fetchProducts = async () => {
      if (products.length) {
        return;
      }
      await getAllProducts();
    };
    fetchProducts();
  }, [getAllProducts]);

  return (
    <section>
      <Header title="Products" subtitle="Browse our catalog" />

      <Separator />

      <div>
        {isLoading ? (
          <LoadingSkeleton message="Loading products" />
        ) : products.length ? (
          products.map((product) => (
            <ProductCard key={product.id} product={product} />
          ))
        ) : (
          <div>No products found.</div>
        )}
      </div>
    </section>
  );
}
```

## 12. Form with validation

Example: `components/products/ProductCreateModal.tsx`. react-hook-form, zod, and
local success state. The
`description` input has the same shape as `name` and is left out of the markup.

```tsx
import { useProducts } from "@/contexts/ProductContext";
import { FiLoader } from "react-icons/fi";
import * as z from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useState } from "react";

const ProductCreateFormSchema = z.object({
  name: z.string().trim().min(1, "Name is required"),
  description: z.string().trim().min(1, "Description is required"),
  price: z.number().positive("Price must be positive"),
  category_id: z.string().uuid("Invalid category ID"),
});

type ProductCreateFormValues = z.infer<typeof ProductCreateFormSchema>;

export default function ProductCreateModal() {
  const [createSuccess, setCreateSuccess] = useState<string | null>(null);

  const form = useForm<ProductCreateFormValues>({
    resolver: zodResolver(ProductCreateFormSchema),
    defaultValues: {
      name: "",
      description: "",
      price: 0,
      category_id: "",
    },
  });

  const {
    createProduct,
    isLoading: isCreating,
    error: createError,
  } = useProducts();

  const onSubmit = async (data: ProductCreateFormValues) => {
    setCreateSuccess(null);
    const product = await createProduct({
      name: data.name,
      description: data.description,
      price: data.price,
      category_id: data.category_id,
    });
    if (product) {
      form.reset();
      setCreateSuccess("Product created successfully");
    }
  };

  return (
    <div>
      <h2>Create Product</h2>

      {createError && <div>{createError}</div>}

      {createSuccess && <div>{createSuccess}</div>}

      <form onSubmit={form.handleSubmit(onSubmit)}>
        <div>
          <label htmlFor="name">Name</label>
          <input
            type="text"
            id="name"
            {...form.register("name")}
            placeholder="Enter product name"
            disabled={isCreating}
            autoComplete="off"
          />
          {form.formState.errors.name && (
            <p>{form.formState.errors.name.message}</p>
          )}
        </div>

        <div>
          <label htmlFor="price">Price</label>
          <input
            type="number"
            id="price"
            {...form.register("price", { valueAsNumber: true })}
            placeholder="Enter price"
            disabled={isCreating}
            step="0.01"
            min="0"
          />
          {form.formState.errors.price && (
            <p>{form.formState.errors.price.message}</p>
          )}
        </div>

        <button type="submit" disabled={isCreating}>
          {isCreating ? (
            <div>
              <span>Creating product</span>
              <FiLoader />
            </div>
          ) : (
            "Create Product"
          )}
        </button>
      </form>
    </div>
  );
}
```

## 13. API client

Example: `lib/api.ts`. Axios instance, token refresh queue, and error message
transformation.

```tsx
import axios from "axios";
import type {
  AxiosResponse,
  AxiosError,
  InternalAxiosRequestConfig,
} from "axios";

export const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || "http://localhost:8000/api",
  headers: {
    "Content-Type": "application/json",
  },
  // Sends the HTTP-only auth cookies with each request.
  withCredentials: true,
});

let isRefreshing = false;
let failedQueue: Array<{
  resolve: (value?: unknown) => void;
  reject: (reason?: unknown) => void;
}> = [];

const processQueue = (error: AxiosError | null) => {
  failedQueue.forEach((promise) => {
    if (error) {
      promise.reject(error);
    } else {
      promise.resolve();
    }
  });
  failedQueue = [];
};

api.interceptors.response.use(
  (response: AxiosResponse) => response,
  async (error: AxiosError) => {
    const originalRequest = error.config as InternalAxiosRequestConfig & {
      _retry?: boolean;
    };

    if (axios.isAxiosError(error) && error.response?.data) {
      const data = error.response.data as { detail?: string };
      if (data.detail) {
        error.message = data.detail;
      }
    }

    // The refresh URL is excluded so a failed refresh does not loop.
    if (
      error.response?.status === 401 &&
      originalRequest &&
      !originalRequest._retry &&
      originalRequest.url !== "/auth/refresh"
    ) {
      if (isRefreshing) {
        return new Promise((resolve, reject) => {
          failedQueue.push({ resolve, reject });
        })
          .then(() => {
            return api(originalRequest);
          })
          .catch((err) => {
            return Promise.reject(err);
          });
      }

      originalRequest._retry = true;
      isRefreshing = true;

      try {
        await api.post("/auth/refresh");
        processQueue(null);
        return api(originalRequest);
      } catch (refreshError) {
        processQueue(refreshError as AxiosError);
        const currentPath = window.location.pathname;
        const isPublicRoute = ["/auth/login", "/auth/register"].includes(
          currentPath
        );
        if (!isPublicRoute) {
          window.location.href = "/auth/login";
        }
        return Promise.reject(refreshError);
      } finally {
        isRefreshing = false;
      }
    }

    return Promise.reject(error);
  }
);
```

## 14. Type definitions

Example: `types/api.ts` and `types/common.ts`. Generated API types are
re-exported. Domain types are written by hand.

```tsx
// types/api.ts
import type { components } from "./openapi";

export type AuthLoginRequest = components["schemas"]["AuthLoginRequest"];
export type AuthLoginResponse = components["schemas"]["AuthLoginResponse"];
export type AuthRegisterRequest = components["schemas"]["AuthRegisterRequest"];
export type AuthRegisterResponse =
  components["schemas"]["AuthRegisterResponse"];

export type Product = components["schemas"]["Product"];
export type ProductCreateRequest =
  components["schemas"]["ProductCreateRequest"];
export type ProductCreateResponse =
  components["schemas"]["ProductCreateResponse"];
export type ProductGetResponse = components["schemas"]["ProductGetResponse"];

// types/common.ts
export type PageItem = {
  buttonLabel: string;
  nodeLabel: string;
  href: string;
  colorClass: string;
};
```

## 15. Complete feature

Example: `pages/products/Create.tsx`. A page that composes a form component.
`contexts/ProductContext.tsx` has the same structure as `AuthContext` in
sample 6, without the `verify` effect. It uses `useProductState`,
`useProductAPI`, and `useProductOperations`.

```tsx
// pages/products/Create.tsx
import Separator from "@/components/ui/separator";
import Header from "@/components/products/Header";
import ProductCreateModal from "@/components/products/ProductCreateModal";
import CustomLink from "@/components/ui/custom-link";
import { FiArrowLeft } from "react-icons/fi";

export default function Create() {
  return (
    <section>
      <Header title="Products" subtitle="Add new product">
        <CustomLink href="/products" variant="link">
          <FiArrowLeft aria-hidden="true" />
          <span>go back</span>
        </CustomLink>
      </Header>

      <Separator />

      <div>
        <ProductCreateModal />
      </div>
    </section>
  );
}
```

## 16. Import organization

Example: file header with the local import groups in order: Contexts,
Components, Hooks, Lib, Types.

```tsx
import { useState, useEffect, useCallback, type ReactNode } from "react";
import { useNavigate } from "react-router-dom";

import { FiLoader, FiArrowLeft } from "react-icons/fi";
import * as z from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";

import { useAuth } from "@/contexts/AuthContext";
import { useProducts } from "@/contexts/ProductContext";

import CustomLink from "@/components/ui/custom-link";
import LoadingSkeleton from "@/components/skeletons/LoadingSkeleton";
import Header from "@/components/products/Header";

import { useWindowSize } from "@/hooks/useWindowSize";

import { api } from "@/lib/api";
import { formatPrice } from "@/lib/products/utils";

import type { Product, ProductCreateRequest } from "@/types/api";
import type { PageItem } from "@/types/common";
```

## 17. App with routing

Example: `App.tsx`. `BrowserRouter`, layouts, protected routes, and the
provider hierarchy.

```tsx
import MainLayout from "@/components/layouts/MainLayout";
import DashboardLayout from "@/components/layouts/DashboardLayout";
import ProtectedRoute from "@/components/layouts/ProtectedRoute";
import RedirectRoute from "@/components/layouts/RedirectRoute";
import NotFound from "@/components/layouts/NotFound";

import ProductHome from "@/pages/products/Home";
import ProductCreate from "@/pages/products/Create";
import ProductDetail from "@/pages/products/Detail";

import AuthLogin from "@/pages/auth/Login";
import AuthRegister from "@/pages/auth/Register";

import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { AuthProvider, ProductProvider } from "@/contexts";

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route index element={<Navigate to="/products" />} />

        <Route path="/products/*" element={<MainLayout />}>
          <Route index element={<ProductHome />} />
          <Route path="create" element={<ProductCreate />} />
          <Route path=":id" element={<ProductDetail />} />
          <Route path="*" element={<NotFound linkHref="/products" />} />
        </Route>

        <Route
          path="/dashboard/*"
          element={
            <AuthProvider>
              <ProductProvider>
                <DashboardLayout />
              </ProductProvider>
            </AuthProvider>
          }
        >
          <Route element={<ProtectedRoute redirectTo="/auth/login" />}>
            <Route index element={<Navigate to="/dashboard/products" />} />
            <Route path="products/*">
              <Route index element={<ProductHome />} />
              <Route path="create" element={<ProductCreate />} />
            </Route>
          </Route>

          <Route element={<RedirectRoute redirectTo="/dashboard" />}>
            <Route path="login" element={<AuthLogin />} />
          </Route>

          <Route path="register" element={<AuthRegister />} />
          <Route path="*" element={<NotFound linkHref="/dashboard" />} />
        </Route>

        <Route path="/auth/*">
          <Route path="login" element={<AuthLogin />} />
          <Route path="register" element={<AuthRegister />} />
          <Route path="*" element={<NotFound linkHref="/auth/login" />} />
        </Route>

        <Route path="*" element={<MainLayout />}>
          <Route path="*" element={<NotFound linkHref="/" />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
```
