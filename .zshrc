PATH=/usr/local/texlive/2011/bin/x86_64-linux:$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/X11R6/bin:/usr/local/bin:~/.bin
#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib:/lib64:/usr/lib:/usr/lib64:/usr/local/lib:/usr/local/lib64
#export PATH
#export LD_LIBRARY_PATH

export SVN_EDITOR=vim
export EDITOR=vim
export BROWSER=/usr/bin/opera

MANPATH=/usr/local/share/man:/usr/share/man:/usr/local/texlive/2011/texmf/doc/man
export MANPATH
INFOPATH=/usr/local/texlive/2011/texmf/doc/info:$INFOPATH
export INFOPATH
# ignore mandriva system alias defined in /etc/profile.d/alias.sh
IGNORE_SYSTEM_ALIASES=true

# Get keys working
(( ${+terminfo[kich1]} )) && bindkey "${terminfo[kich1]}" yank
(( ${+terminfo[kdch1]} )) && bindkey "${terminfo[kdch1]}" delete-char
(( ${+terminfo[kpp]} ))   && bindkey "${terminfo[kpp]}"   up-line-or-history
(( ${+terminfo[knp]} ))   && bindkey "${terminfo[knp]}"   down-line-or-history
(( ${+terminfo[khome]} )) && bindkey "${terminfo[khome]}" beginning-of-line
(( ${+terminfo[kend]} ))  && bindkey "${terminfo[kend]}"  end-of-line

# [[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char

bindkey '^[[3~'   delete-char
bindkey "^[OH"    beginning-of-line   # Pos1
bindkey "^[OF"    end-of-line         # End
#bindkey '[1;5D' emacs-backward-word # ctrl-left
#bindkey '[1;5C' emacs-forward-word  # ctrl-right
#bindkey '[1;5D' vi-backward-word # ctrl-left
#bindkey '[1;5C' vi-forward-word  # ctrl-right
bindkey '[1;5D' backward-word # ctrl-left
bindkey '[1;5C' forward-word  # ctrl-right
# screen
# [1;5D -- ctrl-left, [1;5C -- ctrl-right
# [1;3D -- alt-left,  [1;3C -- alt-right

# Eingabe eines Kommandos und Drücken der Pfeil-nach-oben-Taste veranlasst
# die Zsh, eine hostory-Suche zu starten.
bindkey "^[[A"   up-line-or-search
bindkey "^[[B" down-line-or-search

bindkey '\e[1~' beginning-of-line
bindkey '\e[3~' delete-char
bindkey '\e[4~' end-of-line
bindkey '^[^H' backward-delete-word
bindkey '^[[3;5~' kill-whole-line

bindkey "\e[7~" beginning-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line

# some history related stuff
setopt HIST_IGNORE_DUPS
setopt APPEND_HISTORY
export HISTFILE=${HOME}/.zsh_history

# Some environment variables
path=($path $HOME/bin)
export HISTSIZE=10000
export SAVEHIST=10000
export USER=$USERNAME
export HOSTNAME=$HOST

alias :q='exit'
alias ls='ls --color=auto'
alias ll='ls -h -l --color=auto'
alias la='ls -h -l -a --color=auto'
alias cls='clear'
alias cd..='cd ..'
alias vi='vim'
alias excuse='telnet bofh.jeffballard.us 666 2&> /dev/null | grep "^Your excuse is:"'

# colored grep by default
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'

# remove all cr2 files for wich no jpg exists
cleancr2() {
	for i in *CR2
	do
		if [ -f "${i%CR2}JPG" ]
		then
		else
			echo "Removing $i…"
			rm "$i"
		fi
	done
}

