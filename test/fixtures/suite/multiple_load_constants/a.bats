# shellcheck shell=bats
load test_helper

@test "constant" {
  [ "$A_CONSTANT" = "value" ]
}
