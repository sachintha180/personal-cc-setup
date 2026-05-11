#!/usr/bin/env bash
# runs formatters/linters on edited file - informational only, never blocks

FILE="$1"

if [ -z "$FILE" ]; then
  exit 0
fi

run_prettier() {
  if command -v prettier &>/dev/null; then
    prettier --write "$FILE" 2>&1 || echo "QUALITY: prettier failed on $FILE"
  fi
}

case "$FILE" in
  *.py)
    if command -v ruff &>/dev/null; then
      OUT=$(ruff check --fix "$FILE" 2>&1)
      if [ $? -ne 0 ]; then
        echo "QUALITY: ruff found issues in $FILE - $OUT" | head -1
      fi
    fi
    ;;
  *.ts|*.tsx)
    run_prettier
    if command -v eslint &>/dev/null; then
      OUT=$(eslint --fix "$FILE" 2>&1)
      if [ $? -ne 0 ]; then
        echo "QUALITY: eslint failed on $FILE - $(echo "$OUT" | tail -1)"
      fi
    fi
    ;;
  *.js|*.jsx|*.json|*.css|*.html|*.md)
    run_prettier
    ;;
esac

exit 0