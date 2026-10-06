---
name: web-static-site-seo
description: SEO rules for static sites: meta tags, Open Graph, Twitter cards, JSON-LD, semantic HTML, performance, and security headers. Use when the user asks to "add meta tags", "add JSON-LD", "improve SEO", or "add Open Graph".
---

# Static site SEO

This skill gives SEO rules and examples for static sites. It covers the head
tags, structured data, HTML structure, images, performance, accessibility,
and security headers.

## Scope

The guide targets static sites with a hand-edited `index.html` head and a
`_headers` file. It has no per-route meta guidance for a client-side
single-page app. If the task needs per-route meta tags, tell the user that
this skill does not cover it.

## Reference files

| File                                                                                   | Load when                                                                                             |
| -------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- |
| [references/meta-and-structured-data.md](references/meta-and-structured-data.md)       | You edit the head: title, description, canonical, robots, Open Graph, Twitter cards, or JSON-LD.      |
| [references/html-and-media.md](references/html-and-media.md)                           | You edit page structure: semantic elements, heading hierarchy, images, alt text, or lazy loading.     |
| [references/performance-access-security.md](references/performance-access-security.md) | You work on FCP, LCP, CLS, color contrast, keyboard use, ARIA, mobile layout, or the `_headers` file. |
| [references/checklist.md](references/checklist.md)                                     | You finish an SEO task and need the validation tools and the final checklist.                         |
