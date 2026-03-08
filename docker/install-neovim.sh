#!/usr/bin/env bash

set -euo pipefail

fail() {
  echo "$1" >&2
  exit 1
}

resolve_nvim_arch() {
  local machine_arch="$1"

  case "${machine_arch}" in
    x86_64|amd64)
      printf '%s' "x86_64"
      ;;
    aarch64|arm64)
      printf '%s' "arm64"
      ;;
    *)
      fail "unsupported architecture: ${machine_arch}"
      ;;
  esac
}

resolve_latest_version() {
  local latest_tag
  latest_tag="$({
    curl -fsSL "https://api.github.com/repos/neovim/neovim/releases/latest" \
      | grep -m1 -oE '"tag_name":\s*"[^"]+"' \
      | cut -d '"' -f 4
  } || true)"

  if [ -z "${latest_tag}" ]; then
    fail "failed to resolve latest neovim release"
  fi

  printf '%s' "${latest_tag}"
}

resolve_requested_version() {
  local requested_version="$1"

  if [ "${requested_version}" = "latest" ]; then
    resolve_latest_version
    return
  fi

  if [[ "${requested_version}" == v* ]]; then
    printf '%s' "${requested_version}"
    return
  fi

  printf 'v%s' "${requested_version}"
}

download_neovim_appimage() {
  local nvim_version="$1"
  local nvim_arch="$2"
  local download_path="$3"
  local appimage_name="nvim-linux-${nvim_arch}.appimage"
  local download_url="https://github.com/neovim/neovim/releases/download/${nvim_version}/${appimage_name}"

  curl -fsSL "${download_url}" -o "${download_path}"
}

verify_checksum_if_provided() {
  local checksum="$1"
  local download_path="$2"

  if [ -z "${checksum}" ]; then
    return
  fi

  echo "${checksum}  ${download_path}" | sha256sum --check --status
}

install_appimage_binary() {
  local download_path="$1"
  chmod +x "${download_path}"
  install -m 0755 "${download_path}" /usr/local/bin/nvim
}

main() {
  local requested_version="${1:-v0.11.6}"
  local checksum="${2:-}"
  local machine_arch
  local nvim_arch
  local nvim_version
  local download_path

  machine_arch="$(uname -m)"
  nvim_arch="$(resolve_nvim_arch "${machine_arch}")"
  nvim_version="$(resolve_requested_version "${requested_version}")"
  download_path="/tmp/nvim-linux-${nvim_arch}.appimage"

  download_neovim_appimage "${nvim_version}" "${nvim_arch}" "${download_path}"
  verify_checksum_if_provided "${checksum}" "${download_path}"
  install_appimage_binary "${download_path}"
  rm -f "${download_path}"
}

main "$@"
