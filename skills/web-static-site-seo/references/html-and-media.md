# Semantic HTML and images

## Semantic HTML structure

**Rule:** Use semantic HTML elements to help search engines and assistive
tools understand the page.

**Pattern:** Structure pages with semantic elements such as `<header>`,
`<nav>`, `<main>`, `<section>`, `<article>`, `<aside>`, and `<footer>`.

**Example:** The `tsx` sample shows markup, not a React requirement.

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
- Use `<header>` and `<footer>` correctly
- Keep a correct heading hierarchy (h1 -> h2 -> h3, and so on)

## Image optimization

**Rule:** Optimize all images for performance. Include descriptive alt text
for accessibility and SEO.

**Pattern:** Use the correct image formats and sizes. Always include a
meaningful alt attribute.

**Example:** The `tsx` sample shows markup, not a React requirement.

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

- **Alt text** - Descriptive for informative images, empty (`alt=""`) for
  decorative images
- **Image formats** - Use WebP when possible, fall back to PNG/JPG
- **Responsive images** - Use `srcset` and `sizes` attributes for multiple
  resolutions
- **Lazy loading** - Add `loading="lazy"` for below-fold images
- **Image dimensions** - Specify `width` and `height` to prevent layout shift
