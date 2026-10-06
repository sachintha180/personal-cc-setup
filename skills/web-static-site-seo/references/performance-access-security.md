# Performance, accessibility, mobile, and security headers

## Performance optimization

### Reduce Time to First Contentful Paint (FCP)

**Rule:** Minimize render-blocking resources and optimize the critical
rendering path.

**Implementation:**

- **Minimize CSS** - Remove unused CSS, use CSS purging
- **Inline critical CSS** - For above-fold content
- **Defer non-critical CSS** - Load below-fold styles asynchronously
- **Optimize fonts** - Use `font-display: swap`, preload critical fonts
- **Minimize JavaScript** - Code splitting, lazy loading, tree shaking
- **Asset compression** - Use gzip/brotli compression on the server

### Reduce Largest Contentful Paint (LCP)

**Rule:** Optimize the largest content element on the page for faster
loading.

**Implementation:**

- **Optimize hero images** - Compress, use next-gen formats, correct sizing
- **Preload critical resources** - Use `<link rel="preload">` for LCP images
- **Reduce server response time** - Optimize backend, use CDN, edge caching

### Reduce Cumulative Layout Shift (CLS)

**Rule:** Reserve space for dynamic content to prevent unexpected layout
shifts.

**Implementation:**

- **Ad slots** - Reserve space for advertisements
- **Dynamic content** - Reserve space or use skeleton loaders
- **Fonts** - Use `font-display: swap` with correct fallbacks
- **Avoid insertions above content** - Do not inject content above existing
  content

## Accessibility best practices

### Color contrast

**Rule:** Make sure text meets WCAG AA contrast ratios (4.5:1 for normal
text, 3:1 for large text).

**Implementation:**

- Test contrast ratios with tools such as [WebAIM Contrast
  Checker](https://webaim.org/resources/contrastchecker/)
- Use high contrast mode for critical information
- Do not use color alone to convey information

### Keyboard navigation

**Rule:** Make sure all interactive elements work with the keyboard.

**Implementation:**

- **Focus indicators** - Visible focus states for all interactive elements
- **Tab order** - Logical tab sequence through the page
- **Skip links** - Let users skip to main content
- **Keyboard shortcuts** - Support standard shortcuts (Enter, Space, Escape)

### ARIA labels

**Rule:** Use ARIA attributes when semantic HTML is not enough.

**Implementation:**

- **`aria-label`** - Give an accessible name when text is not visible
- **`aria-describedby`** - Link descriptive text to elements
- **`aria-hidden`** - Hide decorative elements from screen readers
- **`role`** - Define the element role when semantics are unclear

**Example:** The `tsx` sample shows markup, not a React requirement.

```tsx
<button aria-label="Close navigation menu" onClick={handleClose}>
  <IconX aria-hidden="true" />
</button>
```

## Mobile optimization

**Rule:** Make sure the site is fully responsive and mobile-friendly.

**Implementation:**

- **Touch targets** - Minimum 44x44px for interactive elements
- **Readable text** - Minimum 16px font size, avoid horizontal scrolling
- **Mobile-first CSS** - Use mobile-first breakpoints

## Security headers

**Rule:** Implement security headers for improved SEO and security.

**Implementation:**

Configure these headers on your server or in a `_headers` file (for static
hosting):

```
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: geolocation=(), microphone=(), camera=()
```
