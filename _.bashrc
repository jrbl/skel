# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Is inputting fucked up?  Check ~/.inputrc and see 'man 3 readline'.

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Local host pre-execution hook
[ -f ~/.bash_local_pre ] && . ~/.bash_local_pre

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# For git completion and git prompt (provided by bash_completion package)
GIT_PS1_SHOWDIRTYSTATE=true

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    screen) color_prompt=yes;;
    *) color_prompt= ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --group-directories-first'
    alias ll='ls -l'
    alias psa="ps -A -o pid,user,nice,%cpu,%mem,args --forest"
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
    #alias termsize="stty -a | head -1 | cut -d';' -f2,3 | sed -e 's/\(.*\) \([0-9]*\);\(.*\) \([0-9]*\)/\1=\2;\3=\4;/'"
    alias termsize="stty -a | head -1 | cut -d';' -f2,3 | sed -e 's/\(.*\) \([0-9]*\);\(.*\) \([0-9]*\)/\4x\2/'"

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# save termsize (above) into variable for more efficient PROMPT_COMMAND building
TERMSIZE=`termsize`

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
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    #PS1='\[\033[01;32m\]$(__git_ps1 "(%s)")\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    #PS1='\[\033[0;32m\] $(__git_ps1 "%s") \$\[\033[00m\] '
    #####PS1='$(__git_ps1 "%s") \w \$ '
    PS1='\$ '
else
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
    #PS1="\[\033[0;35m\]\h\[\033[0m\] \`pathfrob\` \$ " # Cf. .bash_aliases file
    #PS1='$(__git_ps1 "(%s")):\w\$ '
    #####PS1='$(__git_ps1 "%s") \w \$ '
    PS1='\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*|screen)
    #PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
    #PROMPT_COMMAND='echo -ne "\033]0; $?    `date +%H:%M`     ${USER}@${HOSTNAME}:${PWD}\007"'
    #PROMPT_COMMAND='echo -ne "\033]0; $?    `date +%H:%M`     ${USER}@${HOSTNAME}:${PWD}     ${TERMSIZE}\007"'
    PROMPT_COMMAND='echo -ne "\033]0;$?:${USER}@${HOSTNAME}:${PWD}\007"'
    #PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    #PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features 
# (requires bash_completion package)
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# enable moving to a directory just by naming it
shopt -s autocd

# Random other variables I want set for different programs
export EDITOR="vim"
export EMAIL="Joe Blaylock <jrbl@jrbl.org>"
export PATH=$HOME/bin:$PATH:$HOME/.rvm/bin
# make sure UTF-8 is set up correctly in most linuxes
LANG=en_US.UTF-8
LC_ALL=en_US.UTF-8
export LANG LC_ALL
#NETHACKOPTIONS='color,DECgraphics,lit_corridor,mail,news,number_pad,rest_on_space,safe_pet,sortpack,!autopickup'

#export VIRTUALENV_DISTRIBUTE=true # XXX - commented out 20140129, what did this do?
# virtualenvwrapper setup
export WORKON_HOME=~/Hacking/EnvsVirtualEnv
export PROJECT_HOME=~/Hacking/ProjectsVirtualEnv
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
export VIRTUALENVWRAPPER_VIRTUALENV_ARGS='--no-site-packages'
export VIRTUALENVWRAPPER_VIRTUALENV=/usr/local/bin/virtualenv
source /usr/local/bin/virtualenvwrapper.sh
