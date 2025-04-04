#!/usr/bin/env bats

setup() {
# NOTE: BATS_TMPDIR is assigned by BATS.
# shellcheck disable=SC2154
  export dst_tarball="${BATS_TMPDIR}/dst.tar.gz"
# NOTE: BATS_TMPDIR is assigned by BATS.
# shellcheck disable=SC2154
  export src_dir="${BATS_TMPDIR}/src_dir"

  rm -rf "${dst_tarball}" "${src_dir}"
  mkdir "${src_dir}"
  touch "${src_dir}"/{a,b,c}
}

main() {
# NOTE: BATS_TEST_DIRNAME is assigned by BATS.
# shellcheck disable=SC2154
  bash "${BATS_TEST_DIRNAME}"/package-tarball
}

@test "fail when \${src_dir} and \${dst_tarball} are unbound" {
  unset src_dir dst_tarball

  run main
  [ "${status}" -ne 0 ]
}

@test "fail when \${src_dir} is a non-existent directory" {
  # shellcheck disable=SC2030
  src_dir='not-a-dir'

  run main
  [ "${status}" -ne 0 ]
}

# shellcheck disable=SC2016
@test "pass when \${src_dir} directory is empty" {
  # shellcheck disable=SC2031,SC2030
  rm -rf "${src_dir:?}/*"

  run main
  echo "${output}"
  [ "${status}" -eq 0 ]
}

# shellcheck disable=SC2016
@test "files in \${src_dir} are added to tar archive" {
  run main
  [ "${status}" -eq 0 ]

  run tar tf "${dst_tarball}"
  [ "${status}" -eq 0 ]
  [[ "${output}" =~ a ]]
  [[ "${output}" =~ b ]]
  [[ "${output}" =~ c ]]
}
