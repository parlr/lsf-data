#!/usr/bin/env bash
# see: https://askubuntu.com/q/56022/22343
# REQUIREMENT:
#   sudo apt install --yes ffmpeg libav-tools
# USAGE
#   bash -x ./scripts/encode-videos.bash "$path/to/videos" ["$timing"]

IS_RUNNING_TESTS="${IS_RUNNING_TESTS:=false}"
FILES_TO_CONVERT="raw/*.mkv"

encode() {
  local source_file="$1"
  local target_file="$2"

  # Recommended Settings for VP9 by Google
  # https://developers.google.com/media/vp9/settings/vod/
  local args
  args=(
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

  ffmpeg -y \
    -i "$source_file" \
    "${args[@]}" \
    "$target_file" < /dev/null
}

function convert() {
  for source_file in $FILES_TO_CONVERT; do
    local filename="${source_file##*/}"
    local drop_timing="${filename#*.}"
    local drop_milliseconds=${drop_timing:3}
    local mot="${drop_milliseconds/.mkv/}"
    local target_file="./videos/$mot.webm"

    echo "Extracting: $mot"
    encode "$source_file" "$target_file"
  done
}

if [[ $IS_RUNNING_TESTS == false ]]; then convert; fi