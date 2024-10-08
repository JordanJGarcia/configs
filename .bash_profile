# colors for prompt
blue="\[\e[0;36m\]"
purple="\[\e[1;35m\]"
green="\[\e[3;32m\]"
fgreen="\001\e[3;32m\002"
bgreen="\001\e[42m\002"
red="\[\e[3;91m\]"
fred="\001\e[3;91m\002"
bred="\001\e[41m\002"
yellow="\[\e[3;33m\]"
default="\[\e[0m\]"
clr="\001\033[00\002"

# prompt
export PS1="\n${blue}[\w]\n${default}[${red}\u${blue} - ${red}\d${blue}]\$(show_exit_status \$?)${default}${yellow}\$(show_git_data) $ ${default}"

# path
export PATH="${PATH}:/usr/sbin:/sbin:/usr/local/sbin"

# debian packaging variables                                                                                                                                                      
DEBEMAIL="j.joseph_g@yahoo.com"
DEBFULLNAME="Jordan Garcia"
export DEBEMAIL DEBFULLNAME

# enable timestamps in history
export HISTTIMEFORMAT="%F %T "

# set vi editing mode
set -o vi

# aliases
alias ls='ls --color=auto -F'
alias l='ls --color=auto -F'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls --color=auto -lrt'
alias la='ls --color=auto -lart'
alias tf='tail -fn 1000'
alias grep='grep --color=auto'

alias dte='date +"%a, %d %b %Y %H:%M:%S %z"'
alias galias='git config --list | grep alias'
alias showlog='tail -n 1000 /var/log/syslog'
alias usage='du -hsx * | sort -rh | head -20'

alias dev='cd ~/Documents/'

alias gs='git status'
alias gl='git l'
alias gc='git commit -m'
alias ga='git add'
alias gd='git diff'

alias python='python3'

# used to navigate to the appropriate build dir
build_dir()
{
    # usage check
    if [[ $# -ne 1 ]]; then
        echo "Usage: build_dir <dist>" 1>&2
        return
    fi

    # switch directories
    cd /var/cache/pbuilder/${1}-amd64/result/
}

# used to send built packages to remote node for installation
sync_pkgs()
{
    if [ $# -ne 2 ]; then
        echo "Usage: sync_pkgs server distribution" 1>&2
        return
    fi

    scp ${HOME}/.junk.list root@${1}:/etc/apt/sources.list.d/junk.list
    ssh root@${1} "mkdir /root/packages; apt-get install rsync"
    rsync -avz --progress --partial --stats --delete /var/cache/pbuilder/${2}-amd64/result/*.deb root@${1}:/root/packages/
    ssh root@${1} "(cd /root/packages; apt-ftparchive packages . > Packages; apt-ftparchive release . > Release); apt-get update"
}

# used to place my public key on a remote node
sync_key()
{
    mypubkey="$(find /home/$(whoami)/.ssh/ -name "*.pub" 2>/dev/null)"

    if [[ -z $mypubkey ]]; then
        echo "no key found" 1>&2
        exit 1
    fi

    if [ $# -gt 2 || $# -lt 1 ]; then
        echo "Usage: sync_key server [user]" 1>&2
        return
    elif [ $# -eq 2 ]; then
        ssh-copy-id -i ${mypubkey} ${2}@${1}
    else
        ssh-copy-id -i ${mypubkey} ${1}
    fi
}


##### Functions for my prompt #####

# show git branch currently on
show_git_data()
{
    branch=$(git branch -vv 2>/dev/null | sed -e '/^[^*]/d' | sed -e 's/^\* //g' | awk '{print $1}')
    upstream=$(git branch -vv 2>/dev/null | sed -e '/^[^*]/d' | sed -e 's/^\* //g' | grep -E '\[.*\]') 

    if [[ -z $upstream && -z $branch ]]; then
        return
    elif [[ -z $upstream && -n $branch ]]; then
        upstream="no upstream"
    else
        upstream=$(echo $upstream | cut -d[ -f 2 | cut -d] -f 1)
    fi

    echo " ($branch, $upstream)"
}

# change color of prompt based on last command exit status
show_exit_status()
{
    [[ $1 == "0" ]] && printf -- "$fgreen \u2714" || printf -- "$fred \u2718";
}


# mc related
if [ -f /usr/lib/mc/mc.sh ]; then
    . /usr/lib/mc/mc.sh
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
