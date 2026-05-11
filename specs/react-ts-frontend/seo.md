# SEO Optimization Guide for Static Sites

## HTML Meta Tags

### Essential Meta Tags

**Rule:** Include all essential meta tags in the `<head>` section of `index.html` for proper SEO foundation.

**Pattern:** Structure meta tags in logical groups: charset, viewport, title, description, keywords, robots, and canonical.

**Example:**

```html
<head>
  <!-- Meta tags -->
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Company Name - Tagline or Key Message</title>

  <!-- Meta tags for SEO -->
  <meta
    name="description"
    content="Clear, concise description of your business or service (150-160 characters)."
  />
  <meta
    name="keywords"
    content="relevant, keyword, list, separated, by, commas"
  />
  <meta name="author" content="Company Name" />
  <meta name="robots" content="index, follow" />
  <link rel="canonical" href="https://www.yourdomain.com" />
</head>
```

**Implementation:**

- **`charset="UTF-8"`** - Ensures proper character encoding
- **`viewport`** - Essential for mobile responsiveness
- **`title`** - Should include brand name and primary message (50-60 characters)
- **`description`** - Compelling summary for search results (150-160 characters)
- **`keywords`** - Relevant terms (use sparingly, not primary ranking factor)
- **`robots`** - Control search engine indexing (`index, follow` for public pages)
- **`canonical`** - Prevents duplicate content issues

## Open Graph Tags

**Rule:** Implement Open Graph meta tags for optimal social media sharing and rich previews.

**Pattern:** Include `og:title`, `og:description`, `og:type`, `og:url`, `og:site_name`, `og:image`, and `og:locale`.

**Example:**

```html
<!-- Open Graph tags for social media -->
<meta property="og:title" content="Company Name - Tagline or Key Message" />
<meta
  property="og:description"
  content="Compelling description for social media previews."
/>
<meta property="og:type" content="website" />
<meta property="og:url" content="https://www.yourdomain.com" />
<meta property="og:site_name" content="Company Name" />
<meta property="og:image" content="/og-image.png" />
<meta property="og:locale" content="en_US" />
```

**Implementation:**

- **`og:image`** - Use 1200x630px image for best results
- **`og:locale`** - Use appropriate locale code (e.g., `en_US`, `en_GB`)
- All Open Graph tags should match or complement your meta tags

## Twitter Card Tags

**Rule:** Add Twitter Card meta tags for optimized Twitter sharing experiences.

**Pattern:** Use `twitter:card`, `twitter:site`, `twitter:title`, `twitter:description`, `twitter:image`, and `twitter:creator`.

**Example:**

```html
<!-- Twitter tags for social media -->
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:site" content="@yourhandle" />
<meta name="twitter:title" content="Company Name - Tagline or Key Message" />
<meta
  name="twitter:description"
  content="Compelling description for Twitter previews."
/>
<meta name="twitter:image" content="/og-image.png" />
<meta name="twitter:creator" content="@yourhandle" />
```

**Implementation:**

- **`twitter:card`** - Use `summary_large_image` for visual impact
- **`twitter:image`** - Minimum 1200x675px recommended
- Keep Twitter tags consistent with Open Graph tags

## JSON-LD Structured Data

**Rule:** Implement JSON-LD structured data for enhanced search result features and rich snippets.

**Pattern:** Add structured data script tag in the `<head>` section with appropriate schema.org types.

**Example:**

```html
<!-- JSON-LD Structured Data for SEO -->
<script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": "Company Name",
    "url": "https://www.yourdomain.com",
    "logo": "https://www.yourdomain.com/logo.png",
    "description": "Company description for structured data.",
    "sameAs": ["https://instagram.com/company", "https://twitter.com/company"],
    "contactPoint": {
      "@type": "ContactPoint",
      "email": "contact@company.com",
      "contactType": "customer service"
    },
    "areaServed": "Worldwide",
    "serviceType": ["Service One", "Service Two", "Service Three"]
  }
</script>
```

**Implementation:**

