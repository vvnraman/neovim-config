#!/usr/bin/env bash

set -euo pipefail

fail_stage() {
  local stage_name="$1"
  local log_file="$2"
  local failure_message="${3:-stage failed: ${stage_name}}"

  echo "${failure_message}" >&2
  cat "${log_file}"
  exit 1
}

run_logged_stage() {
  local stage_name="$1"
  local log_file="$2"
  local error_pattern="$3"
  shift 3

  local command_exit=0
  "$@" >"${log_file}" 2>&1 || command_exit=$?

  if [ -n "${error_pattern}" ] && grep -Eq "${error_pattern}" "${log_file}"; then
    fail_stage "${stage_name}" "${log_file}"
  fi

  if [ "${command_exit}" -ne 0 ]; then
    fail_stage "${stage_name}" "${log_file}"
  fi

  echo "stage passed: ${stage_name}"
}

ensure_log_dir() {
  local log_dir="$1"

  mkdir -p "${log_dir}"
}

validate_profile_name() {
  local profile_name="$1"

  case "${profile_name}" in
    minimal|standard)
      ;;
    *)
      echo "unsupported nvim profile: ${profile_name}" >&2
      exit 1
      ;;
  esac
}

validate_os_name() {
  local os_name="$1"

  case "${os_name}" in
    arch|ubuntu)
      ;;
    *)
      echo "unsupported os profile: ${os_name}" >&2
      exit 1
      ;;
  esac
}

setup_smoke_env() {
  local os_name="$1"
  local profile_name="$2"

  validate_os_name "${os_name}"
  validate_profile_name "${profile_name}"

  source "$(dirname "${BASH_SOURCE[0]}")/nvim-env.sh"
  export VVN_NVIM_PROFILE="${profile_name}"
}
