# The following lines were added by compinstall

zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/jrabasco/.zshrc'

autoload -Uz compinit && compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install

# Completion highlighting
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Left prompt <username>@<hostname> <directory> (<return value>) $
setopt prompt_subst
autoload -Uz colors && colors

__prompt_return_value () {
  echo "%{%(?.$fg_bold[green].$fg_bold[red])%}%?%{$reset_color%}"
}

PROMPT="%(!.%{$fg_bold[red]%}.%{$fg[green]%})%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%} %{$fg_bold[blue]%}%~%{$reset_color%} ($(__prompt_return_value)) %{$fg_bold[cyan]%}%(!.⚠.$)%{$reset_color%} "

# Right prompt for git: (<action>) <untracked><unstaged><staged>|<OK> <repo_root>@<branch>

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:git*' formats "%m%{$fg_bold[red]%}%u%{$color_reset%}%{$fg_bold[yellow]%}%c%{$reset_color%} %{$fg_bold[magenta]%}%r%{$reset_color%}%{$fg_bold[white]%}@%{$reset_color%}%{$fg_bold[cyan]%}%b%{$reset_color%}"
zstyle ':vcs_info:git*' actionformats "%{$fg_bold[cyan]%}(%a)%{$color_reset%} %m%{$fg_bold[red]%}%u%{$color_reset%}%{$fg_bold[yellow]%}%c%{$reset_color%} %{$fg_bold[magenta]%}%r%{$reset_color%}%{$fg_bold[white]%}@%{$reset_color%}%{$fg_bold[cyan]%}%b%{$reset_color%}"
zstyle ':vcs_info:git*+set-message:*' hooks git-changes

+vi-git-changes(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[misc]="%{$fg_bold[red]%}+%{$reset_color%}"
    else
	hook_com[misc]=''
    fi
    if [[ $hook_com[unstaged] == 'U' ]]; then
	hook_com[unstaged]='✘'
    else
	hook_com[unstaged]=''
    fi

    if [[ $hook_com[staged] == 'S' ]]; then
	hook_com[staged]='✘'
    else
	hook_com[staged]=''
    fi
    
    if [[ -z $hook_com[unstaged] && -z $hook_com[staged] && -z $hook_com[misc] ]]; then
	hook_com[misc]="%{$fg_bold[green]%}✔%{$reset_color%}"
    fi
}

RPROMPT=''

ASYNC_PROC=0
function precmd() {
    function async() {
			  vcs_info
        # save to temp file
        echo "${vcs_info_msg_0_}" > "/tmp/zsh_prompt_$$"

        # signal parent
        kill -s USR1 $$
    }

    # do not clear RPROMPT, let it persist

    # kill child if necessary
    if [[ "${ASYNC_PROC}" != 0 ]]; then
        kill -s HUP $ASYNC_PROC >/dev/null 2>&1 || :
    fi

    # start background computation
    async &!
    ASYNC_PROC=$!
}

function TRAPUSR1() {
    # read from temp file
    RPROMPT="$(cat /tmp/zsh_prompt_$$)"

    # reset proc number
    ASYNC_PROC=0

    # redisplay
    zle && zle reset-prompt
}

# Environment

export VISUAL=vim
export EDITOR="$VISUAL"

# History bindings

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# Aliases

if [ -f ~/.zsh_aliases ]; then
	source ~/.zsh_aliases
fi

# Functions

git_all() {
	find -type d -name .git | \
		while read l
		do
			dir="$(dirname "${l}")"
			pushd "${dir}" > /dev/null
			"${@}"
			popd > /dev/null
		done
}

