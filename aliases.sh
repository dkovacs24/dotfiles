#!/usr/bin/env bash

# include in .bashrc or .zshrc with `source /path/to/this/file`

# most of the stuff is from https://pastebin.com/hZzV308p

alias sudo="sudo " # need it for aliases to work with sudo
alias cd..="cd .." # fix/prevent cd mishaps

# auto cd TODO: add zsh version
#shopt -s autocd

# Default parameters
alias df="df -h --exclude=squashfs"
alias grep="grep --color=auto"
alias wget="wget -c"
alias mkdir="mkdir -pv"
alias diff="diff -W \$(tput cols)"
## confirmation
alias mv="mv -iv"
alias cp="cp -iv"
alias ln="ln -iv"
## Preventing changes on /
alias rm="rm -Iv --preserve-root"
alias chmod="chmod -c --preserve-root"
alias chown="chown -c --preserve-root"
alias chgrp="chgrp -c --preserve-root"

# """""Custom""""" and shorter commands
alias wtfismyip="echo 'IPv4'; curl -sS -m 5 https://ipv4.yaml.myip.wtf; echo; echo 'IPv6'; curl -sS -m 5 https://ipv6.yaml.myip.wtf"
ls_params="-lFh --time-style=long-iso --color=auto"
alias la="ls -a $ls_params"
alias ll="ls $ls_params"
alias l="la"
alias c="clear"
alias h="history"
alias j="jobs -l"
alias back="cd \$OLDPWD"
alias lsmount="mount | grep -v docker | column -t"
alias lsports="netstat -tulanp"
alias time="/usr/bin/time"
alias empty="truncate --size 0"
alias dc="docker compose"
alias sc="sudo systemctl"

# Make a directory, then go there
if [[ "$ZSH" == *".oh-my-zsh" ]]; then
    unalias md >/dev/null 2>&1 #incase oh-my-zsh adds another md alias and this md func throws an exception
fi
md () {
    test -n "$1" || return
    mkdir -pv "$1" && cd "$1"
}

cheat () {
    joined_args=$(echo "$@" | tr ' ' '-')
    curl -sSL "https://cheat.sh/$joined_args"
}

_ipinfo () {
    ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"
    for ip in "$@"; do
        if [[ "$ip" =~ $ip_regex ]]; then
            URL="https://ipinfo.io/$ip"
            echo "$URL"
            curl -sSL "$URL" | jq 'del(.readme)'
        else
            echo "Invalid IP address: $ip"
        fi
    done

}
if ! command -v ipinfo &>/dev/null; then
    alias ipinfo="_ipinfo"
fi

randstring () {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c "${1:-16}"; echo
}

update-mirrors () {
    if [[ $(command -v rate-mirrors) && $(command -v pacman) ]]; then
        rate-mirrors --protocol https --entry-country HU arch | sudo tee /etc/pacman.d/mirrorlist
    else
        echo "Either the 'rate-mirrors' command, the 'pacman' command, or both are not installed or cannot be found."
    fi
}

# doas
if [ -f /usr/bin/doas ]; then
	#complete -cf doas # bash only
    alias doas="doas "
	alias sudo="doas "
fi

# Manage packages easier TODO: add support for other package managers
if [ -f /usr/bin/apt ]; then
    alias update="sudo apt update"
    alias upgrade="sudo apt update && sudo apt full-upgrade"
    alias install="sudo apt install"
fi
 
if [ -f /usr/bin/pacman ]; then
    alias update="sudo pacman -Sy"
    alias upgrade="sudo pacman -Syu"
    alias install="sudo pacman -S"
fi


