#!/usr/bin/env bash
# see: https://askubuntu.com/q/56022/22343
# REQUIREMENT:
#   make install
# USAGE
#   bash -x ./scripts/extract-and-encode.bash "$path/to/videos" [path/to/timing.tsv]

IS_RUNNING_TESTS="${IS_RUNNING_TESTS:=false}"
FAIL=1

extract-and-encode() {
    local video_source="$1"
    local mot="$2"
    local start="$3"
    local end="$4"
    local output_directory="$5"

    ffmpeg_args=(
        -i "$video_source"
        -ss "$start"
        -to "$end"
        "${FFMPEG_OPTIONS[@]}"  # inherited
    )    
    ffmpeg "${ffmpeg_args[@]}" "$output_directory/$mot.webm"  < /dev/null  # to prevent ffmpeg from swallowing input 
}

process-all() {
    if [[ $# -eq 0 ]] ; then
        echo 'missing arguments.'
        echo 'usage:'
        echo "    extract-and-encode.bash path/to/video.webm [path/to/timing.tsv]"
        exit $FAIL
    fi
    if [[ -z $2 ]]; then
        echo 'missing argument: path/to/timing.tsv'
        exit $FAIL
    fi
    if [[ -z $3 ]]; then
        echo 'missing argument: path/to/output/'
        exit $FAIL
    fi

    local video_source="$1"
    local video_timing="$2"
    local output_directory="$3"

    if [[ ! -d $output_directory ]]; then mkdir -p "$output_directory"; fi

  while read -r start end mot; do
    echo "Extracting: $mot"
    extract-and-encode "$video_source" "$mot" "${start}" "${end}" "$output_directory"
  done < "$video_timing"
}

if [[ $IS_RUNNING_TESTS == false ]]; then process-all "$@"; fi
