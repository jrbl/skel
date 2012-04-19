# Sourced by ~/.bashrc

###############################
## Handy shell functions
################################
function git_diff() {
    # a different way to git diff
    git diff --no-ext-diff -w "$@" | vim -R -
}

function gitr() {
    git for-each-ref --format="%(committerdate:short): %(refname)" --sort=committerdate refs/remotes/$1; # show remote refs by date, for remote $1
}

function print_dark() {
# print the arguments out, but print them dark :)
    echo -e "\033[1;30m$@\033[0m"
}

function cd() {
    # Print working directory after a cd. From http://www.node.mu/2010/11/24/is-your-bash-prompt-cramping-your-style/
    if [[ $@ == '-' ]]; then
        builtin cd "$@" > /dev/null  # We'll handle pwd.
    else
        builtin cd "$@"
    fi
    #echo -e "   \033[1;30m"`pwd`"\033[0m"
    print_dark "    `pwd`"
}

function H() {
# alias for "Where is 'here', exactly?"
    CWD=`pwd`
    QUOTA=`fs quota 2>/dev/null`
    GIT_BRANCH=`git status 2>/dev/null | head -1 | cut -d' ' -f4`
    #echo -e "    \033[1;30m$GIT_BRANCH    "`pwd`"\033[0m"
    print_dark "    $CWD    $GIT_BRANCH    $QUOTA"
}

function W() {
# alias for "Who am I, really?"
    LASTRETVAL=$?
    WHOIAM=`whoami`
    THISHOST=`hostname`
    KRB5PRINCIPAL=`klist 2>/dev/null | head -2 | tail -1 | cut -d' ' -f3`
    #echo -e "    \033[1;30m$WHOIAM    krb5:$KRB5PRINCIPAL\033[0m"
    print_dark "    $WHOIAM@$THISHOST    krb5:$KRB5PRINCIPAL    $LASTRETVAL"
}

function q() {
# alias for quick, useful information
    LASTRETVAL=$?
    TIME=`date +%H:%M`
    print_dark "    $LASTRETVAL      $TIME      ${USER}@${HOSTNAME}:${PWD}"
}

#function pathfrob {
#    # Elide our prompt. From Paul Visscher (Errors are my own)
#    # Expensive-but-useful way to have prompts that say, e.g., /usr/share/.../pngs
#    # These days I tend to only show CWD name and then use cd() and W() liberally
#    perl -e'$env=$ENV{HOME}; $pwd=$ENV{PWD}; chomp($pwd); $pwd =~ s/$env/~/; if(length($pwd) > 30) { @dirs = split(/\//, $pwd); print "$dirs[0]/$dirs[1]/.../$dirs[-2]/$dirs[-1]/"} else { print $pwd; }'
#}

# more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias lg="ls -F -h"
alias l='ls -CF'

# Useful for resetting AFS creds
alias slac="export KRB5CCNAME=/tmp/krb5_slac_jrbl; kinit jrbl@SLAC.STANFORD.EDU " #&& aklog -setpag -c SLAC.STANFORD.EDU"
alias cern="export KRB5CCNAME=/tmp/krb5_cern_jrbl; kinit jblayloc@CERN.CH " #&& aklog -setpag -c CERN.CH"
alias fnal="export KRB5CCNAME=/tmp/krb5_fnal_jrbl; kinit jrbl@FNAL.GOV " #&& aklog -setpag -c FNAL.GOV"

# random useful
alias '..'='cd ..'
alias '...'='cd ../..'
alias '....'='cd ../../..'
alias o='gnome-open'
alias rgrep='grep -r'
alias rscp='scp -r'
alias ll='ls -l'
alias o='gnome-open'
alias vi='vim'
alias view='vim -R'
alias WH="H; W"
alias HW="H; W"
alias pine="/usr/bin/mutt"
alias more="/usr/bin/less"

# Work related things for invenio
alias kwalitee='python ~/Hacking/invenio/modules/miscutil/lib/kwalitee.py --check-some'
alias gitd='git for-each-ref --format="%(committerdate:shortdate): %(refname)" --sort=committerdate refs/heads/'
#alias gitd='git for-each-ref --format="%(committerdate:short): %(refname)" --sort=committerdate refs/heads/' # old form
alias diffkwal='for file in `git diff --name-only HEAD~1 | grep .py$ `; do echo $file; echo; if [ -f $file ]; then kwalitee $file; else echo "$file not found.  Skipping kwalitee check."; fi; echo; done'
alias reload='make install && /opt/cds-invenio/bin/inveniocfg --update-all && sudo /etc/init.d/httpd restart'
# See also (defined above):
# gitr()
# git_diff()


###############################
## keystroke bindings, because they're sort of like aliases
################################
## history search with ? and /
#bind -m vi-command -r '\C-r'
#bind -m vi-command -r '\C-s'
#bind -m vi-command '?':reverse-search-history
#bind -m vi-command '/':forward-search-history 
#bind -m vi-insert '?':self-insert
#bind -m vi-insert '/':self-insert
## make C-r redo like in vim
#bind -m vi-insert '\C-r':vi-redo
#bind -m vi-command '\C-r':vi-redo
