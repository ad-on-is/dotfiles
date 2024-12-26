alias adb='HOME="$XDG_DATA_HOME"/android adb'
alias mvn="mvn -gs $XDG_CONFIG_HOME/maven/settings.xml"

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
alias rg='rg --smart-case'


function distrobox-save() {
  if [[ -z $1 ]]; then
    echo "Please provide a distrobox name"
    return
  fi
  name=$1
  file="$HOME/.local/distrobox/$name.tar.gz"
  echo "Saving $name to $file"
  docker container commit -p "$name" "$name"
  docker save "$name":latest | gzip > $file
}

function distrobox-restore() {
 if [[ -z $1 ]]; then
    echo "Please provide a distrobox name"
    return
  fi

  name=$1
  file="$HOME/.local/distrobox/$name.tar.gz"

  docker load < $file
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
