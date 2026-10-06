# Route design patterns

This file covers how to shape and split routes within a blueprint.

## 18. Resource-style routes

Each route under a blueprint answers for one resource or one page. Its name
matches that resource.

```python
@portfolio_bp.route("/", methods=["GET"])
def home():
    ...

@portfolio_bp.route("/experience", methods=["GET"])
def experience():
    ...

@portfolio_bp.route("/projects", methods=["GET"])
def projects():
    ...
```
Example: `blueprints/portfolio/routes.py`

Notes: Each function name matches its URL path and purpose. The route list is
easy to scan. `url_for` calls, see entry 13 in jinja2.md, are predictable to
write.

---

## 19. Page-shell route plus data-fragment route

A page can load in two steps. One route renders the empty page shell. A second
route, called by HTMX, returns the data that fills it.

```python
@the_cs_class_bp.route("/<bucket_name>", methods=["GET"])
def classroom(bucket_name):
    ...
    return render_template(
        "pages/the_cs_class/classroom.html",
        bucket_name=bucket_name,
        bucket_label=bucket_label,
    )


@the_cs_class_bp.route("/<bucket_name>/files", methods=["GET"])
def files(bucket_name):
    ...
```
Example: `blueprints/the_cs_class/routes.py`

Notes: `classroom` does no Google Cloud Storage work and returns at once. The
browser can paint the shell. `files` does the slow work of listing and parsing
bucket contents. The `hx-get` in entry 14 in htmx.md calls it. Split a route
this way once one part of a page is slow enough to hurt the perceived load
time of the whole page.

---

## 20. Guard and abort

A route or a helper function can check a condition first. It can stop the
request early, before doing any further work.

```python
def validate_bucket(bucket_name: str) -> None:
    if bucket_name not in BUCKET_NAMES:
        abort(404)
```
Example: `blueprints/the_cs_class/utils.py`

Notes: `abort(404)` raises an HTTP exception. No code after it runs for that
request. Once more than one route needs the same guard, put it in a shared
helper, not inline in every view. A new validation rule then needs one change.
See entry 21 for the decorator form.

---

## 21. Decorator guard

A decorator can wrap a view function. It can reject bad input before the view
function's own body runs.

```python
def guard_filename(f: Callable[P, R]) -> Callable[P, R]:
    @wraps(f)
    def guard(*args: P.args, **kwargs: P.kwargs) -> R:
        filename: str | None = kwargs.get("filename")
        if not filename:
            abort(400)
        if ".." in filename or "/" in filename:
            abort(400)
        return f(*args, **kwargs)

    return guard
```
Example: `blueprints/the_cs_class/utils.py`

Notes: This decorator blocks a filename that contains `..` or `/`. Such a
filename could reach a file outside the intended folder (path traversal).
`@wraps(f)` keeps the wrapped function's name and metadata. Flask needs this
to build correct endpoint names. Use a decorator guard instead of the
function-call guard in entry 20 once the check must run before every call to a
whole family of view functions.
