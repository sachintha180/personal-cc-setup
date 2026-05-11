# Code Examples

**Note:** The examples use specific domain names (e.g., "product", "order", "auth") for clarity, but these patterns apply to any domain or entity. Replace domain-specific names with your project's entities while following the same structural patterns.

## UI Component (Kebab-Case)

Reusable UI component demonstrating kebab-case file naming, default export, props interface, and variant pattern.

```tsx
// components/ui/custom-link.tsx
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

## Domain Component (PascalCase)

Domain-specific component demonstrating PascalCase file naming, composition with UI components, and domain logic.

```tsx
// components/products/ProductCard.tsx
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

## Layout Component

Layout component demonstrating routing structure, conditional rendering, and Outlet usage.

```tsx
// components/layouts/MainLayout.tsx
import { Outlet } from "react-router-dom";
import { useWindowSize } from "@/hooks/useWindowSize";

const GRAPHICS_BREAKPOINT = 1024; // Adjust based on performance requirements

export default function MainLayout() {
  // NOTE: Selectively render graphics to improve mobile performance
  const { width: windowWidth } = useWindowSize();
  const renderGraphics = windowWidth >= GRAPHICS_BREAKPOINT;

  return (
    <div>
      {/* Background Graphics */}
      {renderGraphics && <div />}

      {/* Main Container */}
      <main>
        <Outlet />

        {/* Footer */}
        <footer>
          <p>© {new Date().getFullYear()} Your Company</p>
        </footer>
      </main>
    </div>
  );
}
```

## Protected Route Component

Route protection component demonstrating authentication check, loading state, and navigation.

```tsx
// components/layouts/ProtectedRoute.tsx
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

## Skeleton Component

Loading skeleton component demonstrating reusable loading states.

```tsx
// components/skeletons/LoadingSkeleton.tsx
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

## Context Provider with Three-Hook Pattern

Context provider demonstrating the required three-hook pattern: State, API, and Operations.

```tsx
// contexts/AuthContext.tsx
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

  // Verify authentication status on mount
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

## Context State Hook

State hook demonstrating local state management for context.

```tsx
// contexts/hooks/useAuthState.ts
import { useState } from "react";

export function useAuthState() {
  // State management for authentication status
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  // State management for loading
  // NOTE: isLoading is set to true to prevent premature redirects
  //       before initial verification
  const [isLoading, setIsLoading] = useState(true);

  // State management for error
  const [error, setError] = useState<string | null>(null);

  return {
    // State
    isAuthenticated,
    isLoading,
    error,

    // Setters
    setIsAuthenticated,
    setIsLoading,
    setError,
  };
}
```

## Context API Hook

API hook demonstrating API call functions with useCallback.

```tsx
// contexts/hooks/useAuthAPI.ts
import { api } from "@/lib/api";
import type {
  AuthLoginRequest,
  AuthRegisterRequest,
  AuthLoginResponse,
  AuthRegisterResponse,
  AuthVerifyResponse,
} from "@/types/api";
import { useCallback } from "react";

export function useAuthAPI() {
  // Register new user
  const register = useCallback(
    async (payload: AuthRegisterRequest): Promise<AuthRegisterResponse> => {
      const { data } = await api.post<AuthRegisterResponse>(
        "/auth/register",
        payload
      );
      return data;
    },
    []
  );

  // Login user
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

  // Logout user
  const logout = useCallback(async (): Promise<void> => {
    await api.post("/auth/logout");
  }, []);

  // Verify authentication status
  const verify = useCallback(async (): Promise<AuthVerifyResponse> => {
    const { data } = await api.get<AuthVerifyResponse>("/auth/verify");
    return data;
  }, []);

  return {
    register,
    login,
    logout,
    verify,
  };
}
```

## Context Operations Hook

Operations hook demonstrating business logic combining state and API.

```tsx
// contexts/hooks/useAuthOperations.ts
import { useCallback } from "react";
import type { AuthLoginRequest, AuthRegisterRequest } from "@/types/api";
import type { useAuthAPI } from "@/contexts/hooks/useAuthAPI";
import type { useAuthState } from "@/contexts/hooks/useAuthState";

