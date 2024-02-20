#! /bin/bash
#
#/ Usage: SCRIPT
#/
#/ This script will move images from the common "images" directory to a 
#/ subdirectory "assets" of the module source. This will ensure that images are
#/ visible when authoring content and make it 
#/
#/ OPTIONS:
#/   -h|--help|help   Print this help text and exit
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
  for module in "${MODULE_ROOT}"/*/; do
    log "Processing module: ${module}"
    grep '!\[.*\](.*images\/.*)' "${module}"*.md \
      | sed -e 's/.*(.*\(images\/.*\)).*/\1/' \
      | sort -u \
      | while read -r image; do

      log "Moving image: ${image} -> ${module}assets"
      mkdir -p "${module}assets"
      mv -v "${image}" "${module}assets"
    done || log "No images found in ${module}"
  done
}

main "${@}"
