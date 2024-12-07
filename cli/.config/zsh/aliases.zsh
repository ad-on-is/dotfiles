alias gatekeeper-enable='sudo spctl --master-enable'
alias gatekeeper-disable='sudo spctl --master-disable'
alias drminone='docker rmi $(docker images -f "dangling=true" -q)'
alias dsynctime='docker run --rm --privileged alpine hwclock -s'
alias drmex='docker ps -a | grep Exit | cut -d " " -f 1 | xargs sudo docker rm'
alias dclogs='docker-compose -f ~/Development/Docker/docker-compose.yaml logs -f --tail=100'
alias docker-ports='docker ps -a --format="table {{.Image}}\t{{.Names}}\t{{.Ports}}"'
alias docker-status='docker ps -a --format="table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Status}}"'
alias docker-update-images='docker images | grep -v ^REPO | sed "s/ \+/:/g" | cut -d: -f1,2 | xargs -L1 docker pull && drminone -f'
alias dexec=docker_exec
alias emacs='emacs -nw'
alias devwatch='find $1 | entr -cr ${@: 2}'
alias watchgo='watchexec -r -e go --stop-signal SIGINT -- ${@:1}'

alias gobuildrpi='env GOOS=linux GOARCH=arm GOARM=5 go build'

alias get_addcerts='scp -r adis_durakovic@dnmc.in:/home/adis_durakovic/webserver/config/nginx/ssl/archive/add.dnmc.in ~/Docker/conf/nginx/ssl/archive/add.dnmc.in'

alias docker-compose='docker compose'


function stowpush() {
  curdir=$(pwd)
  cd $HOME/dotfiles
  git add .
  git commit -am "changes"
  git push
  cd $curdir
}

function stowpull() {
  curdir=$(pwd)
  cd $HOME/dotfiles
  git pull
  cd $curdir
}


function stowadd() {
  curdir=$(pwd)
  src=$1
  cat=$2
  if [[ "$src" = "." ]]; then
    src=$(pwd)
  fi
 
  if [[ "$src" != /* ]]; then 
    src=$(pwd)/$src
  fi

  what=$src
  what=$(echo $what | sed -e "s/~\///g")
  what=$(echo $what | sed  -e "s/\/home\/$(whoami)\///g")
  BLUE='\033[0;34m'
  YELLOW='\033[0;33m'
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  NC='\033[0m'



  if [[ ! -e "$src" ]]; then
    echo
    echo -e "$src ${RED}not found!${NC}"
    return
  fi



  echo -e "${BLUE}From:\t${NC} $src"
  echo -e "${BLUE}To:\t${NC} $HOME/dotfiles/${GREEN}$cat${NC}/$what"

   read -r "response?Continue? [Y/n]"
  # response=${response,,} # tolower
  if [[ "$response" =~ ^[Nn]$ ]]; then
    echo "Aborted."
  else
    mv $src $HOME/dotfiles/$cat/$what
    cd $HOME/dotfiles
    stow $cat -v
    git add .
    git commit -am "changes"
    git push

    cd $curdir
  fi


}

alias fix-datagrip='fd -H "\\.lock" ~/.var/app/com.jetbrains.DataGrip -x rm'

# function http() {
#     set -e
#     out=$(curl -sSLv "$@" 2>&1)
#     body=""
#     isBody="false"
#     headers=""
#     method=""
#     while read -r line; do
#         if [[ $isBody == "true" ]]; then
#             body+="$line\n"
#         fi
#         # if [[ $isMethod == "true" ]]; then
#         #     method="$line"
#         #     isMethod="false"
#         # fi
#         if [[ $line == *"> "* ]]; then
#             l=${line//> /}
#              if [[ $method == "" ]]; then
#                 method="URI: $l"
#             fi
#         fi
#         if [[ $line == *"* Connection"* ]]; then
#             isBody="true"
#         fi
#          if [[ $line == *"< "* ]]; then
#             l=${line//< /}
#             # l=${l//: /' = '}
#             l=${l//'HTTP\/'/'Status: HTTP/'}

#             # if line is not empty or a new line
#             if [ -n "$l" ]; then
#                 headers+="$l\n"
#             fi
            
#         fi
#     combheaders="$method\n$headers"
#     done <<< "$out"
#     # echo $combheaders | bat --style=plain --paging=never --theme='Catppuccin Mocha' -l makefile
#     # jqbody=$(echo $body | jq >2 /dev/null )
#     # if [ -n "$jqbody" ]; then
#     #     $body = $jqbody
#     # fi
#     echo $body | bat --style=plain --paging=never --theme='Catppuccin Mocha'
# }



alias ..="cd .."
alias cat="bat --style=plain  --paging=never --theme='Catppuccin Mocha'"

alias ls='eza --icons --group --git-repos-no-status --group-directories-first --octal-permissions --no-permissions --color=auto --time-style=long-iso --modified'
alias ll='ls -la -M'
alias la='ls -a'
alias find='fd -H'
alias tree="ls --tree -L 2"
alias rm='gio trash'
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
function quitawesome() {
    apid=`ps -H -t /dev/tty2 | grep "awesome" | awk '{print $1}'`
    kill -SIGKILL $apid
}

function landevice() {
    device="$1"
    if [[ -z $device ]]; then
      device="."
    fi

    vlans=(0 10 30 40 60 80 90 200)
    final=""
    vlanstr=""
    for vlan in "${vlans[@]}"
    do
        vlanstr="10.40.$vlan.0/24 $vlanstr" 
    done

    final=`nmap -sL $(echo $vlanstr | rev | cut -c 2- | rev) | grep '.lan' | grep -i $device`
    final=`echo $final | sed -r '/^\s*$/d' | sort`

    if [[  $device == "." ]]; then
        final=`echo $final | awk '{print $5" "$6}'`
    else
        final=`echo $final | awk '{print $5}'`
    fi

    echo $final


    
}
