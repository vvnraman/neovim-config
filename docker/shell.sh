#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/nvim-env.sh"

profile_name="${1:-standard}"
case "${profile_name}" in
  minimal|standard)
    export VVN_NVIM_PROFILE="${profile_name}"
    ;;
  *)
    echo "unsupported nvim profile: ${profile_name}" >&2
    exit 1
    ;;
esac

exec /bin/bash
