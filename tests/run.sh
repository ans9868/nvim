#!/usr/bin/env bash
# Run the nvim config tests.   Usage: tests/run.sh [NN ...]   (no args = all tests)
# Each test is tests/NN_name.lua (runs inside headless nvim) or tests/NN_name.sh (plain shell).
# A .lua test may start with a line `-- OPEN: samples/t.ts` to open that file first.
# A test passes when it prints "RESULT PASS"; exit code is the number of failing tests.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export NVIM_TESTS="$DIR"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
cd "$DIR" || exit 1

want=("$@")
fails=0
printf '%-34s %-6s %s\n' TEST STATUS DETAIL
for t in [0-9][0-9]_*.lua [0-9][0-9]_*.sh; do
  [ -e "$t" ] || continue
  n="${t%%_*}"
  if [ ${#want[@]} -gt 0 ]; then
    match=0
    for w in "${want[@]}"; do [ "$w" = "$n" ] && match=1; done
    [ $match -eq 1 ] || continue
  fi
  case "$t" in
    *.sh) out="$(perl -e 'alarm 120; exec @ARGV' bash "$DIR/$t" 2>&1 </dev/null)" ;;
    *.lua)
      open="$(sed -n 's/^-- OPEN: *//p' "$t" | head -1)"
      out="$(TEST_FILE="$DIR/$t" perl -e 'alarm 120; exec @ARGV' nvim --headless ${open:+"$DIR/$open"} \
        -c "lua dofile(vim.env.NVIM_TESTS .. '/harness_run.lua')" 2>&1 </dev/null)"
      ;;
  esac
  res="$(printf '%s\n' "$out" | grep '^RESULT' | tail -1)"
  if [ "$res" = "RESULT PASS" ]; then
    printf '%-34s %-6s\n' "${t%.*}" PASS
  else
    fails=$((fails + 1))
    printf '%-34s %-6s %s\n' "${t%.*}" FAIL "${res#RESULT FAIL: }"
    [ -z "$res" ] && printf '    (no result line; last output: %s)\n' "$(printf '%s' "$out" | tail -2 | tr '\n' ' ' | cut -c1-200)"
  fi
done
echo "failing tests: $fails"
exit "$fails"
