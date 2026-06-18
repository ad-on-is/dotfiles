fpath=(~/.config/zsh/completions $fpath)
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache

source "$HOME"/.zshenv
source "$HOME/.config/zsh/init.zsh"

if [[ -f "$HOME"/.custom.zsh ]]; then
  source "$HOME"/.custom.zsh
fi
