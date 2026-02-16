#!/usr/bin/env bash

set -euo pipefail

target_os="${1:?missing target os}"
packages_file="${2:-/tmp/packages.toml}"

packages_raw="$(dasel -i toml "${target_os}.packages" < "${packages_file}" | tr -d "[]'" | tr ',' ' ')"
read -r -a profile_packages <<< "${packages_raw}"

if [ "${#profile_packages[@]}" -gt 0 ]; then
  case "${target_os}" in
    arch)
      pacman --sync --needed --noconfirm "${profile_packages[@]}"
      ;;
    ubuntu)
      apt-get update
      apt-get install --yes --no-install-recommends "${profile_packages[@]}"
      rm -rf /var/lib/apt/lists/*
      ;;
    *)
      echo "unsupported os profile: ${target_os}" >&2
      exit 1
      ;;
  esac
fi
