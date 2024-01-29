#! /bin/bash
#
# collect-author-info.sh -- Collect author information from the Git history
#
# Author: Bert Van Vreckem <https://github.com/bertvv/>
#
# When we convert the Docbook XML source to Markdown, we lose the author
# information from the Git history. This script collects that information
# and adds it to the Markdown files to ensure that the name of the author and
# all contributors are preserved.
# 
# The strategy is to perfor a "git blame" on each file in the directory
# containing the Docbook XML source and count the lines per author. The
# author with the most lines is assumed to be the main author. The other
# committers are listed as contributors.
#
# There is a snag, however, and that is the fact that filtering authors from
# the Git history is not straightforward. The author's name/email is not always
# consistent, depending on how they set up their local Git environment.
# Specifically, a single author can have commits with several email addresses
# (or email-like usernames in the form of user@host). For that purpose, I added
# a CSV file with the author's real name and GitHub handle. We'll count the
# total number of lines per GitHub handle, and use that to determine the main
# author and contributors.
#
# In the final output, we mention the author's and contributors' real name and
# and GitHub handle, e.g.
#
# *(Written by Paul Cobbaut, <https://github.com/paulcobbaut/>)*
#
# *(Written by Paul Cobbaut, <https://github.com/paulcobbaut/>, with
# contributions by: Alex M. Schapelle, <https://github.com/zero-pytagoras/>,
# Serge Van Ginderachter, <https://github.com/srgvg/>)*
#
# The result is written to a file named "015_authors.md" in each module, which
# will be included when converting to a static site or PDF.
#

#set -o errexit
set -o nounset
set -o pipefail

readonly debug_lvl=2  # 0 = off, 1 = only errors, 2 = on, 3 = verbose
readonly source_root_dir="${PWD}/../linux-training-be/modules"
readonly target_root_dir="${PWD}/modules"

readonly author_info_file="${PWD}/lib/authors.csv"

main() {
  if [ ! -d "${source_root_dir}" ]; then
    error "Source directory '${source_root_dir}' does not exist."
    error " - Are you running this script from the project root directory?"
    error " - Is the source repository a sibling of this repository and does it have the expected name?"
    exit 1
  fi

  for d in "${source_root_dir}"/*/; do
    if [ -d "${d}" ]; then
      log "Processing directory '$(basename "${d}")'"
      
      target_dir="${target_root_dir}/$(basename "${d}")"
      local author_file="${target_dir}/015_authors.md"

      collect_author_stats "${d}" \
        | add_github_name \
        | count_total_lines_per_author \
        | sort_by_num_lines \
        | print_author_info \
        | cleanup_ending \
        | tee "${author_file}"
    fi
  done
}

# Usage: collect_author_stats DIR
#  Print the number of lines per author in the Git history of DIR
# Output format:
#   <num_lines> <author_email>
collect_author_stats() {
  local dir="${1}"
  cd "${dir}" || exit 1

  git ls-files \
    | xargs --max-args=1 --delimiter='\n' git blame --line-porcelain \
    | sed --silent 's/^author-mail //p' \
    | sort --ignore-case \
    | uniq --ignore-case --count \
    | tr -d '<>'
}

# Usage: add_github_name <<< AUTHOR_STATS
#   Read number of lines and author email from stdin, and replace the email
#   with the GitHub handle found in the author_info_file
# Output format:
#   <num_lines>,<author_github>
add_github_name() {
  local num_lines author_email author_github
  while read -r line; do
    num_lines="$(awk '{ print $1 }' <<< "${line}")"
    author_email="$(awk '{ print $2 }' <<< "${line}")"
    author_github="$(grep "${author_email}" "${author_info_file}" | cut --delimiter=',' --fields=3 | tr -d '\r')"

    printf '%s,%s\n' \
       "${num_lines}" "${author_github}"
  done
}

# Usage: count_total_lines_per_author <<< LINES_PER_AUTHOR
#   Read number of lines and author Github handle from stdin, and count the
#   total number of lines per unique Github handle
# Output format:
#   <num_lines>,<author_github>
#   with author_github unique
count_total_lines_per_author() {
  awk -F',' '{ sum[$2] += $1 }
    END { for (i in sum) printf "%s,%s\n", i, sum[i] }'
}

# Usage: print_author_info <<< LINES_PER_AUTHOR
#  Read number of lines and author Github handle from stdin, and print the
#  author's real name and GitHub handle, followed by a list of contributors
#  with their real name and GitHub handle
# Output format:
#   *(Written by <author_name>, <github_handle>, with contributions by:
#     <contributor_name>, <github_handle>, )*
print_author_info() {
  local line author_github author_name 
  read -r line
  author_github="$(awk -F, '{ print $1 }' <<< "${line}")"
  author_name="$(grep "${author_github}" "${author_info_file}" | head -1 | cut --delimiter=',' --fields=2)"
  printf -- '*(Written by %s, <https://github.com/%s/>, with contributions by: ' \
    "${author_name}" "${author_github}"

  while read -r line; do
    author_github="$(awk -F, '{ print $1 }' <<< "${line}")"
    author_name="$(grep "${author_github}" "${author_info_file}" | head -1 | cut --delimiter=',' --fields=2)"
    printf -- '%s, <https://github.com/%s/>, ' \
      "${author_name}" "${author_github}"
  done
  printf ')*\n'
}

# Usage: cleanup_ending <<< AUTHOR_INFO
#   Remove trailing ", )" or empty contributors list", with contributions by: )"
cleanup_ending() {
  sed 's/, )/)/' | sed 's/, with contributions by: )/)/'
}

# Usage: log MESSAGE
# Print MESSAGE to stdout, if debug_lvl is greater than or equal to 2.
log() {
  local message="${*}"
  if [ "${debug_lvl}" -ge 2 ]; then
    printf '\e[0;33m[LOG] %s\e[0m\n' "${message}"
  fi
}

sort_by_num_lines() {
  sort --numeric-sort --reverse \
    --key=2 --field-separator=','
}

# add_author_info() {
#   local num_lines author_email author_github
#   while read -r line; do
#     num_lines="$(awk '{ print $1 }' <<< "${line}")"
#     author_email="$(awk '{ print $2 }' <<< "${line}")"
#     author_name="$(grep "${author_email}" "${author_info_file}" | cut --delimiter=',' --fields=2)"
#     author_github="$(grep "${author_email}" "${author_info_file}" | cut --delimiter=',' --fields=3 | tr -d '\r')"
#     printf '%s,%s,%s,%s\n' \
#        "${num_lines}" "${author_email}" "${author_name}" "${author_github}"
#     # printf -- '- %s, <https://github.com/%s>\n' \
#     #   "${author_name}" "${author_github}"
#   done
# }

# sort_by_author() {
#   sort --ignore-case --key=3 --field-separator=','
# }

main "$@"