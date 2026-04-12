#!/usr/bin/env bash

set -euo pipefail

os_name="${1:-arch}"
profile_name="${2:-standard}"
log_dir="/tmp/nvim-smoke"

mkdir -p "${log_dir}"

run_stage() {
  local stage_name="$1"
  local log_file="$2"
  local error_pattern="$3"
  shift 3

  local nvim_exit=0
  "$@" >"${log_file}" 2>&1 || nvim_exit=$?

  if grep -Eq "${error_pattern}" "${log_file}"; then
    echo "stage failed: ${stage_name}" >&2
    cat "${log_file}"
    exit 1
  fi

  if [ "${nvim_exit}" -ne 0 ]; then
    echo "stage failed: ${stage_name}" >&2
    cat "${log_file}"
    exit "${nvim_exit}"
  fi

  echo "stage passed: ${stage_name}"
}

case "${profile_name}" in
  minimal|standard)
    ;;
  *)
    echo "unsupported nvim profile: ${profile_name}" >&2
    exit 1
    ;;
esac

source "$(dirname "${BASH_SOURCE[0]}")/nvim-env.sh"

case "${os_name}" in
  arch|ubuntu)
    export VVN_NVIM_PROFILE="${profile_name}"

    install_error_pattern='Error detected while processing'
    install_error_pattern+='|(^|[[:space:]])E[0-9]{4}:'
    install_error_pattern+='|Failed to run `config`'
    install_error_pattern+='|loop or previous error loading module'
    install_error_pattern+='|nvim-treesitter\[.*\]: Error'
    install_error_pattern+='|fatal error:'
    install_error_pattern+='|Error during compilation'
    install_error_pattern+='|Failed to execute the following command:'

    launch_error_pattern='Error detected while processing'
    launch_error_pattern+='|(^|[[:space:]])E[0-9]{4}:'
    launch_error_pattern+='|Error in command line:'
    launch_error_pattern+='|Failed to run `config`'
    launch_error_pattern+='|loop or previous error loading module'
    launch_error_pattern+='|vim.schedule callback:'

    export NVIM_TREESITTER_SYNC_INSTALL=1
    run_stage \
      "install" \
      "${log_dir}/install.log" \
      "${install_error_pattern}" \
      nvim \
      --headless \
      "+Lazy! restore" \
      +qall

    unset NVIM_TREESITTER_SYNC_INSTALL
    run_stage \
      "launch" \
      "${log_dir}/launch.log" \
      "${launch_error_pattern}" \
      nvim \
      --headless \
      "+doautocmd CmdlineEnter" \
      "+sleep 100m" \
      +qall

    echo "smoke passed: ${os_name} (${profile_name}) [install, launch]"
    ;;
  *)
    echo "unsupported os profile: ${os_name}" >&2
    exit 1
    ;;
esac
