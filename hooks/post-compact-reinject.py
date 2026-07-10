import json
import sys

claude_md_path = sys.argv[1]
with open(claude_md_path, "r", encoding="utf-8") as f:
    content = f.read()

ctx = (
    "IMPORTANT: Context was just compacted. The following rules are authoritative "
    "and take precedence over any paraphrased version in the compacted summary:\n\n"
    + content
)

print(
    json.dumps(
        {
            "hookSpecificOutput": {
                "hookEventName": "SessionStart",
                "additionalContext": ctx,
            }
        }
    )
)
