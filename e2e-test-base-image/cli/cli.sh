#!/usr/bin/env bash
set -eu -o pipefail

# Determine this working directory while resolving symbolic links
E2E_CLI_WORKDIR=$(cd "$(dirname "$0")" && pwd)
export E2E_CLI_WORKDIR

E2E_CLI_LOG_DIR=${E2E_CLI_WORKDIR}/logs
export LOG_DIR

# Import common functions
# shellcheck source=./common.sh
. "${E2E_CLI_WORKDIR}"/common.sh

# Prints the global help dialog
cli_help() {
  local -r cli_name=${0##*/}
  local -r version=$(cat "${E2E_CLI_WORKDIR}/VERSION")
    echo "
  E2E Tests CLI
  CLI-Version: ${version}
  Usage: /cli/${cli_name} [command]

  Commands:
    e2etests  Display e2etests Help
    *         Help

  Description:
    $(cat ${E2E_CLI_WORKDIR}/cli-desc.txt | indent)
  "
  exit 1
}

# Export config properties
cli_log "Exporting config ..."
for LINE in $(grep -v '^\s*#' "${E2E_CLI_WORKDIR}/config.properties")
do
    export "$LINE";
done

# Process script input
COMMAND=${1-"help"}
SUBCOMMANDS=("${@:2}")
case ${COMMAND} in
  e2etests|t)
    "${E2E_CLI_WORKDIR}/commands/e2etests.sh" ${SUBCOMMANDS[@]+"${SUBCOMMANDS[@]}"} | tee -ia "${E2E_CLI_LOG_DIR}/e2etests.log"
    ;;
    *)
    cli_help
    ;;
esac
