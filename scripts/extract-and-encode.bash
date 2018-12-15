#!/usr/bin/env bash
# see: https://askubuntu.com/q/56022/22343
# REQUIREMENT:
#   sudo apt install --yes ffmpeg libav-tools
# USAGE
#   bash -x ./scripts/extract-and-encode.bash "$path/to/videos" [path/to/timing.tsv]

IS_RUNNING_TESTS="${IS_RUNNING_TESTS:=false}"
FAIL=1

extract-and-encode() {
    local video_source="$1"
    local mot="$2"
    local start="$3"
    local end="$4"

    ffmpeg_args=(
        -ss "$start" \
        -to "$end" \
        -r 14  # framerate
        -vf scale=640x480
        -b:v 512k
        -minrate 256k
        -maxrate 742k
        -quality good
        -speed 4
        -crf 37  # maximum quality level.
        -c:v libvpx-vp9  # video codec
        -loglevel error
    )
    local target_file="videos/$mot.webm"

    ffmpeg -y \
        -i "$video_source" \
        "${ffmpeg_args[@]}" \
        "$target_file"  < /dev/null  # to prevent ffmpeg from swallowing input 
}

process-all() {
    if [[ $# -eq 0 ]] ; then
        echo 'missing arguments.'
        echo 'usage:'
        echo "    extract-and-encode.bash path/to/video.mkv [path/to/timing.tsv]"
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
    extract-and-encode "$video_source" "$mot" "${start}" "${end}"
  done < "$video_timing"
}
if [[ $IS_RUNNING_TESTS == false ]]; then process-all "$@"; fi
