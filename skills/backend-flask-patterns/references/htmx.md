# HTMX patterns

This file covers lazy loading, targeted swaps, and fragment responses.

## 14. Load-triggered fetch

An element can fetch its own content from the server as soon as the page
loads. The server does not have to render that content up front.

```html
<div
  id="file-list"
  hx-get="{{ url_for('the_cs_class.files', bucket_name=bucket_name) }}"
  hx-trigger="load"
  hx-swap="innerHTML"
>
  <div class="spinner-border spinner-border-sm"></div>
</div>
```
Example: `templates/pages/the_cs_class/classroom.html`

Notes: The page renders at once, with a spinner in place of the file list. The
list loads when the `/files` request returns. The first response does not wait
on a slow call, such as a Google Cloud Storage listing. Use this pattern when
one part of a page is clearly slower to produce than the rest.

---

## 15. Target and swap

An element can trigger a request whose response replaces a different element
on the page, not itself.

```html
<button
  hx-get="{{ url_for('the_cs_class.files', bucket_name=bucket_name) }}?filter={{ item.id }}"
  hx-target="#file-list"
  hx-swap="innerHTML"
>
```
Example: `templates/partials/the_cs_class/class/file_list.html`

Notes: Clicking a syllabus filter badge replaces the `#file-list` element with
a filtered list, not the badge. `hx-target` names the element to swap.
`hx-swap` names how. `innerHTML` replaces the target's contents. `outerHTML`
replaces the target element itself. If a click has no visible effect, check
`hx-target` first.

---

## 16. HTML fragment response

An HTMX route can return a piece of HTML, built from a partial template. It
does not have to return a full page or a JSON body.

```python
response = make_response(
    render_template(
        "partials/the_cs_class/class/file_list.html",
        bucket_name=bucket_name,
        files=files,
        ...
    )
)
```
Example: `blueprints/the_cs_class/routes.py`

Notes: HTMX swaps this fragment straight into the page. No JavaScript has to
parse JSON and build HTML. This pattern pairs with entry 19 in
route-design.md. Each fragment route returns this shape for one update.

---

## 17. Conditional cache header

A response can set a caching header only on the success path. Error responses
stay uncached.

```python
if error is None:
    response.headers["Cache-Control"] = "private, max-age=300"

return response
```
Example: `blueprints/the_cs_class/routes.py`

Notes: `private` means only the requesting browser may cache the response, not
a shared proxy or CDN. `max-age=300` means the browser treats the response as
fresh for 300 seconds. An error response skips this header, so the browser
retries on the next visit. Set the header only after the handler confirms
success.
Source: [Cache-Control, MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cache-Control)
