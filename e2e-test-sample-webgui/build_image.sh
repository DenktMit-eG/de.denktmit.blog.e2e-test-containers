#!/usr/bin/env bash
set -eu -o pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
VERSION=$(cat "${SCRIPT_DIR}/version.txt")

CACHE_FLAG=""
if [[ "${OMIT_CACHE:-false}" == "true" ]]; then
  CACHE_FLAG="--no-cache"
fi

docker build ${CACHE_FLAG} -t "e2e-test-sample-webgui:${VERSION}" -t e2e-test-sample-webgui:latest .
