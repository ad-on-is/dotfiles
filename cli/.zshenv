skip_global_compinit=1

export XDG_STATE_HOME=${XDG_STATE_HOME:-"$HOME/.local/state"}
export XDG_DATA_HOME=${XDG_DATA_HOME:-"$HOME/.local/share"}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-"$HOME/.config"}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-"$HOME/.cache"}

export LANGUAGE="C.UTF-8"
export LANG="C.UTF-8"
export LC_COLLATE="C.UTF-8"
export LC_CTYPE="C.UTF-8"
export LC_MONETARY="C.UTF-8"
export LC_NUMERIC="C.UTF-8"
export LC_TIME="C.UTF-8"
export LC_MESSAGES="C.UTF-8"
export LC_ALL="C.UTF-8"

# HSTR configuration - add this to ~/.zshrc
# setopt histignorespace           # skip cmds w/ leading space from history

# required for gnome keyring to work
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/keyring/ssh"

export HISTFILESIZE=100000000
export HISTSIZE=${HISTFILESIZE}
export SAVEHIST=${HISTFILESIZE}
export STARSHIP_LOG=error

setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# XDG FIXUP
export ANDROID_USER_HOME="$XDG_DATA_HOME"/android
export ANDROID_EMLUATOR_HOME="$XDG_DATA_HOME"/android
export ANDROID_AVD_HOME="$XDG_DATA_HOME"/android/avd
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export FNM_PATH="$XDG_DATA_HOME"/fnm
export DOTNET_CLI_HOME="$XDG_DATA_HOME"/dotnet
export DUB_HOME="$XDG_DATA_HOME/dub"
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GOPATH=$XDG_DATA_HOME/go
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export XCURSOR_PATH=/usr/share/icons:$XDG_DATA_HOME/icons
export JULIA_DEPOT_PATH="$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"
# export ICEAUTHORITY="$XDG_CACHE_HOME"/ICEauthority
export XCOMPOSEFILE="$XDG_CONFIG_HOME"/X11/xcompose
# export TERMINFO_DIRS="$XDG_DATA_HOME"/terminfo:/usr/share/terminfo
export NODE_REPL_HISTORY="$XDG_STATE_HOME"/node_repl_history
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME"/npm
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME"/npm/config/npm-init.js
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR"/npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export NUGET_PACKAGES="$XDG_CACHE_HOME"/NuGetPackages
export NVM_DIR="$XDG_DATA_HOME"/nvm
export OMNISHARPHOME="$XDG_CONFIG_HOME"/omnisharp
export RANDFILE="$XDG_CACHE_HOME"/rnd
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel
export PLATFORMIO_CORE_DIR="$XDG_DATA_HOME"/platformio
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export WINEPREFIX="$XDG_DATA_HOME"/wine
export PNPM_HOME="$XDG_DATA_HOME"/pnpm
export NPM_CONFIG_STORE_DIR="$PNPM_HOME"/store
export COMPOSER_HOME="$XDG_DATA_HOME"/composer

export LG_CONFIG_FILE="/$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/catppuccin.yml"

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk
export BUN_INSTALL="$HOME/.bun"

export CHROME_EXECUTABLE=/usr/bin/chromium-browser

export EDITOR=nvim

if [ -n "$DISPLAY" ]; then
  export EDITOR=neovide
fi

export PIPX_BIN_DIR="$XDG_DATA_HOME"/pipx/bin
export ANDROID_HOME=$HOME/Development/Android/Sdk
export FLUTTER_ROOT=$HOME/Development/Flutter/Sdk
export CHROME_EXECUTABLE=/usr/bin/chromium-browser
PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
PATH=$PATH:$ANDROID_HOME/platform-tools
PATH=$PATH:$XDG_DATA_HOME/fnm
PATH=$FLUTTER_ROOT/bin:$PATH
PATH=$PATH:/usr/lib/dart/bin
PATH=$PATH:$GOPATH/bin

PATH=$PATH:$HOME/.pub-cache/bin
PATH=$PATH:$HOME/.local/bin
PATH=$PATH:$HOME/.local/bin/docker

PATH=$PATH:$JAVA_HOME/bin
PATH=$PATH:$HOME/.platformio/penv/bin

PATH=$PATH:$PIPX_BIN_DIR
PATH="$BUN_INSTALL/bin:$PATH"

PATH=$PATH:$CARGO_HOME/bin
PATH=$PATH:$XDG_DATA_HOME/composer/vendor/bin
PATH=$HOME/.local/share/devbox/global/default/.devbox/nix/profile/default/bin:$PATH
PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
PATH=$PATH:$XDG_DATA_HOME/nvim/mason/bin

export PATH=$PNPM_HOME:$PATH

export PATH=$PATH

if [[ -f ~/.local/.secrets ]]; then
  source ~/.local/.secrets
fi

# export LS_COLORS=$LS_COLORS'ow=30;106:di=1;4;96:'
# set custom colors for exa
export EXA_COLORS="$LS_COLORS"

export EXA_ICON_SPACING=2

# prevent howdy (facial recognition) warning message
export OPENCV_LOG_LEVEL=ERROR

if [[ -f "$CARGO_HOME/env" ]]; then
  . "$CARGO_HOME/env"
fi

export ZSH_DISABLE_COMPFIX="true"
export ZELLIJ_AUTO_EXIT=true
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_USE_ASYNC=false
# export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=6"
export N_PREFIX="$HOME/n"
[[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin" # Added by n-install (see http://git.io/n-install-repo).
# export MCFLY_LIGHT=TRUE
# export MCFLY_KEY_SCHEME=vim
export MCFLY_FUZZY=3
export MCFLY_RESULTS=50
export MCFLY_DISABLE_MENU=TRUE
export MCFLY_RESULTS_SORT=RANK
export MCFLY_PROMPT="»"
# export MCFLY_LIGHT=TRUE
export SKIM_DEFAULT_OPTIONS="$SKIM_DEFAULT_OPTIONS \
--color=fg:#cdd6f4,bg:#1e1e2e,matched:#313244,matched_bg:#f2cdcd,current:#cdd6f4,current_bg:#45475a,current_match:#1e1e2e,current_match_bg:#f5e0dc,spinner:#a6e3a1,info:#cba6f7,prompt:#89b4fa,cursor:#f38ba8,selected:#eba0ac,header:#94e2d5,border:#6c7086"

export FZF_COMPLETION_TRIGGER='**'
export FZF_DEFAULT_OPTS="--bind btab:up,tab:down"
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:-1,fg+:#89b4fa,bg:-1,bg+:-1
  --color=hl:#5f87af,hl+:#89b4fa,info:#afaf87,marker:#74c7ec
  --color=prompt:#f5e0dc,spinner:#cba6f7,pointer:#cba6f7,header:#87afaf
  --color=border:#313244,label:#aeaeae,query:#d9d9d9
  --preview-window="border-rounded"
  --prompt="» "
  --marker="› "
  --pointer="◆"
  --separator="─"
  --scrollbar="│"
  --info="right"
  --select-1
  '

export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --exact --height=5% --layout=reverse --preview='eza --icons -1 --color=always {2..}'"

# remove duplicates
typeset -U PATH
