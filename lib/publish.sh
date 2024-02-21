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
    bash "${script_dir}/make-book.sh" "books/${book_id}"
    bash "${script_dir}/make-site.sh" "books/${book_id}"
  done

  # Copy generated PDFs to the publish directory

  # shellcheck disable=SC2086
  find "${OUTPUT_DIR}" -type f -name '*.pdf' -exec \
    cp ${_VERBOSE} --target-directory "${PUBLISH_DIR}" {} +

  # Generate the index page

  # shellcheck disable=SC2086
  cp ${_VERBOSE} "${SITE_TEMPLATE}/hogent.css" "${PUBLISH_DIR}"
  pandoc --from markdown \
    --standalone \
    --css hogent.css \
    --output "${PUBLISH_DIR}/index.html" \
    "${SITE_TEMPLATE}/index.md"
}

#---------- Helper functions ---------------------------------------------------

main "${@}"
