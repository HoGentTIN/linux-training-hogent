#! /bin/bash
#
#/ Usage: SCRIPT [-h|--help|help] DIR...
#/
#/ This script creates a static mkdocs site using the info in the specified
#/ directory or directories.
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
#/   SCRIPT
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

# Workaround for shyaml not being installed globally inside the container
if command -v shyaml > /dev/null; then
  shyaml_cmd=$(command -v shyaml)
else
  shyaml_cmd="/root/.local/bin/shyaml"
fi

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
                create_mkdocs "${1}"
                ;;
        esac
        shift
    done
}

#---------- Helper functions --------------------------------------------------

# Usage: check_dependencies
check_dependencies() {
  debug "¤ check_dependencies"

  # check_pip_package_exists mkdocs
  # check_pip_package_exists mkdocs-material
  # check_pip_package_exists pymdown-extensions
  # check_pip_package_exists shyaml
}

# Usage: create_mkdocs course-dir
create_mkdocs() {
  debug "¤ create_mkdocs ${*}"

  local source_dir="${1}"

  local site_name site_title num_parts mkdocs_dir chapters chapter_title

  site_name="$(basename "${source_dir}")"
  site_title=$(${shyaml_cmd} get-value title < "${source_dir}/info.yml")
  mkdocs_dir="${SITE_DIR}/${site_name}/docs"

  log "Creating mkdocs for course '${site_name}'"

  die_on_missing_directory "${source_dir}"
  ensure_directory_exists "${mkdocs_dir}/assets/"

  log "Generating mkdocs.yml"
  python3 "${script_dir}/generate-file.py" \
    --data "${source_dir}/info.yml" \
    "${SITE_TEMPLATE}/mkdocs.yml.j2" \
  > "${mkdocs_dir}/../mkdocs.yml"

  log "Copying frontmatter"

  printf '# %s\n\n' "${site_title}" > "${mkdocs_dir}/index.md"

  files=$(${shyaml_cmd} get-values frontmatter < "${source_dir}/info.yml")
  for file in ${files}; do
    log "  - Adding '${file}'"
    # add contents to index.md, skipping lines starting with a LaTeX command (\)
    # shellcheck disable=SC1003,SC2086
    grep --invert-match '^\\' "${source_dir}/${file}" \
      >>  "${mkdocs_dir}"/index.md
  done

  log "Copying content"

  num_parts=$(${shyaml_cmd} get-length content < "${source_dir}/info.yml")
  for (( i=0; i<"${num_parts}"; i++ )); do
    log "  - Adding part ${i}"

    chapters=$(${shyaml_cmd} get-values "content.${i}.chapters" < "${source_dir}/info.yml")
    for chapter in ${chapters}; do
      log "    - Adding chapter ${chapter}"
      # Copy the chapter content to the mkdocs directory
      cat "${MODULE_ROOT}/${chapter}/"[0-9][0-9][0-9]*.md > "${mkdocs_dir}/${chapter}.md"
      # shellcheck disable=SC2086
      cp ${_VERBOSE} "${MODULE_ROOT}/${chapter}/assets/"* \
        "${mkdocs_dir}/assets/" 2> /dev/null || debug "No assets found"

      # Replace the chapter id with the chapter title in the mkdocs.yml file
      chapter_title=$(grep '^#' "${MODULE_ROOT}/${chapter}/"010*title.md | cut -c3- | tr -d '\r')
      # shellcheck disable=SC2086
      sed ${_SED_VERBOSE} --in-place \
        "s|\"${chapter}\"|\"${chapter_title}\"|;!q" \
        "${mkdocs_dir}/../mkdocs.yml"
    done
  done

  log "Adding Appendix"
  chapters=$(${shyaml_cmd} get-values backmatter < "${source_dir}/info.yml")

  for chapter in ${chapters}; do
    log "  - Adding appendix '${chapter}'"
    cat "${MODULE_ROOT}/${chapter}"/[0-9][0-9][0-9]*.md > "${mkdocs_dir}/${chapter}.md"
    # shellcheck disable=SC2086
    cp ${_VERBOSE} "${MODULE_ROOT}/${chapter}/assets/"* \
      "${mkdocs_dir}/assets/" 2> /dev/null || debug "No assets found"

    # Replace the chapter id with the chapter title in the mkdocs.yml file
    chapter_title=$(grep '^#' "${MODULE_ROOT}/${chapter}/"010*title.md | cut -c3- | tr -d '\r')
    # shellcheck disable=SC2086
    sed ${_SED_VERBOSE} --in-place "s|\"${chapter}\"|\"${chapter_title}\"|;!q" \
      "${mkdocs_dir}/../mkdocs.yml"
  done

  log "Building site"

  ensure_directory_exists "${PUBLISH_DIR}/${site_name}"
  cd "${mkdocs_dir}/.."
  # shellcheck disable=SC2086
  mkdocs build ${_VERBOSE} --clean --site-dir "../../${PUBLISH_DIR}/${site_name}"
}

main "${@}"
