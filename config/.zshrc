fpath=( ~/.zsh/func "${fpath[@]}" )
setopt PROMPT_SUBST
autoload -U promptinit
promptinit
prompt grb

autoload -U compinit
compinit

# Add paths that should have been there by default
export PATH="/usr/local/bin:/usr/local/bin:$HOME/bin:$PATH"

# by default, ^s freezes terminal output and ^q resumes it. disable that so
# that those keys can be used for other things.
unsetopt flowcontrol

# unbreak broken, non-colored terminal
alias ls='ls -g'
alias ll='ls -lg'
export lscolors="exgxbxdxcxegedxbxgxcxd"
export grep_options="--color"

# unbreak history
export histsize=100000
export histfile="$home/.history"
export savehist=$histsize

export editor=nvim
if [[ "$OSTYPE" == "darwin"* ]]; then
  # gnu screen sets -o vi if editor=vi, so we have to force it back. what the
  # hell, gnu?
  set -o emacs
  set clipboard=unnamed
fi

autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# By default, zsh considers many characters part of a word (e.g., _ and -).
# Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'

export ACK_COLOR_MATCH='red'

activate_virtualenv() {
    if [ -f env/bin/activate ]; then . env/bin/activate;
    elif [ -f ../env/bin/activate ]; then . ../env/bin/activate;
    elif [ -f ../../env/bin/activate ]; then . ../../env/bin/activate;
    elif [ -f ../../../env/bin/activate ]; then . ../../../env/bin/activate;
    fi
}

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
alias vi=nvim
alias vim=nvim

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
if [ -x "$(command -v go)" ] ; then
  export PATH="`go env GOPATH`/bin:$PATH"
fi

if [ -x "$(command -v rbenv)" ] ; then
  eval "$(rbenv init -)"
fi
if [ -x "$(command -v nodenv)" ] ; then
  eval "$(nodenv init -)"
fi

export GO111MODULE=auto
export GEM_PATH=~/.gems
export GEM_HOME=~/.gems

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

. ~/.github/tokens
