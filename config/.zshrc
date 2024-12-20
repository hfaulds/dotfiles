autoload -U compinit
compinit

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

export EDITOR=nvim

# By default, zsh considers many characters part of a word (e.g., _ and -).
# Narrow that down to allow easier skipping through words via M-f and M-b.
export WORDCHARS='*?[]~&;!$%^<>'

export ACK_COLOR_MATCH='red'

alias vi=nvim
alias vim=nvim

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="`go env GOPATH`/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 19)
set clipboard=unnamed

mkdir -p ~/.github
touch ~/.github/tokens
source ~/.github/tokens

eval "$(rbenv init -)"
eval "$(/$(brew --prefix)/bin/brew shellenv)"
[ -f "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"
[ -f "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"
[ -f "$(brew --prefix)/etc/grc.zsh" ] && . "$(brew --prefix)/etc/grc.zsh"
[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh
autoload -U add-zsh-hook
[ -f "$(brew --prefix)/opt/spaceship/spaceship.zsh" ] && . "$(brew --prefix)/opt/spaceship/spaceship.zsh"


load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

export SPACESHIP_PROMPT_ORDER=(
  dir            # Current directory section
  git            # Git section (git_branch + git_status)
  exec_time      # Execution time
  async          # Async jobs indicator
  line_sep       # Line break
  jobs           # Background jobs indicator
  exit_code      # Exit code section
  sudo           # Sudo indicator
  char           # Prompt character
)
[ -f $HOME/.zsh_private ] && source $HOME/.zsh_private

# Activate Mise
eval "$(mise activate zsh)"
export PYENV_ROOT=$(brew --prefix)/var/pyenv
export PATH=$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
if command -v pyenv 1>/dev/null 2>&1; then eval "$(pyenv init -)"; fi
export PATH=/Users/haydenfaulds/.local/bin:$PATH
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
source /opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
export CLOUDSDK_PYTHON=/opt/homebrew/var/pyenv/versions/3.11.11/bin/python
export OAUTHLIB_RELAX_TOKEN_SCOPE=1
source /Users/haydenfaulds/src/github.com/monzo/analytics/dbt/misc/shell/source.sh
export PATH=/Users/haydenfaulds/.local/bin:$PATH
export PATH=/Users/haydenfaulds/.local/bin:$PATH
export PATH=/Users/haydenfaulds/.local/bin:$PATH
export PATH=/Users/haydenfaulds/.local/bin:$PATH
