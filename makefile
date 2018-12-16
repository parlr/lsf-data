#!/usr/bin/make -f

SHELL := /bin/bash  # force use of Bash
INTERACTIVE=true
BATS=./test/libs/bats/bin/bats

.PHONY: install
install:
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
	curl https://github.com/yarl/pattypan/releases/download/v18.02/pattypan.jar \
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

.PHONY: extract-copy
extract-copy:
	if [[ ! -d videos-hd ]]; then mkdir videos-hd; fi
	bash ./scripts/extract-copy.bash \
		./data/partie-1:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.mkv \
		./data/partie-1:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.tsv
	bash ./scripts/extract-copy.bash \
		./data/partie-2:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.mkv \
		./data/partie-2:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.tsv

.PHONY: extract-and-encode
extract-and-encode:
	bash ./scripts/extract-and-encode.bash \
		./data/partie-1:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.mkv \
		./data/partie-1:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.tsv
	bash ./scripts/extract-and-encode.bash \
		./data/partie-2:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.mkv \
		./data/partie-2:-Apprendre-300-mots-du-quotidien-en-LSF.jauvert-laura.hd.tsv

.PHONY: build
build: extract-timing extract-and-encode
	time bash ./scripts/encode-videos.bash
	time bash ./scripts/create-json-dictionary.bash

.PHONY: update-dictionary
update-dictionary:
	bash ./scripts/create-json-dictionary.bash
	cp ./vocabulaire.json ../lsf/src/assets/

