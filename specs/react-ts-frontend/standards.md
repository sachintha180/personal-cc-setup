# Coding Standards and Style Guide

## Code Formatting

### Code Spacing

**Rule:** There must be one blank line ALWAYS between logical code blocks and before return statements. Group related code together and separate logical sections with blank lines.

**Example:**

```tsx
// Good
function ExampleComponent() {
  const [state, setState] = useState(false);

  const handleClick = () => {
    setState(true);
  };

  return <button onClick={handleClick}>Click me</button>;
}

// Bad - no blank line before return
function ExampleComponent() {
  const [state, setState] = useState(false);
  return <button>Click me</button>;
}

// Good - semantic spacing
function ComplexComponent() {
  // First logical block - state
  const [isLoading, setIsLoading] = useState(false);
  const [data, setData] = useState(null);

  // Second logical block - effects
  useEffect(() => {
    fetchData();
  }, []);

  // Third logical block - handlers
  const handleSubmit = () => {
    setIsLoading(true);
    submitData();
  };

  return <form onSubmit={handleSubmit}>...</form>;
}
```

**Implementation:**

- Always have one blank line before `return` statement
- Group related code blocks together (state, effects, handlers)
- Separate logical sections with blank lines
- Maintain consistent spacing throughout the codebase

## Naming Conventions

### Component File Naming

**Rule:** Component file names follow a strict pattern based on component type:

- **UI components:** kebab-case (e.g., `custom-link.tsx`, `list-item.tsx`, `page-button.tsx`)
- **Domain/Layout components:** PascalCase (e.g., `ProductCard.tsx`, `MainLayout.tsx`, `LoginModal.tsx`)
- **Skeleton components:** PascalCase (e.g., `LoadingSkeleton.tsx`)

**Pattern:**

- UI components: `{component-name}.tsx` -> `custom-link.tsx`
- Domain components: `{ComponentName}.tsx` -> `ProductCard.tsx`
- Layout components: `{LayoutName}.tsx` -> `MainLayout.tsx`

**Examples:**

- **Good:** `components/ui/custom-link.tsx` -> `CustomLink` component
- **Good:** `components/products/ProductCard.tsx` -> `ProductCard` component
- **Good:** `components/layouts/MainLayout.tsx` -> `MainLayout` component
- **Bad:** `components/ui/CustomLink.tsx` (UI components should be kebab-case)
- **Bad:** `components/products/product-card.tsx` (Domain components should be PascalCase)

**Implementation:**

- UI components are reusable, generic components -> kebab-case
- Domain components are specific to a feature/domain -> PascalCase
- Layout components define page structure -> PascalCase

### Props Interface Naming

**Rule:** Props interfaces must use PascalCase with `Props` suffix, matching the component name.

**Pattern:** `{ComponentName}Props`

**Examples:**

- **Good:** `CustomLinkProps` for `CustomLink` component
- **Good:** `ProductCardProps` for `ProductCard` component
- **Bad:** `CustomLink` (missing `Props` suffix)
- **Bad:** `customLinkProps` (should be PascalCase)

**Implementation:**

- Props interfaces always end with `Props`
- Match the component name exactly (PascalCase)
- Use descriptive prop names within the interface

### Hook Naming Convention

**Rule:** Hook files and hook names must use camelCase with `use` prefix.

**Pattern:** `use{HookName}.ts` -> `use{HookName}` function

**Examples:**

- **Good:** `useWindowSize.ts` -> `useWindowSize()` hook
- **Good:** `useAuthState.ts` -> `useAuthState()` hook
- **Bad:** `UseWindowSize.ts` (should be camelCase)
- **Bad:** `windowSize.ts` (missing `use` prefix)

**Implementation:**

- Hook files: camelCase with `use` prefix
- Hook functions: camelCase with `use` prefix
- Context hooks follow pattern: `use{Context}State`, `use{Context}API`, `use{Context}Operations`

### Context Hook Pattern (Required)

**Rule:** All contexts MUST follow the three-hook pattern: `use{Context}State`, `use{Context}API`, and `use{Context}Operations`. This is a required architectural pattern, not optional.

**Pattern:**

- `use{Context}State` - Manages local state (useState hooks)
- `use{Context}API` - Handles API calls (useCallback with axios)
- `use{Context}Operations` - Combines state and API for business logic (useCallback)

