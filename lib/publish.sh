#! /bin/bash
#
#/ Usage: SCRIPT
#/
#/ This script publishes all content in the site/ directory, to be published
#/ on Github Pages.
#/

set -o errexit
set -o nounset
set -o pipefail

#---------- Variables ---------------------------------------------------------

script_name=$(basename "${0}")
script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# shellcheck disable=SC2034
readonly script_name script_dir

readonly book_ids=( linuxfun linuxsrv linuxsys )

#---------- Load settings and utility functions --------------------------------

# shellcheck disable=SC1091
source "${script_dir}/settings.sh"

# shellcheck disable=SC1091
source "${script_dir}/utils.sh"

#---------- Main function -----------------------------------------------------

main() {
  for book_id in "${book_ids[@]}"; do
    "${script_dir}/make-book.sh" "books/${book_id}"
    "${script_dir}/make-site.sh" "books/${book_id}"
  done

  find "${OUTPUT_DIR}" -type f -name '*.pdf' -exec \
    cp ${_VERBOSE} --target-directory "${PUBLISH_DIR}" {} +

  cp ${_VERBOSE} "${SITE_TEMPLATE}/index.md" "${PUBLISH_DIR}"
}

#---------- Helper functions ---------------------------------------------------

main "${@}"
