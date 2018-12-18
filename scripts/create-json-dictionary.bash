#!/usr/bin/env bash
# DESCRIPTION
#   Create JSON dictionary and move file to production directy
#
# USAGE
#   bash ./create-json-dictionary.bash

JSON_FILE="${JSON_FILE:=vocabulaire.json}"
FILES_TO_INDEX=( videos/{education-nationale,elix,jauvert}/*.webm )
IS_RUNNING_TESTS="${IS_RUNNING_TESTS:=false}"

function begin_dictionary() {
  echo '[' > "$JSON_FILE"
}
function end_dictionary() {
  sed -i '$ s/},$/}\n]/' "$JSON_FILE"
}

function add_word() {
  local mot="$1"
  local video="$2"
    
  json=$(cat <<-JSON
  {
    "key": "${mot}",
    "video": "${video}"
  },
JSON
  )
  echo "$json" >> "$JSON_FILE"
}

function fill_dictionary() {
    for filepath in "${FILES_TO_INDEX[@]}"; do
        local filename="${filepath##*/}"
        local video="${filepath#*/}"
        local drop_extension="${filename%.*}"

        mot="${drop_extension%.*}"

        [[ $IS_RUNNING_TESTS == false ]] && echo "Indexing: $mot"
        add_word "$mot" "$video"
    done
}

function create_json_dictionary() {
    begin_dictionary "$JSON_FILE"
    fill_dictionary "$FILES_TO_INDEX"
    end_dictionary "$JSON_FILE"
}

if [[ $IS_RUNNING_TESTS == false ]]; then create_json_dictionary; fi