# shellcheck shell=bats
teardown() {
  eval "( exit ${STATUS:-1} )"
}

@test "truth" {
  [ "$PASS" = 1 ]
}
