#!/usr/bin/env bash

# shellcheck disable=SC1091
source ./scripts/split-laura-video.bash ./"raw/partie 1"*.hd.mkv
extract_timing_from_subtitles
split_video

source ./scripts/split-laura-video.bash ./"raw/partie 2"*.hd.mkv
extract_timing_from_subtitles
split_video

source ./raw-to-production.bash
