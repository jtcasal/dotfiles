#!/bin/bash

# shellcheck source=/dev/null
if [ -e "$HOME/.profile" ]; then source "$HOME/.profile"; fi

ulimit -n 8192

#
# Git command completions
#
source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash


#
# Go shortcuts
#

if [ -e "$HOME/.dotfiles/go.sh" ]; then source "$HOME/.dotfiles/go.sh"; fi

#
# VSCode
#
if [ -e '/Applications/Visual Studio Code.app' ]
then
  alias code='open -a /Applications/Visual\ Studio\ Code.app '
fi

#
# Git
#
alias git=hub

#
# Rails
#
alias r='rails'
alias ri='ri -f ansi -T'

#
# Node
#
alias npm-exec='PATH=$(npm bin):$PATH'

#
# ls
#
alias ls='ls -Fc'
alias ll='ls -ltr'
alias la='ls -a'

#
# Services
#
alias postgres_start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias postgres_stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias redis_start='redis-server /usr/local/etc/redis.conf'
alias memcache_start='memcached -p 11211 &'
alias spec="bundle exec spec --color --format progress"

#
# Proxies
#
alias bundle_proxy="http_proxy=http://localhost:3132 bundle"

#
# Shell Defaults
#
export EDITOR=$(which vi)
export TERM=xterm-color
export CLICOLOR=1
export LSCOLORS=cxgxcxdxbxegedabagacad
export ARCHFLAGS='-arch x86_64'
export HISTFILESIZE=900
export HISTSIZE=900

#
# JDK defaults
#
export M2_HOME=/usr/local/Cellar/maven/3.3.9/libexec
export JAVA_HOME=/Library/Java/Home

#
# Scala / SBT
#
export SBT_OPTS=-XX:MaxPermSize=256M
export SCALA_HOME=/usr/local/Cellar/scala/2.9.1/libexec

#
# Python defaults
#
alias ipython='ipython --colors=Linux'

#
# Go
#
export GOPATH=$HOME/projects/go
export PATH=$PATH:$GOPATH/bin

#
# Open man page in Preview, or TextMate
#
pman () {
    man -t "${1}" | open -f -a /Applications/Preview.app
}

tman () {
  MANWIDTH=160 MANPAGER='col -bx' man "$@" | mate
}

#
# https://twitter.com/francesc/status/982025296898478080
#
whatport() {
  lsof -i ":$1" | grep LISTEN
}

##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################
bash_prompt_command() {
  # How many characters of the $PWD should be kept
  local pwdmaxlen=10
  # Indicate that there has been dir truncation
  local dir=${PWD##*/}
  pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
  NEW_PWD=${PWD/$HOME/~}
  local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
  if [ ${pwdoffset} -gt "0" ]
    then
    NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
    NEW_PWD=${NEW_PWD#*/}
  fi
}

parse_git_branch() {
  STATUS=$(git branch 2>/dev/null)
  [ $? -eq 128 -o $? -eq 127 ] && return
  # [[ "$STATUS" == *'working directory clean'* ]] || DIRTY=''
  echo " ($(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* //'))"         # Full path
}

bash_prompt() {
  local NONE='\[\033[0m\]'    # unsets color to term's fg color

  # regular colors
  local  K='\[\033[0;30m\]'   # black
  local  R='\[\033[0;31m\]'   # red
  local  G='\[\033[0;32m\]'   # green
  local BR='\[\033[0;33m\]'   # brown
  local  B='\[\033[0;34m\]'   # blue
  local  M='\[\033[0;35m\]'   # magenta
  local  C='\[\033[0;36m\]'   # cyan
  local LY='\[\033[0;37m\]'   # light gray

  local DG='\[\033[1;30m\]'   # dark gray
  local LR='\[\033[1;31m\]'   # light red
  local LG='\[\033[1;32m\]'   # light green
  local  Y='\[\033[1;33m\]'   # yellow
  local LB='\[\033[1;34m\]'   # light blue
  local LP='\[\033[1;35m\]'   # light purple
  local LC='\[\033[1;36m\]'   # light cyan
  local W='\[\033[1;37m\]'    # dark gray

  # background colors
  local BGK='\[\033[40m\]'  # black
  local BGR='\[\033[41m\]'  # red
  local BGR='\[\033[42m\]'  # green
  local BGBR='\[\033[43m\]' # brown
  local BGB='\[\033[44m\]'  # blue
  local BGM='\[\033[45m\]'  # purple
  local BGC='\[\033[46m\]'  # cyan
  local BGG='\[\033[47m\]'  # gray

  local UC=$C                 # user's color
  [ $UID -eq "0" ] && UC=$R   # root's color

  PS1="${NONE}${R}\u@\h${LY}:${BR}\${NEW_PWD}${LG}\$(parse_git_branch) ${LY}> ${NONE}"
}

PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

#
# na - https://github.com/ttscoff/na/
#
if [ -s "$HOME/.dotfiles/na.sh" ]; then
	export NA_MAX_DEPTH=2
	export NA_AUTO_LIST_FOR_DIR=1 # 0 to disable
	source "$HOME/.dotfiles/na.sh"
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
[[ -s "$HOME/.rbenv.sh" ]] && source "$HOME/.rbenv.sh"
