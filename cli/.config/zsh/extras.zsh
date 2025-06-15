# Custom widget that works with fzf-tab

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
# Create the widget and bind it
zle -N fzf_cd_complete_or_space
bindkey '^I' fzf_cd_complete_or_space