**Examples:**

- **Good:** `AuthContext` uses `useAuthState`, `useAuthAPI`, `useAuthOperations`
- **Good:** `ProductContext` uses `useProductState`, `useProductAPI`, `useProductOperations`
- **Bad:** Single hook combining state, API, and operations
- **Bad:** Missing any of the three hooks
- **Bad:** Inconsistent naming (e.g., `useAuthState`, `useAuthApi`, `useAuthOps`)

**Implementation:**

- State hook: Returns state values and setters
- API hook: Returns API call functions wrapped in useCallback
- Operations hook: Takes state and API hooks, returns business logic functions
- Context provider combines all three hooks

### Type File Naming

**Rule:** Type definition files follow specific naming conventions:

- **API types:** `api.ts` (reserved filename for OpenAPI-generated types)
- **Domain types:** kebab-case or camelCase (e.g., `common.ts`, `miscellaneous.ts`)
- **Type declarations:** `.d.ts` extension (e.g., `openapi.d.ts`, `ui.d.ts`)

**Examples:**

- **Good:** `types/api.ts` - OpenAPI-generated types
- **Good:** `types/common.ts` - Common shared types
- **Good:** `types/ui.d.ts` - UI library type declarations
- **Bad:** `types/Api.ts` (should be lowercase)
- **Bad:** `types/common.d.ts` (use `.d.ts` only for declarations)

**Implementation:**

- `api.ts` is reserved for OpenAPI-generated contract types
- Domain types use descriptive names without extension
- Type declaration files use `.d.ts` for third-party library types

## Import Organization

### Import Placement

**Rule:** All imports MUST be at the top of the file. Group imports in the following order: standard library, third-party, local imports (grouped by type).

**Example:**

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

**Implementation:**

- All imports at the top of the file
- Group imports: standard library -> third-party -> local
- Local imports grouped by type: Contexts -> Components -> Hooks -> Lib -> Types
- Use `type` keyword for type-only imports when appropriate

## Component Export Patterns

### Default Exports for Components

**Rule:** Components MUST use default exports as the standard pattern. Exceptions exist for components using `forwardRef` or other advanced patterns.

**Examples:**

- **Good:** `export default function ProductCard() { ... }`
- **Good:** `export default function MainLayout() { ... }`
- **Bad:** `export function ProductCard() { ... }` (should be default export)
- **Exception:** `export const ProductCard = forwardRef(...)` (forwardRef may require named export)

**Implementation:**

- Default exports are the standard for all components
- Use named exports only when necessary (forwardRef, etc.)

### Named Exports for Hooks, Types, and Utilities

**Rule:** Hooks, types, and utility functions MUST use named exports.

**Examples:**

- **Good:** `export function useWindowSize() { ... }`
- **Good:** `export type ProductCardProps = { ... }`
- **Good:** `export function formatPrice(price: number) { ... }`
- **Bad:** `export default function useWindowSize() { ... }` (hooks should be named exports)

**Implementation:**

- Hooks: Always named exports
- Types: Always named exports
- Utilities: Always named exports

## Context Provider Standards

### Three-Hook Pattern Requirement

**Rule:** All context providers MUST use the three-hook pattern: State, API, and Operations hooks. The context provider combines all three hooks and exposes their combined values.

**Example:**

```tsx
// contexts/AuthContext.tsx
export function AuthProvider({ children }: { children: ReactNode }) {
  const state = useAuthState();
  const api = useAuthAPI();
  const operations = useAuthOperations(state, api);

  return (
    <AuthContext.Provider value={{ ...state, ...operations }}>
      {children}
    </AuthContext.Provider>
  );
}
```

**Implementation:**

- Context provider calls all three hooks: State, API, Operations
- Operations hook receives state and api hooks as parameters
- Provider combines all values: `{ ...state, ...operations }`
- API hook functions are typically not exposed directly (only through operations)

### Context Hook Exports

**Rule:** Context files export both the Provider component (default export) and the custom hook (named export).

**Examples:**

- **Good:** `export function AuthProvider() { ... }` and `export function useAuth() { ... }`
- **Bad:** Both Provider and hook as default exports

**Implementation:**

- Provider component: Default export
- Custom hook: Named export (`use{Context}`)
- Hook throws error if used outside provider

