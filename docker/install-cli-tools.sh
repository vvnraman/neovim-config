#!/usr/bin/env bash

set -euo pipefail

declare -A REQUESTED_TOOLS=()
declare -A RESOLVED_TOOL_VERSIONS=()

usage() {
  echo "usage: $0 <arch|ubuntu> [--tool <fd:version|ripgrep:version|tree-sitter-cli:version>]..." >&2
}

fail() {
  echo "$1" >&2
  exit 1
}

has_tool() {
  local tool_name="$1"
  [ "${REQUESTED_TOOLS[${tool_name}]+x}" = "x" ]
}

parse_tool_spec() {
  local tool_spec="$1"
  local tool_name
  local tool_version

  if [[ "${tool_spec}" != *:* ]]; then
    usage
    fail "invalid --tool format: ${tool_spec}"
  fi

  tool_name="${tool_spec%%:*}"
  tool_version="${tool_spec#*:}"

  if [ -z "${tool_name}" ] || [ -z "${tool_version}" ]; then
    usage
    fail "invalid --tool format: ${tool_spec}"
  fi

  case "${tool_name}" in
    fd|ripgrep|tree-sitter-cli)
      ;;
    *)
      usage
      fail "unsupported tool: ${tool_name}"
      ;;
  esac

  if has_tool "${tool_name}"; then
    fail "duplicate --tool for ${tool_name}"
  fi

  REQUESTED_TOOLS["${tool_name}"]="${tool_version}"
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --tool)
        if [ "$#" -lt 2 ]; then
          usage
          fail "missing value for --tool"
        fi
        parse_tool_spec "$2"
        shift 2
        ;;
      *)
        usage
        fail "unknown argument: $1"
        ;;
    esac
  done

  if [ "${#REQUESTED_TOOLS[@]}" -eq 0 ]; then
    REQUESTED_TOOLS[fd]="v10.2.0"
    REQUESTED_TOOLS[ripgrep]="14.1.1"
  fi
}

resolve_tool_arch() {
  local machine_arch="$1"
  case "${machine_arch}" in
    x86_64|amd64)
      printf '%s' "x86_64"
      ;;
    aarch64|arm64)
      printf '%s' "aarch64"
      ;;
    *)
      fail "unsupported architecture: ${machine_arch}"
      ;;
  esac
}

resolve_latest_tag() {
  local repository="$1"
  curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/${repository}/releases/latest" | sed 's#.*/##'
}

resolve_fd_version() {
  local requested_version="$1"

  if [ "${requested_version}" = "latest" ]; then
    requested_version="$(resolve_latest_tag "sharkdp/fd")"
  fi

  if [[ "${requested_version}" == v* ]]; then
    printf '%s' "${requested_version}"
    return
  fi

  printf 'v%s' "${requested_version}"
}

resolve_ripgrep_version() {
  local requested_version="$1"

  if [ "${requested_version}" = "latest" ]; then
    requested_version="$(resolve_latest_tag "BurntSushi/ripgrep")"
  fi

  printf '%s' "${requested_version#v}"
}

resolve_requested_versions() {
  local tool_name
  local requested_version

  for tool_name in fd ripgrep tree-sitter-cli; do
    if ! has_tool "${tool_name}"; then
      continue
    fi

    requested_version="${REQUESTED_TOOLS[${tool_name}]}"
    case "${tool_name}" in
      fd)
        RESOLVED_TOOL_VERSIONS[fd]="$(resolve_fd_version "${requested_version}")"
        ;;
      ripgrep)
        RESOLVED_TOOL_VERSIONS[ripgrep]="$(resolve_ripgrep_version "${requested_version}")"
        ;;
      tree-sitter-cli)
        RESOLVED_TOOL_VERSIONS[tree-sitter-cli]="$(resolve_tree_sitter_cli_version "${requested_version}")"
        ;;
    esac
  done
}

resolve_tree_sitter_cli_version() {
  local requested_version="$1"

  if [ "${requested_version}" = "latest" ]; then
    requested_version="$(resolve_latest_tag "tree-sitter/tree-sitter")"
  fi

  if [[ "${requested_version}" == v* ]]; then
    printf '%s' "${requested_version}"
    return
  fi

  printf 'v%s' "${requested_version}"
}

resolve_tree_sitter_arch() {
  local machine_arch="$1"

  case "${machine_arch}" in
    x86_64|amd64)
      printf '%s' "x64"
      ;;
    aarch64|arm64)
      printf '%s' "arm64"
      ;;
    *)
      fail "unsupported tree-sitter architecture: ${machine_arch}"
      ;;
  esac
}

