# Recommended File Structure

## Complete Directory Tree

```
frontend/
├── .git/                   # Git version control
├── node_modules/           # Node.js dependencies
├── dist/                   # Build output
├── public/                 # Static assets
├── src/
│   ├── components/         # React components
│   │   ├── ui/             # Reusable UI components
│   │   ├── layouts/        # Layout components
│   │   ├── skeletons/      # Loading skeleton components
│   │   └── {domain}/       # Domain-specific components
│   ├── contexts/           # React Context providers
│   │   └── hooks/          # Context-specific hooks
│   ├── hooks/              # Shared custom hooks
│   ├── lib/                # Utility functions and helpers
│   │   └── {domain}/       # Domain-specific utilities
│   ├── pages/              # Page components (routes)
│   │   └── {domain}/       # Domain-specific pages
│   ├── types/              # TypeScript type definitions
│   ├── App.tsx             # Main application component
│   ├── main.tsx            # Application entry point
│   └── index.css           # Global styles
├── index.html              # HTML template
├── package.json            # Node.js dependencies and scripts
├── tsconfig.json           # TypeScript configuration
├── vite.config.ts          # Vite build configuration
├── eslint.config.js        # ESLint configuration
├── prettier.config.js      # Prettier configuration
└── .gitignore              # Git ignore rules
```

## Root Directory Files

- **`index.html`** - HTML template. Entry point for the application.
- **`package.json`** - Node.js package dependencies and scripts. Lists all npm packages and build/dev commands.
- **`tsconfig.json`** - TypeScript configuration. Defines compiler options and path aliases.
- **`vite.config.ts`** - Vite build configuration. Configures the build tool, plugins, and development server.
- **`eslint.config.js`** - ESLint configuration. Defines linting rules for code quality.
- **`prettier.config.js`** - Prettier configuration. Defines code formatting rules.
- **`.gitignore`** - Git ignore rules for excluding build artifacts, dependencies, and environment files.

## `/public` Directory

**Purpose:** Static assets served directly without processing.

- **`favicon.ico`** - Site favicon
- **`*.png`, `*.svg`, `*.jpg`** - Images, logos, and other static assets
- Other static files as needed

**Pattern:** Files in `/public` are referenced with absolute paths (e.g., `/logo.png`). Use for assets that don't need processing or bundling.

## `/src/components` Directory

**Purpose:** React component definitions. Organized by component type and domain.

### `/components/ui`

**Purpose:** Reusable, generic UI components used across the application.

- **`{component-name}.tsx`** - UI components (e.g., `list-item.tsx`, `underlining-link.tsx`, `page-button.tsx`)

**Pattern:**

- File names use **kebab-case** (e.g., `list-item.tsx`, `underlining-link.tsx`)
- Components are highly reusable and domain-agnostic
- Default exports for components
- Props interfaces use PascalCase (e.g., `ListItemProps`)

**Example Structure:**

```
/components/ui
  - list-item.tsx          # ListItem component
  - underlining-link.tsx   # UnderliningLink component
  - page-button.tsx        # PageButton component
  - seperator.tsx          # Seperator component
```

### `/components/layouts`

**Purpose:** Layout components that wrap pages and define page structure.

- **`{LayoutName}.tsx`** - Layout components (e.g., `MainLayout.tsx`, `DashboardLayout.tsx`, `AuthLayout.tsx`)
- **`ProtectedRoute.tsx`** - Route protection wrapper
- **`RedirectRoute.tsx`** - Route redirection wrapper
- **`NotFound.tsx`** - 404 error page component

**Pattern:**

- File names use **PascalCase** (e.g., `MainLayout.tsx`, `DashboardLayout.tsx`)
- Layouts handle routing structure and nested routes
- Default exports for components

### `/components/skeletons`

**Purpose:** Loading skeleton components for better UX during data fetching.

- **`{SkeletonName}.tsx`** - Skeleton components (e.g., `LoadingSkeleton.tsx`)

**Pattern:**

- File names use **PascalCase**
- Reusable loading states
- Default exports for components

### `/components/{domain}`

**Purpose:** Domain-specific components tied to a particular feature or business domain.

- **`{ComponentName}.tsx`** - Domain components (e.g., `LoginModal.tsx`, `ProductCard.tsx`, `OrderListItem.tsx`)

**Pattern:**

- File names use **PascalCase** (e.g., `LoginModal.tsx`, `ProductCreateModal.tsx`, `OrderListItem.tsx`)
- Components are specific to a domain/feature
- Default exports for components
- Props interfaces use PascalCase (e.g., `LoginModalProps`, `ProductCardProps`)

**Example Structure:**

