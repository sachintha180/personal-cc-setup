# React frontend standards

Code samples for these rules are in [examples.md](examples.md). File
locations are in [files.md](files.md).

## Architecture

- Build a feature component-first: Pages, then Components, then Contexts,
  then Hooks.
- Keep the layers apart. Pages handle routing and page-level logic.
  Components handle presentation and user interaction. Contexts handle global
  state and business logic. Hooks handle reusable logic.
- Do not mix concerns between layers.
- Follow the patterns in [examples.md](examples.md) and the layout in
  [files.md](files.md). Add a new pattern or directory to those files before
  you use it.

## Naming

### Component files

| Component type | File name  | Example                                    |
| -------------- | ---------- | ------------------------------------------ |
| UI             | kebab-case | `components/ui/custom-link.tsx`            |
| Domain         | PascalCase | `components/products/ProductCard.tsx`      |
| Layout         | PascalCase | `components/layouts/MainLayout.tsx`        |
| Skeleton       | PascalCase | `components/skeletons/LoadingSkeleton.tsx` |

- A UI component is generic and reusable. A domain component belongs to one
  feature.
- Bad: `components/ui/CustomLink.tsx`. A UI file uses kebab-case.
- Bad: `components/products/product-card.tsx`. A domain file uses PascalCase.

### Props interfaces

- Name a props type `{ComponentName}Props` in PascalCase. Example:
  `CustomLinkProps` for `CustomLink`.
- Bad: `CustomLink` (no `Props` suffix). Bad: `customLinkProps` (not
  PascalCase).

### Hooks

- Name a hook file and its function in camelCase with the `use` prefix.
  Example: `useWindowSize.ts` exports `useWindowSize`.
- Bad: `UseWindowSize.ts`. Bad: `windowSize.ts`.

### Type files

- `types/api.ts` is reserved for OpenAPI-generated contract types. Use a
  lowercase name.
- Name domain type files in kebab-case or camelCase. Example:
  `types/common.ts`.
- Use the `.d.ts` extension only for declarations. Example: `types/ui.d.ts`.
- Bad: `types/Api.ts`. Bad: `types/common.d.ts`.

## Imports

- Order local imports as Contexts, Components, Hooks, Lib, then Types.

## Types

- Type `useState` with a generic: `useState<Type>(initialValue)`.

## Exports

| Item                         | Export  |
| ---------------------------- | ------- |
| Component                    | Default |
| Page component               | Default |
| Context Provider             | Default |
| Hook                         | Named   |
| Type                         | Named   |
| Utility function or constant | Named   |

- A component that uses `forwardRef` or another advanced pattern may use a
  named export.
- A context file exports the Provider and the `use{Context}` hook. The hook
  uses a named export.
- The hook throws an error when it is used outside its provider.
- Bad: `export function ProductCard() {}` for a component.
- Bad: `export default function useWindowSize() {}` for a hook.

## Context providers

### Three-hook pattern

Every context uses three hooks.

| Hook                     | Role                                                           |
| ------------------------ | -------------------------------------------------------------- |
| `use{Context}State`      | Holds local state. Returns state values and setters.           |
| `use{Context}API`        | Holds API calls. Wraps each call in `useCallback` with Axios.  |
| `use{Context}Operations` | Combines state and API into business logic with `useCallback`. |

- Use the exact names `State`, `API`, and `Operations`. Bad: `useAuthApi`,
  `useAuthOps`.
- Do not merge the three hooks into one. Do not leave one out.
- The Operations hook takes the state hook result and the API hook result as
  parameters.
- The Provider calls all three hooks. It passes `{ ...state, ...operations }`
  as the context value.
- The Provider does not expose the API hook functions. Consumers reach them
  only through operations.

## Forms

- Use zod schemas with react-hook-form for every form.
- Define the schema before the component.
- Infer the form type with `z.infer<typeof Schema>`.
- Pass the schema to react-hook-form with `zodResolver`.
- Write clear, user-friendly error messages in the schema. The schema is the
  single source of truth for validation.
- Manage loading, error, and success states explicitly.
- Keep the success state in the form component. Take the loading and error
  states from the context.
- Clear the success state before each new submission.
- Reset the form after a successful submission.
- Disable the inputs while a submission runs. Example:
  `disabled={isCreating}`.

## API client

### Centralized instance

- Make every API call through the Axios instance exported from `lib/api.ts`.
- Do not create an Axios instance in a component or a hook.
- Configure the instance with the base URL, the headers, and credentials.
- Read the base URL from a Vite environment variable.
- Handle token refresh and error transformation in response interceptors.

### Token refresh

- Detect a 401 response in the response interceptor.
- Call the refresh endpoint. Do not retry the refresh request itself.
- Retry an original request once. Queue requests that fail during a refresh.
  Allow one refresh call at a time. Example 13 in
  [examples.md](examples.md) shows the flags and the queue.
- When the refresh fails, redirect to the login page. Skip the redirect on a
  public route.

### Error messages

- Read `error.response.data.detail` in the interceptor. Copy it to
  `error.message`.
- Keep the default message when `detail` is absent.

### API types

- Generate API request and response types from the OpenAPI schema. Use a
  script such as `npm run generate-types`.
- Import the generated types from `openapi.d.ts`. Re-export them from
  `types/api.ts`.
- Do not write by hand a type that matches a backend schema.

## Composition

- Make UI components domain-agnostic. They accept generic props and carry no
  domain types.
- Let domain components compose UI components. Domain components own business
  logic and data.
- Give each page the same structure: Header, Separator, then Content.
- Use semantic HTML in a page: `<section>`, `<header>`, `<footer>`.
- Apply the responsive layout of the active design system.

## Performance

- Render heavy graphics and animations only above a viewport breakpoint.
  Detect the width with the `useWindowSize` hook.
- Define the breakpoint as a constant. Example: `GRAPHICS_BREAKPOINT`.
- Check for existing data and the loading state before a fetch. This
  prevents duplicate API calls.
- Wrap a function in `useCallback` when it goes into a dependency array.
- Keep each dependency array exact. Omit a value that is not referentially
  stable, and state the reason in a comment.

## Error handling

- Show an error in a visible element that does not block the page.
- Clear the error state at the start of each operation. Example:
  `setError(null)`.
- Reset the loading state in a `finally` block.
