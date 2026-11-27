#!/bin/bash
# Blocks edits to secrets, build output and report documents. See CLAUDE.md rules 2 and 9.
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
FILE_PATH="${FILE_PATH//\\//}"

case "$FILE_PATH" in
  *.env|*.env.*|*/.git/*|*/infra/build/*|*/uv.lock)
    echo "Blocked: $FILE_PATH is a secret, lock or build file. Ask the human." >&2; exit 2 ;;
  *.pdf|*.PDF|*.docx)
    echo "Blocked: no report documents written by hand. Fixtures come from tests/fixtures/generate.py (O-4)." >&2; exit 2 ;;
esac
exit 0
