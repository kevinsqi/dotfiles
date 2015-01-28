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
HISTSIZE=1000
HISTFILESIZE=2000

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

# open files that match git grep, AND SET THE SEARCH QUERY
function gitgrepvim {
  vim -p $(git grep -l "${@}") +/"${@}"
}

# open git modified files
function gitmod {
  vim -p $(git status -s | grep "^ \?M\|^ \?A" | sed 's/^ \?. //')
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
  git grep ${@} $(git rev-list --all)
}
function gitsearchlog {
  # http://stackoverflow.com/questions/4468361/search-all-of-git-history-for-string
  git log --all -S${@}
}

__git_files () {
  _wanted files expl 'local files' _files
}

# Copy file to clipboard
# Usage: clip <filename>
function clip {
  cat ${@} | xclip -selection c
}

# Run one test file
function raketestone {
  rake test TEST=${@}
}

# Run one method from one test file
function raketestonemethod {
  ruby -I"lib:test" $1 -n $2
}

# exports
export EDITOR='vim'
export PAGER='less -S -R'
export PATH=${PATH}:~/android-sdks/platform-tools:~/android-sdks/tools  # android development

################
#   Aliases    #
################

# general unix
alias vim='vim -p'
alias less='less -S'
alias Less='less'
alias diff='git diff --color --no-index'
alias lessf='less --follow-name -f'
alias top='htop'
alias op='xdg-open'
alias xclip='xclip -selection c'  # Usage: `cat <filename> | xclip`
alias fd='find . -name'

# git
alias sg='git grep'  # TODO: make this also match on filenames?
alias vg='gitgrepvim'
alias sd='gitdiff'
alias sdc="gitdiff --cached"
alias sdw="gitdiff --color-words"
alias sts='git status'
alias gl='git log --name-status'          # git log with files changed
alias gf='git diff --name-status origin/master...HEAD'  # list files changed against master
alias bl='git log origin/master..HEAD'    # show commits that aren't in master
alias gp='gitpush'
alias gpuf='gitpull && git fetch'         # git pull and fetch
alias gss='git stash show -p'             # show stash diff

# misc
alias jk='jekyll serve --watch'

# rails
alias rt='raketestone'
alias rtm='raketestonemethod'


########################
# Sourcing other files #
########################

# .bashrc.local
if [ -f ~/.bashrc.local ]
then
  source ~/.bashrc.local
fi

# nvm (nodejs version manager)
if [ -d ~/.nvm ]; then
  export NVM_DIR=~/.nvm
  source ~/.nvm/nvm.sh
fi

# PatientsLikeMe
if [ -f ~/.bashrc_patientslikeme ]
then
  source ~/.bashrc_patientslikeme
fi

# RVM (keep at bottom)
if [ -f ~/.bashrc_rvm ]
then
  source ~/.bashrc_rvm
fi
