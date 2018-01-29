#!./test/libs/bats/bin/bats

load 'libs/bats-support/load'
load 'libs/bats-assert/load'
load 'libs/bats-file/load'
load '../scripts/raw-to-production'

setup() {
  echo
}

teardown() {
   echo
}

@test "require at least one argument" {
  run check_arguments
  (( $status == 1 ))

  run check_arguments "fake"
  (( $status == 0 ))
}
# @test "set vocabulaire and files" {
#   run check_arguments "subtitle-file.ass"
#
#   echo $output
#   [[ $vocabulaire == '123' ]]
# }
