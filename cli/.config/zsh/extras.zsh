# Custom widget that works with fzf-tab and shows zoxide directories if cd does not provide any suggestions.

fzf_cd_complete_or_space() {
  if [[ "$LBUFFER" =~ ^cd\ +[^\ ]+$ ]]; then
    local current_path="${LBUFFER#cd }"

    # Check if there are any directory matches
    local matches=()
    matches=(${current_path}*(/N)) # N flag makes glob return empty if no matches

    if [[ ${#matches[@]} -gt 0 ]]; then
      # There are potential matches, use normal completion
      zle fzf-tab-complete
    else

      before="$LBUFFER"
      LBUFFER="$LBUFFER "
      zle fzf-tab-complete
      LBUFFER="$before"
      # set buffer to non-space version again to prvent adding more spaces
    fi
  else
    zle fzf-tab-complete
  fi
}
zle -N fzf_cd_complete_or_space
bindkey '^I' fzf_cd_complete_or_space

_ssh_completion() {
script_path=${(%):-%x}
script_dir=${script_path:h}
  local -a ssh_hosts

  if [[ -f ~/.ssh/config ]]; then
  ssh_hosts+=($(grep -i '^host ' ~/.ssh/config | awk '{print $2}' | grep -v '*' | sort -fbu))
    # ssh_hosts+=($(grep '^[[:space:]]*Host[[:space:]]' ~/.ssh/config | grep -v '*' | cut -d ' ' -f 2 | awk '{print " SSH: "$0}' | fzf --reverse --height 20% --preview="awk -v HOST={3} -f $script_dir/ssh_completion_parser.awk ~/.ssh/config" | awk '{print $3}'))
  fi

  _describe 'ssh hosts' ssh_hosts
}

compdef _ssh_completion ssh
