PS1='\[\033[0m\]Container: \[\033[0;32m\]${debian_chroot:+($debian_chroot)}\u@\h \[\033[0;36m\]\w \[\033[0m\]\$ '
umask 022

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

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# directory changing
alias cd="cd -P"
alias cd..='cd ..'
alias ..='cd ..'
