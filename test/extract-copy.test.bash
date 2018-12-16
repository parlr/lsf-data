#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'libs/bats-file/load'
export IS_RUNNING_TESTS=true
load '../scripts/extract-copy'


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
    extract-copy.bash path/to/video.mkv [path/to/timing.tsv]
OUTPUT
  assert_failure
}

@test "fails if 'timing'argument missing" {
  run process-all ./.tmp/paris.mkv

  assert_output 'missing argument: path/to/timing.tsv'
  assert_failure
}

@test 'call ffmpeg with correct arguments to extract and encode' {
  ffmpeg() { echo "ffmpeg $*"; exit; }  # mock
  export -f ffmpeg
  cp ./test/paris.mkv ./.tmp/

  run extract-copy ./.tmp/paris.mkv 'paris' '0:00:00.00' '0:00:01.00' 

  assert_output 'ffmpeg -y -i ./.tmp/paris.mkv -ss 0:00:00.00 -to 0:00:01.00 -acodec copy -vcodec copy -loglevel error videos-hd/paris.mkv' 
}

@test 'extract clip from video' {
  cp ./test/paris.mkv ./.tmp/

  run extract-copy ./.tmp/paris.mkv 'paris' '0:00:00.00' '0:00:01.00' 

  assert_file_exist ./videos-hd/paris.mkv
}

@test 'process all entries' {
  cp ./test/paris.mkv ./.tmp/paris.mkv
  echo '0:00:00.00 0:00:01.00 paris' > ./.tmp/dataset.tsv
  cp ./test/paris.mkv ./.tmp/bordeaux.mkv
  echo '0:00:00.00 0:00:01.00 bordeaux' >> ./.tmp/dataset.tsv

  run process-all ./test/paris.mkv ./.tmp/dataset.tsv

  assert_file_exist ./videos-hd/paris.mkv
  assert_file_exist ./videos-hd/bordeaux.mkv
}
