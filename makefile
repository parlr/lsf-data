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

split-video:
		bash ./scripts/split.bash ./"raw/partie 1"*.mkv
		bash ./scripts/split.bash ./"raw/partie 2"*.mkv

update:
	git submodule update --init --recursive
