#!/usr/bin/env bash

declare -r SCRIPT=${0##*/}

set -e

case ${1#linux/} in
386)
  TINI_PLATFORM=i386
  ;;
arm/v7)
  TINI_PLATFORM=armhf
  ;;
arm/v6)
  TINI_PLATFORM=armel
  ;;
*)
  TINI_PLATFORM=${1#linux/}
  ;;
esac

echo "Installing tini for ${TINI_PLATFORM}"

declare -r TINI_URL="https://github.com/krallin/tini"
declare -r TINI_VERSION="$(git ls-remote --tags --sort=-v:refname "${TINI_URL}" | head -n 1 | awk '{print $2}' | sed 's|refs/tags/||')"
if [[ -z "${TINI_VERSION}" ]]
then
  echo "[${SCRIPT}] ERROR: Could not determine most recent git tag for remote tini repository [${TINI_URL}]. Exiting."
  exit 1
fi

wget "${TINI_URL}/releases/download/${TINI_VERSION}/tini-static-${TINI_PLATFORM}" -O /tini
wget "${TINI_URL}/releases/download/${TINI_VERSION}/tini-static-${TINI_PLATFORM}.asc" -O /tini.asc

chmod +x /tini

apk add gnupg
gpg --import </tmp/docker/tini.pubkey.gpg
gpg --batch --verify /tini.asc /tini
apk del gnupg
