#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'libs/bats-file/load'
export IS_RUNNING_TESTS=true
load '../scripts/extract-timing'

setup() {
  mkdir --parents ./.tmp
}

teardown() {
  rm --force --recursive ./.tmp/
  echo
}

@test "stop if no argument given" {
  run extract-timing-from-subtitles

  assert_output 'missing argument: subtitle_filepath'
  assert_failure
}

@test "create timing file" {
  run extract-timing-from-subtitles ./.tmp/fake.ass
  
  assert_file_exist ./.tmp/fake.tsv
}

@test "extract word timing" {
  run bash -c "echo 'Dialogue: 0,0:00:01.64,0:00:04.07,Default,,0,0,0,,bonjour' > ./.tmp/fake.ass"

  run extract-timing-from-subtitles ./.tmp/fake.ass
  
  assert_equal "$(cut -f1 -d ' ' ./.tmp/fake.tsv)" '00:00:01.64'
  assert_equal "$(cut -f2 -d ' ' ./.tmp/fake.tsv)" '00:00:04.07'
  assert_equal "$(cut -f3 -d ' ' ./.tmp/fake.tsv)" 'bonjour'
}

@test "extract multiple words" {
  run bash -c "echo 'Dialogue: 0,0:12:15.01,0:12:17.36,Default,,0,0,0,,son, sa, ses, leurs' > ./.tmp/fake.ass"

  run extract-timing-from-subtitles ./.tmp/fake.ass
  
  assert_equal "$(cut -f1 -d ' ' ./.tmp/fake.tsv)" '00:12:15.01'
  assert_equal "$(cut -f2 -d ' ' ./.tmp/fake.tsv)" '00:12:17.36'
  assert_equal "$(cut -f3- -d ' ' ./.tmp/fake.tsv)" 'son, sa, ses, leurs'
}