export function useAuthOperations(
  state: ReturnType<typeof useAuthState>,
  api: ReturnType<typeof useAuthAPI>
) {
  const { setIsAuthenticated, setIsLoading, setError } = state;
  const { register: apiRegister, login: apiLogin, logout: apiLogout } = api;

  // Register new user
  const register = useCallback(
    async (data: AuthRegisterRequest): Promise<boolean> => {
      setIsLoading(true);
      setError(null);

      try {
        await apiRegister(data);
        setIsAuthenticated(true);
        return true;
      } catch (error) {
        const errorMessage =
          error instanceof Error ? error.message : "Registration failed";
        setError(errorMessage);
        setIsAuthenticated(false);
        return false;
      } finally {
        setIsLoading(false);
      }
    },
    [apiRegister, setIsAuthenticated, setIsLoading, setError]
  );

  // Login user
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

  // Logout user
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
    register,
    login,
    logout,
  };
}
```

## Shared Custom Hook

Shared hook demonstrating reusable logic not tied to a specific domain.

```tsx
// hooks/useWindowSize.ts
import { useLayoutEffect, useState } from "react";

export function useWindowSize() {
  // NOTE: Initialized this way to avoid a flickering effect on the initial render.
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

## Page Component

Page component demonstrating composition of layouts, components, and page-level logic.

```tsx
// pages/products/Home.tsx
import Header from "@/components/products/Header";
import ProductCard from "@/components/products/ProductCard";
import LoadingSkeleton from "@/components/skeletons/LoadingSkeleton";
import Separator from "@/components/ui/separator";
import { useProducts } from "@/contexts/ProductContext";
import { useEffect } from "react";

export default function Home() {
  const { getAllProducts, products, isLoading } = useProducts();

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
      {/* Header */}
      <Header title="Products" subtitle="Browse our catalog" />

      {/* Separator */}
      <Separator />

      {/* Products Grid */}
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

## Form Component with Validation

Form component demonstrating react-hook-form, zod validation, and error handling.

```tsx
// components/products/ProductCreateModal.tsx
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
      {/* Header */}
      <h2>Create Product</h2>

      {/* Error Message */}
      {createError && <div>{createError}</div>}

      {/* Success Message */}
      {createSuccess && <div>{createSuccess}</div>}

      {/* Form */}
      <form onSubmit={form.handleSubmit(onSubmit)}>
        {/* Name Input */}
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

        {/* Description Input */}
        <div>
          <label htmlFor="description">Description</label>
          <textarea
            id="description"
            {...form.register("description")}
            placeholder="Enter product description"
            rows={4}
            disabled={isCreating}
            autoComplete="off"
          />
          {form.formState.errors.description && (
            <p>{form.formState.errors.description.message}</p>
          )}
        </div>

        {/* Price Input */}
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

        {/* Submit Button */}
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

## API Client Configuration

API client setup demonstrating axios configuration, interceptors, and error handling.

```tsx
// lib/api.ts
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
  withCredentials: true, // Required for HTTP-only cookies
});

// Track refresh token state to prevent multiple simultaneous refresh calls
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

// Response interceptor for handling errors and automatic token refresh
api.interceptors.response.use(
  (response: AxiosResponse) => response,
  async (error: AxiosError) => {
    const originalRequest = error.config as InternalAxiosRequestConfig & {
      _retry?: boolean;
    };

    // Transform error messages to use API detail
    if (axios.isAxiosError(error) && error.response?.data) {
      const data = error.response.data as { detail?: string };
      if (data.detail) {
        error.message = data.detail;
      }
    }

    // Handle 401 Unauthorized errors (expired access token)
    if (
      error.response?.status === 401 &&
      originalRequest &&
      !originalRequest._retry &&
      originalRequest.url !== "/auth/refresh"
    ) {
      if (isRefreshing) {
        // If refresh is already in progress, queue this request
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
        // Attempt to refresh the access token
        await api.post("/auth/refresh");
        processQueue(null);
        // Retry the original request with the new access token
        return api(originalRequest);
      } catch (refreshError) {
        processQueue(refreshError as AxiosError);
        // Redirect to login page if not a public route
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

    // All other errors pass through unchanged
    return Promise.reject(error);
  }
);
```

## Type Definitions

Type definitions demonstrating API types, domain types, and type declarations.

```tsx
// types/api.ts
import type { components } from "./openapi";

// Auth-related schemas
export type AuthLoginRequest = components["schemas"]["AuthLoginRequest"];
export type AuthLoginResponse = components["schemas"]["AuthLoginResponse"];
export type AuthRegisterRequest = components["schemas"]["AuthRegisterRequest"];
export type AuthRegisterResponse =
  components["schemas"]["AuthRegisterResponse"];

// Product-related schemas
export type Product = components["schemas"]["Product"];
export type ProductCreateRequest =
  components["schemas"]["ProductCreateRequest"];
export type ProductCreateResponse =
  components["schemas"]["ProductCreateResponse"];
export type ProductGetResponse = components["schemas"]["ProductGetResponse"];

// types/common.ts
import type { ReactNode } from "react";

export type ColorClasses = {
  border: string;
  circle: string;
  text: string;
};

export type PageItem = {
  buttonLabel: string;
  nodeLabel: string;
  href: string;
  colorClass: string;
};

export type ContactItem = {
  icon: ReactNode;
  href: string;
  text: string;
  iconColorClass: string;
};
```

## Complete Feature Implementation

Complete feature implementation demonstrating component composition, context usage, and page structure.

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
      {/* Header */}
      <Header title="Products" subtitle="Add new product">
        <CustomLink href="/products" variant="link">
          <FiArrowLeft aria-hidden="true" />
          <span>go back</span>
        </CustomLink>
      </Header>

      {/* Separator */}
      <Separator />

      {/* Product Create Modal */}
      <div>
        <ProductCreateModal />
      </div>
    </section>
  );
}

