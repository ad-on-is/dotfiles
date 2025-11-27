alias adb='HOME="$XDG_DATA_HOME"/android adb'
alias mvn="mvn -gs $XDG_CONFIG_HOME/maven/settings.xml"

alias gatekeeper-enable='sudo spctl --master-enable'
alias gatekeeper-disable='sudo spctl --master-disable'
alias drminone='docker rmi $(docker images -f "dangling=true" -q)'
alias dsynctime='docker run --rm --privileged alpine hwclock -s'
alias drmex='docker ps -a | grep Exit | cut -d " " -f 1 | xargs sudo docker rm'
alias dclogs='docker compose -f ~/Development/Docker/docker-compose.yaml logs -f --tail=100'
alias docker-ports='docker ps -a --format="table {{.Image}}\t{{.Names}}\t{{.Ports}}"'
alias docker-status='docker ps -a --format="table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"'
alias docker-update-images='docker images | grep -v ^REPO | sed "s/ \+/:/g" | cut -d: -f1,2 | xargs -L1 docker pull && drminone -f'
alias dexec=docker_exec
alias emacs='emacs -nw'
alias devwatch='find $1 | entr -cr ${@: 2}'
alias watchgo='watchexec -r -e go --stop-signal SIGINT -- ${@:1}'
alias sctl='systemctl --user'
alias jctl='journalctl --user'
alias lag='lazygit'
alias lad='lazydocker'
alias dbg='devbox global'
alias http='xh -Fb'
alias download='xh -b --download'
alias ze='~/.local/bin/zed --new'

function gitpr() {
  git fetch origin pull/$1/head:PR-$1
  git checkout PR-$1
}

function gitcb() {
  git checkout --track origin/$1
}

function spf() {
  os=$(uname -s)

  # Linux
  if [[ "$os" == "Linux" ]]; then
    export SPF_LAST_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir"
  fi

  # macOS
  if [[ "$os" == "Darwin" ]]; then
    export SPF_LAST_DIR="$HOME/Library/Application Support/superfile/lastdir"
  fi

  command superfile "$@"

  [ ! -f "$SPF_LAST_DIR" ] || {
    . "$SPF_LAST_DIR"
    rm -f -- "$SPF_LAST_DIR" >/dev/null
  }
}

alias gobuildrpi='env GOOS=linux GOARCH=arm GOARM=5 go build'

alias get_addcerts='scp -r adis_durakovic@dnmc.in:/home/adis_durakovic/webserver/config/nginx/ssl/archive/add.dnmc.in ~/Docker/conf/nginx/ssl/archive/add.dnmc.in'

alias rg='rg --smart-case --hidden'
alias rgp='rg --passthru'

function rgmulti() {
}

function distrobox-save() {
  if [[ -z $1 ]]; then
    echo "Please provide a distrobox name"
    return
  fi
  name=$1
  file="$HOME/.local/distrobox/$name.tar.gz"
  echo "Saving $name to $file"
  docker container commit -p "$name" "$name"
  docker save "$name":latest | gzip >$file
}

function distrobox-restore() {
  if [[ -z $1 ]]; then
    echo "Please provide a distrobox name"
    return
  fi

  name=$1
  file="$HOME/.local/distrobox/$name.tar.gz"

  docker load <$file
}

alias fix-datagrip='fd -H "\\.lock" ~/.var/app/com.jetbrains.DataGrip -x rm'

function nva() {
  NVIM_APPNAME=astronvim nv "$@"
}

function nvam() {
  NVIM_APPNAME=astronvim nvim "$@"
}

function updatezsh() {
  echo "$ZPLUGINDIR"
  /bin/rm -rf "$ZPLUGINDIR"
  zsh
}

function zshplugins() {
  ll "$ZPLUGINDIR"
}

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd <"$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  /usr/bin/rm -f -- "$tmp"
}

alias ..="cd .."
alias cat="bat"

alias ls='eza --icons --group --group-directories-first --octal-permissions --no-permissions --color=auto --time-style=long-iso --modified'
alias ll='ls -la -M'
alias la='ls -a'
alias find='fd -H'
alias tree="ls --tree -L 2"
# alias rm='gio trash'
function rm() {
  cmd=""
  for arg in "$@"; do
    if [[ "$arg" != "-rf" && "$arg" != "-r" ]]; then
      cmd="$cmd$arg "
    fi
  done

  eval "gio trash $cmd"
}
alias usage='\gdu --no-cross'

alias ldu='du -h --max-depth=1 | sort -rh'
alias fix_history='mv ~/.zsh_history ~/.zsh_history_bad && strings ~/.zsh_history_bad > ~/.zsh_history && rm  ~/.zsh_history_bad && fc -R ~/.zsh_history'

docker_exec() {
  docker exec -it "$1" /bin/sh
}

fb_google_hash() {
  echo "$1" | xxd -r -p | openssl base64
}

alias fb_release_hash='keytool --exportcert -alias key -keystore ~/Credentials/key.jks | openssl sha1 -binary | openssl base64'

alias android_signed_keys='keytool -list -v -alias key -keystore ~/Credentials/key.jks'

alias gico='git checkout'
alias gicm='git commit -am'
alias gitr='git checkout -t'
alias gibr='git checkout -b'
alias gilo='git l $(git branch --show-current)'
alias gipl='git pull'
alias giph='git push'

# git config --global alias.d '!git diff $(git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/origin/@@")'
