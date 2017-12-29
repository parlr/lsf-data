#!/usr/bin/env bash

source ./raw-to-production.bash
source ./split.bash

extract_timing_from_subtitles
split_video
