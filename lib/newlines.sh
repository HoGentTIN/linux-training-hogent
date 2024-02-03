#! /bin/bash

# nl='
# '
nl=$'\n'
find modules -type f -name '*.md' | while read -r f; do
    printf '\n' >> "${f}"
done