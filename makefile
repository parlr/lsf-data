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

split-video: split_video-1 split_video-2

split-video-1:
	source ./scripts/split.bash ./"raw/partie 1"*.hd.mkv; \
	extract_timing_from_subtitles; \
	split_video

split-video-2:
	source ./scripts/split.bash ./"raw/partie 2"*.hd.mkv; \
	extract_timing_from_subtitles; \
	split_video

build:
	bash ./scripts/build.bash

update:
	git submodule update --init --recursive
