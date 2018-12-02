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

build:
	time bash ./scripts/split-laura-video.bash ./data/partie-1*.hd.mkv
	time bash ./scripts/split-laura-video.bash ./data/partie-2*.hd.mkv
	time bash ./scripts/encode-videos.bash
	time bash ./scripts/create-json-dictionary.bash

update:
	git submodule update --init --recursive
