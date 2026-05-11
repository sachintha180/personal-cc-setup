#!/usr/bin/env bash
# reinjects CLAUDE.md after context compaction

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_MD="$SCRIPT_DIR/../CLAUDE.md"

if [ -f "$CLAUDE_MD" ]; then
  cat "$CLAUDE_MD"
fi

exit 0