export EDITOR=vim
type vimx &> /dev/null && export EDITOR=vimx
export BROWSER=surf

# We always have a visual terminal supporting colors
export TERM=screen-256color

# But still use emacs-style zsh bindings
bindkey -e

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
export HISTSIZE=100000
export SAVEHIST=100000
export USER=$USERNAME
export HOSTNAME=$HOST

alias :q='exit'
alias ls='ls --color=auto'
alias ll='ls -h -l --color=auto'
alias la='ls -h -l -a --color=auto'
alias cls='clear'
alias cd..='cd ..'
alias vi="TERM=xterm ${EDITOR}"
alias vim="TERM=xterm ${EDITOR}"
type vimx &> /dev/null && alias vimx="TERM=xterm vimx"
alias excuse='telnet bofh.jeffballard.us 666 2&> /dev/null | grep "^Your excuse is:"'
alias cal='cal -m'

audiobook() {
	ffmpeg -i $1 -map 0:a -c:a libmp3lame -ac 1 -b:a 96k $2;
}


# colored grep by default
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'

# set advanced tab-completion
autoload -U compinit
compinit
zstyle ':completion:*' menu select

# completion for vim
zstyle ':completion:*:(gvim|vim):*' ignored-patterns '*.(pdf|jpg|png|bmp|ogg|mp3|avi|flv|mkv|rar|zip)'
zstyle ':completion:*:(gvim|vim):*' file-sort access

# simple stupid completion for dnf
compctl -k "(check-update clean distro-sync downgrade erase group help history
	info install list makecache provides reinstall repolist repository-packages
	search updateinfo upgrade upgrade-to)" dnf
# and for mkdocs
compctl -k "(build gh-deploy json new serve)" mkdocs

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

PROMPT='[%F{green}%n@%m%f]%(5c,.../%1~,%~)%# '
RPROMPT=$'$(vcs_info_wrapper)'[%F{yellow}%?%f]


echo -e "Hi \033[1m${USER}\033[0m"
