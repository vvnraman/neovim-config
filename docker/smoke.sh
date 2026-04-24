#!/usr/bin/env bash

set -euo pipefail

os_name="${1:-arch}"
profile_name="${2:-standard}"
log_dir="/tmp/nvim-smoke"

source "$(dirname "${BASH_SOURCE[0]}")/smoke-lib.sh"

build_base_nvim_error_pattern() {
  local error_pattern='Error detected while processing'
  error_pattern+='|(^|[[:space:]])E[0-9]{4}:'
  error_pattern+='|Failed to run `config`'
  error_pattern+='|loop or previous error loading module'

  printf '%s\n' "${error_pattern}"
}

build_install_error_pattern() {
  local error_pattern
  error_pattern="$(build_base_nvim_error_pattern)"
  error_pattern+='|nvim-treesitter\[.*\]: Error'
  error_pattern+='|fatal error:'
  error_pattern+='|Error during compilation'
  error_pattern+='|Failed to execute the following command:'

  printf '%s\n' "${error_pattern}"
}

build_launch_error_pattern() {
  local error_pattern
  error_pattern="$(build_base_nvim_error_pattern)"
  error_pattern+='|Error in command line:'
  error_pattern+='|vim.schedule callback:'

  printf '%s\n' "${error_pattern}"
}

install_error_pattern="$(build_install_error_pattern)"
launch_error_pattern="$(build_launch_error_pattern)"

run_install_stage() {
  export NVIM_TREESITTER_SYNC_INSTALL=1
  run_logged_stage \
    "install" \
    "${log_dir}/install.log" \
    "${install_error_pattern}" \
    nvim \
    --headless \
    "+Lazy! restore" \
    +qall
  unset NVIM_TREESITTER_SYNC_INSTALL
}

run_launch_stage() {
  run_logged_stage \
    "launch" \
    "${log_dir}/launch.log" \
    "${launch_error_pattern}" \
    nvim \
    --headless \
    "+doautocmd CmdlineEnter" \
    "+sleep 100m" \
    +qall
}

setup_smoke_env "${os_name}" "${profile_name}"
ensure_log_dir "${log_dir}"

run_install_stage
run_launch_stage

echo "smoke passed: ${os_name} (${profile_name}) [install, launch]"
