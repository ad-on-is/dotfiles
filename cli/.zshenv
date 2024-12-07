
skip_global_compinit=1

# HSTR configuration - add this to ~/.zshrc
# setopt histignorespace           # skip cmds w/ leading space from history
export HISTFILESIZE=100000000
export HISTSIZE=${HISTFILESIZE}
export SAVEHIST=${HISTFILESIZE}
export HISTFILE=~/.zsh_history
export STARSHIP_LOG=error

setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt appendhistory
setopt INC_APPEND_HISTORY  
setopt SHARE_HISTORY

#export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk/
#export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/Cellar/unox/0.2.0_1/bin:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/tools:$PATH
export EDITOR=/bin/nvim
#export DOCKER_HOST=tcp://127.0.0.1:2375
# PLATFORMIOBINPATH=/home/add/.platformio/penv/bin
# export FLUTTERPATH=$HOME/Flutter/flutter-sdk-linux
# export ANDROID_HOME=$HOME/Android
# export GOPATH=$HOME/Go
# export GOROOT=$GOPATH/go
# export ANDROID_SDK_ROOT=$ANDROID_HOME/tools
# export PATH=$HOME/Docker/bin:$PATH:/usr/lib/dart/bin:/snap/bin:$FLUTTERPATH/bin:$ANDROID_SDK_ROOT/bin:/usr/lib/dart/bin:$GOROOT/bin:$GOPATH/tools/bin:$GOPATH/bin:$HOME/Docker/.npm-global/bin:$PLATFORMIOBINPATH
export GOPATH=$HOME/go
export PIPX_BIN_DIR=~/.local/share/pipx/bin
export ANDROID_HOME=$HOME/Development/Android/Sdk
export FLUTTER_ROOT=$HOME/Development/Flutter/Sdk
PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
PATH=$PATH:$ANDROID_HOME/platform-tools
export CHROME_EXECUTABLE=/usr/bin/chromium-browser
#export PATH=$PATH:$HOME/Development/Docker/bin
PATH=$PATH:$HOME/.fnm
PATH=$FLUTTER_ROOT/bin:$PATH
PATH=$PATH:/usr/lib/dart/bin
PATH=$PATH:$GOROOT/bin:$GOPATH/tools/bin:$GOPATH/bin

PATH=$PATH:$HOME/.pub-cache/bin
PATH=$PATH:$HOME/.local/bin
PATH=$PATH:$HOME/.local/bin/docker


export JAVA_HOME=/etc/alternatives/jre
PATH=$PATH:$JAVA_HOME/bin
PATH=$PATH:$HOME/.platformio/penv/bin

PATH=$PATH:$PIPX_BIN_DIR
export BUN_INSTALL="$HOME/.bun"
PATH="$BUN_INSTALL/bin:$PATH"



export CHROME_EXECUTABLE=/usr/bin/chromium-browser

PATH=$PATH:~/.cargo/bin
PATH=$PATH:/home/linuxbrew/.linuxbrew/bin


export PNPM_HOME=$HOME/.local/share/pnpm
export PATH=$PNPM_HOME:$PATH

export PATH=$PATH
#export ADB_SERVER_SOCKET=tcp:192.168.1.100:5037
# export ADB_SERVER_SOCKET=tcp:"$(cat /etc/resolv.conf | tail -n1 | cut -d " " -f 2)":5037
# export ADB_SERVER_SOCKET=tcp:"$(tail -1 /etc/resolv.conf | cut -d' ' -f2)":5037

# docker-compose vars

if [[ -f ~/.secrets   ]]; then
  source ~/.secrets
fi

# export LS_COLORS=$LS_COLORS'ow=30;106:di=1;4;96:'
# set custom colors for exa
export EXA_COLORS="$LS_COLORS"

export EXA_ICON_SPACING=2

# prevent howdy (facial recognition) warning message
export OPENCV_LOG_LEVEL=ERROR


. "$HOME/.cargo/env"

ZSH_DISABLE_COMPFIX="true"
ZELLIJ_AUTO_EXIT=true
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=false
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=6,underline"
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
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
  --preview-window="border-rounded" --prompt="» " --marker="› " --pointer="◆"
  --separator="─" --scrollbar="│" --info="right"'

export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --exact --height=45% --layout=reverse --preview='eza --icons -1 --color=always {2..}'"

# remove duplicates
typeset -U PATH
