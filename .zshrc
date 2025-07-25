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
if [[ "$AGENT_MODE" != "true" ]] && [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Set Oh My Zsh theme conditionally - disable for agents only
if [[ "$AGENT_MODE" == "true" ]]; then
  ZSH_THEME=""  # Disable Powerlevel10k for agents
else
  ZSH_THEME="powerlevel10k/powerlevel10k"
fi

ZSH_DISABLE_COMPFIX="true"
# FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
# Path to your oh-my-zsh installation.
export ZSH=/Users/mattstratton/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="powerlevel10k/powerlevel10k"
#source /opt/homebrew/opt/powerlevel10k/powerlevel10k.zsh-theme
#ZSH_THEME="clean"
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"
DEFAULT_USER="mattstratton"
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(autojump brew bundler colored-man-pages colorize gem git git-extras github git golang history history-substring-search oc macos pip python ruby vagrant vscode zsh-syntax-highlighting zsh-autosuggestions)
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/sbin:/sbin:~/bin:/usr/local/packer:/Library/Frameworks/Python.framework/Versions/3.4/bin"

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

export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# ssh() {
#    tmux set-option allow-rename off 1>/dev/null
#    tmux rename-window "ssh/$*"
#    command ssh "$@"
#    tmux set-option allow-rename on 1>/dev/null

# }
#

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
export FONT_AWESOME_TOKEN=$(keychain-environment-variable FONT_AWESOME_TOKEN);
export REG_GH_TOKEN=$(keychain-environment-variable REG_GH_TOKEN);
export AIVEN_TOKEN=$(keychain-environment-variable AIVEN_TOKEN);
export GITHUB_PERSONAL_ACCESS_TOKEN=$(keychain-environment-variable GITHUB_TOKEN);
export DIGITALOCEAN_TOKEN=$(keychain-environment-variable DIGITALOCEAN_TOKEN);

alias ohmyzsh="vim ~/.oh-my-zsh"
alias zshconfig="vim ~/.zshrc"
alias c='clear'
alias sz='source ~/.zshrc'
alias prep='changelog prepare'
alias -s rb=ruby
alias -s log="less -MN"
alias imgls="~/.iterm2/imgls"
alias imgcat="~/.iterm2/imgcat"
alias ybrew="yadm add Brewfile"
alias ypom="yadm push origin master"
alias gpom="git push origin master"
alias gitmain="git checkout main && git pull origin main"
alias python="/opt/homebrew/bin/python3"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
export GOPATH=~/go/
export GOROOT="$(brew --prefix golang)/libexec"
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
export DODPATH=/Users/mattstratton/src/github.com/devopsdays/devopsdays-web/
export PATH=$PATH:/Users/matty.stratton/bin
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1
export PATH="/Users/mattstratton/.cargo/bin:$PATH"
### Turbot build stuff
export STEAMPIPE_DOCS_PATH=/Users/mattstratton/src/github.com/turbot/steampipe-docs
export TAILPIPE_DOCS_PATH=/Users/mattstratton/src/github.com/turbot/tailpipe-docs
export GUARDRAILS_DOCS_PATH=/Users/mattstratton/src/github.com/turbot/guardrails-docs
export PIPES_DOCS_PATH=/Users/mattstratton/src/github.com/turbot/pipes-docs
export POWERPIPE_DOCS_PATH=/Users/mattstratton/src/github.com/turbot/powerpipe-docs
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
eval "$(thefuck --alias)"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
# source $HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Later in your .zshrc - minimal prompt for agents
if [[ "$AGENT_MODE" == "true" ]]; then
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
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/mattstratton/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
