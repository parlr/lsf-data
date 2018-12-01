#!/usr/bin/env bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'libs/bats-file/load'

export JSON_FILE=./test/.tmp/vocabulaire.json  # same variable name as tested file
export PATTERN_TO_INDEX="./test/.tmp/*.webm"
export IS_RUNNING_TESTS=true
load '../scripts/create-json-dictionary'

setup() {
  mkdir --parents ./test/.tmp/
  cp test/paris.webm ./test/.tmp/
}

teardown() {
  echo ''
  rm --recursive --force ./test/.tmp/
}

@test "write opening square bracket to json" {
  OPENING_BRACKET='['

  run begin_dictionary

  lines_count=$(wc --lines "$JSON_FILE" | cut --delimiter=' ' --fields=1)
  assert_equal "$lines_count" 1

  content=$(cat "$JSON_FILE")
  assert_equal "$content" "$OPENING_BRACKET" 
}

@test "write closing square bracket, on new line, to json" {
  CLOSING_BRACKET=']'
  CLOSING_ENTRY='},'
  echo "$CLOSING_ENTRY" > "$JSON_FILE"  # need pre-existing content

  run end_dictionary

  content=$(tail --lines=1 "$JSON_FILE")
  echo "[$content] $(cat $JSON_FILE)"
  assert_equal "$content" "$CLOSING_BRACKET" 
}

@test "craft a word object" {
  touch "$JSON_FILE"
  entry=$(cat <<-MOT
  {
    "key": "bonjour",
    "label": "bonjour",
    "video": "videos/bonjour.webm"
  },
MOT
)

  run add_word "bonjour"

  content=$(cat $JSON_FILE)
  assert_equal "$content" "$entry" 
}

@test "translit key" {
  touch "$JSON_FILE"
  entry=$(cat <<-MOT
  {
    "key": "eaaio",
    "label": "éàäio",
    "video": "videos/éàäio.webm"
  },
MOT
)
  run add_word "éàäio"

  content=$(cat $JSON_FILE)
  assert_equal "$content" "$entry" 
}

@test "fill dictionary content (no wrapping list)" {
  touch "$JSON_FILE"
  cp test/paris.webm ./test/.tmp/bordeaux.webm
  sed -i 's/paris/bordeaux/g' ./test/.tmp/bordeaux.webm
  
  run fill_dictionary

  assert_equal "$(grep --count paris "$JSON_FILE")" 3 
  assert_equal "$(grep --count bordeaux "$JSON_FILE")" 3 
}
