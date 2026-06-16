FROM ros:humble

ENV DEBIAN_FRONTEND=noninteractive

# Install nala first
RUN apt-get update && \
    apt-get install -y nala

# Packages
RUN nala update && \
    nala install -y \
        wget \
        curl \
        git \
        gnupg \
        lsb-release \
        software-properties-common \
        sudo \
        nano \
        neovim \
        tmux \
        zoxide \
        zsh \
        build-essential && \
    rm -rf /var/lib/apt/lists/*

# Neovim config
RUN mkdir -p /root/.config && \
    git clone https://github.com/voidWorldDev/nvimDotfiles.git /root/.config/nvim

# Dotfiles
COPY .tmux.conf /root/.tmux.conf
COPY .zshrc /root/.zshrc

# Use zsh for future RUN commands
SHELL ["/usr/bin/zsh", "-c"]

# Start container in zsh
CMD ["/usr/bin/zsh"]
