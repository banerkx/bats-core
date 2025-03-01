# shellcheck shell=bats
@test "a failing test" {
  true
  ((1 == 2))
}
