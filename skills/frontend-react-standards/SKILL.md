---
name: frontend-react-standards
description: Build rules for a React and TypeScript frontend on Vite, with Context API state, Axios, and react-hook-form with zod. Use for "add a React component", "add a context provider", "add a form", "call the API", or "where does this file go".
---

# React frontend standards

This skill defines how to build a React and TypeScript frontend. It covers
naming, exports, context providers, forms, the API client, composition,
performance, and file layout.

## Stack

- Vite as the build tool.
- react-router-dom with `BrowserRouter`.
- Context API only for global state.
- Axios through one shared instance.
- react-hook-form with zod for forms.
- OpenAPI-generated types for API contracts.

## Reference files

| File                                               | Load it when                                                                              |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| [references/standards.md](references/standards.md) | You write or review a component, context, hook, form, API call, or error path.            |
| [references/examples.md](references/examples.md)   | You need a code sample to copy for a component, context, form, API client, or route tree. |
| [references/files.md](references/files.md)         | You decide where a file goes, or you set up the root config files and ESLint.             |

## Related skills

Stack-neutral TypeScript rules live in the frontend-typescript-conventions
skill. Static-site SEO lives in the web-static-site-seo skill.
