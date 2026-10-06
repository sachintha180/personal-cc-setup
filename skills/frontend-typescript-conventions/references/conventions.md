# TypeScript conventions

## Code spacing

Rule: Put one blank line before every `return` statement. Put one blank line
between logical code blocks.

- Group related code together.
- Separate logical sections with a blank line.
- Keep the spacing consistent across the codebase.

## Import organization

Rule: Put all imports at the top of the file. Group them in this order:

1. Standard library imports.
2. Third-party imports.
3. Local imports.

Use the `type` keyword for type-only imports.

Example: a third-party import followed by local imports.

```ts
import * as z from "zod";

import { api } from "@/lib/api";
import { formatPrice } from "@/lib/products/utils";

import type { Product, ProductCreateRequest } from "@/types/api";
import type { PageItem } from "@/types/common";
```

## Type safety

Rule: Give every function, parameter, return value, and variable an explicit
TypeScript type. Avoid `any`.

- Always type function parameters and return types.
- Use `unknown` or a proper type in place of `any`.
- Use `any` only when no other type works.

Example: a typed function.

```ts
function handleClick(id: string): void { ... }
```

### API type generation

Rule: Generate API types from the OpenAPI schema. Store them in
`types/api.ts`. Never define API request or response types by hand.

- Use an OpenAPI code generation tool, for example `npm run generate-types`.
- Import types from the generated `openapi.d.ts` file.
- Re-export the types from `types/api.ts`.

Example:

```ts
export type Product = components["schemas"]["Product"];
```

## Comments

Rule: Write no comment except a non-obvious WHY.

- A comment explains why the code does something that the code cannot show.
- Do not write a comment that restates what the code does.
- Do not add a comment to framework-generated, scaffolded, or vendored files.
- A linter or type-checker pragma is a functional directive. Keep it.
