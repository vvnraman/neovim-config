FROM ubuntu:24.04 AS base

ENV DEBIAN_FRONTEND=noninteractive

RUN <<EOF
set -eux
apt-get update
apt-get install --yes --no-install-recommends \
  bash \
  ca-certificates \
  curl \
  g++ \
  gcc \
  git \
  libc6-dev \
  tar
rm -rf /var/lib/apt/lists/*
EOF

FROM base AS runtime

ARG TARGET_OS=ubuntu
ARG NVIM_VERSION=v0.11.6
ARG FD_VERSION=v10.2.0
ARG RIPGREP_VERSION=14.1.1
ENV DEBIAN_FRONTEND=noninteractive
# AppImage needs extract-and-run mode in containers without FUSE support.
ENV APPIMAGE_EXTRACT_AND_RUN=1

COPY docker/install-cli-tools.sh /opt/nvim-harness/install-cli-tools.sh
COPY docker/install-neovim.sh /opt/nvim-harness/install-neovim.sh

RUN <<EOF
set -eux
chmod +x /opt/nvim-harness/install-cli-tools.sh
chmod +x /opt/nvim-harness/install-neovim.sh
/opt/nvim-harness/install-neovim.sh "${NVIM_VERSION}"
/opt/nvim-harness/install-cli-tools.sh "${TARGET_OS}" \
  --tool "fd:${FD_VERSION}" \
  --tool "ripgrep:${RIPGREP_VERSION}"
EOF

COPY docker/smoke.sh /opt/nvim-harness/smoke.sh
COPY docker/shell.sh /opt/nvim-harness/shell.sh
COPY docker/nvim-env.sh /opt/nvim-harness/nvim-env.sh
RUN chmod +x /opt/nvim-harness/smoke.sh /opt/nvim-harness/shell.sh /opt/nvim-harness/nvim-env.sh

ENTRYPOINT ["/bin/bash"]