## Form Handling Standards

### Schema-First Validation

**Rule:** All forms MUST use zod schemas for validation with react-hook-form. Define schemas before component definition.

**Pattern:**

1. Define zod schema
2. Infer TypeScript type from schema
3. Use schema with react-hook-form resolver

**Example:**

```tsx
const ProductCreateFormSchema = z.object({
  name: z.string().trim().min(1, "Name is required"),
  description: z.string().trim().min(1, "Description is required"),
  price: z.number().positive("Price must be positive"),
});

type ProductCreateFormValues = z.infer<typeof ProductCreateFormSchema>;

export default function ProductCreateModal() {
  const form = useForm<ProductCreateFormValues>({
    resolver: zodResolver(ProductCreateFormSchema),
    defaultValues: { ... },
  });
  // ...
}
```

**Implementation:**

- Define zod schema before component
- Use `z.infer<typeof Schema>` for TypeScript type
- Use `zodResolver` with react-hook-form
- Provide clear, user-friendly error messages in schema
- Schema serves as single source of truth for validation

### Form State Management

**Rule:** Forms MUST manage loading, error, and success states explicitly. Reset form on successful submission.

**Example:**

```tsx
export default function ProductCreateModal() {
  const [createSuccess, setCreateSuccess] = useState<string | null>(null);

  const {
    createProduct,
    isLoading: isCreating,
    error: createError,
  } = useProducts();

  const onSubmit = async (data: ProductCreateFormValues) => {
    setCreateSuccess(null);
    const product = await createProduct(data);
    if (product) {
      form.reset();
      setCreateSuccess("Product created successfully");
    }
  };
  // ...
}
```

**Implementation:**

- Track success state locally (not from context)
- Clear success state before new submission
- Reset form on successful submission
- Display error messages from context
- Display success messages locally
- Disable form inputs during submission (`disabled={isCreating}`)

## API Client Standards

### Centralized API Instance

**Rule:** All API calls MUST use a centralized axios instance from `lib/api.ts`. Never create ad-hoc axios instances.

**Examples:**

- **Good:** `import { api } from "@/lib/api"; await api.post("/auth/login", payload);`
- **Bad:** Creating new axios instances in components or hooks

**Implementation:**

- Single axios instance exported from `lib/api.ts`
- Instance configured with base URL, headers, credentials
- Response interceptors handle token refresh and error transformation

### Automatic Token Refresh

**Rule:** The API client MUST handle automatic token refresh for 401 errors. Failed requests during refresh must be queued and retried after refresh completes.

**Implementation:**

- Response interceptor detects 401 errors
- Automatically calls refresh endpoint
- Queues failed requests during refresh
- Retries queued requests after successful refresh
- Redirects to login if refresh fails (unless on public route)
- Prevents multiple simultaneous refresh calls

### Error Message Transformation

**Rule:** API errors MUST transform backend `detail` messages into user-friendly error messages.

**Implementation:**

- Interceptor checks for `error.response.data.detail`
- Transforms error message to use API detail
- Falls back to default error message if detail not present
- Context operations extract error messages: `error instanceof Error ? error.message : "Default message"`

## Type Safety Standards

### Explicit Type Definitions

**Rule:** All components, functions, and variables MUST have explicit TypeScript types. Avoid `any` type except when absolutely necessary.

**Examples:**

- **Good:** `const [products, setProducts] = useState<Product[]>([]);`
- **Good:** `function handleClick(id: string): void { ... }`
- **Good:** `type ProductCardProps = { product: Product; onView?: (id: string) => void; };`
- **Bad:** `const [products, setProducts] = useState([]);` (missing type)

**Implementation:**

- Always type function parameters and return types
- Type useState with generic: `useState<Type>(initialValue)`
- Type props interfaces explicitly
- Use `type` keyword for type-only imports
- Avoid `any` - use `unknown` or proper types instead

### API Type Generation

**Rule:** API types MUST be generated from OpenAPI schema and stored in `types/api.ts`. Never manually define API request/response types.

**Examples:**

- **Good:** `export type Product = components["schemas"]["Product"];`
- **Bad:** Manually defining `type Product = { id: string; name: string; ... }`

**Implementation:**

- Use OpenAPI code generation tool (e.g., `npm run generate-types`)
- Import types from generated `openapi.d.ts` file
- Re-export types from `types/api.ts` for convenience
- Never manually define types that match backend schemas

