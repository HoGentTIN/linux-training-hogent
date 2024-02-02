#! /bin/bash

# Directory where all courses are stored
readonly COURSE_ROOT="${COURSE_ROOT:-courses}"

# Directory where the modules are stored
readonly MODULE_ROOT="${MODULE_ROOT:-modules}"

# Directory where the module template is stored
readonly MODULE_TEMPLATE="${MODULE_TEMPLATE:-templates/module}"

# Output directory
readonly OUTPUT_DIR="${OUTPUT_DIR:-dist}"

# Directory where book template files are stored
readonly BOOK_TEMPLATE="${BOOK_TEMPLATE:-templates/book}"

# Directory where presentation template files are stored
readonly PRESENTATION_TEMPLATE="${PRESENTATION_TEMPLATE:-templates/presentation}"

# Directory where the mkdocs site template files are stored
readonly SITE_TEMPLATE="${SITE_TEMPLATE:-templates/site}"

# Verbosity level:
# 0 = quiet
# 1 = errors
# 2 = log (default)
# 3 = debug
# 4 = set -x enabled
readonly VERBOSITY="${VERBOSITY:-2}"

export COURSE_ROOT MODULE_ROOT \
  MODULE_TEMPLATE PRESENTATION_TEMPLATE SITE_TEMPLATE \
  VERBOSITY
