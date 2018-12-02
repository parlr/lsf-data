#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'libs/bats-file/load'
export IS_RUNNING_TESTS=true
load '../scripts/encode-videos'

setup() {
  mkdir --parents ./test/.tmp/
}

teardown() {
  rm --force --recursive ./test/.tmp/
  echo
}

@test 'call ffmpeg with correct arguments to encode' {
  ffmpeg() { echo "ffmpeg $*"; exit; }  # mock
  export -f ffmpeg

  run encode 'test/paris.mkv' 'test/.tmp/paris.webm'

  spy="${lines[0]}"
  assert_equal "$spy" "ffmpeg -y -i test/paris.mkv -r 14 -vf scale=640x480 -b:v 512k -minrate 256k -maxrate 742k -quality good -speed 4 -crf 37 -c:v libvpx-vp9 -loglevel error test/.tmp/paris.webm"
}

@test 'encoding file exists' {
  cp ./test/paris.mkv ./test/.tmp/0:00:00.00.paris.mkv
  run encode 'test/paris.mkv' 'test/.tmp/paris.webm'

  assert_file_exist './test/.tmp/0:00:00.00.paris.mkv' 'test/.tmp/paris.webm'
}
