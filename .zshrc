ZSH_DISABLE_COMPFIX="true"
# FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

# Configuring Completions in zsh
# See: https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Path to your oh-my-zsh installation.
export ZSH=/Users/jeremymeiss/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="muse"
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
DEFAULT_USER="jeremymeiss"
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
plugins=(autojump brew bundler colored-man-pages colorize docker docker-compose dotenv emoji gatsby gem git git-extras github git golang heroku history history-substring-search iterm2 jsontools node npm npx nvm oc osx pip python repo ruby ssh-agent vagrant vscode zsh-completions zsh-syntax-highlighting zsh-autosuggestions)
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

export EDITOR='nano'

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

#source ~/keychain-environment-variables.sh

# AWS configuration example, after doing:
# $  set-keychain-environment-variable AWS_ACCESS_KEY_ID
#       provide: "AKIAYOURACCESSKEY"
# $  set-keychain-environment-variable AWS_SECRET_ACCESS_KEY
#       provide: "j1/yoursupersecret/password"

#export AWS_ACCESS_KEY_ID=$(keychain-environment-variable AWS_ACCESS_KEY_ID);
#export AWS_SECRET_ACCESS_KEY=$(keychain-environment-variable AWS_SECRET_ACCESS_KEY);
#export GITHUB_TOKEN=$(keychain-environment-variable GITHUB_TOKEN);
#export CHANGELOG_GITHUB_TOKEN=$(keychain-environment-variable GITHUB_TOKEN);
#export BOWIE_GITHUB_TOKEN=$(keychain-environment-variable GITHUB_TOKEN);
#export HOMEBREW_GITHUB_API_TOKEN=$(keychain-environment-variable GITHUB_TOKEN);

# Example aliases
alias ohmyzsh="vim ~/.oh-my-zsh"
alias zshconfig="vim ~/.zshrc"
#alias ping='ping -c 5'
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
alias gpd='docker run -it -v $PWD:/repo -p 9000:9000 gitpitch/desktop:pro'
#alias brew='PATH="/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/sbin:/usr/sbin" brew'
# eval "$(hub alias -s)"

export GOPATH=~/go/
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOROOT/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/Users/jeremymeiss/bin
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_INSECURE_REDIRECT=1

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
eval "$(thefuck --alias)"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# source /usr/local/opt/git-extras/share/git-extras/git-extras-completion.zsh
export GPG_TTY=$(tty)
# unalias pip
# eval "$(direnv hook zsh)"
# eval "$(starship init zsh)"
