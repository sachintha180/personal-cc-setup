#!/usr/bin/env bash
# SessionStart hook (matcher: compact) - reinjects CLAUDE.md as authoritative context after compaction.
# PreCompact stdout gets summarized away; this fires after compaction completes, so it survives.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_MD="$SCRIPT_DIR/../CLAUDE.md"

if [ -f "$CLAUDE_MD" ]; then
  python "$SCRIPT_DIR/post-compact-reinject.py" "$CLAUDE_MD"
fi

exit 0
