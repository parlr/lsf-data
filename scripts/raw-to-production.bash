#!/usr/bin/env bash
# DESCRIPTION
#   Create JSON dictionary and move file to production directy
#
# USAGE
#   bash ./raw-to-production.bash subtitle-file [glob]

WITH_ERROR=1

function check_arguments() {
  if [[ -z $1 ]]; then exit $WITH_ERROR; fi
  vocabulaire="${1%.*}.json"
  files=${2:-./raw/*.webm}
}

function begin_dictionary() {
  echo '[' > "$vocabulaire"
}
function end_dictionary() {
  sed -i '$ s/.$/\n]/' "$vocabulaire"
}

function add_word() {
  local mot="$1"

  key="$(echo "$mot" | iconv -f UTF-8 -t ASCII//TRANSLIT | sed 's!\s!-!g')"
  json=$(cat <<-JSON
  {
    "key": "${key}",
    "label": "${mot}",
    "video": "video/${mot}.webm"
  },
JSON
  )
  echo "$json" >> "$vocabulaire"
}

function move_video() {
    new_directory_path="${directory_path/raw/video}"
    local new_filepath="$new_directory_path/$new_filename"

    # git mv "$filepath" "$new_filepath"
    echo "$filepath" "$new_filepath"
}
function fill_dictionary() {
  for filepath in $files; do
    directory_path="${filepath%/*}"
    filename="${filepath##*/}"

    drop_mkv_extension="${filename/.mkv/}"
    drop_timing="${drop_mkv_extension#*.}"
    new_filename=${drop_timing:3}
    mot="${new_filename%.*}"

    add_word "$mot"
    move_video "$directory_path" "$new_filename"
  done
}

# check_arguments "$1" "$2"
# begin_dictionary "$vocabulaire"
# fill_dictionary "$files"
# end_dictionary "$vocabulaire"
