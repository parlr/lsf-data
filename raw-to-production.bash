#!/usr/bin/env bash
# USAGE
#   bash ./raw-to-production.bash subtitle-file [glob]

if [[ -z $1 ]]; then exit; fi
vocabulaire="${1%.*}.json"
files=${2:-./raw/*.webm}

echo '[' > "$vocabulaire"
for filepath in $files; do
  directory_path="${filepath%/*}"
  filename="${filepath##*/}"

  drop_mkv_extension="${filename/.mkv/}"
  drop_timing="${drop_mkv_extension#*.}"
  new_directory_path="${directory_path/raw/video}"
  new_filename=${drop_timing:3}
  mot="${new_filename%.*}"
  new_filepath="$new_directory_path/$new_filename"

  key="$(echo "$mot" | iconv -f UTF-8 -t ASCII//TRANSLIT | sed 's!\s!-!g')"
  json=$(cat <<-JSON
  {
    "key": "${key}",
    "label": "${mot}",
    "video": "video/${mot}.webm"
  },
JSON
  )

  echo $json >> "$vocabulaire"
  # git mv "$filepath" "$new_filepath"
  echo "$filepath" "$new_filepath"
done
sed -i '$ s/.$/\n]/' "$vocabulaire"
