#!/usr/bin/env bash

set -euo pipefail

target_os="${1:?missing target os}"
fd_version="${2:-v10.2.0}"
ripgrep_version="${3:-14.1.1}"
machine_arch="$(uname -m)"

case "${machine_arch}" in
  x86_64|amd64)
    fd_arch="x86_64"
    ripgrep_arch="x86_64"
    ;;
  aarch64|arm64)
    fd_arch="aarch64"
    ripgrep_arch="aarch64"
    ;;
  *)
    echo "unsupported architecture: ${machine_arch}" >&2
    exit 1
    ;;
esac

fd_expected_sha256() {
  case "${fd_version}:${fd_arch}" in
    v10.2.0:x86_64)
      printf '%s' "5f9030bcb0e1d03818521ed2e3d74fdb046480a45a4418ccff4f070241b4ed25"
      ;;
    v10.2.0:aarch64)
      printf '%s' "6de8be7a3d8ca27954a6d1e22bc327af4cf6fc7622791e68b820197f915c422b"
      ;;
    *)
      return 1
      ;;
  esac
}

install_fd() {
  fd_archive="fd-${fd_version}-${fd_arch}-unknown-linux-gnu.tar.gz"
  fd_url="https://github.com/sharkdp/fd/releases/download/v${fd_version#v}/${fd_archive}"

  curl -fsSL "${fd_url}" -o "/tmp/${fd_archive}"
  fd_hash="$(fd_expected_sha256 || true)"
  if [ -z "${fd_hash}" ]; then
    echo "missing checksum for ${fd_archive}" >&2
    exit 1
  fi
  echo "${fd_hash}  /tmp/${fd_archive}" | sha256sum --check --status
  tar -xzf "/tmp/${fd_archive}" -C /tmp
  install -m 0755 "/tmp/fd-${fd_version}-${fd_arch}-unknown-linux-gnu/fd" /usr/local/bin/fd
  rm -rf "/tmp/${fd_archive}" "/tmp/fd-${fd_version}-${fd_arch}-unknown-linux-gnu"
}

install_ripgrep() {
  rg_archive="ripgrep-${ripgrep_version}-${ripgrep_arch}-unknown-linux-musl.tar.gz"
  rg_url="https://github.com/BurntSushi/ripgrep/releases/download/${ripgrep_version}/${rg_archive}"
  rg_checksum_url="${rg_url}.sha256"
  rg_checksum_path="/tmp/${rg_archive}.sha256"

  curl -fsSL "${rg_url}" -o "/tmp/${rg_archive}"
  curl -fsSL "${rg_checksum_url}" -o "${rg_checksum_path}"
  rg_hash="$(cut -d ' ' -f 1 "${rg_checksum_path}")"
  if [ -z "${rg_hash}" ]; then
    echo "missing checksum for ${rg_archive}" >&2
    exit 1
  fi
  echo "${rg_hash}  /tmp/${rg_archive}" | sha256sum --check --status
  tar -xzf "/tmp/${rg_archive}" -C /tmp
  install -m 0755 "/tmp/ripgrep-${ripgrep_version}-${ripgrep_arch}-unknown-linux-musl/rg" /usr/local/bin/rg
  rm -rf "/tmp/${rg_archive}" "/tmp/ripgrep-${ripgrep_version}-${ripgrep_arch}-unknown-linux-musl" "${rg_checksum_path}"
}

case "${target_os}" in
  arch)
    ;;
  ubuntu)
    install_fd
    install_ripgrep
    ;;
  *)
    echo "unsupported os profile: ${target_os}" >&2
    exit 1
    ;;
esac
