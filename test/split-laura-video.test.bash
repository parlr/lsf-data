#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'libs/bats-file/load'
export IS_RUNNING_TESTS=true
load '../scripts/split-laura-video'

setup() {
  timing_path=./.tmp/fake.tsv

  mkdir --parents ./.tmp
}

teardown() {
  rm --force --recursive "$directory_path"
  echo
}

@test "create timing file" {
  run extract_timing_from_subtitles

  assert_file_exist "$timing_path"
}

@test "extract word timing" {
  input_data_path=./.tmp/fake.ass
  run bash -c "echo 'Dialogue: 0,0:00:01.64,0:00:04.07,Default,,0,0,0,,bonjour' > $input_data_path"

  run extract_timing_from_subtitles

  assert_equal "$(cut -f1 -d ' ' "$timing_path")" '0:00:01.64'
  assert_equal "$(cut -f2 -d ' ' "$timing_path")" '0:00:04.07'
  assert_equal "$(cut -f3 -d ' ' "$timing_path")" 'bonjour'
}

@test "extract multiple words" {
  input_data_path=./.tmp/fake.ass
  run bash -c "echo 'Dialogue: 0,0:12:15.01,0:12:17.36,Default,,0,0,0,,son, sa, ses, leurs' > $input_data_path"

  run extract_timing_from_subtitles

  assert_equal "$(cut -f1 -d ' ' "$timing_path")" '0:12:15.01'
  assert_equal "$(cut -f2 -d ' ' "$timing_path")" '0:12:17.36'
  assert_equal "$(cut -f3- -d ' ' "$timing_path")" 'son, sa, ses, leurs'
}

@test 'call ffmpeg with correct arguments to split' {
  ffmpeg() { echo "ffmpeg $*"; exit; }  # mock
  export -f ffmpeg

  full_path=./test/paris.mkv
  run extract_word_chunk 'raw/0:00:00.00.fake.mkv' '0:00:00.00' '0:00:01.00'

  spy="${lines[0]}"
  assert_equal "$spy" "ffmpeg -y -i ./test/paris.mkv -ss 0:00:00.00 -to 0:00:01.00 -acodec copy -vcodec copy -loglevel error raw/0:00:00.00.fake.mkv"
}

@test 'extract clip from video' {
  full_path=./test/paris.mkv
  run extract_word_chunk 'raw/0:00:00.00.paris.mkv' '0:00:00.00' '0:00:01.00'

  assert_file_exist './raw/0:00:00.00.paris.mkv'
}
