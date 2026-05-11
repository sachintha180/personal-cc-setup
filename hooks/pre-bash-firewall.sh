#!/usr/bin/env bash
# blocks destructive commands before they run

CMD="$1"

check() {
  local pattern="$1"
  local reason="$2"
  if echo "$CMD" | grep -qE "$pattern"; then
    echo "BLOCKED: $reason"
    exit 2
  fi
}

check 'rm\s+-rf'               "rm -rf is destructive and irreversible"
check 'git\s+reset\s+--hard'   "git reset --hard discards uncommitted work"
check 'git\s+push\s+--force'   "force push can overwrite upstream history"

exit 0