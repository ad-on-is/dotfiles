#!/usr/bin/env zsh

host=$(grep '^[[:space:]]*Host[[:space:]]' ~/.ssh/config | cut -d ' ' -f 2 | awk '{print " SSH: "$0}' | fzf  --reverse --height 20% --preview="awk -v HOST={3} -f ~/.local/bin/host2conf.awk ~/.ssh/config" | awk '{print $3}')

if [ -n "$host" ]; then
  eval "</dev/tty ssh -o RequestTTY=yes $host"
  # pid=$!
  # notify-send $pid
  exit
fi
