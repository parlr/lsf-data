#!/usr/bin/env bash
# see: https://askubuntu.com/q/56022/22343
# REQUIREMENT:
#   sudo apt install --yes ffmpeg libav-tools
# USAGE
#   bash -x ./split.bash "$video" ["$timing"]

INPUT_FILE="$1"   # video file to split

full_path="$1"
directory_path="${full_path%/*}"
filename="${full_path##*/}"
extension="${full_path##*.}"
timing_path="${2:-$directory_path/$filename.tsv}"   # timing, as: mot  start_time end_time


extract_timing_from_subtitles() {
  awk 'BEGIN{FS=","} /Dialogue/{print $2" "$3" "$10}' \
     "$directory_path/${filename/.$extension/.ass}" \
   > "$directory_path/$filename.tsv"
}

extract_word_chunk() {
  ffmpeg \
    -i "$INPUT_FILE" \
    -ss "$start" \
    -to "$end" \
    -vcodec copy \
    -acodec copy \
    -loglevel error \
    "$chunk" < /dev/null
}

convert_to_webm() {
  ffmpeg \
    -y \
    -i "$chunk" \
    -acodec libvorbis \
    -codec:v libvpx \
    -b:v 192k \
    -b:a 96k \
    -minrate 128k \
    -maxrate 256k \
    -bufsize 192k \
    -quality good \
    -cpu-used 2 \
    -deadline best \
    -loglevel error \
  "$chunk.webm" < /dev/null
  # rm "$chunk"
}

split_video() {
  while read -r start end mot; do
    chunk="$directory_path/$start.$mot.$extension"

    extract_word_chunk "${start}" "${end}"
    convert_to_webm
  done < "$timing_path"
}

extract_timing_from_subtitles
split_video
