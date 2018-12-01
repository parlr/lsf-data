#!/usr/bin/env bash
# see: https://askubuntu.com/q/56022/22343
# REQUIREMENT:
#   sudo apt install --yes ffmpeg libav-tools
# USAGE
#   bash -x ./scripts/split-laura-video.bash "$path/to/videos" ["$timing"]

full_path="$1" # video file to split
directory_path="${full_path%/*}"
filename="${full_path##*/}"
extension="${full_path##*.}"
timing_path="${2:-$directory_path/$filename.tsv}"   # timing, as: mot  start_time end_time
input_data_path="$directory_path/${filename/.$extension/.ass}"
output_directory_path="./raw"

extract_timing_from_subtitles() {
  awk 'BEGIN{FS=","} /Dialogue/{print $2" "$3" "$10}' \
     "$input_data_path" \
   > "$timing_path"
}

extract_and_encode_word_chunk() {
  local start
  start="$1"
  local end
  end="$2"

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
    -i "$full_path" \
    -ss "$start" \
    -to "$end" \
    "${args[@]}" \
    "$chunk.webm" < /dev/null
}

split_video() {
  while read -r start end mot; do
    echo "Extracting: $mot"
    chunk="$output_directory_path/$start.$mot.$extension"

    extract_and_encode_word_chunk "${start}" "${end}"
  done < "$timing_path"
}
