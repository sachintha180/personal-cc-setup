# Jinja2 patterns

This file covers inheritance, includes, macros, and value formatting.

## 8. Template inheritance

A child template extends a parent template and fills in named blocks. A
parent can itself extend a further parent. This forms a chain.

```html
{% extends "layouts/base.html" %}

{% block content %}
  ...
    {% block page_content %}
    {% endblock %}
  ...
{% endblock %}
```
Example: `templates/layouts/the_cs_class.html`

```html
{% extends "layouts/the_cs_class.html" %}

{% block page_content %}
  ...
{% endblock %}
```
Example: `templates/pages/the_cs_class/classroom.html`

Notes: A three-level chain is common. `base.html` defines the outer HTML shell
and a `content` block. A section layout, such as `layouts/the_cs_class.html`,
extends it and defines a narrower `page_content` block. A leaf page fills only
`page_content`. The portfolio pages use `layouts/portfolio.html` the same
way. Add a layer when a whole
section of pages shares chrome, such as a sidebar, that the site-wide base
does not have.

---

## 9. Include

An include pulls in another template file at that exact point. The result is
the same as if the included file's content were copied in.

```html
{% include "partials/portfolio/navbar.html" %}
...
{% include "partials/footer.html" %}
```
Example: `templates/layouts/portfolio.html`

Notes: An include is a direct insertion. It needs no matching block in the
child template. This project uses includes for shared pieces, such as the
navbar, the footer, and the file-type sections in
`partials/the_cs_class/class/file_list.html`. Use a macro, see entry 10, once
the same markup must render more than once per page with different data.

---

## 10. Macro

A macro is a reusable template function. It takes arguments and returns
markup, in the same way a Python function returns a value.

```html
{% macro project_card(project) %}
  ...
{% endmacro %}
```
Example: `templates/macros/portfolio/project_card.html`

```html
{% from "macros/portfolio/project_card.html" import project_card %}
...
{{ project_card(project) }}
```
Example: `templates/partials/portfolio/projects/grid.html`

Notes: A macro must be imported with `{% from ... import ... %}` before it can
be called. `{% include %}` needs no import. Use a macro when the same markup
shape repeats across a loop, such as one card per project in a grid.

---

## 11. Comment

A Jinja comment does not render. It is not sent to the browser.

```html
{# Card Header #}
```
Example: `templates/macros/portfolio/project_card.html`

Notes: A Jinja comment, `{# ... #}`, is removed before the HTML reaches the
browser. An HTML comment, `<!-- ... -->`, ships in the response and is
visible in View Source. Use a Jinja comment for anything that should not reach
the browser. Use an HTML comment only when it should be visible in the page
source.

---

## 12. Filter

A filter transforms a value inside a template, using the pipe symbol.

```html
{{ item.id }} - {{ item.title | truncate(length=20, killwords=True) }}
```
Example: `templates/partials/the_cs_class/class/file_list.html`

Notes: `truncate` shortens `item.title` to 20 characters. `killwords=True`
allows the cut inside a word. Filters chain left to right, for example
`{{ value | filter_a | filter_b }}`. Use a filter instead of pre-formatting a
value in the view when the formatting is only for display. The raw value
stays available for an API response or a log line.

---

## 13. url_for

`url_for` builds a URL from an endpoint name. The template does not write the
URL path by hand.

```html
hx-get="{{ url_for('the_cs_class.files', bucket_name=bucket_name) }}"
```
Example: `templates/pages/the_cs_class/classroom.html`

Notes: If a route's URL path changes, every `url_for` call for that endpoint
keeps working. A hard-coded path breaks silently. An endpoint name combines
the blueprint name with the view function name. `the_cs_class.files` is the
`files` view on `the_cs_class_bp`. See entry 1 in flask.md.
Source: [URL Building, Flask documentation](https://flask.palletsprojects.com/en/stable/quickstart/#url-building)
