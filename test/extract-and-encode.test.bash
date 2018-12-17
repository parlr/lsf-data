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

@test "fails if 'timing' argument missing" {
  run process-all video.webm

  assert_output 'missing argument: path/to/timing.tsv'
  assert_failure
}

@test "fails if 'output_directory' argument missing" {
  run process-all video.webm timing.tsv

  assert_output 'missing argument: path/to/output/'
  assert_failure
}

@test 'call ffmpeg with correct arguments to extract and encode' {
  ffmpeg() { echo "ffmpeg $*"; exit; }  # mock
  export -f ffmpeg
  cp ./test/paris.webm ./.tmp/

  FFMPEG_OPTIONS=( -imported-options )
  run extract-and-encode ./.tmp/paris.webm 'paris' '0:00:00.00' '0:00:01.00' .tmp/output/

  assert_output 'ffmpeg -i ./.tmp/paris.webm -ss 0:00:00.00 -to 0:00:01.00 -imported-options .tmp/output//paris.webm' 
}

@test "extract clip to output_directory" {
  cp ./test/paris.webm ./.tmp/
  mkdir -p ./.tmp/output/

  run extract-and-encode ./.tmp/paris.webm 'paris' '0:00:00.00' '0:00:01.00' .tmp/output/

  assert_file_exist ./.tmp/output/paris.webm
  rm --recursive --force ./.tmp/output/
}

@test "process all create output_directory" {
  extract-and-encode() { echo "$*"; }  # mock
  export -f extract-and-encode

  run process-all 'foo' 'bar' ./.tmp/output/

  assert_file_exist ./.tmp/output/
  rm --recursive --force ./.tmp/output/
}


@test 'process all entries' {
  cp ./test/paris.webm ./.tmp/paris.webm
  echo '0:00:00.00 0:00:01.00 paris' > ./.tmp/dataset.tsv
  cp ./test/paris.webm ./.tmp/bordeaux.webm
  echo '0:00:00.00 0:00:01.00 bordeaux' >> ./.tmp/dataset.tsv

  run process-all ./test/paris.webm ./.tmp/dataset.tsv ./.tmp/output/

  assert_file_exist ./.tmp/output/paris.webm
  assert_file_exist ./.tmp/output/bordeaux.webm
  rm ./.tmp/output/{paris,bordeaux}.webm
}
