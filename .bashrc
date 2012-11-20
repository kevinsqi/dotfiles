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

# NOTE: add 'tools'? vendor/plugins?
RAILS_APP_SOURCE_DIRECTORIES='app config db lib public script spec'

# git-grep clone
function svngrep {
  grep -Irs --exclude-dir=\.svn --color=always "${@}" | less -RS
}

# open grepped files
function vimgrep {
  vim -p $(svngrep -l --color=never "${@}") +/"${@}"
}

# grep common rails directories from rails root
# NOTE: does not currently work with options e.g. -i
function svngreprails {
  if [ -z "$2" ]
  then
    svngrep --exclude-dir=public/images "${@}" $RAILS_APP_SOURCE_DIRECTORIES
  else
    svngrep "${@}"
  fi
}

# NOTE: bug where last argument is opened as a file even if it's a directory
# NOTE: does not currently work with options e.g. -i
function vimgreprails {
  if [ -z "$2" ]
  then
    vim -p $(svngrep -l --color=never --exclude-dir=public/images "${@}" $RAILS_APP_SOURCE_DIRECTORIES) +/"${@}"
  else
    vimgrep "${@}"
  fi
}

function gitgrepvim {
  vim -p $(git grep -l "${@}") +/"${@}"
}

# open svn modified files
function svnmod {
  vim -p $(svn status | grep "^M\|^A" | sed 's/^.      //')
}

# open svn unversioned files
function svnver {
  vim -p $(svn status | grep "^\?" | sed 's/^.      //')
}

# add unversioned files
function svnadd {
  svn status | grep '^\?' | awk '{print $2}' | xargs svn add
}

# open git modified files
function gitmod {
  vim -p $(git status -s | grep "^ M\|^ A" | sed 's/^ . //')
}

# make diff awesome
# sudo apt-get install colordiff
function svndiff {
  svn diff --diff-cmd colordiff "${@}" | less -RS
}

# always pipe output to less
function gitdiff {
  git diff --color "${@}" | less -RS
}

# remove unversioned svn files
function svncleancheck {
  svn status --no-ignore | grep '^\?' | sed 's/^\?       //'
}
function svnclean {
  svncleancheck | xargs -Ixx rm -rf xx
}

# exports
export EDITOR='vim'

# aliases
alias grep='grep --exclude-dir=\.svn --color=auto'
alias vim='vim -p'
alias less='less -S'
alias Less='less'
#alias sg='svngreprails'
#alias vg='vimgreprails'
#alias g='vimgreprails'
#alias sd='svndiff'
#alias sts='svn status'
alias sg='git grep'
alias vg='gitgrepvim'
alias g='gitgrepvim'
alias sd='gitdiff'
alias sdc="gitdiff --cached"
alias sts='git status'
alias gl='git log --name-status'
alias diff='git diff --color --no-index'

alias xorgswap='sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.laptop'
alias xorgreset='sudo cp /etc/X11/xorg.conf.laptop /etc/X11/xorg.conf'
alias lessf='less --follow-name -f'
alias top='htop'

# panjiva stuff
source ~/.bashrc_panjiva

# rvm (keep at bottom)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