## Component Composition Standards

### UI Component Reusability

**Rule:** UI components MUST be domain-agnostic and highly reusable. Domain components compose UI components.

**Examples:**

- **Good:** `CustomLink` used in `ProductCard`, `OrderCard`, `UserCard`
- **Good:** `LoadingSkeleton` used across all pages
- **Bad:** UI component that includes domain-specific logic

**Implementation:**

- UI components accept generic props (no domain-specific types)
- Domain components use UI components for presentation
- UI components handle interaction patterns
- Domain components handle business logic and data

### Page Component Structure

**Rule:** Page components MUST follow a consistent structure: Header, Separator, Content sections. Use semantic HTML.

**Example:**

```tsx
export default function Home() {
  return (
    <section>
      {/* Header */}
      <Header title="Products" subtitle="Browse our catalog" />

      {/* Separator */}
      <Separator />

      {/* Content */}
      <div>{/* ... */}</div>
    </section>
  );
}
```

**Implementation:**

- Use semantic HTML: `<section>`, `<header>`, `<footer>`
- Comment sections for clarity
- Apply responsive layout per the active design system

## Performance Standards

### Conditional Rendering for Performance

**Rule:** Heavy graphics or animations MUST be conditionally rendered based on viewport size to improve mobile performance.

**Example:**

```tsx
const GRAPHICS_BREAKPOINT = 1024; // Adjust based on performance requirements

export default function MainLayout() {
  // NOTE: Selectively render graphics to improve mobile performance
  const { width: windowWidth } = useWindowSize();
  const renderGraphics = windowWidth >= GRAPHICS_BREAKPOINT;

  return (
    <div>
      {renderGraphics && <HeavyGraphicsComponent />}
      {/* ... */}
    </div>
  );
}
```

**Implementation:**

- Use `useWindowSize` hook to detect viewport size
- Define breakpoint constants at component level
- Conditionally render heavy components
- Add NOTE comments explaining performance decisions

### Loading State Management

**Rule:** Components MUST prevent duplicate API calls by checking loading state and existing data before fetching.

**Example:**

```tsx
useEffect(() => {
  const fetchProducts = async () => {
    if (products.length) {
      return; // Already have data
    }
    await getAllProducts();
  };
  fetchProducts();
}, [getAllProducts]);
```

**Implementation:**

- Check if data already exists before fetching
- Use loading states to prevent duplicate requests
- Include NOTE comments explaining dependency array decisions
- Use referentially stable functions (useCallback) in dependency arrays

## Error Handling Standards

### User-Friendly Error Messages

**Rule:** Error messages MUST be user-friendly and extracted from API responses. Display errors prominently but non-intrusively.

**Example:**

```tsx
{createError && (
  <div>{createError}</div>
)}
```

**Implementation:**

- Extract error messages: `error instanceof Error ? error.message : "Default message"`
- Display errors in visible but non-blocking UI elements
- Clear error state before new operations
- Show success messages similarly for positive feedback

### Error State Management

**Rule:** Error states MUST be cleared before new operations. Errors should not persist after user actions.

**Implementation:**

- Clear error state at start of operations: `setError(null)`
- Clear success state before new submissions: `setCreateSuccess(null)`
- Errors come from context, success states managed locally
- Use finally blocks to ensure state cleanup

## Documentation Standards

### Comments

**Rule:** Use "NOTE:" comments for important implementation details, architectural decisions, and non-obvious code behavior. Include inline comments for complex logic.

**Example:**

```tsx
// NOTE: isLoading is set to true to prevent premature redirects
//       before initial verification
const [isLoading, setIsLoading] = useState(true);

// NOTE: The products state is not referentially stable, so we don't include it
//       in the dependency array. If can be made stable using useMemo + deep
//       comparison, but this is computationally expensive.
useEffect(() => {
  fetchProducts();
}, [getAllProducts]);
```

**Implementation:**

- Use "NOTE:" prefix for important implementation details
- Explain non-obvious decisions (dependency arrays, state initialization)
- Document performance considerations
- Keep comments concise but informative

## See Also

- `examples.md` - Code examples demonstrating these standards in practice
- `developer.md` - Developer persona and workflow
- `files.md` - Recommended file structure and organization
