#!/usr/bin/env bash
# DESCRIPTION
#   Create JSON dictionary and move file to production directy
#
# USAGE
#   bash ./create-json-dictionary.bash

# set -x
JSON_FILE="${JSON_FILE:=vocabulaire.json}"
FILES_TO_INDEX="${FILES_TO_INDEX:="./videos/*.webm"}"
IS_RUNNING_TESTS="${IS_RUNNING_TESTS:=false}"

function begin_dictionary() {
  echo '[' > "$JSON_FILE"
}
function end_dictionary() {
  sed -i '$ s/},$/}\n]/' "$JSON_FILE"
}

function add_word() {
  local mot="$1"
    
  key="$(echo "$mot" | iconv -f UTF-8 -t ASCII//TRANSLIT | sed 's!\s!-!g')"
  json=$(cat <<-JSON
  {
    "key": "${key}",
    "label": "${mot}",
    "video": "videos/${mot}.webm"
  },
JSON
  )
  echo "$json" >> "$JSON_FILE"
}

function fill_dictionary() {
    for filepath in $FILES_TO_INDEX; do
        local filename="${filepath##*/}"
        local drop_mkv_extension="${filename/.mkv/}"

        mot="${drop_mkv_extension%.*}"

        [[ $IS_RUNNING_TESTS == false ]] && echo "Adding: $mot"
        add_word "$mot"
    done
}

function create_json_dictionary() {
    begin_dictionary "$JSON_FILE"
    fill_dictionary "$FILES_TO_INDEX"
    end_dictionary "$JSON_FILE"
}

if [[ $IS_RUNNING_TESTS == false ]]; then create_json_dictionary; fi