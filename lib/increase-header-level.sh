#! /bin/bash
# increase-header-level.sh -- Increase the header level in the specified
# Markdown files

set -o errexit
set -o nounset
set -o pipefail

readonly debug_lvl=2  # 0 = off, 1 = only errors, 2 = on, 3 = verbose

main() {
  local filename
  for filename in "${@}"; do
    log "Processing file '${filename}'"
    increase_header_level "${filename}"
  done
}

increase_header_level() {
  local filename="${1}"
  
  sed -i 's/^### /#### /' "${filename}"
  sed -i 's/^## /### /' "${filename}"
  sed -i 's/^# /## /' "${filename}"
}

# Usage: log MESSAGE
# Print MESSAGE to stdout, if debug_lvl is greater than or equal to 2.
log() {
  local message="${*}"
  if [ "${debug_lvl}" -ge 2 ]; then
    printf '\e[0;33m[LOG] %s\e[0m\n' "${message}"
  fi
}

main "${@}"