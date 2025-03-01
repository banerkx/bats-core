# shellcheck shell=bats
@test "my sleep ${SLEEP}" {
  sleep "${SLEEP?}"
}
