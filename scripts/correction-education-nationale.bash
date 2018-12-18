#!/usr/bin/env bash
# DESCRIPTION
#   Corrige l'orthographe et lève l'ambiguité sur certaines entrées
#
# USAGE
#   bash ./correction-education-nationale.bash

IS_RUNNING_TESTS="${IS_RUNNING_TESTS:=false}"

function correction-education-nationale() {
  while IFS=';' read -r old new; do
    if [[ -n $new ]]; then
        old_filepath="videos/education-nationale/$old.webm"
        new_filepath="videos/education-nationale/$new.webm"
        echo "Renaming: $old → $new"
        git mv "$old_filepath" "$new_filepath"
    else
        echo "Keeping: $old"
    fi
  done < ./data/correction-education-nationale.csv
}

if [[ $IS_RUNNING_TESTS == false ]]; then correction-education-nationale; fi

