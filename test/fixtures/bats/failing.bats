# shellcheck shell=bats
@test "a failing test" {
  true
  true
  eval "( exit ${STATUS:-1} )"
}
