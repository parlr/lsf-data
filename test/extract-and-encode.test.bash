#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'libs/bats-file/load'
export IS_RUNNING_TESTS=true
load '../scripts/extract-and-encode'

setup() {
  mkdir --parents ./.tmp
}

teardown() {
  rm --force --recursive ./.tmp
  echo
}

@test "fails if no arguments provided" {
  run process-all

  assert_output <<OUTPUT
missing arguments.
usage:
    extract-and-encode.bash path/to/video.webm [path/to/timing.tsv]
OUTPUT
  assert_failure
}

@test "fails if 'timing'argument missing" {
  run process-all ./.tmp/paris.webm

  assert_output 'missing argument: path/to/timing.tsv'
  assert_failure
}

@test 'call ffmpeg with correct arguments to extract and encode' {
  ffmpeg() { echo "ffmpeg $*"; exit; }  # mock
  export -f ffmpeg
  cp ./test/paris.webm ./.tmp/

  run extract-and-encode ./.tmp/paris.webm 'paris' '0:00:00.00' '0:00:01.00' 

  assert_output 'ffmpeg -y -i ./.tmp/paris.webm -ss 0:00:00.00 -to 0:00:01.00 -r 14 -vf scale=640x480 -b:v 512k -minrate 256k -maxrate 742k -quality good -speed 4 -crf 37 -c:v libvpx-vp9 -loglevel error videos//paris.webm' 
}

@test 'extract clip from video' {
  cp ./test/paris.webm ./.tmp/

  run extract-and-encode ./.tmp/paris.webm 'paris' '0:00:00.00' '0:00:01.00' 

  assert_file_exist ./videos/paris.webm
}

@test 'extract clip to author directory' {
  cp ./test/paris.webm ./.tmp/
  mkdir -p videos/test-author/

  run extract-and-encode ./.tmp/paris.webm 'paris' '0:00:00.00' '0:00:01.00' 'test-author'

  assert_file_exist ./videos/test-author/paris.webm
  rm --recursive --force videos/test-author/
}

@test "process all create author's directory" {
  extract-and-encode() { echo "$*"; }  # mock
  export -f extract-and-encode

  run process-all 'foo' 'bar' test-author

  assert_file_exist videos/test-author/
  rm --recursive --force videos/test-author/
}


@test 'process all entries' {
  cp ./test/paris.webm ./.tmp/paris.webm
  echo '0:00:00.00 0:00:01.00 paris' > ./.tmp/dataset.tsv
  cp ./test/paris.webm ./.tmp/bordeaux.webm
  echo '0:00:00.00 0:00:01.00 bordeaux' >> ./.tmp/dataset.tsv

  run process-all ./test/paris.webm ./.tmp/dataset.tsv

  assert_file_exist ./videos/paris.webm
  assert_file_exist ./videos/bordeaux.webm
  rm ./videos/{paris,bordeaux}.webm
}
