# shellcheck shell=bats
@test "unfocused" {
    false
}

# bats test_tags=bats:focus
@test "focused" {
    true
}