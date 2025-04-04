# shellcheck shell=bats
set -u

# This file is used to test line number offsets. Any changes to lines will affect tests

@test "access unbound variable" {
  unset unset_variable
  # Add a line for checking line number
  # shellcheck disable=SC2154
  foo=$unset_variable
}

@test "access second unbound variable" {
  unset second_unset_variable
  # shellcheck disable=SC2034,SC2154
  foo=$second_unset_variable
}
