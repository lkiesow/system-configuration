export SVN_EDITOR=vim
export EDITOR=vim
export BROWSER=surf

# Add /usr/local/texlive/2011/texmf/doc/man to MANPATH, if not dynamically determined.
# Add /usr/local/texlive/2011/texmf/doc/info to INFOPATH.
# Most importantly, add /usr/local/texlive/2011/bin/x86_64-linux to path

PATH=/usr/local/texlive/2012/bin/x86_64-linux:$PATH:/sbin:/usr/sbin:/usr/local/sbin:/usr/X11R6/bin:/usr/local/bin:~/.bin
export PATH
MANPATH=/usr/local/share/man:/usr/share/man:/usr/local/texlive/2012/texmf/doc/man
export MANPATH
INFOPATH=/usr/local/texlive/2012/texmf/doc/info:$INFOPATH
export INFOPATH

# Get keys working
(( ${+terminfo[kich1]} )) && bindkey "${terminfo[kich1]}" yank
(( ${+terminfo[kdch1]} )) && bindkey "${terminfo[kdch1]}" delete-char
(( ${+terminfo[kpp]} ))   && bindkey "${terminfo[kpp]}"   up-line-or-history
(( ${+terminfo[knp]} ))   && bindkey "${terminfo[knp]}"   down-line-or-history
(( ${+terminfo[khome]} )) && bindkey "${terminfo[khome]}" beginning-of-line
(( ${+terminfo[kend]} ))  && bindkey "${terminfo[kend]}"  end-of-line

bindkey '[1;5D' backward-word # ctrl-left
bindkey '[1;5C' forward-word  # ctrl-right
bindkey '\e^?'    backward-delete-word

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

# History search with up-/down-keys
bindkey "^[[A"   up-line-or-search
bindkey "^[[B" down-line-or-search

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
alias screencast1="ffmpeg -f alsa -ac 2 -i pulse -f x11grab -s 1600x900+0+0 -r 30 -i :0.0 -threads 1 "
alias beamer_config='xrandr --output LVDS1 --mode 1024x768 --output VGA1 --mode 1024x768'
alias beamer_config_2='xrandr --output LVDS1 --mode 1600x900 --output VGA1 --mode 1024x768 --right-of LVDS1'

# colored grep by default
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'

# Pulse audio sink names
PA_SINK_UA1G=:alsa_output.usb-Roland_UA-1G-00-UA1G.analog-stereo
PA_SINK_HDMI=:alsa_output.pci-0000_01_00.1.hdmi-stereo
PA_SINK_INTERNAL=:alsa_output.pci-0000_00_14.2.analog-stereo

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

function mnt() {
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
function devicelabel() {
	reply=(`ls /dev/disk/by-label/`)
}
compctl -K devicelabel mnt

function umnt() {
	if [ -e "/dev/disk/by-label/$1" ]
	then
		sudo umount "/media/$1"
		sudo rmdir  "/media/$1"
	else
		echo "No device with label »$1«"
	fi
}
function mountlabel() {
	reply=(`ls /media/`)
}
compctl -K mountlabel umnt

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
