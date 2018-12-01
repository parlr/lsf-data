#!/usr/bin/env bash
# DESCRIPTION
#   Create JSON dictionary and move file to production directy
#
# USAGE
#   bash ./raw-to-production.bash glob

PATTERN_TO_MOVE="../videos/*.webm"

function move_video() {
    local new_directory_path="${directory_path/raw/videos}"
    local new_filepath="$new_directory_path/$new_filename"

    # git mv "$filepath" "$new_filepath"
    echo "$filepath" "$new_filepath"
}

function update_videos() {
  for filepath in $PATTERN_TO_MOVE; do
    local directory_path="${filepath%/*}"
    local filename="${filepath##*/}"

    local drop_mkv_extension="${filename/.mkv/}"
    local drop_timing="${drop_mkv_extension#*.}"
    local new_filename=${drop_timing:3}

    move_video "$directory_path" "$new_filename"
  done
}

[[ -z $RUNNING_TESTS ]] && update_videos