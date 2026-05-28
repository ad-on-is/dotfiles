fpath=(~/.config/zsh/completions $fpath)
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME"/zsh/zcompcache

source "$HOME"/.zshenv
source "$HOME/.config/zsh/init.zsh"

if [[ -f "$HOME"/.zshrc_custom ]]; then
  source "$HOME"/.zshrc_custom
fi

# bun completions
[ -s "/home/adonis/.bun/_bun" ] && source "/home/adonis/.bun/_bun"
