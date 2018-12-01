#!/usr/bin/make -f

SHELL := /bin/bash  # force use of Bash
INTERACTIVE=true
BATS=./test/libs/bats/bin/bats

.PHONY: test

install: update
	sudo apt-get install --yes \
		ffmpeg \
		libav-tools

test:
	${BATS} --pretty ./test/*.test.bash

split-video-1:
	source ./scripts/split-laura-video.bash ./data/partie-1*.hd.mkv \
		&& extract_timing_from_subtitles \
		&& split_video

split-video-2:
	source ./scripts/split-laura-video.bash ./data/partie-2*.hd.mkv \
		&& extract_timing_from_subtitles \
		&& split_video

split-videos: split-video-1 split-video-2

build: split-videos
	bash ./scripts/convert-videos.bash
	bash ./scripts/create-json-dictionary.bash
	bash ./scripts/raw-to-production.bash

update:
	git submodule update --init --recursive
