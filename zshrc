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
# export LANG=en_US.UTF-8
export LANG=zh_TW.UTF-8
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
alias svi='sudo vi'

# Personal Aliases
alias nanoha='vi ~/nanoha'
alias n='vi ~/nanoha'
alias e='exit'
alias q='exit'
alias topme='top -c -u $USER'
alias tl='tmux ls'
alias ts='tmux new -A -s'
alias tx='tmux new -A -D -s'
alias cd="venv_cd"
alias txa='tx a'
alias txs='cd ~/git/space/; tx s'
alias txw='cd ~/git/website/; tx w'
alias cr='cd $(git root)'
alias cf='cd $(git root)/frontend'
alias cb='cd $(git root)/backend'
alias cs='cd ~/git/space/'
alias cw='cd ~/git/website/'
alias c='clear'
alias ports='netstat -tulanp'
alias top='atop'
alias df='df -H'
alias g='git'
alias ga='git add'
alias gd='git diff --cached'
alias gph='git push'
alias gn='git n'
alias gc='git commit -m'
alias gco='git checkout'
alias gl='git l'
alias gs='git s'
alias gst='git st'
alias y="yarn"
alias ys="yarn start"
alias yt="yarn test --watch"
alias yl="yarn lint"
alias c="code ."
alias cof='code $(git root)/frontend'
alias cx="chmod +x"
alias dc="docker-compose"
alias dcbu="cr; docker-compose build"
alias dcd="cr; docker-compose down -v"
alias dcl="cr; docker-compose logs --tail 20 -f"
alias dcr="cr; docker-compose restart"
alias dcu="cr; docker-compose up -d"
alias dclf="cr; docker-compose logs --tail 20 -f frontend"
alias dclb="cr; docker-compose logs --tail 20 -f backend"
alias dcbf="cr; docker-compose exec frontend /bin/bash"
alias dcbb="cr; docker-compose exec backend /bin/bash"
function dcb() { cr; docker-compose exec $@ /bin/bash; }
function dcs() { cr; docker-compose exec $@ /bin/sh; }
function copy() { cat $@ | pbcopy; }
alias mr="cr; make stop-dev-main; make start-dev-main"
alias msa="cr; make start-dev-main"
alias mso="cr; make stop-dev-main"
alias mrf="cr; docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml restart frontend"
alias mrb="cr; docker-compose -f docker-compose.yaml -f docker-compose.dev.yaml restart backend"
alias grp="grep -nR --exclude-dir=node_modules --exclude-dir=dist"
alias dp="vi ~/Daily\ Progress.md"
alias isw="innocent_starter ~/git/website w"
alias iss="innocent_starter ~/git/space s"
alias msoall="cw; make stop-dev-main; cs; make stop-dev-main"

# Home Aliases
if [ -e $HOME/.alias ]; then
	. $HOME/.alias
fi

# Local Functions and Commands
#
function start_rns {
	msoall
	tmux new -A -d -s r -c ~/git/research-note-system
	tmux send-keys 'cd backend; ./manage.py runserver' C-m
	tmux split-window -v -c ~/git/research-note-system
	tmux send-keys 'cd frontend; ys' C-m
	tx r
}

function innocent_starter {
	msoall
	tmux new -A -d -s $2 -c $1
	tmux rename-window 'exec'
	tmux send-keys 'msa' C-m
	tmux split-window -h -c $1
	tmux send-keys 'sleep 10s; dclf' C-m
	tmux split-window -v -c $1
	tmux send-keys 'sleep 10s; dclb' C-m
	tmux select-pane -t 0
	tmux split-window -v -c $1
	tmux new-window -c $1
	tmux rename-window 'vim'
	tmux new-window -c $1
	tmux rename-window 'git'
	tmux select-window -t 0
	tx $2
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

function set_vpn_net {
    sudo route delete -net default -interface ppp0
    sudo route add -net 0.0.0.0 -interface en0
    sudo route add -net 172.18.0.0 -netmask 255.255.0.0 -interface ppp0
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
