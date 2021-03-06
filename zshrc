# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

setopt PROMPT_SUBST
PS1=$'%B%F{magenta}%n%F{red}@%m%F{yellow}:%1d%F{cyan}$(git_repo)$(git_info)\n%b%F{white}$ '

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
	eval "`gdircolors -b`"
	alias ls='_ls'
fi

# some more ls aliases
export CLICOLOR=1

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [ -f ~/.django_bash_completion ]; then
	. ~/.django_bash_completion
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# Globals

export EDITOR=vim
export GDFONTPATH="$HOME/share/fonts"
export LANG=ja_JP.UTF-8
export PATH="$PATH:$HOME/bin:$HOME/.aspera/connect/bin:/Applications/Postgres.app/Contents/Versions/9.6/bin/:/usr/local/sbin"
export WORKON_HOME="$HOME/.virtualenvs/"

# Standard Aliases

alias ls='pwd; ls'
alias grep='grep --color=auto'
alias cls='clear'
alias cp='cp -i'
alias du='du -h --max-depth=1'
alias h='history | grep'
alias mv='mv -i'
alias vi='vim'
alias v='vim'
alias va="vim -R +AnsiEsc ~/ac-checker-log"
alias svi='sudo vi'

# Personal Aliases
alias python='python3'
alias tl='tmux ls'
alias ts='tmux new -A -s'
alias tx='tmux new -A -D -s'
alias cd="venv_cd"
alias cr='cd $(git root)'
alias cf='cd $(git root)/frontend'
alias cb='cd $(git root)/backend'
alias cs='cd ~/git/space/'
alias cw='cd ~/git/website/'
alias ca='cd ~/git/accel-shooter/'
alias cm='cd ~/git/aether-mono/'
alias ports='netstat -tulanp'
alias top='atop'
alias df='df -H'
alias g='git'
alias y="yarn"
alias ys="yarn start"
alias yt="cf; yarn jest --watch --coverage=false"
alias yta="cf; yarn jest --watchAll --coverage=false"
alias yl="cf; yarn lint"
alias yp="cf; yarn prod"
alias ydt="dcc frontend yarn jest --coverage=false"
alias ydp="dcc frontend yarn prod"
function yc() {
	tmux send-keys 'yl' C-m
	tmux split-window
	tmux send-keys 'ydt' C-m
	tmux split-window -v
	tmux send-keys 'ydp' C-m
	tmux select-layout even-vertical
}
alias c="code-insiders --disable-gpu --ignore-gpu-blacklist --disable-gpu-blacklist --high-dpi-support=1 ."
alias cof='code-insiders --disable-gpu --ignore-gpu-blacklist --disable-gpu-blacklist --high-dpi-support=1 $(git root)/frontend'
alias dc="docker-compose"
alias dcbu="cr; docker-compose build"
alias dcd="cr; docker-compose down -v"
alias dcl="cr; docker-compose logs --tail 30 -f -t"
alias dcr="cr; docker-compose restart"
alias dcu="cr; docker-compose up -d"
alias dclf="cr; dcl frontend"
alias dclb="cr; dcl backend"
alias dcbf="cr; dcb frontend"
alias dcbb="cr; dcb backend"
function dcc() { cr; docker-compose exec $@; }
function dcb() { cr; docker-compose exec $@ /bin/bash; }
function dcs() { cr; docker-compose exec $@ /bin/sh; }
alias drm='docker rm $(docker ps -q -f 'status=exited'); docker rmi $(docker images -q -f "dangling=true")'
function copy() { cat $@ | pbcopy; }
alias mr="cr; make stop-dev-main; make start-dev-main"
alias msa="cr; make start-dev-main"
alias mso="cr; make stop-dev-main"
alias mrf="cr; docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml restart frontend; dclf"
alias mrb="cr; docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml restart backend; dclb"
alias grp="grep -nR --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=.git"
alias dp="vi ~/ResilioSync/Daily\ Progress.md"
alias tk="vi ~/ResilioSync/Track.csv"
alias isw="innocent_starter ~/git/website w"
alias iss="innocent_starter ~/git/space s"
alias ism="innocent_starter ~/git/aether-mono m"
alias ac="accel-shooter check"
alias as="accel-shooter"

# Home Aliases
if [ -e $HOME/.alias ]; then
	. $HOME/.alias
fi

# Local Functions and Commands
#
function zipr {
	zip -r $@.zip $@ -x "*node_modules*"
}

function start_rns {
	msoa
	tmux new -A -d -s r -c ~/git/research-note-system
	tmux send-keys 'cd backend; ./manage.py runserver' C-m
	tmux split-window -v -c ~/git/research-note-system
	tmux send-keys 'cd frontend; ys' C-m
	tx r
}

