#!/usr/bin/env bash
# runs test suite after agent completes - informational only, never blocks

if command -v pytest &>/dev/null; then
  OUT=$(pytest -q 2>&1)
  if [ $? -ne 0 ]; then
    SUMMARY=$(echo "$OUT" | tail -5)
    echo "TESTS FAILED: $SUMMARY"
  fi
elif [ -f "package.json" ] && node -e "require('./package.json').scripts.test" &>/dev/null 2>&1; then
  OUT=$(npm test --silent 2>&1)
  if [ $? -ne 0 ]; then
    SUMMARY=$(echo "$OUT" | tail -5)
    echo "TESTS FAILED: $SUMMARY"
  fi
fi

exit 0