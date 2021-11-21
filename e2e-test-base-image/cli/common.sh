#!/usr/bin/env bash

cli_log() {
  local -r script_name=${0##*/}
  local -r timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  echo "== $script_name $timestamp $1"
}

indent() { sed '2,$s/^/    /'; }