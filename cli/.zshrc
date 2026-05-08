fpath=(~/.config/zsh/completions $fpath)
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache

source "$HOME"/.zshenv

bindkey -e

ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

# get zsh_unplugged and store it with your other plugins
if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone --quiet https://github.com/mattmc3/zsh_unplugged "$ZPLUGINDIR"/zsh_unplugged
fi
source "$ZPLUGINDIR"/zsh_unplugged/zsh_unplugged.zsh
source "$HOME/.config/zsh"/unplugged_init.zsh

export plugins=(
  zsh-defer
  ohmyzsh/plugins/sudo
  ohmyzsh/plugins/fancy-ctrl-z
  ohmyzsh/plugins/extract
  zsh-autosuggestions
  zsh-completions
  zsh-syntax-highlighting
  fzf-tab
  fzf-tab-source
  # prezto/modules/terminal
)

repos=(
  romkatv/zsh-defer
  ohmyzsh/ohmyzsh
  sorin-ionescu/prezto
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
  zsh-users/zsh-syntax-highlighting
  Aloxaf/fzf-tab
  Freed-Wu/fzf-tab-source
)

plugin-clone $repos
plugin-source $plugins

if (( ${+functions[compdef]} )); then
  compdef _gwt_add gwt_add
  compdef _gwt_remove gwt_remove
else
  zsh-defer compdef _gwt_add gwt_add
  zsh-defer compdef _gwt_remove gwt_remove
fi

source "$HOME"/.config/zsh/aliases.zsh
source "$HOME"/.config/zsh/zstyle.zsh

export FNM_PATH="$HOME"/.local/share/fnm
source "$HOME"/.config/zsh/exec.zsh

[ -s "$HOME/.bun/_bun" ] && source "/$HOME/.bun/_bun"

if [[ -f "$HOME"/.zshrc_custom ]]; then
  source "$HOME"/.zshrc_custom
fi

source "$HOME"/.config/zsh/extras.zsh

# fnm
