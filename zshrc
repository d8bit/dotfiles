# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="geoffgarside"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

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
plugins=(git vi-mode git kubectl kube-ps1 kubectx)
# plugins=(git)

# User configuration

# export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/share/virtualenvwrapper/:/opt/sonar-scanner-3.0.3.778-linux/bin/:/opt/node-v8.11.2-linux-x64/bin/"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

export VISUAL=vim
export EDITOR="$VISUAL"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# alias vim="vim.athena"
alias bim="vim -u ~/dotfiles/basic_vimrc"
alias clim="vim ~/dotfiles/vimrc_cloudops"
alias vime="vim ~/dotfiles/vimrc"
alias nvime="nvim ~/dotfiles/init.vim"
# alias bim="vim.athena -u ~/dotfiles/basic_vimrc"
alias ze="vim ~/.zshrc"
alias zu="source ~/.zshrc"
alias ga="git add"
alias gs="git status"
alias gc="git commit"
alias gac="git add . && git commit"
alias cdw="cd /var/www/html"
alias fcd="cd \$(ls -l|fzf)"
alias cb="git checkout \$(git branch|fzf)"
alias morning="sudo apt update && sudo apt upgrade"
alias gpush="git add . && git commit && git push"
alias gtest="git add . && git commit -m 'Test' && git push"
alias gupdate="git add . && git commit -m 'Update' && git push"
alias gref="git add . && git commit -m 'Refactor' && git push"
alias gpush_all="git checkout develop && git push && git checkout master && git push && git push --tags && git checkout develop"
alias activate="source venv/bin/activate"
alias trash="gio trash"
alias cdk="cdktf"

alias venv="python3 -m venv ."
alias ngrok="/opt/ngrok/ngrok"
# alias python3="/usr/bin/python3.7"
alias vpnui="/opt/cisco/anyconnect/bin/vpnui &"
# Terraform
alias tftemplate="touch main.tf locals.tf README.md outputs.tf variables.tf && mkdir examples"
alias tfrm="rm -rf .terraform .terraform.lock.hcl"

alias monitor="pactl load-module module-loopback"
alias unmonitor="pactl unload-module module-loopback"

DISABLE_AUTO_TITLE="true"

NPM_STORE="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_STORE/bin"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export SECRET_KEY_BASE=1157982c668f68b81d54b1b309e0ec5eaa6fd5a93d50aa40bd992c231a858275aed524b8ef69354525f5f8719fb9a5025c1836efbd97ff9e80b45c91525dbeb2
PATH=$PATH:/usr/local/sbin
export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH="$PATH:/opt/"
export COMPOSER_MEMORY_LIMIT=-1

export PYDEV="/var/www/python"
# export WORKON_HOME=$PYDEV/.virtualenvs
export PROJECT_HOME=$PYDEV
# source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
export FLASK_APP=app
export FLASK_ENV=development

# cookiecutter requirement
# Add ~/.local/ to PATH
export PATH=$HOME/.local/bin:$PATH


export confluence_password=hgtiF!f0

# export DOCKER_HOST=127.0.0.1:2376
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export PATH="$PATH:/opt/nvim-linux64/bin"

source ~/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

# FZF
source ~/.fzf/shell/key-bindings.zsh
source ~/.fzf/shell/completion.zsh

fpath+=${ZDOTDIR:-~}/.zsh_functions

export KUBECONFIG=/home/david/Documents/k8s/kubeconfig-doliva.yaml



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# alias para hacer login en TUI
load-token(){
  export AWS_PROFILE=$1
  rm -rf ~/.aws/sso/cache/
  aws sso login --profile $AWS_PROFILE
  file=$(ls ~/.aws/sso/cache/ | head -n1)
  cp ~/.aws/sso/cache/$file ~/.aws/sso/cache/8ff2bb760cd406ebba55e4d5dd92a49eeb3cdf1c.json
}

save-obsidian(){
  git -C ~/Documents/tui/obsidian/ add . && git -C ~/Documents/tui/obsidian/ commit -m "Update"
  git -C ~/Documents/tui/obsidian/ archive --format=zip --output=/media/david/F5EE-16E5/work/obsidian.zip master
}
