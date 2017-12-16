#!/usr/bin/env bash
# USAGE
#   bash ./raw-to-production.bash

files=${1:-./raw/*.webm}
for filepath in $files; do
  directory_path="${filepath%/*}"
  filename="${filepath##*/}"

  no_mkv_extension="${filename/.mkv/}"
  new_filename="${no_mkv_extension#*.}"
  new_directory_path="${directory_path/raw/video}"
  new_filepath="$new_directory_path/${new_filename:3}"

  git mv "$filepath" "$new_filepath"
done
