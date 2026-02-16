FROM archlinux:latest

ARG TARGET_OS=arch
ARG NVIM_VERSION=v0.11.6

RUN pacman --sync --refresh --sysupgrade --noconfirm \
  && pacman --sync --needed --noconfirm \
    bash \
    ca-certificates \
    curl \
    gcc \
    git \
  && curl -sSLf "https://github.com/TomWright/dasel/releases/latest/download/dasel_linux_amd64" -o /usr/local/bin/dasel \
  && chmod +x /usr/local/bin/dasel \
  && pacman --sync --clean --clean --noconfirm

COPY docker/packages.toml /tmp/packages.toml
COPY docker/install-packages.sh /opt/nvim-harness/install-packages.sh
COPY docker/install-neovim.sh /opt/nvim-harness/install-neovim.sh

RUN chmod +x /opt/nvim-harness/install-packages.sh \
  && chmod +x /opt/nvim-harness/install-neovim.sh \
  && /opt/nvim-harness/install-neovim.sh "${NVIM_VERSION}" \
  && /opt/nvim-harness/install-packages.sh "${TARGET_OS}" /tmp/packages.toml \
  && rm -f /tmp/packages.toml \
  && pacman --sync --clean --clean --noconfirm

COPY docker/smoke.sh /opt/nvim-harness/smoke.sh
COPY docker/shell.sh /opt/nvim-harness/shell.sh
COPY docker/nvim-env.sh /opt/nvim-harness/nvim-env.sh
RUN chmod +x /opt/nvim-harness/smoke.sh /opt/nvim-harness/shell.sh /opt/nvim-harness/nvim-env.sh

ENTRYPOINT ["/bin/bash"]
