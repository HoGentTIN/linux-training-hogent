#! /bin/bash
#
#/ Usage: SCRIPT [-h|--help|help] DIR...
#/
#/ This script creates a PDF book using the info in the specified directory.
#/
#/ OPTIONS:
#/   -h|--help|help   Print this help text and exit
#/
#/ CONFIGURATION:
#/   The file `settings.sh` contains configurable variables, e.g. directories
#/   for modules, templates, and output. The default values can be overridden
#/   by setting the corresponding environment variables.
#/
#/   In particular, you can set the verbosity level of the commands with
#/   variable VERBOSITY. The following values are supported:
#/
#/   0 = quiet
#/   1 = errors
#/   2 = log (default)
#/   3 = debug
#/   4 = set -x enabled
#/
#/ EXAMPLES:
#/   SCRIPT -h
#/   SCRIPT books/linuxfun
#/   SCRIPT books/linuxfun books/linuxsys
#/   VERBOSITY=3 SCRIPT books/linuxfun
#/

set -o errexit
set -o nounset
set -o pipefail

#---------- Variables ---------------------------------------------------------

script_name=$(basename "${0}")
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# shellcheck disable=SC2034
readonly script_name script_dir

#---------- Load settings and utility functions --------------------------------

# shellcheck disable=SC1091
source "${script_dir}/settings.sh"

# shellcheck disable=SC1091
source "${script_dir}/utils.sh"

#---------- Main function -----------------------------------------------------

main() {
    if [ "${#}" -eq 0 ]; then
      error "At least 1 argument expected"
      usage
      exit 1
    fi

    check_dependencies

    # Parse arguments
    while [ "${#}" -gt 0 ]; do
        case "${1:-}" in
            -h|--help|help)
                usage
                exit 0
                ;;
            -*)
                error "Unrecognized option: ${1}"
                usage
                exit 1
                ;;
            *)
                create_book "${1}"
                ;;
        esac
        shift
    done
}

#---------- Helper functions --------------------------------------------------

# Usage: check_dependencies
check_dependencies() {
  debug "¤ check_dependencies"

  check_command_exists pandoc
  check_pip_package_exists shyaml
}

# Usage: create_book BOOK_DIR
create_book() {
  debug "¤ create_book ${*}"

  local source_dir="${1}"
  
  local book_name files num_parts chapters

  book_name="$(basename "${source_dir}")"

  local book_dir="${OUTPUT_DIR}/${book_name}"

  log "Creating '${book_name}'"

  die_on_missing_directory "${source_dir}"
  ensure_directory_exists "${book_dir}/assets/"

  log "Generating YAML metadata block"
  python3 "${script_dir}/generate-file.py" \
    --data "${source_dir}/info.yml" \
    "${BOOK_TEMPLATE}/metadata-block.yml.j2" \
  > "${book_dir}/metadata-block.yml"

  log "Copying frontmatter"

  printf '\n' > "${book_dir}/frontmatter.md"

  files=$(shyaml get-values frontmatter < "${source_dir}/info.yml")
  for file in ${files}; do
    log "  - Adding '${file}'"
    cat "${source_dir}/${file}" >>  "${book_dir}"/frontmatter.md
  done

  log "Copying content"

  printf '\n' > "${book_dir}/content.md"

  num_parts=$(shyaml get-length content < "${source_dir}/info.yml")

  for (( i=0; i<"${num_parts}"; i++ )); do
    part=$(shyaml get-value "content.${i}.title" < "${source_dir}/info.yml")
    log "  - Adding part ${i}. ${part}"
    printf '\part{%s}\n' "${part}" >> "${book_dir}/content.md"

    chapters=$(shyaml get-values "content.${i}.chapters" < "${source_dir}/info.yml")
    for chapter in ${chapters}; do
      log "    - Adding chapter '${chapter}'"
      cat "${MODULE_ROOT}/${chapter}/"[0-9][0-9][0-9]_*.md >> "${book_dir}/content.md"
      # shellcheck disable=SC2086
      cp ${_VERBOSE} "${MODULE_ROOT}/${chapter}/assets/"* \
        "${book_dir}/assets/" 2> /dev/null || debug "No assets found"
    done
  done

  log "Adding backmatter"

  printf '\\appendix\n\n' \
    > "${book_dir}/backmatter.md"

  chapters=$(shyaml get-values backmatter < "${source_dir}/info.yml")
  for chapter in ${chapters}; do
    log "  - Adding appendix '${chapter}'"
    cat "${MODULE_ROOT}/${chapter}"/[0-9][0-9][0-9]_*.md >> "${book_dir}/backmatter.md"
    # shellcheck disable=SC2086
    cp ${_VERBOSE} "${MODULE_ROOT}/${chapter}/assets/"* \
      "${book_dir}/assets/" 2> /dev/null || debug "No assets found"
  done
  
  log "Generating PDF"
  cd "${book_dir}"
  # shellcheck disable=SC2086
  pandoc ${_VERBOSE} \
    --pdf-engine=xelatex \
    --from markdown+raw_tex \
    --metadata-file "metadata-block.yml" \
    --output "${book_name}.pdf" \
    frontmatter.md \
    content.md \
    backmatter.md
}

main "${@}"
