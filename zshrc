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
if [ -f ~/.sh_aliases ]; then
    . ~/.sh_aliases
fi

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

