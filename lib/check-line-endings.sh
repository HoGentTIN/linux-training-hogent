#! /bin/bash
# The markdown files should end with a double newline, otherwise conversion
# to other formats will result in formatting issues. This script checks whether
# all markdown files in modules/ end with two newlines and if not, prints the
# name of that file.

for file in modules/**/*.md; do
    if [[ -f "$file" ]]; then
        # Read the last two characters of the file in hex format
        last_two_chars=$(xxd -seek -2 -p "${file}")

        # The hex representation of these should be '0a0a'
        if [ "${last_two_chars}" != '0a0a' ]; then
            printf '%s: %s\n' "${file}" "${last_two_chars}"
        fi
    fi
done