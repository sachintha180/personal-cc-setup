#!/usr/bin/env bash

input=$(cat)

model_id=$(printf '%s' "$input" | jq -r '.model.id // empty' 2>/dev/null)
model=$(printf '%s' "$model_id" | sed -E 's/^claude-//; s/-[0-9]{8}$//')
if [ -z "$model" ]; then
  model=$(printf '%s' "$input" | jq -r '.model.display_name // "unknown"' 2>/dev/null)
  [ -z "$model" ] && model="unknown"
fi

ctx_pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty' 2>/dev/null)
five_pct=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty' 2>/dev/null)
week_pct=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)

mid=""
add_mid() {
  [ -z "$2" ] && return
  [ -n "$mid" ] && mid="$mid, "
  mid="$mid$1 $(printf '%.0f' "$2")%"
}
add_mid ctx "$ctx_pct"
add_mid 5h "$five_pct"
add_mid 7d "$week_pct"

cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty' 2>/dev/null)
branch=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null || true)
fi

out="$model"
[ -n "$mid" ] && out="$out | $mid"
[ -n "$branch" ] && out="$out | git $branch"

printf '%s' "$out"
