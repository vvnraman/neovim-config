#!/usr/bin/env bash

set -euo pipefail

show_help() {
  cat <<'EOF'
Usage: docker/run-workflow.sh [--workflow <interactive|smoke-test>] [<os,profile> ...]

Examples:
  docker/run-workflow.sh
  docker/run-workflow.sh ubuntu,standard
  docker/run-workflow.sh --workflow smoke-test ubuntu,standard ubuntu,minimal

Options:
  --workflow   Workflow type (default: interactive)
  --help       Show this help message

Targets:
  <os,profile> where:
    os      = arch | ubuntu
    profile = standard | minimal

Default target:
  arch,standard
EOF
}

workflow="interactive"
declare -a targets=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workflow)
      workflow="${2:-}"
      shift 2
      ;;
    --workflow=*)
      workflow="${1#*=}"
      shift
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    --*)
      echo "unknown argument: $1" >&2
      show_help
      exit 1
      ;;
    *)
      targets+=("$1")
      shift
      ;;
  esac
done

case "$workflow" in
  interactive|smoke-test)
    ;;
  *)
    echo "invalid --workflow value: $workflow" >&2
    exit 1
    ;;
esac

if [[ ${#targets[@]} -eq 0 ]]; then
  targets+=("arch,standard")
fi

to_service_name() {
  local combo="$1"
  local mode="$2"

  if [[ "$combo" != *,* ]]; then
    echo "invalid target format: $combo (expected os,profile)" >&2
    exit 1
  fi

  local os="${combo%%,*}"
  local profile="${combo#*,}"

  case "$os" in
    arch|ubuntu)
      ;;
    *)
      echo "invalid os in target '$combo': $os" >&2
      exit 1
      ;;
  esac

  case "$profile" in
    standard|minimal)
      ;;
    *)
      echo "invalid profile in target '$combo': $profile" >&2
      exit 1
      ;;
  esac

  case "$mode:$os,$profile" in
    interactive:arch,standard)
      printf '%s\n' "arch-shell"
      ;;
    interactive:ubuntu,standard)
      printf '%s\n' "ubuntu-shell"
      ;;
    interactive:ubuntu,minimal)
      printf '%s\n' "ubuntu-shell-minimal"
      ;;
    smoke-test:arch,standard)
      printf '%s\n' "arch-smoke"
      ;;
    smoke-test:ubuntu,standard)
      printf '%s\n' "ubuntu-smoke"
      ;;
    smoke-test:ubuntu,minimal)
      printf '%s\n' "ubuntu-smoke-minimal"
      ;;
    *)
      echo "unsupported target for workflow '$mode': $combo" >&2
      exit 1
      ;;
  esac
}

declare -a services=()
declare -A seen=()

for target in "${targets[@]}"; do
  service="$(to_service_name "$target" "$workflow")"
  if [[ -z "${seen[$service]+x}" ]]; then
    services+=("$service")
    seen[$service]=1
  fi
done

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
compose_file="${repo_root}/docker/docker-compose.yaml"
nvim_config_dir="${NVIM_CONFIG_DIR:-${repo_root}}"

if [[ "$workflow" == "interactive" ]]; then
  if [[ ${#services[@]} -ne 1 ]]; then
    echo "interactive workflow requires exactly one target" >&2
    exit 1
  fi

  target="${targets[0]}"
  profile="${target#*,}"

  compose_run_args=(run --rm --build)
  if [[ -n "${TMUX:-}" && -n "${TMUX_PANE:-}" ]]; then
    host_tmux_socket="${TMUX%%,*}"
    if [[ -S "${host_tmux_socket}" ]]; then
      host_tmux_dir="$(dirname "${host_tmux_socket}")"
      compose_run_args+=(
        -e "TMUX_PANE=${TMUX_PANE}"
        -e "NVIM_CLIPBOARD=tmux"
        -v "${host_tmux_dir}:${host_tmux_dir}"
      )
    fi
  fi

  NVIM_CONFIG_DIR="${nvim_config_dir}" docker compose -f "${compose_file}" "${compose_run_args[@]}" \
    "${services[0]}" \
    /opt/nvim-harness/shell.sh "${profile}"
  exit 0
fi

NVIM_CONFIG_DIR="${nvim_config_dir}" docker compose -f "${compose_file}" up --build --abort-on-container-failure \
  "${services[@]}"
