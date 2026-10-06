# Flask patterns

This file covers blueprints, extensions, config, and request hooks.

## 1. Blueprint

A blueprint groups a set of related routes under one name and one URL prefix.
The app registers each blueprint once at startup.

```python
the_cs_class_bp = Blueprint("the_cs_class", __name__, url_prefix="/the-cs-class")
```
Example: `blueprints/the_cs_class/__init__.py`

```python
app.register_blueprint(portfolio_bp)
app.register_blueprint(the_cs_class_bp)
app.register_blueprint(blog_bp)
```
Example: `app.py`

Notes: A multi-section site can have one blueprint per section, each with its
own `routes.py`. The blueprint name becomes the first part of every endpoint
name inside it. A `home` view in `portfolio_bp` gets the endpoint
`portfolio.home`. See entry 13 in jinja2.md.

---

## 2. Single app instance versus application factory

The simplest option creates the app object once, at module import time.

```python
app = Flask(__name__)
```
Example: `app.py`

Alternative approach: Flask's own documentation recommends an application
factory. This is a function that builds and returns the app object. A factory
can build more than one app instance with different settings. This helps when
automated tests each start a fresh app with test config.
Source: [Application Factories, Flask documentation](https://flask.palletsprojects.com/en/stable/patterns/appfactories/)

Notes: For a single-deployment app, a module-level instance is simpler. Add a
factory only when the project has a real second use, such as more than one
config or isolated test instances.

---

## 3. Extension singleton

A Flask extension object is created once, with no app attached yet. The app
binds to it later with `init_app`.

```python
from flask_flatpages import FlatPages

pages = FlatPages()
```
Example: `extensions.py`

```python
pages.init_app(app)
```
Example: `app.py`

Notes: Flask's documentation recommends this for extensions used with an
application factory. It also avoids a circular import. `extensions.py` never
imports `app`. Blueprint modules can import `pages` without pulling in
`app.py`.
Source: [Factories and Extensions, Flask documentation](https://flask.palletsprojects.com/en/stable/patterns/appfactories/#factories-extensions)

---

## 4. Context processor

A context processor adds variables to every template's context. Individual
views do not have to pass these variables in by hand.

```python
@app.context_processor
def inject_layout_data():
    return {
        "active_nav_endpoint": _resolve_active_nav(request.endpoint),
        "current_year": datetime.now(timezone.utc).year,
        "navbar_items": NAVBAR_ITEMS,
    }
```
Example: `app.py`

Notes: Use a context processor for any value that would otherwise repeat in
every `render_template` call, such as nav state or a copyright year.

---

## 5. Error handler

An error handler renders a chosen template for a given HTTP status code. It
replaces Flask's default error page.

```python
@app.errorhandler(404)
def not_found(e):
    return render_template("pages/not_found.html"), 404
```
Example: `app.py`

Notes: The tuple `(rendered_template, 404)` sets the response status code.
Flask uses `200` by default. This tuple shape applies to any view that needs a
non-default status code.

---

## 6. Dynamic route segment

A route can capture part of the URL path as a function argument.

```python
@the_cs_class_bp.route("/<bucket_name>", methods=["GET"])
def classroom(bucket_name):
    ...
```
Example: `blueprints/the_cs_class/routes.py`

Notes: `<bucket_name>` uses the default `string` converter. It matches any
text without a slash, which suits a bucket name. Use a typed converter, such
as `<int:product_id>`, when the segment must have a specific shape. Flask
rejects the match if the URL segment does not fit. This saves a manual type
check in the view.
Source: [Variable Rules, Flask documentation](https://flask.palletsprojects.com/en/stable/quickstart/#variable-rules)

---

## 7. Config-before-import ordering

Some setup must run before other modules are imported. Those modules read
config values at import time, not at call time.

```python
# NOTE: Load the environment variables before importing blueprints
load_flat_env_yaml("portfolio_env.yaml")

from blueprints.blog.routes import blog_bp
from blueprints.portfolio.routes import portfolio_bp
from blueprints.the_cs_class import the_cs_class_bp
```
Example: `app.py`

Alternative approach: Flask's documentation warns against needing
configuration at import time, because it makes the app harder to test and
reconfigure. Load config inside an application factory, before any blueprint
import. This removes the ordering rule. See entry 2.
Source: [Configuration Best Practices, Flask documentation](https://flask.palletsprojects.com/en/stable/config/#configuration-best-practices)

Notes: `blueprints/the_cs_class/utils.py` reads an environment variable, such
as `THE_CS_CLASS_BUCKETS`, at module load time. So `load_flat_env_yaml` must
run first. A `NOTE` comment should flag this. An ordering rule that needs its
own comment is fragile. Remove it if a second entry point, such as a CLI
script, imports the same module.
