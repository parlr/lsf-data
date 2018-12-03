#!/usr/bin/make -f

SHELL := /bin/bash  # force use of Bash
INTERACTIVE=true
BATS=./test/libs/bats/bin/bats

.PHONY: test

install: update
	sudo add-apt-repository ppa:duggan/bats --yes
	sudo apt-get update --quiet --quiet
	sudo apt-get install \
		--yes \
		--no-install-recommends \
		--no-install-suggests \
		--quiet --quiet \
		bats \
		ffmpeg \
		libav-tools

test:
	${BATS} --pretty ./test/*.test.bash

build:
	time bash ./scripts/split-laura-video.bash ./data/partie-1*.hd.mkv
	time bash ./scripts/split-laura-video.bash ./data/partie-2*.hd.mkv
	time bash ./scripts/encode-videos.bash
	time bash ./scripts/create-json-dictionary.bash

update-dictionary:
	bash ./scripts/create-json-dictionary.bash
	cp ./vocabulaire.json ../lsf/src/assets/

