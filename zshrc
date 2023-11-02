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
export LANG=en_US.UTF-8
export PATH="$PATH:$HOME/bin:$HOME/.aspera/connect/bin:/Applications/Postgres.app/Contents/Versions/9.6/bin/:/usr/local/sbin:$HOME/.local/bin"
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
function l() {
  cd "$(llama "$@")"
}
alias cr='cd $(git root)'
alias cf='cd $(git root)/frontend'
alias cb='cd $(git root)/backend'
alias cs='cd ~/git/space/'
alias cw='cd ~/git/website/'
alias ca='cd ~/git/accel-shooter/'
alias cm='cd ~/git/aether-mono/'
alias ci='cd ~/git/ihis/'
alias cdc='cd ~/git/dicom-ct/'
alias cv='cd ~/git/vfss/'
alias ports='netstat -tulanp'
alias top='atop'
alias df='df -H'
alias g='git'
alias gs='git s'
alias gd='git d'
alias gdc='git dc'
alias gp='git push'
alias ga='git add -A'
alias gci='git ci'
alias r='radian'
alias y="yarn"
alias ys="yarn start"
alias yt="cf; yarn jest --watch --coverage=false"
alias yta="cf; yarn jest --watchAll --coverage=false"
alias yl="cf; yarn lint"
alias yp="cf; yarn prod"
alias ydt="dcc frontend yarn jest --coverage=false"
alias ydp="dcc frontend yarn prod"
alias ip="ifconfig | grep 'inet' | grep '192.168.1'"
function yc() {
	tmux send-keys 'yl' C-m
	tmux split-window
	tmux send-keys 'ydt' C-m
	tmux split-window -v
	tmux send-keys 'ydp' C-m
	tmux select-layout even-vertical
}
alias c="code-insiders --disable-gpu ."
function cof() {
	DIR=$(git root)/frontend
	if [ -d "$DIR" ]; then
		code-insiders --disable-gpu $DIR
	else
		code-insiders --disable-gpu $(git root)
	fi
}
function cob() {
	DIR=$(git root)/backend
	if [ -d "$DIR" ]; then
		code-insiders --disable-gpu $DIR
	else
		code-insiders --disable-gpu $(git root)
	fi
}
function coi() {
	DIR=$(git root)/image-server
	if [ -d "$DIR" ]; then
		code-insiders --disable-gpu $DIR
	else
		code-insiders --disable-gpu $(git root)
	fi
}
function dc() {
	if [[ "$(git_repo)" == "[website]" ]]; then
		./bin/dc2 -f docker-compose.yaml -f docker-compose.dev.yaml $@
	elif [ -e "dev.yaml" ]; then
		docker-compose -f docker-compose.yaml -f dev.yaml $@
	else
		docker-compose $@
	fi
}
alias dcbu="cr; dc build"
alias dcd="cr; dc down -v"
alias dcl="cr; dc logs --tail 30 -f -t"
alias dcfl="cr; dc logs 30 -f -t"
alias dcr="cr; dc restart"
alias dcu="cr; dc up -d"
alias dclf="cr; dcl frontend"
alias dclb="cr; dcl backend"
alias dcld="cr; dcl database"
alias dcbf="cr; dcb frontend"
alias dcbb="cr; dcb backend"
function dcc() { cr; dc exec $@; }
function dcb() { cr; dc exec $@ /bin/bash; }
function dcs() { cr; dc exec $@ /bin/sh; }
alias drm='docker rm $(docker ps -q -f 'status=exited'); docker rmi $(docker images -q -f "dangling=true")'
function copy() { cat $@ | pbcopy; }
alias mr="cr; make stop-dev-main; make start-dev-main"
alias msa="cr; make start-dev-main"
alias mso="cr; make stop-dev-main"
alias mrf="cr; dc restart frontend; dclf"
alias mrb="cr; dc restart backend; dclb"
alias grp="grep -nR --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=.git --exclude=poetry.lock"
function search() {
	rm -f ~/search-$1
	grp -i $1 > ~/search-$1
	vi ~/search-$1
}
function searchc() {
	rm -f ~/search-$1
	grp $1 > ~/search-$1
	vi ~/search-$1
}
alias dp="vi ~/ResilioSync/accel-shooter/Daily\ Progress.md"
alias tk="vi ~/ResilioSync/accel-shooter/Track.csv"
alias isa="accel_shooter_starter"
alias isw="innocent_starter ~/git/website w"
alias iss="innocent_starter ~/git/space s"
alias isi="innocent_starter ~/git/ihis i"
alias isd="innocent_starter ~/git/dicom-ct d"
alias ism="innocent_starter ~/git/aether-mono m"
alias isv="innocent_starter ~/git/vfss v"
alias ac="accel-shooter check"
alias aci="accel-shooter commit"
alias as="accel-shooter"
alias ao="accel-shooter open"
alias dpcp="accel-shooter dailyProgress"
alias op="open ~/git/aether-mono/libs/pheno/documentation/compodoc/index.html"
alias sp="cd ~/git/aether-mono;NODE_OPTIONS=--openssl-legacy-provider  yarn build:iconfont;NODE_OPTIONS=--openssl-legacy-provider yarn serve pheno"

function gas {
	Commands=(
		"git status -s"
		"git add -A"
		"git diff --cached"
		"c"
		"accel-shooter commit"
	)

	for c in ${Commands[*]}; do
		if [[ "$c" == "c" ]]; then
			echo "continue?"
			read x
			[[ ! $x =~ ^[Yy]$ ]] && break
		else
			eval $c
		fi
	done
}

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

function accel_shooter_starter {
	cd ~/git/accel-shooter
	tmux new -A -d -s a -c ~/git/accel-shooter
	tmux rename-window 'acst'
	tmux send-keys 'as track' C-m
	tmux split-window
	tmux send-keys 'acst-server' C-m
	tmux split-window
	tmux send-keys 'as meetingTrack && exit' C-m
	tmux split-window
	tmux send-keys 'colima start && exit' C-m
	tx a
}

function innocent_starter {
	cd $1
	tmux new -A -d -s $2 -c $1
	tx $2
}

function setup_python {
	mkdir $1
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
export ACCEL_SHOOTER_CONFIG_FILE=~/ResilioSync/accel-shooter/.config.yml

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_COMPLETION_TRIGGER='//'
export FZF_DEFAULT_COMMAND='fd'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# zsh hook
function precmd_function() {
    if [ "$TERM_PROGRAM" = tmux ]; then
        tmux set set-titles-string "$(git_repo)$(git_info)"
    fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_function

export PATH="$HOME/.poetry/bin:$PATH"

export GPG_TTY=$(tty)
export PUPPETEER_CACHE_DIR='/Users/nanoha/.cache/puppeteer'
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -s "/Users/nanoha/.scm_breeze/scm_breeze.sh" ] && source "/Users/nanoha/.scm_breeze/scm_breeze.sh"