function innocent_starter {
	cd $1
	tmux new -A -d -s $2 -c $1
	tmux rename-window 'acst'
	tmux send-keys 'as sync' C-m
	tmux split-window
	tmux send-keys 'as track' C-m
	tmux new-window -c $1
	tmux send-keys 'cd ~/git/aether-mono; yarn build:iconfont; yarn serve pheno' C-m
	tmux new-window -c $1
	tmux select-window -t 0
	tx $2
}

function setup_python {
	cd $1
	git init
	python3 -m venv ~/.virtualenvs/$1
	source ~/.virtualenvs/$1/bin/activate
}

function msoa {
	pwd=`pwd`
	cw
	make stop-dev-main
	cs
	make stop-dev-main
	cd $pwd
}

function git_repo {
    GIT_DIR=`git rev-parse --git-dir 2> /dev/null` || return;
    GIT_DIR=`\cd $GIT_DIR; pwd`
    PROJECT_ROOT=`dirname "$GIT_DIR"`
	REPO_NAME=`basename "$PROJECT_ROOT"`
	echo "[$REPO_NAME]"
}

function git_info {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
	last_commit=$(git log --pretty=format:%at -1 2> /dev/null) || return;

	now=`date +%s`;
	sec=$((now-last_commit));
	min=$((sec/60)); hr=$((min/60)); day=$((hr/24)); yr=$((day/365));
	if [ $min -lt 60 ]; then
		info="${min}m"
	elif [ $hr -lt 24 ]; then
		info="${hr}h$((min%60))m"
	elif [ $day -lt 365 ]; then
		info="${day}d$((hr%24))h"
	else
		info="${yr}y$((day%365))d"
	fi

	echo "(${ref#refs/heads/} $info)";
	#	echo "(${ref#refs/heads/})";
}

function _ls() {
	LANG=zh_TW.BIG5
	# /bin/gls -C --color=always $@ | /usr/bin/iconv -f big5 -t utf8
	/bin/gls -C --color=always $@
	LANG=zh_TW.UTF-8
}

# Automatically activate Git projects' virtual environments based on the
# directory name of the project. Virtual environment name can be overridden
# by placing a .venv file in the project root with a virtualenv name in it
function workon_cwd {
    # Check that this is a Git repo
    GIT_DIR=`git rev-parse --git-dir 2> /dev/null`
    if [ $? '==' 0 ]; then
        # Find the repo root and check for virtualenv name override
        GIT_DIR=`\cd $GIT_DIR; pwd`
        PROJECT_ROOT=`dirname "$GIT_DIR"`
        ENV_NAME=`basename "$PROJECT_ROOT"`
        if [ -f "$PROJECT_ROOT/.venv" ]; then
            ENV_NAME=`cat "$PROJECT_ROOT/.venv"`
        fi
        # Activate the environment only if it is not already active
        if [ "$VIRTUAL_ENV" != "$WORKON_HOME/$ENV_NAME" ]; then
            if [ -e "$WORKON_HOME/$ENV_NAME/bin/activate" ]; then
                source "$WORKON_HOME/$ENV_NAME/bin/activate" && export CD_VIRTUAL_ENV="$ENV_NAME"
            fi
        fi
    elif [ $CD_VIRTUAL_ENV ]; then
        # We've just left the repo, deactivate the environment
        # Note: this only happens if the virtualenv was activated automatically
        deactivate && unset CD_VIRTUAL_ENV
    fi
}

# New cd function that does the virtualenv magic
function venv_cd {
    \cd "$@" && workon_cwd
}

# Initinalize
workon_cwd

DIR=Ex
SYM_LINK=Gx
SOCKET=Fx
PIPE=dx
EXE=Cx
BLOCK_SP=Dx
CHAR_SP=Dx
EXE_SUID=hb
EXE_GUID=ad
DIR_STICKY=Ex
DIR_WO_STICKY=Ex
export LSCOLORS="$DIR$SYM_LINK$SOCKET$PIPE$EXE$BLOCK_SP$CHAR_SP$EXE_SUID$EXE_GUID$DIR_STICKY$DIR_WO_STICKY"

# tabtab source for yarn package
# uninstall by removing these lines or running `tabtab uninstall yarn`
[ -f /Users/nanoha/.config/yarn/global/node_modules/tabtab/.completions/yarn.bash ] && . /Users/nanoha/.config/yarn/global/node_modules/tabtab/.completions/yarn.bash

[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
export PATH="/usr/local/opt/ruby/bin:$PATH"
export EDITOR=vim
export VISUAL="$EDITOR"

zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fpath=(~/.zsh $fpath)

autoload -Uz compinit && compinit
export ACCEL_SHOOTER_CONFIG_FILE=~/ResilioSync/.config.json
