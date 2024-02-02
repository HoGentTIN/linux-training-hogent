#! /bin/bash
# increase-header-level.sh -- Increase the header level in the specified
# Markdown files

set -o errexit
set -o nounset
set -o pipefail


script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
readonly VERBOSITY="${VERBOSITY:-2}"

# shellcheck disable=SC1091
source "${script_dir}/utils.sh"

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

main "${@}"