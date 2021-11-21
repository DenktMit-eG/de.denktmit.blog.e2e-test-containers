#!/usr/bin/env bash
set -eu -o pipefail

# Import common functions
# shellcheck source=../common.sh
. "${E2E_CLI_WORKDIR}"/common.sh

e2etests_run() {
  cli_log "RUN E2E TESTS"
  if [ ! -d /tests/specs ]; then
      echo "The container has no path /tests/specs for Gauge to run"
      exit 1
  fi
  if [ $# -eq 0 ];
    then
      gauge_jvm_args="${GAUGE_JVM_ARGS}" gauge --hide-suggestion --simple-console --log-level "${GAUGE_LOG_LEVEL}" run /tests/specs
    else
      gauge_jvm_args="${GAUGE_JVM_ARGS}" gauge --hide-suggestion --simple-console --log-level "${GAUGE_LOG_LEVEL}" --tags "$1" run /tests/specs
  fi
}

e2etests_specs() {
  cli_log "PRINT E2E SPECS"
  if [ ! -d /tests/specs ]; then
      echo "The container has no path /tests/specs for Gauge to run"
      exit 1
  fi
  tail -n +1 /tests/specs/*.spec
  echo
}

e2etests_help() {
  cli_log "HELP"
  echo "
  Command: e2etests

  Usage:
    e2etests run [tags]     Runs all tests
    e2etests specs          Prints defined specs
    e2etests *              Help

  Description:
    This command executes Gauge specifications provided in the /tests/specs directory of this container
    when called with 'run'. If you run the tests without providing tags, all tests will be run. Otherwise,
    if you submit a tags specification, only the tests that match it are run. For detailed explanation,
    visit https://docs.gauge.org/execution.html#tag-expressions. If all tests succeed, this script returns
    with exit code 0, otherwise with exit code 1.

    Configurable environment variables:
    This is an overview of configurable environment variables. Mandatory variables must be provided as docker env
    variables, otherwise the run command will fail. Optional variables on the other hand might be used if needed. If
    both lists are empty, it means, that your current test container does not need any setup to run the tests :).

    $(cat ${E2E_CLI_WORKDIR}/commands/e2etests-env.txt | indent)

    Available test tags:
    The available tags and their purpose. For example a tag smoke might only run some quick tests to verify a system is
    ready.

    $(cat ${E2E_CLI_WORKDIR}/commands/e2etests-tags.txt  | indent)

    Mount points of interest:
    The mount points of interests describe container paths you might want to mount to your host machine.

    $(cat ${E2E_CLI_WORKDIR}/commands/e2etests-volumes.txt | indent)
  "
  exit 1
}

# Process script input
COMMAND=${1-"help"}
SUBCOMMANDS=("${@:2}")
case ${COMMAND} in
  run|r)
    e2etests_run ${SUBCOMMANDS[@]+"${SUBCOMMANDS[@]}"}
    ;;
  specs|s)
    e2etests_specs
    ;;
  *)
    e2etests_help
    ;;
esac
