#!/usr/bin/env bash
# see: https://askubuntu.com/q/56022/22343
# REQUIREMENT:
#   sudo apt install --yes ffmpeg libav-tools
# USAGE
#   bash -x ./scripts/split-laura-video.bash "$path/to/videos" ["$timing"]

IS_RUNNING_TESTS="${IS_RUNNING_TESTS:=false}"

SOURCE_VIDEO_FILE="$1" # video file to split
directory_path="${SOURCE_VIDEO_FILE%/*}"
filename="${SOURCE_VIDEO_FILE##*/}"
timing_path="${2:-$directory_path/$filename.tsv}"   # timing, as: mot  start_time end_time

extract_word_chunk() {
  local target_file="$1"
  local start="$2"
  local end="$3"

  # Recommended Settings for VP9 by Google
  # https://developers.google.com/media/vp9/settings/vod/
  local args
  args=(
    -acodec copy
    -vcodec copy
    -loglevel error
  )

  ffmpeg -y \
    -i "$SOURCE_VIDEO_FILE" \
    -ss "$start" \
    -to "$end" \
    "${args[@]}" \
    "$target_file" < /dev/null
}

split_video() {
  while read -r start end mot; do
    echo "Extracting: $mot"

    target_file="raw/$start.$mot.mkv"
    extract_word_chunk "$target_file" "${start}" "${end}"
  done < "$timing_path"
}

function extract_video_chunks() {
  split_video
}
if [[ $IS_RUNNING_TESTS == false ]]; then extract_video_chunks; fi
