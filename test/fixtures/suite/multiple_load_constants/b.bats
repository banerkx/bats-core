# shellcheck shell=bats
load test_helper

@test "constant (again)" {
  [ "$A_CONSTANT" = "value" ]
}
