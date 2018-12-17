#!/usr/bin/env bash
# FFMPEG options to encode for mobile
# see https://developers.google.com/media/vp9/settings/vod/

IS_RUNNING_TESTS="${IS_RUNNING_TESTS:=false}"

export FFMPEG_OPTIONS=(  # options for mobile        
    -b:v 512k
    -c:v libvpx-vp9  # video codec
    -crf 37  # maximum quality level.
    -filter:v scale=640x480
    -loglevel error
    -maxrate 742k
    -minrate 256k
    -pass 1 
    -quality good
    -r 14  # framerate
    -speed 4
    -threads 4
    -tile-columns 1
    -y
)

# shellcheck source=./scripts/encode.bash
source ./scripts/encode.bash

if [[ $IS_RUNNING_TESTS == false ]]; then process-all "$@"; fi
