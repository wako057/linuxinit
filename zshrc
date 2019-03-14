# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$PATH:$(npm bin)
export PATH=~/.local/bin:$PATH
export TERM="xterm-256color"
export WORKSPACE=~/projects

# Path to your oh-my-zsh installation.
#export ZSH="/home/greg/.oh-my-zsh"

POWERLEVEL9K_MODE='nerdfont-complete'

#ZSH_THEME="robbyrussell"
#ZSH_THEME="random"
#ZSH_THEME="cobalt2"
#ZSH_THEME="powerlevel9k/powerlevel9k"

plugins=(
  git virtualenv
)

source $ZSH/oh-my-zsh.sh

# User configuration
alias l='ls -lh --color=auto --group-directories-first'
alias la='ls -lha --color=auto --group-directories-first'
alias lc='colorls -l --sd'
alias lca='colorls -la --sd'
alias vi='vim'
alias grep='grep --color=auto'
alias egrep='egrep --color'

alias dockup='docker-compose up'
alias gitlog='git log --pretty=oneline -n 54'
alias dockerdeldead='docker rm `docker ps -aqf  status=exited`'
alias dockerdelete='docker stop `docker ps -aq` && docker rm `docker ps -aq`'
alias dockerstop='docker stop `docker ps -aqf status=running`'
alias dockerdelimage='docker rmi -f $(docker images -q)'
alias dockerfclean='docker stop `docker ps -aqf status=running` && docker volume rm `docker volume ls -q` && docker rm `docker ps -aq` && docker rmi -f $(docker images -q)'

alias sshdocker='docker exec -i -t '

zstyle ':completion:*' menu select=2

#CONFIGURATION DU PROMPT
POWERLEVEL9K_CUSTOM_DEBIAN_ICON="echo -e '\uf306' "
POWERLEVEL9K_CUSTOM_DEBIAN_ICON_BACKGROUND=234
POWERLEVEL9K_CUSTOM_DEBIAN_ICON_FOREGROUND=196
POWERLEVEL9K_ROOT_ICON='\uf198'
POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND=196
POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND=232
POWERLEVEL9K_TIME_FORMAT="%D{\ue383 %H:%M:%S \uf073 %d/%m/%y}"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_debian_icon root_indicator dir dir_writable vcs virtualenv)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)

# You may need to manually set your language environment
export LANG=fr_FR:UTF-8
export LC_ALL="fr_FR.UTF-8"

# Preferred editor for local and remote sessions
export EDITOR='vim'


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

