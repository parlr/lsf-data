#!/usr/bin/make -f

SHELL := /bin/bash  # force use of Bash
INTERACTIVE=true
BATS=./test/libs/bats/bin/bats

.PHONY: install
install:
	sudo add-apt-repository ppa:jonathonf/ffmpeg-4 --yes
	sudo add-apt-repository ppa:duggan/bats --yes
	sudo apt-get update --quiet --quiet
	sudo apt-get install \
		--yes \
		--no-install-recommends \
		--no-install-suggests \
		--quiet --quiet \
		bats \
		ffmpeg

.PHONY: install-subtitle-editor
install-subtitle-editor:
	sudo add-apt-repository ppa:alex-p/aegisub --yes
	sudo apt-get update --quiet --quiet
	sudo apt-get install  \
		--yes \
		--no-install-recommends \
		--no-install-suggests \
		--quiet --quiet \
		aegisub

.PHONY: install-uploader
install-uploader:
	curl https://github.com/yarl/pattypan/releases/download/v20.04/pattypan.jar \
		--output pattypan.jar \
		--location
	apt-get install \
		--yes \
		--no-install-recommends \
		--no-install-suggests \
		--quiet --quiet \
	openjfx \
	openjdk-8-jre \
	openjdk-8-jre-headless

.PHONY: test
test:
	${BATS} --pretty ./test/*.test.bash

.PHONY: extract-timing
extract-timing:
	time bash ./scripts/extract-timing.bash \
		./data/partie-1:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.ass
	time bash ./scripts/extract-timing.bash \
		./data/partie-2:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.ass

.PHONY: encode-in-hd
encode-in-hd:
	if [[ ! -d videos-hd ]]; then mkdir videos-hd; fi
	time bash ./scripts/encode-in-hd.bash \
		./data/partie-1:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.webm \
		./data/partie-1:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.tsv \
		./videos/hd/
	time bash ./scripts/encode-in-hd.bash \
		./data/partie-2:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.webm \
		./data/partie-2:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.tsv \
		./videos/hd/

.PHONY: encode-for-mobile
encode-for-mobile:
	time bash ./scripts/encode-for-mobile.bash \
		./data/partie-1:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.webm \
		./data/partie-1:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.tsv \
		./videos/jauvert/
	time bash ./scripts/encode-for-mobile.bash \
		./data/partie-2:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.webm \
		./data/partie-2:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.tsv \
		./videos/jauvert/

.PHONY: build
build: extract-timing encode-for-mobile
	time bash ./scripts/create-json-dictionary.bash

.PHONY: update-dictionary
update-dictionary:
	cp ./vocabulaire.json ../lsf/src/assets/
	cp ./semantic-primes.json ../lsf/src/assets/

.PHONY: convert-jauvert-to-webm
convert-jauvert-to-webm:
	@echo "Convert MP4 source to WEBM (only accepted in Commons)"
	@if (( $$(ls ./data/partie-*.jauvert-laura.hd.mp4 | wc -l) != 2 )); then printf "\n/!\ Files to convert are missing!\n\n"; exit 1; fi
	rm data/*.webm
	time ffmpeg \
		-i ./data/partie-1:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.mp4 \
		-b:v 1024k \
		-c:v libvpx-vp9 \
		-cpu-used 4 \
		-crf 32 \
		-g 240 \
		-loglevel warning \
		-maxrate 1485k \
		-minrate 512k \
		-quality good \
		-speed 4 \
		-threads 8 \
		-tile-columns 2 \
		-vf scale=1280x720 \
		-y \
		./data/partie-1:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.webm
	time ffmpeg \
		-i ./data/partie-2:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.mp4 \
		-b:v 1024k \
		-c:v libvpx-vp9 \
		-cpu-used 4 \
		-crf 32 \
		-g 240 \
		-loglevel warning \
		-maxrate 1485k \
		-minrate 512k \
		-quality good \
		-speed 4 \
		-threads 8 \
		-tile-columns 2 \
		-vf scale=1280x720 \
		-y \
		./data/partie-2:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.webm
