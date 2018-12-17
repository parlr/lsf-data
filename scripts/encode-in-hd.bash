#!/usr/bin/env bash
# FFMPEG options to encode in HD
# see https://developers.google.com/media/vp9/settings/vod/

IS_RUNNING_TESTS="${IS_RUNNING_TESTS:=false}"

export FFMPEG_OPTIONS=(  # HD options
    -b:v 1024k
    -c:v libvpx-vp9  # video codec
    -cpu-used 4
    -crf 32  # maximum quality level.
    -filter:v scale=1280x720 
    -loglevel warning
    -maxrate 1485k 
    -minrate 512k 
    -quality good 
    -speed 4
    -threads 8
    -tile-columns 2 
    -y
)

# shellcheck source=./scripts/encode.bash
source ./scripts/encode.bash

if [[ $IS_RUNNING_TESTS == false ]]; then process-all "$@"; fi
