#!/usr/bin/env bash
# see: https://askubuntu.com/q/56022/22343
# REQUIREMENT:
#   sudo apt install --yes ffmpeg libav-tools
# USAGE
#   bash -x ./scripts/split.bash "$video" ["$timing"]

full_path="$1" # video file to split
directory_path="${full_path%/*}"
filename="${full_path##*/}"
extension="${full_path##*.}"
timing_path="${2:-$directory_path/$filename.tsv}"   # timing, as: mot  start_time end_time
input_data_path="$directory_path/${filename/.$extension/.ass}"

extract_timing_from_subtitles() {
  awk 'BEGIN{FS=","} /Dialogue/{print $2" "$3" "$10}' \
     "$input_data_path" \
   > "$timing_path"
}

extract_and_encode_word_chunk() {
  ffmpeg -y \
    -i "$full_path" \
    -ss "$start" \
    -to "$end" \
    -vf scale=640x480 \
    -b:v 512k \
    -minrate 256k \
    -maxrate 742k \
    -quality good \
    -speed 4 \
    -crf 37 \
    -c:v libvpx-vp9 \
    -loglevel error \
    "$chunk.webm" < /dev/null
}

split_video() {
  while read -r start end mot; do
    chunk="$directory_path/$start.$mot.$extension"

    extract_and_encode_word_chunk "${start}" "${end}"
  done < "$timing_path"
}
