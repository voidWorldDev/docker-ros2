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
COPY configs/.tmux.conf /root/.tmux.conf
COPY configs/.zshrc /root/.zshrc
COPY configs/starship.toml /root/.config/starship.toml

RUN RUNZSH=no \
    CHSH=no \
    KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        /root/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        /root/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y

# Use zsh for future RUN commands
RUN chsh -s /usr/bin/zsh root

# Start container in zsh
CMD ["/usr/bin/zsh"]
