# Config and I/O patterns

This file covers client reuse, environment config, and range streaming.

## 8. Module-level singleton client

A client object that manages a network connection can be created once at
module load. Every request then reuses the same connection.

```python
gcs_client = storage.Client()
```
Example: `blueprints/the_cs_class/utils.py`

Notes: A new Google Cloud Storage client on every request opens a new TLS
handshake each time. This applies to any SDK client for an external service.
Check the client's thread-safety guarantee before sharing it across
concurrent requests.

---

## 9. Flat-YAML environment config

A flat YAML file of `KEY: VALUE` pairs can be loaded straight into
`os.environ` at startup. No key needs to be set by hand.

```python
def load_flat_env_yaml(filename: str) -> None:
    env_path = BASE_DIR / filename
    if not env_path.exists():
        return
    with open(env_path, "r") as file:
        config = yaml.safe_load(file)
        for key, value in config.items():
            os.environ[key] = str(value)
```
Example: `lib/transforms.py`

Notes: Exclude the source file, such as `portfolio_env.yaml`, with
`.gitignore`, `.dockerignore`, and `.gcloudignore`. On a platform that injects
environment variables directly, this function is a no-op. Example: Cloud Run.
The file is not in the deployed image, so `env_path.exists()` returns `False`.
The timing of this call matters. See entry 7, config-before-import ordering,
in `references/flask.md` of the `backend-flask-patterns` skill.

---

## 10. HTTP range-request streaming

A server can read the `Range` request header. It can return only the
requested byte range of a file, not the whole file.

```python
def parse_range_header(range_header: str, file_size: int) -> tuple[int, int] | None:
    match = re.match(r"bytes=(\d+)-(\d*)", range_header)
    if not match:
        return None
    start = int(match.group(1))
    end = int(match.group(2)) if match.group(2) else file_size - 1
    return start, min(end, file_size - 1)
```
Example: `blueprints/the_cs_class/utils.py`

Alternative approach: the HTTP specification allows one `Range` header to
name more than one range, for example `bytes=0-50,100-150`. A server that
supports this responds with a `multipart/byteranges` body. This function's
regular expression matches only a single range. A multi-range request falls
back to a full response.
Source: [HTTP range requests, MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Range_requests)

Notes: Video players almost always request a single range, so this gap rarely
matters for the mp4 files served here. Pair this with entry 4 in
`design-patterns.md` to serve only the requested bytes.
