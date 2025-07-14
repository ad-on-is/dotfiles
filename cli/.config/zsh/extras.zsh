# Custom widget that works with fzf-tab and shows zoxide directories if cd does not provide any suggestions.

fzf_cd_complete_or_zoxide() {
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
zle -N fzf_cd_complete_or_zoxide
bindkey '^I' fzf_cd_complete_or_zoxide

script_path=${(%):-%x}
script_dir=${script_path:h}
_ssh_completion() {
  local -a ssh_hosts

  if [[ -f ~/.ssh/config ]]; then
  ssh_hosts+=($(grep -i '^host ' ~/.ssh/config | awk '{print $2}' | grep -v '*' | sort -fbu))
    # selection=($(grep '^[[:space:]]*Host[[:space:]]' ~/.ssh/config | grep -v '*' | cut -d ' ' -f 2 | awk '{print " SSH: "$0}' | fzf --reverse --height 20% --preview="awk -v HOST={3} -f $script_dir/ssh_completion_parser.awk ~/.ssh/config" | awk '{print $3}'))
  
    # ssh_hosts+="$selection\n"
  fi

  _describe 'ssh hosts' ssh_hosts
}

compdef _ssh_completion ssh
zstyle ':fzf-tab:complete:ssh:*' fzf-preview 'awk -v HOST=$word -f $HOME/.config/zsh/ssh_completion_parser.awk ~/.ssh/config'



# Auto Virtual Environment Activation Hook
# Add this to your ~/.zshrc file

# Function to handle virtual environment activation/deactivation
auto_venv() {
    # Deactivate current virtual environment if active
    if [[ -n "$VIRTUAL_ENV" ]]; then
        deactivate
    fi
    
    # Check if current directory contains requirements.txt
    if [[ -f "requirements.txt" ]]; then
        # Look for common virtual environment directory names
        local venv_dirs=("venv" ".venv" "env" ".env" "virtualenv")
        local venv_found=false
        
        for venv_dir in "${venv_dirs[@]}"; do
            if [[ -d "$venv_dir" && -f "$venv_dir/bin/activate" ]]; then
                source "$venv_dir/bin/activate"
                venv_found=true
                break
            fi
        done
        
        # If no virtual environment found, create one automatically
        if [[ "$venv_found" = false ]]; then
            echo "🔨 Creating virtual environment..."
            
            # Create virtual environment
            python -m venv venv
            
            if [[ $? -eq 0 ]]; then
                echo "✅ Virtual environment created successfully!"
                source venv/bin/activate
                
                # Ask to install packages from requirements.txt
                echo -n "📦 Install packages from requirements.txt? [Y/n]: "
                read -r response
                
                # Default to yes if empty response or starts with y/Y
                if [[ -z "$response" || "$response" =~ ^[Yy] ]]; then
                    pip install -r requirements.txt
                    
                    if [[ $? -eq 0 ]]; then
                        echo "✅ Packages installed successfully!"
                    else
                        echo "❌ Failed to install some packages. Check requirements.txt"
                    fi
                fi
            else
                echo "❌ Failed to create virtual environment"
            fi
        fi
    fi
}

# Hook the function to directory changes
autoload -U add-zsh-hook
add-zsh-hook chpwd auto_venv

# Also run when shell starts (in case you're already in a project directory)
auto_venv