# automatically pipe svn log into less
svn() {
	if [ $1 = 'log' ]; then
		/usr/bin/svn $@ | less
	else
		/usr/bin/svn $@
	fi
}
#
# set cpu frequency
alias cpufreq.show_freq='cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_cur_freq'
cpufreq() {
	if [ $# -ne 1 ]; then
		echo "Usage: $0 governor"
	else
		for i in /sys/devices/system/cpu/cpu[0-9]; do
			sudo sh -c "echo $1 > $i/cpufreq/scaling_governor"; 
			echo -n "Core $i is now set to "; 
			cat $i/cpufreq/scaling_governor;
		done
	fi
}
compctl -k "(`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors`)" cpufreq


print_html() {
	tmp=`mktemp` 
	w3m -dump -T text/html "$1" > $tmp
	leafpad $tmp
	rm $tmp     
}

mnt() {
	if [ -e "/dev/disk/by-label/$1" ]
	then
		sudo mkdir -p "/media/$1"
		# Check if we have a NFTS filesystem
		dv=`readlink -f "/dev/disk/by-label/$1"`
		fs=`sudo file -s $dv | sed -n 's/.*NTFS.*/NTFS/p'`
		if [[ $fs == 'NTFS' ]]
		then
			sudo mount "/dev/disk/by-label/$1" "/media/$1" \
				-o rw,uid=`id -u`,gid=`id -g`,nls=utf8,umask=007,fmask=117
		else
			sudo mount "/dev/disk/by-label/$1" "/media/$1"
		fi
	else
		echo "No device with label »$1«"
	fi
}
compctl -k "(`ls /dev/disk/by-label/`)" mnt

umnt() {
	if [ -e "/dev/disk/by-label/$1" ]
	then
		sudo umount "/media/$1"
		sudo rmdir  "/media/$1"
	else
		echo "No device with label »$1«"
	fi
}
compctl -k "(`ls /media/`)" umnt

# stream various radio stations
radio() {
	if [ $# -ne 1 ]; then
		echo "Usage: $0 radiostation"
	else
		stream=''
		if [ $1 = 'deutschlandfunk' ]; then
			mplayer -volume 30 'http://dradio.ic.llnwd.net/stream/dradio_dlf_m_a' \
				'http://dradio.ic.llnwd.net/stream/dradio_dlf_m_b'

		elif [ $1 = 'deutschlandradio_kultur' ]; then
			mplayer -playlist -volume 30 'http://dradio.ic.llnwd.net/stream/dradio_dkultur_m_a'

		elif [ $1 = 'dradio_wissen' ]; then
			mplayer -playlist -volume 30 'http://dradio.ic.llnwd.net/stream/dradio_dwissen_m_a'

		elif [ $1 = 'wdr5' ]; then
			mplayer -volume 30 -playlist 'http://www.wdr.de/wdrlive/media/wdr5.m3u'

		elif [ $1 = 'ffn' ]; then
			mplayer -playlist 'http://player.ffn.de/tunein_ffn.pls'

		# sky.fm stream (we can generate the url from the given name)
		elif [[ $1 == sky.fm.* ]]; then
			echo `expr substr $1 8 99`
			mplayer -volume 30 -playlist "http://www.sky.fm/mp3/`expr substr $1 8 99`.pls"
		fi
	fi
}
compctl -k '(
		deutschlandfunk          deutschlandradio_kultur dradio_wissen
		wdr5                     sky.fm.altrock          sky.fm.americansongbook
		sky.fm.beatles           sky.fm.bebop            sky.fm.bossanova
		sky.fm.christian         sky.fm.classical        sky.fm.classicalpianotrios
		sky.fm.classicrap        sky.fm.classicrock      sky.fm.country
		sky.fm.dancehits         sky.fm.datempolounge    sky.fm.dreamscapes
		sky.fm.guitar            sky.fm.hit70s           sky.fm.indierock
		sky.fm.jazzclassics      sky.fm.jpop             sky.fm.lovemusic
		sky.fm.newage            sky.fm.oldies           sky.fm.pianojazz
		sky.fm.poppunk           sky.fm.romantica        sky.fm.rootsreggae
		sky.fm.salsa             sky.fm.smoothjazz       sky.fm.solopiano
		sky.fm.soundtracks       sky.fm.the80s           sky.fm.tophits
		sky.fm.uptemposmoothjazz sky.fm.urbanjamz        sky.fm.vocalsmoothjazz
		sky.fm.world             ffn
	)' radio

# set advanced tab-completion
autoload -U compinit
compinit
zstyle ':completion:*' menu select

# completion for vim
zstyle ':completion:*:(gvim|vim):*' ignored-patterns '*.(pdf|jpg|png|bmp|ogg|mp3|avi|flv|mkv|rar|zip)'
zstyle ':completion:*:(gvim|vim):*' file-sort access

# completion for openbox
compctl -k "(--help --version --replace --reconfigure --restart --config-file
	--sm-disable --sync --debug --debug-focus --debug-xinerama --exit)" openbox

# evince completion
zstyle ':completion:*:evince:*' file-patterns '*(-/):directories *.(pdf|ps|dvi)'

rehash

eval `dircolors ~/.colors`

# Show git and svn branch in shell
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'


echo -e "Wilkommen \033[1mLars Kiesow\033[0m"
