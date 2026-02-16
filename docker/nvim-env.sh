#!/usr/bin/env bash

set -euo pipefail

config_dir="${NVIM_CONFIG_DIR:-$(pwd)}"

export XDG_CONFIG_HOME="$(dirname "${config_dir}")"
export NVIM_APPNAME="$(basename "${config_dir}")"
