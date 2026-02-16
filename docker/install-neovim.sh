#!/usr/bin/env bash

set -euo pipefail

nvim_version="${1:-v0.11.6}"
machine_arch="$(uname -m)"

case "${machine_arch}" in
  x86_64|amd64)
    nvim_arch="x86_64"
    ;;
  aarch64|arm64)
    nvim_arch="arm64"
    ;;
  *)
    echo "unsupported architecture: ${machine_arch}" >&2
    exit 1
    ;;
esac

appimage_name="nvim-linux-${nvim_arch}.appimage"
download_url="https://github.com/neovim/neovim/releases/download/${nvim_version}/${appimage_name}"
download_path="/tmp/${appimage_name}"
install_dir="/opt/nvim-${nvim_version}-${nvim_arch}"

release_api_url="https://api.github.com/repos/neovim/neovim/releases/tags/${nvim_version}"

curl -fsSL "${download_url}" -o "${download_path}"
expected_hash="$({
  curl -fsSL "${release_api_url}" \
    | grep -F -A40 "\"name\": \"${appimage_name}\"" \
    | grep -m1 -oE '"digest": "sha256:[0-9a-f]+"' \
    | cut -d ':' -f 3 \
    | tr -d '"'
} || true)"
if [ -z "${expected_hash}" ]; then
  echo "missing checksum for ${appimage_name}" >&2
  exit 1
fi

echo "${expected_hash}  ${download_path}" | sha256sum --check --status
chmod +x "${download_path}"

rm -rf "${install_dir}" /tmp/squashfs-root

(
  cd /tmp
  "${download_path}" --appimage-extract >/dev/null
)

mv /tmp/squashfs-root "${install_dir}"
ln -sfn "${install_dir}/AppRun" /usr/local/bin/nvim

rm -f "${download_path}"
