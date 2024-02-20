#! /bin/bash
# Utility functions for the linux-training scripts.

#---------- Logging -----------------------------------------------------------

# Usage: error MESSAGE
# Print MESSAGE to stderr, if VERBOSITY is greater than 0.
error() {
  local message="${*}"
  if [ "${VERBOSITY}" -ge 1 ]; then
    printf '\e[0;31m[ERR] %s\e[0m\n' "${message}" >&2
  fi
}

# Usage: log MESSAGE
# Print MESSAGE to stdout, if VERBOSITY is greater than or equal to 2.
log() {
  local message="${*}"
  if [ "${VERBOSITY}" -ge 2 ]; then
    printf '\e[0;33m[LOG] %s\e[0m\n' "${message}"
  fi
}

# Usage: debug MESSAGE
# Print debug MESSAGE to stdout, if VERBOSITY is greater than or equal to 3.
debug() {
  local message="${*}"
  if [ "${VERBOSITY}" -ge 3 ]; then
    printf '\e[0;36m[DBG] %s\e[0m\n' "${message}"
  fi
}

# Enable additional command output depending on the verbosity level
if [ "${VERBOSITY}" -ge 4 ]; then
  _VERBOSE='-v'          # Enable verbose option (e.g. for mkdir)
  _SED_VERBOSE='--debug' # Enable sed debugging
  set -x                 # Enable Bash debugging
elif [ "${VERBOSITY}" -ge 3 ]; then
  _VERBOSE='-v'          # Enable verbose option (e.g. for mkdir)
  _SED_VERBOSE=''        # Don't enable sed debugging
else
  _VERBOSE=''            # Don't add verbose option
  _SED_VERBOSE=''
fi

readonly _VERBOSE _SED_VERBOSE
export _VERBOSE _SED_VERBOSE

#---------- Usage function ----------------------------------------------------

# Usage: usage
#  Search the script for lines starting with "#/" and print them to stdout
#  (without the leading "#/").
usage() {
  grep '^#/' <"${0}" \
    | cut --characters=4- \
    | sed 's+SCRIPT+'"${0}"'+g'
}

# ---------- Dependency checking ----------------------------------------------

# Usage: check_command_exists COMMAND
#
# Check if the specified command exists. If not, print an error message and
# exit.
check_command_exists() {
    debug "¤ check_command_exists ${*}"
    local command="${1}"

    if ! command -v "${command}" > /dev/null 2>&1; then
        error "Command '${command}' not found". Please install before continuing.
        exit 1
    fi
}

# Usage: check_pip_package_exists PACKAGE
#
# Check if the specified pip package exists. If not, print an error message and
# exit.
check_pip_package_exists() {
    debug "¤ check_pip_package_exists ${*}"
    local package="${1}"

    if ! pip show "${package}" > /dev/null 2>&1; then
        error "Pip package '${package}' not found". Please install before continuing.
        exit 1
    fi
}

#---------- Filesystem functions ----------------------------------------------

# Usage: ensure_directory_exists DIRECTORY
ensure_directory_exists() {
  debug "¤ ensure_directory_exists ${*}"
  local directory="${1}"
  # shellcheck disable=SC2086
  mkdir ${_VERBOSE} --parents "${directory}"
}

# Usage: die_on_missing_directory DIRECTORY
die_on_missing_directory() {
  debug "¤ die_on_missing_directory ${*}"
  local directory="${1}"
  if [ ! -d "${directory}" ]; then
    error "Directory '${directory}' does not exist."
    exit 1
  fi
}

# Usage: die_on_missing_file FILE
die_on_missing_file() {
  debug "¤ die_on_missing_file ${*}"
  local file="${1}"
  if [ ! -f "${file}" ]; then
    error "File '${file}' does not exist."
    exit 1
  fi
}
