zstyle '*:compinit' arguments -D -i -u -C -w
# all Tab widgets
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:complete:*:options' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':completion:*' fzf-search-display true
zstyle ':fzf-tab:*' fzf-min-height 200
zstyle ':fzf-tab:*' use-fzf-default-opts yes



zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --icons -1 --color=always $realpath'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'    
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --color=always $word'
zstyle ':fzf-tab:complete:git-he    lp:*' fzf-preview 'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'

# zstyle ':completion:*' completer _expand _expand_alias _complete _correct _ignored _approximate

