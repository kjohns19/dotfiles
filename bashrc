# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreupds:erasedups

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s histverify

# large history
HISTSIZE=10000
HISTFILESIZE=10000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# 256 colors!
case $TERM in
xterm)  TERM=xterm-256color;;
screen) TERM=screen-256color;;
esac

# Funtions to time the last command
function __set_command_start() {
    [ -z "$_command_start" ] && _command_start=$(date +"%s %N")
}
function __format_time() {
    local h=$1; h=$((h/3600))
    local m=$1; m=$(((m/60)%60))
    local s=$1; s=$((s%60))
    local ms=$2;
    if   [ $h -gt 0 ]; then printf '%uh%02um%02u.%03us' $h $m $s $ms
    elif [ $m -gt 0 ]; then printf '%um%02u.%03us' $m $s $ms
    else                    printf '%u.%03us' $s $ms
    fi
}
function __calc_elapsed_time() {
    local begin_s
    local begin_ns
    local end_s
    local end_ns
    read begin_s begin_ns <<< "$_command_start"
    begin_ns=${begin_ns##+(0)}
    read end_s end_ns <<< $(date +"%s %N")
    end_ns=${end_ns##+(0)}
    local s=$((end_s - begin_s))
    local ms
    if [ $end_ns -ge $begin_ns ]; then
        ms=$(((end_ns - begin_ns) / 1000000))
    else
        s=$((s-1))
        ms=$(((1000000000 + end_ns - begin_ns) / 1000000))
    fi
    __format_time $s $ms
}

# PS1 setup
function __prompt_command() {
    local EXIT=$?
    local TIME=$(__calc_elapsed_time)
    local JOBS=$(jobs -rp | wc -l)

    local RED="\[\033[0;31m\]"
    local BLUE="\[\033[1;34m\]"
    local GREEN="\[\033[0;32m\]"
    local LIGHTRED="\[\033[1;31m\]"
    local BROWN="\[\033[0;33m\]"
    local YELLOW="\[\033[1;33m\]"
    local NONE="\[\033[0m\]"

    local ARROW="$(printf "\xe2\x87\x92") "
    local ARROW2="$(printf "\xe2\x86\xb3") "

    # Start on new line
    PS1="\n"

    # Time of last command
    PS1+="$LIGHTRED$TIME$NONE "

    # user@host workingdir
    PS1+="$BLUE\u@\h $GREEN\w$NONE"

    # Current git branch
    local branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    [ -n "$branch" ] && PS1+=" $LIGHTRED($branch)$NONE"

    # Show number of jobs if > 0
    [ $JOBS -gt 0 ] && PS1+=" $YELLOW$JOBS$NONE"

    # Show exit status of last command if != 0
    [ $EXIT != 0 ] && PS1+=" $RED$EXIT$NONE"

    PS1+="\n"

    # Prompt: a yellow arrow
    PS1+="$YELLOW$ARROW$NONE"
    PS2="$YELLOW$ARROW2$NONE"
    _command_start=
}
__set_command_start
trap __set_command_start DEBUG
export PROMPT_COMMAND=__prompt_command

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto -F'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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

export PATH=$PATH:~/programming/programs:~/pebble-dev/PebbleSDK-3.0-beta12/bin

set -o vi

alias ack="ack-grep"
alias mv='mv -i'
alias cp='cp -i'
alias screen='echo "You meant to run tmux"; sleep 1; tmux'
