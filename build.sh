#!/usr/bin/env bash

THIS_SCRIPTS_DIR=$(cd "$(dirname "$0")" && pwd)

cd "${THIS_SCRIPTS_DIR}"/e2e-test-base-image || exit
./build_image.sh

cd "${THIS_SCRIPTS_DIR}"/e2e-test-sample-webgui || exit
./build_image.sh