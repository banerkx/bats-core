# shellcheck shell=bats
helper() {
  false
}

helper

@test "everything is ok" {
  true
}
