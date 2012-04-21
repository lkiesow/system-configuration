if [[ $TERM == 'xterm' ]]
then
	setxkbmap de nodeadkeys -model pc105 \
		-option "terminate:ctrl_alt_bksp," \
		-option "compose:rwin"
fi
