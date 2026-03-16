# Agent detection - only activate minimal mode for actual agents  
if [[ -n "$npm_config_yes" ]] || [[ -n "$CI" ]] || [[ "$-" != *i* ]]; then
  export AGENT_MODE=true
else
  export AGENT_MODE=false
fi
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Enable Powerlevel10k instant prompt only when not in agent mode
# Commented out in favor of starship
# if [[ "$AGENT_MODE" != "true" ]] && [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Set Oh My Zsh theme - disabled in favor of starship
# if [[ "$AGENT_MODE" == "true" ]]; then
#   ZSH_THEME=""  # Disable Powerlevel10k for agents
# else
#   ZSH_THEME="powerlevel10k/powerlevel10k"
# fi
ZSH_THEME=""

ZSH_DISABLE_COMPFIX="true"
# FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
# Docker CLI completions (must be before oh-my-zsh compinit)
fpath=(/Users/mattstratton/.docker/completions $fpath)
# Path to your oh-my-zsh installation.
export ZSH=/Users/mattstratton/.oh-my-zsh

# ZSH_THEME="powerlevel10k/powerlevel10k"
#source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
#ZSH_THEME="clean"

DEFAULT_USER="mattstratton"
plugins=(autojump brew colored-man-pages colorize git git-extras docker docker-compose github golang history history-substring-search macos vscode zsh-syntax-highlighting zsh-autosuggestions)
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/sbin:/sbin:~/bin"

# export MANPATH="/usr/local/man:$MANPATH"

export BUNDLE_PATH=$GEM_HOME
# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export EDITOR='code --wait'

# secrets!

source ~/keychain-environment-variables.sh

# AWS configuration example, after doing:
# $  set-keychain-environment-variable AWS_ACCESS_KEY_ID
#       provide: "AKIAYOURACCESSKEY"
# $  set-keychain-environment-variable AWS_SECRET_ACCESS_KEY
#       provide: "j1/yoursupersecret/password"

# export AWS_ACCESS_KEY_ID=$(keychain-environment-variable AWS_ACCESS_KEY_ID);
# export AWS_SECRET_ACCESS_KEY=$(keychain-environment-variable AWS_SECRET_ACCESS_KEY);
export GITHUB_TOKEN=$(keychain-environment-variable GITHUB_TOKEN);
export CHANGELOG_GITHUB_TOKEN=$(keychain-environment-variable GITHUB_TOKEN);
export BOWIE_GITHUB_TOKEN=$(keychain-environment-variable GITHUB_TOKEN);
export HOMEBREW_GITHUB_API_TOKEN=$(keychain-environment-variable GITHUB_TOKEN);
#export GH_TOKEN=$(keychain-environment-variable GITHUB_TOKEN);
#export FONT_AWESOME_TOKEN=$(keychain-environment-variable FONT_AWESOME_TOKEN);
#export REG_GH_TOKEN=$(keychain-environment-variable REG_GH_TOKEN);
#export AIVEN_TOKEN=$(keychain-environment-variable AIVEN_TOKEN);
export GITHUB_PERSONAL_ACCESS_TOKEN=$(keychain-environment-variable GITHUB_TOKEN);
#export DIGITALOCEAN_TOKEN=$(keychain-environment-variable DIGITALOCEAN_TOKEN);

alias vim="nvim"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias zshconfig="nvim ~/.zshrc"
alias c='clear'
alias sz='source ~/.zshrc'
alias prep='changelog prepare'
alias -s rb=ruby
alias -s log="less -MN"
alias imgls="~/.iterm2/imgls"
alias imgcat="~/.iterm2/imgcat"
alias ybrew="yadm add Brewfile"
alias ypom="yadm push origin master"
alias gpom="git push origin main"
alias gitmain="git checkout main && git pull origin main"
alias gitrelease="git checkout release && git pull origin release"
alias python="/opt/homebrew/bin/python3"
alias gh="GITHUB_TOKEN= command gh"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export GOPATH=~/go/
export GOROOT="/opt/homebrew/opt/go/libexec"
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
export DODPATH=/Users/mattstratton/src/github.com/devopsdays/devopsdays-web/
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export PATH="/Users/mattstratton/.cargo/bin:$PATH"
eval "$(thefuck --alias)"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

## obsidian cli
export PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
# nvm

# add jump forward and back keybindings

# Make Alt+Left/Right move by word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

## ngrok
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
# source $HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Later in your .zshrc - minimal prompt for agents
if [[ "$AGENT_MODE" == "true" ]]; then
  export EDITOR='nvim'
  PROMPT='%n@%m:%~%# '
  RPROMPT=''
  unsetopt CORRECT
  unsetopt CORRECT_ALL
  setopt NO_BEEP
  setopt NO_HIST_BEEP  
  setopt NO_LIST_BEEP
  
  # Agent-friendly aliases to avoid interactive prompts
  alias rm='rm -f'
  alias cp='cp -f' 
  alias mv='mv -f'
  alias npm='npm --no-fund --no-audit'
  alias yarn='yarn --non-interactive'
  alias pip='pip --quiet'
  alias git='git -c advice.detachedHead=false'
else
  # Commented out in favor of starship
  # [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi
# for benchmarks
alias gdate='gdate'  # use gdate explicitly instead of overriding date
eval "$(atuin init zsh)"
export PATH="$HOME/.local/bin:$PATH"
eval "$(starship init zsh)"
