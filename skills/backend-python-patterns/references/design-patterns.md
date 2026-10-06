# Design patterns

This file covers pluggable behavior, caching, streaming, and typed data.

## 1. Strategy pattern

A strategy pattern defines one shared interface. A separate class implements
each variant of the behavior behind that interface.

```python
class BaseProcessor(ABC):
    @staticmethod
    @abstractmethod
    def parse_fnames(
        fnames: list[str],
        syllabus_items: list[SyllabusItem],
        file_contents: dict[str, str] | None = None,
    ) -> tuple[FileMap, list[str]]: ...
```
Example: `lib/processors/base.py`

```python
class A2CS2025Processor(BaseProcessor):
    @staticmethod
    def parse_fnames(fnames, syllabus_items, file_contents=None):
        ...
```
Example: `lib/processors/A2CS2025Processor.py`

Notes: Each syllabus, such as A2 CS 2025 or IGCSE CS 2024, has its own
processor class, because filenames follow a different naming convention per
syllabus. See entry 2 for how the class is chosen at request time. Use this
pattern once there are three or more variants of the same operation, and an
`if`/`elif` chain between them would grow with every new variant.
Source: [Abstract Base Classes, Python documentation](https://docs.python.org/3/library/abc.html)

---

## 2. Registry lookup table

A registry maps a key to a class, a function, or a value. Calling code looks
up the right one instead of writing a chain of `if` statements.

```python
PROCESSOR_MAP = {
    "a2-cs-2025": A2CS2025Processor,
    "a2-cs-2024": A2CS2024Processor,
    "as-cs-2024": ASCS2024Processor,
    "igcse-cs-2024": IGCSECS2024Processor,
}
```
Example: `lib/constants.py`

```python
NAVBAR_ITEMS = [
    {"label": "home", "endpoint": "portfolio.home"},
    {"label": "experience", "endpoint": "portfolio.experience"},
    ...
]
```
Example: `lib/constants.py`

Notes: `PROCESSOR_MAP.get(bucket_name)` picks the processor class for a bucket.
Adding a syllabus means adding one dictionary entry and one processor class.
No existing code changes. The same shape works for data that is not a class,
as `NAVBAR_ITEMS` shows. Use a lookup table when a fixed, known set of keys
maps to fixed, known behavior or data.

---

## 3. Double-checked locking cache

A cache can check for a fresh value twice, once without a lock and once with
a lock. This avoids two threads doing the same expensive work.

```python
def get_cached_files(bucket_name: str) -> tuple[FileMap, list[str]]:
    cached = file_cache.get(bucket_name)
    if cached and (time.monotonic() - cached["cached_at"]) < CACHE_TTL:
        return cached["files"], cached["errors"]

    with _cache_lock:
        cached = file_cache.get(bucket_name)
        if cached and (time.monotonic() - cached["cached_at"]) < CACHE_TTL:
            return cached["files"], cached["errors"]

        files, errors = _list_bucket_files(bucket_name)
        file_cache[bucket_name] = {
            "files": files,
            "errors": errors,
            "cached_at": time.monotonic(),
        }
        return files, errors
```
Example: `blueprints/the_cs_class/utils.py`

Alternative approach: a caching library, such as `cachetools`, provides a
`TTLCache` class and a `cached` decorator. Its documentation states that its
cache classes are not thread-safe by themselves. The `cached` decorator
accepts a lock argument and applies it around each cache access. This removes
the hand-written locking logic above.
Source: [cachetools documentation](https://cachetools.readthedocs.io/en/stable/)

Notes: The pattern guards against a time-of-check to time-of-use race (TOCTOU).
Two threads see a stale cache at the same moment. Both start the same
expensive call, such as a Google Cloud Storage call. Hand-write this logic
only when no caching library is a project dependency. Otherwise prefer the
library.

---

## 4. Generator streaming response

A generator function can yield chunks of a file, one at a time. It does not
load the whole file into memory before sending it.

```python
def blob_chunks(
    blob: storage.Blob,
    start: int = 0,
    end: int | None = None,
    chunk_size: int = 1024 * 1024,
) -> Generator[bytes, None, None]:
    with blob.open("rb") as f:
        if start:
            f.seek(start)
        remaining = (end - start + 1) if end is not None else None
        while True:
            to_read = (
                min(chunk_size, remaining) if remaining is not None else chunk_size
            )
            chunk: bytes = f.read(to_read)
            if not chunk:
                break
            yield chunk
            if remaining is not None:
                remaining -= len(chunk)
                if remaining <= 0:
                    break
```
Example: `blueprints/the_cs_class/utils.py`

Notes: Check whether the deployment platform buffers response bodies.
Example: Flask accepts a generator as a streaming response body. Cloud Run's
proxy buffers the full body and applies a 32 MB cap whenever `Content-Length`
is present. A streaming response must leave `Content-Length` unset to stream
past that cap. This pattern pairs with entry 10 in `config-and-io.md` to
serve only the requested byte range.

---

## 5. TypedDict schema

A `TypedDict` names the expected keys and value types of a dictionary. It does
not turn the dictionary into a class instance at runtime.

```python
class SyllabusItem(TypedDict):
    id: str
    title: str
    type: str
```
Example: `custom_types.py`

Alternative approach: the Python documentation states that a `TypedDict`'s key
and type expectations are not checked at runtime. Only a separate type checker
enforces them. Data that must be validated when it is created needs a
hand-written check or a validation library, such as `pydantic`.
Source: [typing.TypedDict, Python documentation](https://docs.python.org/3/library/typing.html#typing.TypedDict)

Notes: `SyllabusItem` values come from a hand-edited file, such as
`syllabus.json`, so a runtime check is optional. `TypedDict` still gives
autocomplete and static checking. Use `pydantic` or a
hand-written check once the data crosses a trust boundary, such as user input
or an external API response.

---

## 6. Enum controlled vocabulary

An `Enum` names a fixed, closed set of allowed values. It replaces raw strings
that could be misspelled anywhere they are used.

```python
class AllowedExts(Enum):
    MP4 = "mp4"
    PDF = "pdf"
    PY = "py"
    LINK = "link"
```
Example: `custom_types.py`

Notes: Each processor's `parse_fnames` compares `AllowedExts.MP4.value`
against a real file extension. A type checker catches a typo in an `Enum`
member. A typo in a bare string literal, repeated in several files, is caught
only by a failing test, or not at all. Use an `Enum` as soon as the same fixed
string appears in more than one file.

---

## 7. Pure transform layer

A transform function takes raw data in and returns shaped data out. It has no
side effects and no direct dependency on the web framework.

```python
def transform_experience(raw: dict[str, Any]) -> dict[str, Any]:
    result: dict[str, Any] = {}
    for i, (group_name, group) in enumerate(raw.items()):
        ...
    return result
```
Example: `lib/transforms.py`

Notes: `transform_experience` reshapes `data/experience.json` for the
template, such as computed `duration_label` and `total_months` fields. The
route in `blueprints/portfolio/routes.py` passes the result to
`render_template`. A function free of Flask imports, such as `request` or
`session`, is testable on its own and reusable outside a request context. If a
transform needs `request`, it belongs in the route.
