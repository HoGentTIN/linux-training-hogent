#! /bin/bash
#
# remove-indexterm.sh -- Remove the indexterm elements resulting from the
# Docbook XML source.

set -o errexit
set -o nounset
set -o pipefail

root_dir="${PWD}/modules"

find "${root_dir}" -type f -name "*.md" -print \
    -exec sed -i 's/\[\]{\.indexterm}//' {} \;
