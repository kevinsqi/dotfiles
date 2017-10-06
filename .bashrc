# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000

# History: add commands to history immediately instead of after each session (makes ctrl + r more useful)
# https://www.digitalocean.com/community/tutorials/how-to-use-bash-history-commands-and-expansions-on-a-linux-vps
#
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

####################
#  CUSTOMIZATIONS  #
####################

MASTER_BRANCH="master"

# open files that match git grep, AND SET THE SEARCH QUERY
function gitgrepvim {
  # this works but effs up the terminal after quitting:
  # git grep -lz "${@}" | xargs -0 vim -p +/"${@}" 

  # sed command is to handle spaces in filenames
  vim -p $(git grep -I -l "${@}" | sed -e 's/ /\ /') +/"${@}"
}

# open git modified files in vim
function gitmod {
  vim -p $(git status -s | grep "^ \?M\|^ \?A\|^??" | sed 's/^...//')
}

# always pipe output to less
function gitdiff {
  git diff --color "${@}" | less -RS
}

# push current branch
function gitpush {
  echo "Pushing to $(git rev-parse --abbrev-ref HEAD)..."
  git push origin $(git rev-parse --abbrev-ref HEAD)
}

# pull current branch
function gitpull {
  echo "Pulling from $(git rev-parse --abbrev-ref HEAD)..."
  git pull origin $(git rev-parse --abbrev-ref HEAD)
}

# checkout remote branch
function gitbranch {
  echo "Executing: git checkout -b ${@} origin/${@}..."
  git checkout -b ${@} origin/${@}
}

# search git history
function gitsearch {
  git rev-list --all | xargs git grep ${@}
}
function gitsearchlog {
  # http://stackoverflow.com/questions/4468361/search-all-of-git-history-for-string
  git log --all -S${@}
}

# set branch to track its remote
function gitsetupstream {
  git branch --set-upstream-to=origin/$(git rev-parse --abbrev-ref HEAD)
}

function gitbranchmodifiedfiles {
  if [ $# -ge 1 ]
  then
    git diff --name-status origin/${@}...HEAD
  else
    git diff --name-status origin/$MASTER_BRANCH...HEAD
  fi
}
function vimbranchmodifiedfiles {
  vim -p $(gitbranchmodifiedfiles | sed 's/^.//')
}

# Copy file to clipboard
# Usage: clip <filename>
function clip {
  cat ${@} | xclip -selection c
}

# Run one test file
function raketestone {
  ruby -I"lib:test" ${@}
}

# Run one method from one test file
function raketestonemethod {
  ruby -I"lib:test" $1 -n /.*$2.*/
}

# Find substring in file
function findfilesubstr {
  find . -iname "*${@}*"
}

# Add "&& notifywhendone" after a long running script to send OSX notification when complete, e.g.:
#
#     somelongrunningscript && notifywhendone
#
function notifywhendone {
  osascript -e 'display notification "have a good one" with title "the thing is done"'
}

# Get password for a given SSID
function wifipassword {
  security find-generic-password -D "AirPort network password" -a ${@} -g
}

# batch rename files - TODO
function batchrename {
  # https://stackoverflow.com/questions/602706/batch-renaming-files-with-bash
  # for i in *.pkg ; do mv "$i" "${i/-[0-9.]*.pkg/.pkg}" ; done
}

################
#   Docker
################

# TODO: split into separate file?

function docker-container-image() {
    docker inspect $1 | jq -r '.[0].Image' | cut -d: -f2
}

function docker-nuke-container-image() {
    for container in $(docker ps -a | grep $1 | awk 'NF>1{print $NF}'); do
        docker-container-image ${container}
    done | sort | uniq | xargs docker rmi -f
}

function docker-killall() {
    docker kill $(docker ps -q)
}

function docker-rm-all() {
    docker rm -f $(docker ps -a -q)
}

function docker-rmi-all() {
    docker rmi -f $(docker images -q)
}

function docker-cleanup-space() {
    docker system prune -a
}

################
#   Exports
################

export EDITOR='vim'
export PAGER='less -S -R'
export PATH=${PATH}:~/android-sdks/platform-tools:~/android-sdks/tools  # android development
export PYTHONDONTWRITEBYTECODE=1  # disable creation of .pyc files (http://docs.python-guide.org/en/latest/writing/gotchas/)

################
#   Aliases
################

# general unix
alias vim='vim -p'
alias less='less -S'
alias Less='less'
alias diff='git diff --color --no-index'
alias lessf='less --follow-name -f'
alias op='xdg-open'
alias xclip='xclip -selection c'  # Usage: `cat <filename> | xclip`
alias fd='find . -iname'
alias fds='findfilesubstr'

# git
alias sg='git grep -I'  # TODO: make this also match on filenames?
alias vg='gitgrepvim'
alias sd='gitdiff'
alias sdc="gitdiff --cached"
alias sdw="gitdiff --color-words"
alias sts='git status'
alias gcf='git clean -f'                  # remove unversioned files
alias gd='git diff origin/$MASTER_BRANCH...HEAD'  # show diff of branch against master
alias gdw='gd -w'
alias gf='gitbranchmodifiedfiles'         # list files changed against master
alias vf='vimbranchmodifiedfiles'         # open files changed against master in vim
alias gl="git log --no-merges --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"  # morganatic git log
alias glf="git log --no-merges --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --name-status --"  # show files changed
alias bl='git log origin/$MASTER_BRANCH..HEAD'    # show commits that aren't in master
alias gp='git push'
alias gss='git stash show -p'             # show stash diff
alias gundo='git revert --no-commit'
alias gundolocal='git reset --soft HEAD^'

# misc
alias jk='jekyll serve --watch'
alias nmr='sudo service network-manager restart'  # ugh
alias listfilesbylines='find . | xargs wc -l | gsort | less'
alias listfilesbysize='du -sh * | gsort -h | less'

# rails
alias rspub='rails server -b 0.0.0.0'
alias rt='raketestone'
alias rtm='raketestonemethod'
alias rdb='rails dbconsole'
alias rake='bundle exec rake'


########################
# Sourcing other files #
########################

# Mac OSX git completion
if [ -f ~/.bashrc_osx ]; then
  source ~/.bashrc_osx
fi

# .bashrc.local
if [ -f ~/.bashrc.local ]; then
  source ~/.bashrc.local
fi

# nvm (nodejs version manager)
if [ -d ~/.nvm ]; then
  export NVM_DIR=~/.nvm
  source ~/.nvm/nvm.sh
fi

# rbenv
if [ -d ~/.rbenv ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# rvm (keep at bottom)
if [ -d ~/.rvm ]; then
  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell sessio
  export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
fi
