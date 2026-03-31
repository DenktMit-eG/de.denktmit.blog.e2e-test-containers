#!/usr/bin/env bash
set -eu -o pipefail

OMIT_CACHE=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    --omit-cache) OMIT_CACHE=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

export OMIT_CACHE
THIS_SCRIPTS_DIR=$(cd "$(dirname "$0")" && pwd)

cd "${THIS_SCRIPTS_DIR}"/e2e-test-base-image || exit 1
./build_image.sh

cd "${THIS_SCRIPTS_DIR}"/e2e-test-sample-webgui || exit 1
./build_image.sh
