PS1='\[\033[0m\]Container: \[\033[0;32m\]${debian_chroot:+($debian_chroot)}\u@\h \[\033[0;36m\]\w \[\033[0m\]\$ '
umask 022

# add WP cli auto completion
source /usr/local/bin/wp-completion.sh

# colorize ls output
if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    export LS_OPTIONS='--color=auto'

    alias ls='ls $LS_OPTIONS'
fi

# set vim as default
alias vi=vim
alias edit=vim

# update directory listings
alias ll='ls -al'
alias la='ls -AF'
alias l='ls -CF'
alias l.='ls -d .*'

# directory changing
alias cd="cd -P"
alias cd..='cd ..'
alias ..='cd ..'

# create parent directories on demand and verbose directory actions
alias mkdir='mkdir -pv'
alias rmdir='rmdir -v'

# add some safety to more often used commands
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# make an output use a random color per line
# use like so: $ tail -f file.log | colorize
alias colorize='while read -r line; do printf "\033[38;5;%dm%s\033[0m\n" $(($RANDOM%255)) "$line"; done'

# exec WP cli as www-data
alias wp='runuser -u www-data -g www-data -- wp'