install_fd_ubuntu() {
  local fd_release_version="$1"
  local fd_arch="$2"
  local fd_archive="fd-${fd_release_version}-${fd_arch}-unknown-linux-gnu.tar.gz"
  local fd_extract_dir="/tmp/fd-${fd_release_version}-${fd_arch}-unknown-linux-gnu"
  local fd_url="https://github.com/sharkdp/fd/releases/download/${fd_release_version}/${fd_archive}"

  install_tarball_binary "${fd_url}" "${fd_archive}" "${fd_extract_dir}" "fd"
}

install_ripgrep_ubuntu() {
  local rg_release_version="$1"
  local rg_arch="$2"
  local rg_archive="ripgrep-${rg_release_version}-${rg_arch}-unknown-linux-musl.tar.gz"
  local rg_extract_dir="/tmp/ripgrep-${rg_release_version}-${rg_arch}-unknown-linux-musl"
  local rg_url="https://github.com/BurntSushi/ripgrep/releases/download/${rg_release_version}/${rg_archive}"

  install_tarball_binary "${rg_url}" "${rg_archive}" "${rg_extract_dir}" "rg"
}

install_tarball_binary() {
  local download_url="$1"
  local archive_name="$2"
  local extract_dir="$3"
  local binary_name="$4"

  curl -fsSL "${download_url}" -o "/tmp/${archive_name}"
  rm -rf "${extract_dir}"
  tar -xzf "/tmp/${archive_name}" -C /tmp
  install -m 0755 "${extract_dir}/${binary_name}" "/usr/local/bin/${binary_name}"
  rm -rf "/tmp/${archive_name}" "${extract_dir}"
}

install_tree_sitter_cli_binary() {
  local ts_release_version="$1"
  local ts_arch="$2"
  local ts_archive="tree-sitter-linux-${ts_arch}.gz"
  local ts_url="https://github.com/tree-sitter/tree-sitter/releases/download/${ts_release_version}/${ts_archive}"
  local ts_download_path="/tmp/${ts_archive}"
  local ts_binary_path="/tmp/tree-sitter"

  curl -fsSL "${ts_url}" -o "${ts_download_path}"
  gzip -dc "${ts_download_path}" > "${ts_binary_path}"
  install -m 0755 "${ts_binary_path}" "/usr/local/bin/tree-sitter"
  rm -f "${ts_download_path}" "${ts_binary_path}"
}

install_arch_packages() {
  local -a packages=()

  if has_tool fd; then
    packages+=(fd)
  fi

  if has_tool ripgrep; then
    packages+=(ripgrep)
  fi

  if [ "${#packages[@]}" -gt 0 ]; then
    pacman --sync --needed --noconfirm "${packages[@]}"
  fi
}

install_ubuntu_tools() {
  local tool_arch="$1"
  local ts_arch="$2"

  if has_tool fd; then
    install_fd_ubuntu "${RESOLVED_TOOL_VERSIONS[fd]}" "${tool_arch}"
  fi

  if has_tool ripgrep; then
    install_ripgrep_ubuntu "${RESOLVED_TOOL_VERSIONS[ripgrep]}" "${tool_arch}"
  fi

  if has_tool tree-sitter-cli; then
    install_tree_sitter_cli_binary "${RESOLVED_TOOL_VERSIONS[tree-sitter-cli]}" "${ts_arch}"
  fi
}

main() {
  if [ "$#" -lt 1 ]; then
    usage
    fail "missing target os"
  fi

  local target_os="$1"
  local machine_arch
  local tool_arch
  local tree_sitter_arch
  shift

  parse_args "$@"

  machine_arch="$(uname -m)"
  tool_arch="$(resolve_tool_arch "${machine_arch}")"
  tree_sitter_arch="$(resolve_tree_sitter_arch "${machine_arch}")"
  resolve_requested_versions

  case "${target_os}" in
    arch)
      install_arch_packages
      if has_tool tree-sitter-cli; then
        install_tree_sitter_cli_binary "${RESOLVED_TOOL_VERSIONS[tree-sitter-cli]}" "${tree_sitter_arch}"
      fi
      ;;
    ubuntu)
      install_ubuntu_tools "${tool_arch}" "${tree_sitter_arch}"
      ;;
    *)
      fail "unsupported os profile: ${target_os}"
      ;;
  esac
}

main "$@"
