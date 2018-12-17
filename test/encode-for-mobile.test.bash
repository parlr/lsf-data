#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'libs/bats-file/load'
export IS_RUNNING_TESTS=true
load '../scripts/encode-for-mobile'

setup() {
  mkdir --parents ./.tmp
}

teardown() {
  rm --force --recursive ./.tmp
  echo
}

@test 'call ffmpeg with correct arguments to encode for mobile' {
  ffmpeg() { echo "ffmpeg $*"; exit; }  # mock
  export -f ffmpeg
  cp ./test/paris.webm ./.tmp/

  run extract-and-encode ./.tmp/paris.webm 'paris' '0:00:00.00' '0:00:01.00' .tmp/output/

  assert_output 'ffmpeg -i ./.tmp/paris.webm -ss 0:00:00.00 -to 0:00:01.00 -b:v 512k -c:v libvpx-vp9 -crf 37 -filter:v scale=640x480 -loglevel error -maxrate 742k -minrate 256k -pass 1 -quality good -r 14 -speed 4 -threads 4 -tile-columns 1 -y .tmp/output//paris.webm' 
}
