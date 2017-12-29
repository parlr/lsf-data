#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load '../scripts/split'

setup() {
  full_path=./.tmp/fake.mkv
  directory_path=./.tmp
  filename=fake.mkv
  extension=mkv
  timing_path=./.tmp/fake.tsv
  input_data_path=./.tmp/fake.ass

  mkdir --parents ./.tmp
}

teardown() {
  rm --force --recursive "$directory_path"
}

@test "create timing file" {
  run extract_timing_from_subtitles
  assert [ -f "$timing_path" ]
}

@test "extract word timing" {
  run bash -c "echo 'Dialogue: 0,0:00:01.64,0:00:04.07,Default,,0,0,0,,bonjour' > $input_data_path"
  run extract_timing_from_subtitles

  assert_equal "$(cut -f1 -d ' ' "$timing_path")" '0:00:01.64'
  assert_equal "$(cut -f2 -d ' ' "$timing_path")" '0:00:04.07'
  assert_equal "$(cut -f3 -d ' ' "$timing_path")" 'bonjour'
}
