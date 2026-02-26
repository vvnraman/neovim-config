FROM ubuntu:24.04

ARG TARGET_OS=ubuntu
ARG NVIM_VERSION=v0.11.6
ARG FD_VERSION=v10.2.0
ARG RIPGREP_VERSION=14.1.1
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    g++ \
    gcc \
    git \
    libc6-dev \
    tar \
  && curl -sSLf "https://github.com/TomWright/dasel/releases/latest/download/dasel_linux_amd64" -o /usr/local/bin/dasel \
  && chmod +x /usr/local/bin/dasel \
  && rm -rf /var/lib/apt/lists/*

COPY docker/packages.toml /tmp/packages.toml
COPY docker/install-packages.sh /opt/nvim-harness/install-packages.sh
COPY docker/install-cli-tools.sh /opt/nvim-harness/install-cli-tools.sh
COPY docker/install-neovim.sh /opt/nvim-harness/install-neovim.sh

RUN chmod +x /opt/nvim-harness/install-packages.sh \
  && chmod +x /opt/nvim-harness/install-cli-tools.sh \
  && chmod +x /opt/nvim-harness/install-neovim.sh \
  && /opt/nvim-harness/install-neovim.sh "${NVIM_VERSION}" \
  && /opt/nvim-harness/install-cli-tools.sh "${TARGET_OS}" "${FD_VERSION}" "${RIPGREP_VERSION}" \
  && /opt/nvim-harness/install-packages.sh "${TARGET_OS}" /tmp/packages.toml \
  && rm -f /tmp/packages.toml

COPY docker/smoke.sh /opt/nvim-harness/smoke.sh
COPY docker/shell.sh /opt/nvim-harness/shell.sh
COPY docker/nvim-env.sh /opt/nvim-harness/nvim-env.sh
RUN chmod +x /opt/nvim-harness/smoke.sh /opt/nvim-harness/shell.sh /opt/nvim-harness/nvim-env.sh

ENTRYPOINT ["/bin/bash"]
