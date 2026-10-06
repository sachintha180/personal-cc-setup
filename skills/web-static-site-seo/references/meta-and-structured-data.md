# Meta tags and structured data

## Essential meta tags

**Rule:** Include all essential meta tags in the `<head>` section of
`index.html` for a proper SEO foundation.

**Pattern:** Structure meta tags in logical groups: charset, viewport, title,
description, keywords, robots, and canonical.

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
- **`title`** - Should include brand name and primary message (50-60
  characters)
- **`description`** - Compelling summary for search results (150-160
  characters)
- **`keywords`** - Relevant terms (use sparingly, not primary ranking factor)
- **`robots`** - Control search engine indexing (`index, follow` for public
  pages)
- **`canonical`** - Prevents duplicate content issues

## Open Graph tags

**Rule:** Implement Open Graph meta tags for optimal social media sharing and
rich previews.

**Pattern:** Include `og:title`, `og:description`, `og:type`, `og:url`,
`og:site_name`, `og:image`, and `og:locale`.

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

- **`og:image`** - Use a 1200x630px image for best results
- **`og:locale`** - Use the correct locale code (for example, `en_US`,
  `en_GB`)
- All Open Graph tags must match or complement your meta tags

## Twitter Card tags

**Rule:** Add Twitter Card meta tags for optimized Twitter sharing
experiences.

**Pattern:** Use `twitter:card`, `twitter:site`, `twitter:title`,
`twitter:description`, `twitter:image`, and `twitter:creator`.

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

## JSON-LD structured data

**Rule:** Implement JSON-LD structured data for enhanced search result
features and rich snippets.

**Pattern:** Add a structured data script tag in the `<head>` section with
the correct schema.org types.

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

- Use the correct schema type: `Organization`, `LocalBusiness`, `WebSite`,
  `Article`, and others
- Include all relevant business information
- Keep URLs absolute (full domain)
- Validate the markup with
  [Google's Rich Results Test](https://search.google.com/test/rich-results)
