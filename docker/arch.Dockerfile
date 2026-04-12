FROM archlinux:latest AS base

RUN <<EOF
set -eux
pacman-key --init
pacman-key --populate archlinux
pacman --sync --refresh --noconfirm archlinux-keyring
pacman --sync --refresh --sysupgrade --noconfirm
pacman --sync --needed --noconfirm \
  bash \
  ca-certificates \
  curl \
  gcc \
  gzip \
  git \
  tmux
pacman --sync --clean --clean --noconfirm
EOF

FROM base AS runtime

ARG TARGET_OS=arch
ARG NVIM_VERSION=v0.12.1
ARG FD_VERSION=v10.2.0
ARG RIPGREP_VERSION=14.1.1
ARG TREE_SITTER_CLI_VERSION=v0.26.1
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
  --tool "ripgrep:${RIPGREP_VERSION}" \
  --tool "tree-sitter-cli:${TREE_SITTER_CLI_VERSION}"
pacman --sync --clean --clean --noconfirm
EOF

COPY docker/smoke.sh /opt/nvim-harness/smoke.sh
COPY docker/shell.sh /opt/nvim-harness/shell.sh
COPY docker/nvim-env.sh /opt/nvim-harness/nvim-env.sh
RUN chmod +x /opt/nvim-harness/smoke.sh /opt/nvim-harness/shell.sh /opt/nvim-harness/nvim-env.sh

ENTRYPOINT ["/bin/bash"]
