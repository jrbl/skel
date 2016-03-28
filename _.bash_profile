# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/login.defs
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi
if [ -d ~/.usr/bin ] ; then
    PATH=~/.usr/bin:"${PATH}"
fi

if [ -d ~/.usr/man ]; then
    if [ ! $MANPATH ]; then
      MANPATH=`manpath`
      MANPATH=~/.usr/man:"${MANPATH}"
    fi 
fi

PATH=${PATH}:/usr/local/bin
MANPATH=${MANPATH}:/usr/local/man

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi
