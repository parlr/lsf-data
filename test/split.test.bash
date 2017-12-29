#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'libs/bats-file/load'
load '../scripts/split'

setup() {
  full_path=./.tmp/fake.mkv
  directory_path=./.tmp
  filename=fake.mkv
  extension=mkv
  timing_path=./.tmp/fake.tsv

  mkdir --parents ./.tmp
}

teardown() {
  rm --force --recursive "$directory_path"
  # echo
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

@test 'call ffmpeg with correct arguments' {
  ffmpeg() { echo "ffmpeg $*"; exit; }  # mock
  export -f ffmpeg
  # shellcheck disable=SC2034
  chunk='bonjour'

  run extract_and_encode_word_chunk

  spy="${lines[0]}"
  assert_equal "$spy" "ffmpeg -y -i ./.tmp/fake.mkv -ss  -to  -vf scale=640x480 -b:v 512k -minrate 256k -maxrate 742k -quality good -speed 4 -crf 37 -c:v libvpx-vp9 -loglevel error bonjour.webm"
}

@test 'extract clip from video' {
  # shellcheck disable=SC2034
  chunk="$directory_path/paris"
  # shellcheck disable=SC2034
  full_path=test/paris.mkv
  # shellcheck disable=SC2034
  start='0:00:00.00'
  # shellcheck disable=SC2034
  end='0:00:00.10'

  run extract_and_encode_word_chunk

  echo $output
  assert_file_exist './.tmp/paris.webm'
}
