#!/usr/bin/env bash
# see: https://askubuntu.com/q/56022/22343
# REQUIREMENT:
#   sudo apt install --yes ffmpeg libav-tools
# USAGE
#   bash -x ./scripts/extract-copy.bash "$path/to/videos" [path/to/timing.tsv]

IS_RUNNING_TESTS="${IS_RUNNING_TESTS:=false}"
FAIL=1

extract-copy() {
    local video_source="$1"
    local mot="$2"
    local start="$3"
    local end="$4"

    ffmpeg_args=(
        -ss "$start" 
        -to "$end"
        -acodec copy
        -vcodec copy
        -loglevel error
    )
    local target_file="videos-hd/$mot.mkv"

    ffmpeg -y \
        -i "$video_source" \
        "${ffmpeg_args[@]}" \
        "$target_file"  < /dev/null  # to prevent ffmpeg from swallowing input 
}

process-all() {
    if [[ $# -eq 0 ]] ; then
        echo 'missing arguments.'
        echo 'usage:'
        echo "    extract-copy.bash path/to/video.mkv [path/to/timing.tsv]"
        exit $FAIL
    fi
    if [[ -z $2 ]]; then
        echo 'missing argument: path/to/timing.tsv'
        exit $FAIL
    fi
    local video_source="$1"
    local video_timing="$2"

  while read -r start end mot; do
    echo "Extracting: $mot"
    extract-copy "$video_source" "$mot" "${start}" "${end}"
  done < "$video_timing"
}
if [[ $IS_RUNNING_TESTS == false ]]; then process-all "$@"; fi
