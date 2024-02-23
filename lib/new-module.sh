#! /bin/bash
#
#/ Usage: SCRIPT <module-name> <title>
#/        SCRIPT -h|--help|help
#/
#/ This script creates the skeleton of a new course module with the specified
#/ title. The first argument is the name of the module, which will be used as
#/ the directory name. All following arguments are assumed to be the title of
#/ the module.
#/
#/ OPTIONS:
#/   -h|--help|help   Print this help text and exit
#/
#/ EXAMPLES:
#/   new-module.sh user_mgmt 'User management'

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
    if [ "${#}" -lt 1 ]; then
        usage
        exit 1
    fi

    case "${1}" in
        -h|--help|help)
            usage
            exit 0
            ;;
        *)
            create_module "${@}"
            ;;
    esac
}

#---------- Helper functions --------------------------------------------------

# Usage: create_module <module-name> <title>
create_module() {
    local module_name="${1}"
    shift
    local module_title="${*:-${module_name}}"
    local module_dir="${MODULE_ROOT}/${module_name}"

    if [ "${#}" -lt 1 ]; then
        log "Warning: no module title given. Will use module name instead."
    fi

    if [ -d "${module_dir}" ]; then
        error "Module ${module_dir} already exists."
        exit 1
    fi

    log "Creating module ${module_name} in ${module_dir}..."
    # shellcheck disable=SC2086
    mkdir ${_VERBOSE} --parents "${module_dir}"
    # shellcheck disable=SC2086
    cp ${_VERBOSE} --recursive "${MODULE_TEMPLATE}"/* "${module_dir}"

    # Replace placeholders in module files
    # shellcheck disable=SC2086
    sed ${_SED_VERBOSE} --in-place \
        "s/{{MODULE_TITLE}}/${module_title}/g" \
        "${module_dir}"/*.md

    log "Done."
}

main "$@"