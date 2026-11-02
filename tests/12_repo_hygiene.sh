#!/usr/bin/env bash
# P2: no stray PDFs in the config repo.
cd "$NVIM_TESTS/.." || exit 1
pdfs="$(ls ./*.pdf 2>/dev/null; git ls-files '*.pdf')"
if [ -z "$pdfs" ]; then echo "RESULT PASS"; else echo "RESULT FAIL: $(echo "$pdfs" | sort -u | tr '\n' ' ')"; fi
