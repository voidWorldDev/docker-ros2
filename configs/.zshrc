# --------------------
# General
# --------------------

export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export LANG=en_US.UTF-8
# export plugin="/usr/share/zsh/plugins"
#----------------------
# Plugins
# --------------------
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh
# source $plugin/zsh-autosuggestions/zsh-autosuggestions.zsh
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
# source $plugin/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source $plugin/zsh-git-prompt/zshrc.sh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# --------------------
# History
# --------------------

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# --------------------
# Completion
# --------------------
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# --------------------
# Keybindings
# --------------------
bindkey -e
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^R' history-incremental-search-backward

# -------------------------
# Functions
# ------------------------
f(){ 
	xdg-open . 
}

upgrade(){
	sudo pacman --noconfirm -Syu --ignore firefox
	sudo pacman --noconfirm -Scc
	yay --noconfirm -Syu --ignore firefox
	yay --noconfirm -Scc
}
  
play() {
    local video
    video=$(find . -type f \( \
        -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.avi" -o -iname "*.mov" -o -iname "*.webm" \
        \) | sort | wofi --dmenu --prompt "Select a video")

    # Check if user selected something
    if [ -n "$video" ]; then
        echo "Selected: $video"
        mpv --hwdec=auto "$video"
    else
        echo "No video selected."
    fi
}



launch_firefox_profiles() {
  local profiles=(Default_user jobhunt collage man_entertain Socials)
  local FIREFOX_BIN="firefox"  # Adjust if needed
  local choices=("ALL" "${profiles[@]}")

  local selection
  selection=$(printf '%s\n' "${choices[@]}" | fzf --multi --height=40% --border \
    --prompt="Select profiles › " \
    --header=$'↑/↓ move  TAB mark/unmark  Alt‑A all  Enter launch')

  [[ -z $selection ]] && { echo "Nothing chosen – bye!"; return; }

  grep -qx "ALL" <<< "$selection" && selection=$(printf '%s\n' "${profiles[@]}")

  while IFS= read -r prof; do
    echo "Launching $prof …"
    "$FIREFOX_BIN" -P "$prof" --no-remote &
  done <<< "$selection"

  wait
}


# --------------------
# Aliases
# --------------------
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias cls='clear'
alias rm='trash-put'
alias grep='grep --color=auto'
alias cd='z'

alias ci="flatpak run com.visualstudio.code"
alias notebook='code --enable-proposed-api ms-toolsai.jupyter .'
alias ff='fzf --preview="cat {}"'
alias sml="source ~/projects/venv/bin/activate"
#

alias firefoxpp='launch_firefox_profiles'

# --------------------
# Path
# --------------------

[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

export PATH="$HOME/bin:/usr/local/bin:$PATH"

# export ANDROID_HOME=/opt/android-sdk
# export ANDROID_SDK_ROOT=$ANDROID_HOME
# export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/cmdline-tools/bin:$PATH
# export PATH=$ANDROID_HOME/platform-tools:$PATH
# export PATH=$ANDROID_HOME/emulator:$PATH
#

export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator

export JAVA_HOME=/usr/lib/jvm/java-25-openjdk
export PATH=$JAVA_HOME/bin:$PATH

export PATH="$HOME/fvm/default/bin:$PATH"
export PATH="$HOME/.pub-cache/bin:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export CUDA_HOME=$CONDA_PREFIX
export PATH=$CUDA_HOME/bin:$PATH
export LD_LIBRARY_PATH=$CUDA_HOME/lib:$LD_LIBRARY_PATH

export DOCKER_BUILDKIT=1

# opencode
export PATH=/home/great/.opencode/bin:$PATH


export CRYPTOGRAPHY_OPENSSL_NO_LEGACY_PROVIDER=1

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/great/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/great/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/great/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/great/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
