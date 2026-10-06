# File structure

Naming and export rules are in [standards.md](standards.md). Code samples are
in [examples.md](examples.md). The ESLint config is at
[../assets/eslint.config.js](../assets/eslint.config.js). Copy it to the
project root as `eslint.config.js`.

## Directory tree

```
frontend/
|-- .git/                   # Git version control
|-- node_modules/           # Node.js dependencies
|-- dist/                   # Build output
|-- public/                 # Static assets
|-- src/
|   |-- components/         # React components
|   |   |-- ui/             # Reusable UI components
|   |   |-- layouts/        # Layout components
|   |   |-- skeletons/      # Loading skeleton components
|   |   `-- {domain}/       # Domain-specific components
|   |-- contexts/           # React Context providers
|   |   `-- hooks/          # Context-specific hooks
|   |-- hooks/              # Shared custom hooks
|   |-- lib/                # Utility functions and helpers
|   |   `-- {domain}/       # Domain-specific utilities
|   |-- pages/              # Page components (routes)
|   |   `-- {domain}/       # Domain-specific pages
|   |-- types/              # TypeScript type definitions
|   |-- App.tsx             # Main application component
|   |-- main.tsx            # Application entry point
|   `-- index.css           # Global styles
|-- index.html              # HTML template
|-- package.json            # Node.js dependencies and scripts
|-- tsconfig.json           # TypeScript configuration
|-- vite.config.ts          # Vite build configuration
|-- eslint.config.js        # ESLint configuration
|-- prettier.config.js      # Prettier configuration
`-- .gitignore              # Git ignore rules
```

## Root files

- `index.html`: HTML template and entry point of the application.
- `package.json`: npm packages and build and dev commands.
- `tsconfig.json`: TypeScript compiler options and path aliases.
- `vite.config.ts`: Vite build tool, plugins, and development server.
- `eslint.config.js`: ESLint rules for code quality. A sample is in
  [../assets/eslint.config.js](../assets/eslint.config.js).
- `prettier.config.js`: Prettier formatting rules.
- `.gitignore`: build artifacts, dependencies, and environment files to
  exclude from Git.

## public

Static assets served without processing.

- `favicon.ico`: site favicon.
- `*.png`, `*.svg`, `*.jpg`: images, logos, and other static assets.

Reference a file in `public` with an absolute path. Example: `/logo.png`. Use
it for assets that need no bundling.

## src/components

React component definitions. Organized by component type and domain.

### components/ui

Reusable, generic UI components.

- File: `{component-name}.tsx`. Use kebab-case.
- The component is domain-agnostic and has a default export.
- The props type uses PascalCase. Example: `ListItemProps`.

```
/components/ui
  - list-item.tsx          # ListItem component
  - underlining-link.tsx   # UnderliningLink component
  - page-button.tsx        # PageButton component
  - separator.tsx          # Separator component
```

### components/layouts

Layout components that wrap pages and define page structure.

- File: `{LayoutName}.tsx`. Use PascalCase. Examples: `MainLayout.tsx`,
  `DashboardLayout.tsx`, `AuthLayout.tsx`.
- `ProtectedRoute.tsx` wraps a route that needs authentication.
- `RedirectRoute.tsx` redirects a route.
- `NotFound.tsx` is the 404 page component.
- A layout handles the routing structure and nested routes. It has a default
  export.

### components/skeletons

Loading skeleton components.

- File: `{SkeletonName}.tsx`. Use PascalCase. Example: `LoadingSkeleton.tsx`.
- A skeleton is a reusable loading state with a default export.

### components/{domain}

Components tied to one feature or business domain.

- File: `{ComponentName}.tsx`. Use PascalCase. Examples: `LoginModal.tsx`,
  `ProductCard.tsx`, `OrderListItem.tsx`.
- A domain component has a default export.
- The props type uses PascalCase. Example: `LoginModalProps`.

```
/components/products
  - ProductCard.tsx         # ProductCard component
  - ProductListItem.tsx     # ProductListItem component
  - ProductFilter.tsx       # ProductFilter component

/components/auth
  - LoginModal.tsx          # LoginModal component
  - RegisterModal.tsx       # RegisterModal component
  - PasswordResetForm.tsx   # PasswordResetForm component
```

## src/contexts

React Context providers for global state.

- File: `{ContextName}Context.tsx`. It holds the Provider and the hook.
  Examples: `AuthContext.tsx`, `UserContext.tsx`.
- `index.ts` is a barrel export file for all contexts.
- `hooks/` holds the context-specific hooks.
- Use one context file per domain or feature.
- Export the Provider as the default and the hook as a named export. Examples:
  `AuthProvider`, `useAuth`.
- Each context has three hooks: `use{Context}State`, `use{Context}API`, and
  `use{Context}Operations`.

```
/contexts
  - AuthContext.tsx         # AuthProvider, useAuth
  - UserContext.tsx         # UserProvider, useUser
  - ProductContext.tsx      # ProductProvider, useProduct
  - index.ts                # Barrel exports
  /hooks
    - useAuthState.ts       # Auth state management
    - useAuthAPI.ts         # Auth API calls
    - useAuthOperations.ts  # Auth business logic
    - index.ts              # Hook exports
```

## src/hooks

Shared custom hooks used across components.

- File: `use{HookName}.ts`. Use camelCase with the `use` prefix. Examples:
  `useWindowSize.ts`, `useElementSize.ts`.
- A hook is reusable and not tied to a domain. It has a named export.
- Use subfolders when the folder grows.

```
/hooks
  - useWindowSize.ts        # Window size hook
  - useElementSize.ts       # Element size hook
  - useDebounce.ts          # Debounce hook
```

## src/lib

Utility functions, helpers, and domain-specific logic.

- `api.ts` holds the centralized API client: the Axios instance and the
  interceptors.
- `{domain}/` folders hold domain utilities and constants.
- Functions and constants use named exports.

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

## src/pages

Page components that match the routes of the application.

- File: `{PageName}.tsx`. Use PascalCase. Examples: `Home.tsx`,
  `Dashboard.tsx`.
- Use one page component per route. Use `{domain}/` folders for domain pages.
- A page can have nested folders for sub-routes.
- A page has a default export. It composes components and handles page-level
  logic.

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

## src/types

TypeScript type definitions and declarations.

- `api.ts` holds the API contract types generated from the OpenAPI schema. The
  name is reserved.
- `{domain}.ts` holds domain-specific types. Example: `miscellaneous.ts`.
- `*.d.ts` holds declarations for third-party libraries or global types.
- Types use named exports.

```
/types
  - api.ts                  # API contract types (OpenAPI generated)
  - common.ts               # Common shared types
  - ui.d.ts                 # UI library type declarations
  - openapi.d.ts            # OpenAPI schema types
```

## src root files

- `App.tsx`: main application component. Defines the routing structure and the
  provider hierarchy.
- `main.tsx`: application entry point. Renders the root component.
- `index.css`: global styles.