// contexts/ProductContext.tsx
import { createContext, useContext, type ReactNode } from "react";
import type { Product, ProductCreateRequest } from "@/types/api";
import { useProductState } from "@/contexts/hooks/useProductState";
import { useProductAPI } from "@/contexts/hooks/useProductAPI";
import { useProductOperations } from "@/contexts/hooks/useProductOperations";

type ProductContextType = {
  products: Product[];
  isLoading: boolean;
  error: string | null;
  getAllProducts: () => Promise<void>;
  createProduct: (data: ProductCreateRequest) => Promise<Product | null>;
};

const ProductContext = createContext<ProductContextType | undefined>(undefined);

export function ProductProvider({ children }: { children: ReactNode }) {
  const state = useProductState();
  const api = useProductAPI();
  const operations = useProductOperations(state, api);

  return (
    <ProductContext.Provider value={{ ...state, ...operations }}>
      {children}
    </ProductContext.Provider>
  );
}

export function useProducts() {
  const context = useContext(ProductContext);
  if (context === undefined) {
    throw new Error("useProducts must be used within a ProductProvider");
  }
  return context;
}
```

## Import Organization

File header demonstrating proper import organization pattern.

```tsx
// Standard library imports
import { useState, useEffect, useCallback, type ReactNode } from "react";
import { useNavigate } from "react-router-dom";

// Third-party imports
import { FiLoader, FiArrowLeft } from "react-icons/fi";
import * as z from "zod";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";

// Local imports - Contexts
import { useAuth } from "@/contexts/AuthContext";
import { useProducts } from "@/contexts/ProductContext";

// Local imports - Components
import CustomLink from "@/components/ui/custom-link";
import LoadingSkeleton from "@/components/skeletons/LoadingSkeleton";
import Header from "@/components/products/Header";

// Local imports - Hooks
import { useWindowSize } from "@/hooks/useWindowSize";

// Local imports - Lib
import { api } from "@/lib/api";
import { formatPrice } from "@/lib/products/utils";

// Local imports - Types
import type { Product, ProductCreateRequest } from "@/types/api";
import type { PageItem } from "@/types/common";
```

## App Component with Routing

Main App component demonstrating routing structure and provider hierarchy.

```tsx
// App.tsx
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
        {/* Index Route */}
        <Route index element={<Navigate to="/products" />} />

        {/* Public Routes */}
        <Route path="/products/*" element={<MainLayout />}>
          <Route index element={<ProductHome />} />
          <Route path="create" element={<ProductCreate />} />
          <Route path=":id" element={<ProductDetail />} />
          <Route path="*" element={<NotFound linkHref="/products" />} />
        </Route>

        {/* Protected Routes */}
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

        {/* Auth Routes */}
        <Route path="/auth/*">
          <Route path="login" element={<AuthLogin />} />
          <Route path="register" element={<AuthRegister />} />
          <Route path="*" element={<NotFound linkHref="/auth/login" />} />
        </Route>

        {/* Catch-all Route */}
        <Route path="*" element={<MainLayout />}>
          <Route path="*" element={<NotFound linkHref="/" />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
```
