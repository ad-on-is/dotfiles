zstyle '*:compinit' arguments -D -i -u -C -w
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
zstyle ':fzf-tab:*' fzf-min-height 200
zstyle ':fzf-tab:*' use-fzf-default-opts yes

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons -1 --color=always $realpath'
# zstyle ':fzf-tab:complete:ssh:*' fzf-preview 'host $word  | head -1'
