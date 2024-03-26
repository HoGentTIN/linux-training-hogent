#! /bin/bash
# adoc2md.sh - convert asciidoc to markdown
#
# Dependencies: asciidoc, pandoc

#set -euo pipefail

input_dir='chapters'
xml_dir='xml'
output_dir='markdown'

# Create xml directory if it doesn't exist
if [ ! -d "${xml_dir}" ]; then
    mkdir -p "${xml_dir}"
fi

# Create output directory if it doesn't exist
if [ ! -d "${output_dir}" ]; then
    mkdir -p "${output_dir}"
fi

for chap in "${input_dir}"/*.adoc; do
    echo "Converting $chap"
    echo " asciidoc -> DocBook XML"
    asciidoc -b docbook \
      -o "${xml_dir}/$(basename "${chap%.adoc}.xml")" \
      "${chap}"
    echo " DocBook XML -> markdown"
    pandoc -f docbook -t markdown_strict \
      -o "${output_dir}/$(basename "${chap%.adoc}.md")" \
      "${xml_dir}/$(basename "${chap%.adoc}.xml")"
done