- Use appropriate schema types: `Organization`, `LocalBusiness`, `WebSite`, `Article`, etc.
- Include all relevant business information
- Keep URLs absolute (full domain)
- Validate using [Google's Rich Results Test](https://search.google.com/test/rich-results)

## Semantic HTML Structure

**Rule:** Use semantic HTML elements to improve search engine understanding and accessibility.

**Pattern:** Structure pages with semantic elements like `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<aside>`, and `<footer>`.

**Example:**

```tsx
export default function Index() {
  return (
    <div>
      <Navbar />
      <main>
        <HeroSection />
        <ServicesSection />
        <WhySection />
        <CTASection />
      </main>
      <Footer />
    </div>
  );
}
```

**Implementation:**

- Use `<main>` for primary content (only one per page)
- Use `<section>` for distinct content areas with headings
- Use `<nav>` for navigation elements
- Use `<header>` and `<footer>` appropriately
- Maintain proper heading hierarchy (h1 -> h2 -> h3, etc.)

## Image Optimization

**Rule:** Optimize all images for performance and include descriptive alt text for accessibility and SEO.

**Pattern:** Use appropriate image formats, sizes, and always include meaningful alt attributes.

**Example:**

```tsx
// Good - descriptive alt text
<img
  src="/services-banner.png"
  alt="Creative team collaborating on digital marketing strategy"
/>

// Good - decorative images with empty alt
<img src="/shape.png" alt="" />
```

**Implementation:**

- **Alt text** - Descriptive for informative images, empty (`alt=""`) for decorative images
- **Image formats** - Use WebP when possible, fallback to PNG/JPG
- **Responsive images** - Use `srcset` for multiple resolutions
- **Lazy loading** - Add `loading="lazy"` for below-fold images
- **Image dimensions** - Specify `width` and `height` to prevent layout shift

## Performance Optimization

### Reduce Time to First Contentful Paint (FCP)

**Rule:** Minimize render-blocking resources and optimize critical rendering path.

**Implementation:**

- **Minimize CSS** - Remove unused CSS, use CSS purging
- **Inline critical CSS** - For above-fold content
- **Defer non-critical CSS** - Load below-fold styles asynchronously
- **Optimize fonts** - Use `font-display: swap`, preload critical fonts
- **Minimize JavaScript** - Code splitting, lazy loading, tree shaking
- **Asset compression** - Use gzip/brotli compression on server

### Reduce Largest Contentful Paint (LCP)

**Rule:** Optimize the largest content element on the page for faster loading.

**Implementation:**

- **Optimize hero images** - Compress, use next-gen formats, appropriate sizing
- **Preload critical resources** - Use `<link rel="preload">` for LCP images
- **Reduce server response time** - Optimize backend, use CDN, edge caching
- **Eliminate render-blocking resources** - Defer non-critical CSS/JS
- **Optimize fonts** - Preload critical fonts, use font-display: swap

### Reduce Cumulative Layout Shift (CLS)

**Rule:** Reserve space for dynamic content to prevent unexpected layout shifts.

**Implementation:**

- **Image dimensions** - Always specify `width` and `height` attributes
- **Ad slots** - Reserve space for advertisements
- **Dynamic content** - Reserve space or use skeleton loaders
- **Fonts** - Use `font-display: swap` with appropriate fallbacks
- **Avoid insertions above content** - Don't inject content above existing content

## Accessibility Best Practices

### Color Contrast

**Rule:** Ensure text meets WCAG AA contrast ratios (4.5:1 for normal text, 3:1 for large text).

**Implementation:**

- Test contrast ratios using tools like [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- Use high contrast mode for critical information
- Don't rely solely on color to convey information

### Keyboard Navigation

**Rule:** Ensure all interactive elements are keyboard accessible.

**Implementation:**

- **Focus indicators** - Visible focus states for all interactive elements
- **Tab order** - Logical tab sequence through page
- **Skip links** - Allow users to skip to main content
- **Keyboard shortcuts** - Support standard shortcuts (Enter, Space, Escape)

### ARIA Labels

**Rule:** Use ARIA attributes when semantic HTML is insufficient.

**Implementation:**

- **`aria-label`** - Provide accessible name when text is not visible
- **`aria-describedby`** - Link descriptive text to elements
- **`aria-hidden`** - Hide decorative elements from screen readers
- **`role`** - Define element role when semantics are unclear

**Example:**

```tsx
<button aria-label="Close navigation menu" onClick={handleClose}>
  <IconX aria-hidden="true" />
</button>
```

## Mobile Optimization

**Rule:** Ensure site is fully responsive and mobile-friendly.

**Implementation:**

- **Viewport meta tag** - Always include `<meta name="viewport" content="width=device-width, initial-scale=1.0">`
- **Responsive images** - Use `srcset` and `sizes` attributes
- **Touch targets** - Minimum 44x44px for interactive elements
- **Readable text** - Minimum 16px font size, avoid horizontal scrolling
- **Mobile-first CSS** - Use mobile-first breakpoints

## Security Headers

**Rule:** Implement security headers for improved SEO and security.

**Implementation:**

Configure these headers on your server or in `_headers` file (for static hosting):

```
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: geolocation=(), microphone=(), camera=()
```

## Validation and Testing

**Rule:** Validate and test SEO implementations regularly.

**Tools:**

- **Google Search Console** - Monitor search performance and issues
- **Google Rich Results Test** - Validate structured data
- **PageSpeed Insights** - Measure performance metrics
- **Lighthouse** - Comprehensive SEO, performance, and accessibility audit
- **W3C Markup Validator** - Validate HTML structure
- **Wave** - Accessibility testing tool

## Checklist

Use this checklist when implementing SEO for a static site:

### HTML

- [ ] Meta charset and viewport tags
- [ ] Descriptive title tag (50-60 characters)
- [ ] Meta description (150-160 characters)
- [ ] Canonical URL
- [ ] Open Graph tags
- [ ] Twitter Card tags
- [ ] JSON-LD structured data
- [ ] Favicon and touch icons

### Performance

- [ ] Image optimization (format, size, lazy loading)
- [ ] Font preloading for critical fonts
- [ ] Minimized CSS and JavaScript
- [ ] Asset compression enabled

### Accessibility

- [ ] Semantic HTML structure
- [ ] Proper heading hierarchy
- [ ] Alt text for all images
- [ ] Keyboard navigation support
- [ ] Color contrast compliance
- [ ] ARIA labels where needed

### Testing

- [ ] Lighthouse audit (90+ scores)
- [ ] Mobile responsiveness
- [ ] Cross-browser compatibility
- [ ] Structured data validation
- [ ] Accessibility testing