```
/components/products
  - ProductCard.tsx          # ProductCard component
  - ProductListItem.tsx     # ProductListItem component
  - ProductFilter.tsx       # ProductFilter component

/components/auth
  - LoginModal.tsx          # LoginModal component
  - RegisterModal.tsx       # RegisterModal component
  - PasswordResetForm.tsx   # PasswordResetForm component
```

## `/src/contexts` Directory

**Purpose:** React Context providers for global state management.

- **`{ContextName}Context.tsx`** - Context provider and hook (e.g., `AuthContext.tsx`, `UserContext.tsx`)
- **`index.ts`** - Barrel export file for all contexts
- **`hooks/`** - Context-specific hooks directory

**Pattern:**

- One context file per domain/feature
- Context files export both Provider component and custom hook (e.g., `AuthProvider`, `useAuth`)
- Contexts use a three-hook pattern:
  - `use{Context}State` - Manages local state
  - `use{Context}API` - Handles API calls
  - `use{Context}Operations` - Combines state and API for business logic
- Default exports for Provider components, named exports for hooks

**Example Structure:**

```
/contexts
  - AuthContext.tsx         # AuthProvider, useAuth
  - UserContext.tsx        # UserProvider, useUser
  - ProductContext.tsx     # ProductProvider, useProduct
  - index.ts               # Barrel exports
  /hooks
    - useAuthState.ts      # Auth state management
    - useAuthAPI.ts        # Auth API calls
    - useAuthOperations.ts # Auth business logic
    - index.ts             # Hook exports
```

## `/src/hooks` Directory

**Purpose:** Shared custom React hooks used across multiple components.

- **`use{HookName}.ts`** - Custom hooks (e.g., `useWindowSize.ts`, `useElementSize.ts`)

**Pattern:**

- File names use **camelCase** with `use` prefix
- Hooks are reusable and not tied to a specific domain
- Can have subfolders for organization if needed
- Named exports for hooks

**Example Structure:**

```
/hooks
  - useWindowSize.ts        # Window size hook
  - useElementSize.ts        # Element size hook
  - useDebounce.ts           # Debounce hook
```

## `/src/lib` Directory

**Purpose:** Utility functions, helpers, and domain-specific logic.

- **`{utility}.ts`** - Shared utilities (e.g., `api.ts` for API client configuration)
- **`{domain}/`** - Domain-specific utilities

**Pattern:**

- `api.ts` - Centralized API client configuration (axios instance, interceptors)
- Domain folders contain domain-specific utilities and constants
- Named exports for functions and constants

**Example Structure:**

```
/lib
  - api.ts                  # API client configuration
  /products
    - constants.ts          # Product constants
    - utils.ts              # Product utilities
    - formatters.ts         # Product formatting functions
  /orders
    - constants.ts          # Order constants
    - utils.ts              # Order utilities
    - validators.ts         # Order validation functions
```

## `/src/pages` Directory

**Purpose:** Page components that correspond to routes in the application.

- **`{PageName}.tsx`** - Page components (e.g., `Home.tsx`, `Dashboard.tsx`)
- **`{domain}/`** - Domain-specific pages

**Pattern:**

- File names use **PascalCase**
- One page component per route
- Pages can have nested folders for sub-routes (e.g., `syllabus/AddSyllabus.tsx`)
- Default exports for page components
- Pages compose components and handle page-level logic

**Example Structure:**

```
/pages
  /products
    - Home.tsx              # Products home page
    - List.tsx              # Product list page
    - Detail.tsx            # Product detail page
  /orders
    - Dashboard.tsx         # Orders dashboard
    - Create.tsx            # Create order page
    /{id}
      - View.tsx            # View order page
      - Edit.tsx            # Edit order page
```

## `/src/types` Directory

**Purpose:** TypeScript type definitions and type declarations.

- **`api.ts`** - API contract types (generated from OpenAPI schema)
- **`{domain}.ts`** - Domain-specific types
- **`*.d.ts`** - Type declaration files for third-party libraries or global types

**Pattern:**

- `api.ts` - Reserved filename for API contract types (generated from OpenAPI)
- Domain-specific types in separate files (e.g., `miscellaneous.ts`)
- Type declaration files use `.d.ts` extension
- Named exports for types and interfaces

**Example Structure:**

```
/types
  - api.ts                  # API contract types (OpenAPI generated)
  - common.ts               # Common shared types
  - ui.d.ts                 # UI library type declarations
  - openapi.d.ts           # OpenAPI schema types
```

## `/src` Root Files

- **`App.tsx`** - Main application component. Defines routing structure and provider hierarchy.
- **`main.tsx`** - Application entry point. Renders the root component and initializes the app.
- **`index.css`** - Global styles.

## See Also

- `standards.md` - Coding standards and conventions
- `developer.md` - Developer persona and workflow
- `examples.md` - Code examples demonstrating patterns
