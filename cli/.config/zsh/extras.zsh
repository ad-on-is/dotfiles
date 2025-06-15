# Custom widget that works with fzf-tab
fzf_cd_complete_or_space() {
  if [[ "$LBUFFER" =~ ^cd\ +[^\ ]+$ ]]; then
    # Store original state
    local original_buffer="$LBUFFER"

    # Try fzf-tab completion
    zle fzf-tab-complete

    # If buffer unchanged (no completions), add space and try again
    if [[ "$LBUFFER" == "$original_buffer" ]]; then
      LBUFFER="$LBUFFER "
      # Automatically invoke completion again after adding the space
      zle fzf-tab-complete
    fi
  else
    # For non-cd commands, use normal fzf-tab completion
    zle fzf-tab-complete
  fi
}

# Create the widget and bind it
zle -N fzf_cd_complete_or_space
bindkey '^I' fzf_cd_complete_or_space
