zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache

source "$HOME"/.zshenv

bindkey -e

ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

# get zsh_unplugged and store it with your other plugins
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone --quiet https://github.com/mattmc3/zsh_unplugged "$ZPLUGINDIR"/zsh_unplugged
fi
source "$ZPLUGINDIR"/zsh_unplugged/zsh_unplugged.zsh

# ohmyzsh plugins
export plugins=(
  sudo
)


repos=(
  ohmyzsh/ohmyzsh
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  Aloxaf/fzf-tab
  Freed-Wu/fzf-tab-source
  zsh-users/zsh-syntax-highlighting
)

plugin-load $repos

source "$HOME"/.config/zsh/aliases.zsh
source "$HOME"/.config/zsh/zstyle.zsh

# autoload -U compinit && compinit -i # BEFORE zoxide init
# compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

[ -x "$(command -v starship)" ] && eval "$(starship init zsh)"
[ -x "$(command -v zoxide)" ] && eval "${$(zoxide init --cmd cd zsh):s#_files -/#_dirs#}"
[ -x "$(command -v phpenv)" ] && eval "$(phpenv init -)"
[ -x "$(command -v fzf)" ] && eval "$(fzf --zsh)"
[ -x "$(command -v fnm)" ] && eval "$(fnm env --use-on-cd --shell zsh --resolve-engines)"
[ -x "$(command -v goenv)" ] && eval "$(goenv init -)"
[ -x "$(command -v atuin)" ] && eval "$(atuin init zsh)"
[ -x "$(command -v devbox)" ] && eval "$(devbox global shellenv)"
[ -x "$(command -v direnv)" ] && eval "$(direnv hook zsh)"
# [ -x "$(command -v zellij)" ] && eval "$(zellij setup --generate-auto-start zsh)"
[ -x "$(command -v vivid)" ] && export LS_COLORS="$(vivid generate catppuccin-mocha)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "/$HOME/.bun/_bun"
#
bindkey '^l' autosuggest-accept

function clear-scrollback-widget {
  clear && printf '\e[3J'
  zle && zle .reset-prompt && zle -R
}
zle -N clear-scrollback-widget
bindkey '^k' clear-scrollback-widget

# function open-select-widget {
#   "$HOME"/.local/bin/ssh-select.sh
# }
# zle -N open-select-widget
# bindkey '^P' open-select-widget

if [[ -f $HOME/.local/share/bash-completion/completions/appman ]]; then
  autoload bashcompinit
  bashcompinit
  source "$HOME/.local/share/bash-completion/completions/appman"
fi

if [[ -f "$HOME"/.zshrc_custom ]]; then
  source "$HOME"/.zshrc_custom
fi

# fnm
export FNM_PATH="$HOME"/.local/share/fnm
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi


source "$HOME"/.config/zsh/extras.zsh
