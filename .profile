if [[ $TERM == 'xterm' ]]
then
	setxkbmap de nodeadkeys -model pc105 \
		-option "terminate:ctrl_alt_bksp," \
		-option "compose:lwin"
fi

# extending path variables
PATH=`realpath /usr/local/texlive/20*/bin/x86_64-linux`:/sbin:/usr/sbin:~/.bin:$PATH
export PATH
MANPATH=`realpath /usr/local/texlive/20*/texmf/doc/man`:/usr/share/man
export MANPATH
INFOPATH=`realpath /usr/local/texlive/20*/texmf/doc/info`:$INFOPATH
export INFOPATH
