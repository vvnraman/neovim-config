#!/usr/bin/env bash

set -euo pipefail

os_name="${1:-arch}"
profile_name="${2:-standard}"
log_file="/tmp/nvim-smoke.log"

case "${profile_name}" in
  minimal|standard)
    ;;
  *)
    echo "unsupported nvim profile: ${profile_name}" >&2
    exit 1
    ;;
esac

source "$(dirname "${BASH_SOURCE[0]}")/nvim-env.sh"
export NVIM_TREESITTER_SYNC_INSTALL=1

case "${os_name}" in
  arch|ubuntu)
    export NVIM_PROFILE="${profile_name}"

    nvim_exit=0
    nvim --headless "+Lazy! restore" "+Lazy! load nvim-treesitter" +qall >"${log_file}" 2>&1 || nvim_exit=$?
    error_pattern='Error detected while processing'
    error_pattern+='|(^|[[:space:]])E[0-9]{4}:'
    error_pattern+='|nvim-treesitter\[.*\]: Error'
    error_pattern+='|fatal error:'
    error_pattern+='|Error during compilation'
    error_pattern+='|Failed to execute the following command:'

    if grep -Eq "${error_pattern}" "${log_file}"; then
      cat "${log_file}"
      exit 1
    fi

    if [ "${nvim_exit}" -ne 0 ]; then
      cat "${log_file}"
      exit "${nvim_exit}"
    fi

    echo "smoke passed: ${os_name} (${profile_name})"
    ;;
  *)
    echo "unsupported os profile: ${os_name}" >&2
    exit 1
    ;;
esac
