# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Gridmatic

alias g='gsutil'
alias kp='kubectl -n production'
alias k='kubectl'
alias kcontext='kubectl config current-context'
alias kgetcontexts='kubectl config get-contexts'

alias kgrep='k get all | grep ${@}'
alias kpgrep='kp get all | grep ${@}'

alias restartretailbackend='kp rollout restart deployment.apps/retail-backend'

function kpods {
  kubectl get pods -n production | grep ${@}
}

function klogs {
  kubectl logs ${@} -n production -f
}

function klogs_less {
  kubectl logs ${@} -n production | less
}


function kssh {
  kubectl exec -it ${@} /bin/bash
}

function kpssh {
  kubectl exec -it ${@} -n production /bin/bash
}

alias kwest="kubectl config use-context gke_tlal-1210_us-west1-b_tlaloc"
alias kcent="kubectl config use-context gke_tlal-1210_us-central1-c_tlaloc"
alias keast="kubectl config use-context gke_tlal-1210_us-east1-b_tlaloc-us-east1"
alias kgputest="kubectl config use-context gke_tlal-1210_us-central1-c_tlaloc-gpu-test"

alias sshstatic1433="gcloud compute ssh static --project tlal-1210 --zone us-central1-b -- -L 1433:localhost:1433"

alias retailall="kp get all | grep retail"

cd ~/tlaloc # Default dir

export PATH="/home/kevinqi/.local/bin:$PATH"

# Install to /bin instead of /local/bin to fix pre-commit virtualenvs
# https://github.com/pypa/virtualenv/issues/2350
export DEB_PYTHON_INSTALL_LAYOUT='deb'


# Personal

export EDITOR='vim'

alias vim='vim -p'

alias cd1='cd ..'
alias cd2='cd ../..'
alias cd3='cd ../../../'
alias cd4='cd ../../../..'
alias cd5='cd ../../../../..'
alias cd6='cd ../../../../../..'

alias gg='git grep -I'  # TODO: make this also match on filenames?
alias gdc="git diff --cached"

alias fdh='fd -H'  # Include hidden files

function ggi {
  git grep -I ${@} -- ':!*.ipynb' ':!*.min.css' ':!*.min.js' ':!*.xml' ':!*.json'
}

# alias gdm='git diff origin/master...HEAD'  # show diff of branch against master
function gdm {
  git diff origin/$(git branch --list master main | sed 's/^*//' | xargs)...HEAD
}

# show commits from master and files changed in each
function gl {
  git log origin/$(git branch --list master main | sed 's/^*//' | xargs)..HEAD --no-merges --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --name-status --
}

function gitmod {
  vim -p $(git status -s | grep "^ \?M\|^ \?A\|^??" | sed 's/^...//')
}

# open files that match git grep in vim, AND SET THE SEARCH QUERY
function vgg {
  # this works but effs up the terminal after quitting:
  # git grep -lz "${@}" | xargs -0 vim -p +/"${@}" 

  # sed command is to handle spaces in filenames
  vim -p $(git grep -I -l "${@}" | sed -e 's/ /\ /') +/"${@}"
}
function gf {
  if [ $# -ge 1 ]
  then
    git diff --name-status origin/${@}...HEAD
  else
    git diff --name-status origin/$(git branch --list master main | sed 's/^*//' | xargs)...HEAD
  fi
}
function vgf {
  vim -p $(gf | sed 's/^.//')
}


#
# Other scripts
#

# Run ssh-agent to keep ssh key pw
eval $(keychain --agents ssh --eval id_rsa --noask)

# z.sh
if [ -f ~/z.sh ]; then
  . ~/z.sh
fi
eval "$(direnv hook bash)"
export PATH="$HOME/.tfenv/bin:$PATH"
