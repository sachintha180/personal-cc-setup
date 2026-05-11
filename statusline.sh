#!/usr/bin/env bash

input=$(cat)

cwd=$(printf '%s' "$input" | node -e '
let s = "";
process.stdin.on("data", d => s += d);
process.stdin.on("end", () => {
  try {
    const j = JSON.parse(s);
    console.log(j.current_dir || j.workspace?.current_dir || process.cwd());
  } catch {
    console.log(process.cwd());
  }
});
')

context_pct=$(printf '%s' "$input" | npx ccstatusline)

if git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
  repo_name=$(basename "$(git -C "$cwd" rev-parse --show-toplevel)")
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
  printf '%s | %s | %s' "$repo_name" "$branch" "$context_pct"
else
  folder_name=$(basename "$cwd")
  printf '%s | %s' "$folder_name" "$context_pct"
fi