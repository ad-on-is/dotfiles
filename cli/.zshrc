

source ~/.zshenv
source ~/.config/zsh/aliases.zsh

bindkey -e

### Added by Zinit's installer
# if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
#     print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
#     command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
#     command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
#         print -P "%F{33} %F{34}Installation successful.%f%b" || \
#         print -P "%F{160} The clone has failed.%f%b"
# fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
ZINIT[PLUGINS_DIR]=$HOME/.config/zsh/plugins
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust  \
    zsh-users/zsh-autosuggestions \
    Aloxaf/fzf-tab \
    zsh-users/zsh-syntax-highlighting \
    https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/sudo/sudo.plugin.zsh




source ~/.config/zsh/zstyle.zsh




autoload -U compinit && compinit -i  # BEFORE zoxide init




[ -x "$(command -v starship)" ] && eval "$(starship init zsh)"
[ -x "$(command -v zoxide)" ] && eval "${$(zoxide init --cmd cd zsh):s#_files -/#_dirs#}"
[ -x "$(command -v phpenv)" ] && eval "$(phpenv init -)"
[ -x "$(command -v fzf)" ] && eval "$(fzf --zsh)"
[ -x "$(command -v fnm)" ] && eval "$(fnm env --use-on-cd --shell zsh --resolve-engines)"
[ -x "$(command -v goenv)" ] && eval "$(goenv init -)"
[ -x "$(command -v atuin)" ] && eval "$(atuin init zsh)"
# [ -x "$(command -v zellij)" ] && eval "$(zellij setup --generate-auto-start zsh)"
# [ -x "$(command -v vivid)" ] && export LS_COLORS="$(vivid generate catppuccin-mocha)"



# _zoxide_cd_completion() {
#
# local debug_log="/tmp/zoxide_completion_debug.log"
#
#     # Log the current completion context
#     {
#         echo "--- Completion Debug ---"
#         echo "Current words: ${words[@]}"
#         echo "Current word index: $CURRENT"
#         echo "Completing word: ${words[CURRENT]}"
#     } >> "$debug_log"
#
#     # Try to get zoxide matches
#     local completion_word="${words[CURRENT]}"
#     local -a zoxide_matches
#     zoxide_matches=($(zoxide query -l "$completion_word" 2>&1))
#
#     # Log zoxide matches
#     {
#         echo "Zoxide matches count: ${#zoxide_matches[@]}"
#         echo "Zoxide matches: ${zoxide_matches[@]}"
#     } >> "$debug_log"
#
#     # If matches exist, add to completion
#     if [[ ${#zoxide_matches[@]} -gt 0 ]]; then
#         compadd -f "${zoxide_matches[@]}"
#     fi
#
# }
#
# # Replace the default cd completion with our custom function
# compdef _zoxide_cd_completion cd
#



_atuin_up_search() {
    if [[ ! $BUFFER == *$'\n'* ]]; then
        _atuin_search --shell-up-key-binding --inline-height 20 "$@"
    else
        zle up-line
    fi
}



# bun completions
[ -s "$HOME/.bun/_bun" ] && source "/$HOME/.bun/_bun"



# bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
# bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
# bindkey -M menuselect '\r' .accept-line

# bindkey -s "\C-k" 'clear^M'
bindkey '^l'      autosuggest-accept



function clear-scrollback-widget {
  clear && printf '\e[3J'
  zle && zle .reset-prompt && zle -R
}
zle -N clear-scrollback-widget
bindkey '^k' clear-scrollback-widget


if [[ -f $HOME/.local/share/bash-completion/completions/appman ]]; then
  autoload bashcompinit
  bashcompinit
  source "$HOME/.local/share/bash-completion/completions/appman"
fi
