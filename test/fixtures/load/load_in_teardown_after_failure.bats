# shellcheck shell=bats
teardown() {
  load 'test_helper'
}

@test failed {
  false
}
