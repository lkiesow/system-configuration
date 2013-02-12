if [[ $TERM == 'xterm' ]]
then
	setxkbmap de nodeadkeys -model pc105 \
		-option "terminate:ctrl_alt_bksp," \
		-option "compose:lwin"
fi

# extending path variables
PATH=$PATH:`realpath /usr/local/texlive/20*/bin/x86_64-linux`:/sbin:/usr/sbin:/usr/local/sbin:/usr/X11R6/bin:/usr/local/bin:~/.bin
export PATH
MANPATH=`realpath /usr/local/texlive/20*/texmf/doc/man`:/usr/local/share/man:/usr/share/man
export MANPATH
INFOPATH=`realpath /usr/local/texlive/20*/texmf/doc/info`:$INFOPATH
export INFOPATH

alias :q='exit'
alias ls='ls --color=auto'
alias ll='ls -h -l --color=auto'
alias la='ls -h -l -a --color=auto'
alias cls='clear'
alias cd..='cd ..'
alias vi='vimx'
alias vim='vimx'
alias excuse='telnet bofh.jeffballard.us 666 2&> /dev/null | grep "^Your excuse is:"'

# colored grep by default
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'
