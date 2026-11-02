#!/usr/bin/env bash
# P0: command-line tools the config and LazyVim pickers rely on.
export PATH="/opt/homebrew/bin:/usr/local/bin:/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
missing=()
for t in rg fd lazygit gfind; do
  command -v "$t" >/dev/null 2>&1 || missing+=("$t")
done
[ -d /opt/homebrew/opt/coreutils/libexec/gnubin ] || missing+=("coreutils")
if [ ${#missing[@]} -eq 0 ]; then echo "RESULT PASS"; else echo "RESULT FAIL: missing ${missing[*]}"; fi
