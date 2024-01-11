#!/bin/bash
# convert-titles.sh -- Convert the titles in the Docbook XML source to Markdown
# 
# The "normal" pandoc conversion doesn't work well for titles. This script takes
# care of that.

#set -o errexit
set -o nounset
set -o pipefail

readonly debug_lvl=2  # 0 = off, 1 = only errors, 2 = on, 3 = verbose

readonly source_root_dir="${PWD}/../linux-training-be/modules"
readonly target_root_dir="${PWD}/modules"

main() {
  for d in "${source_root_dir}"/*/; do
    if [ -d "${d}" ]; then
      log "Processing directory '$(basename "${d}")'"
      convert_titles "${d}"
    fi
  done
}

convert_titles() {
  local dir="${1}"
  local filename target_file target_dir

  target_dir="${target_root_dir}/$(basename "${dir}")"
  mkdir -p "${target_dir}"

  for source_file in "${dir}"/010_*_title.xml; do
    filename="$(basename "${source_file}")"
    target_file="${target_dir}/${filename%.xml}.md"

    log "Converting '${filename}'"
    sed  's/<title>\(.*\)<\/title>/\n# \1\n/' "${source_file}" > "${target_file}"
  done
}


# Usage: error MESSAGE
# Print MESSAGE to stderr, if debug_lvl is greater than 0.
error() {
  local message="${*}"
  if [ "${debug_lvl}" -ge 1 ]; then
    printf '\e[0;31m[ERR] %s\e[0m\n' "${message}" >&2
  fi
}

# Usage: log MESSAGE
# Print MESSAGE to stdout, if debug_lvl is greater than or equal to 2.
log() {
  local message="${*}"
  if [ "${debug_lvl}" -ge 2 ]; then
    printf '\e[0;33m[LOG] %s\e[0m\n' "${message}"
  fi
}

# Usage: debug MESSAGE
# Print debug MESSAGE to stdout, if debug_lvl is greater than or equal to 3.
debug() {
  local message="${*}"
  if [ "${debug_lvl}" -ge 3 ]; then
    printf '\e[0;36[DBG] m%s\e[0m\n' "${message}"
  fi
}

main "$@"