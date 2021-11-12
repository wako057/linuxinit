# If you come from bash you might have to change your $PATH.
export ZSH="/home/__USERNAME__/.oh-my-zsh"
npm 2>&1 > /dev/null && export PATH=$PATH:$(npm bin)
export PATH=~/.local/bin:$PATH
export TERM="xterm-256color"
export WORKSPACE=~/projects

#ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE='nerdfont-complete'

plugins=(git virtualenv docker docker-compose)

source $ZSH/oh-my-zsh.sh

# User configuration
if [ -f ~/.include-env ]; then
    . ~/.include-env
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

POWERLEVEL9K_CONTEXT_TEMPLATE="%n@`hostname -f`"
if [[ -z "$SSH_CLIENT" ]]; then
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_debian_icon root_indicator dir dir_writable vcs virtualenv)
else
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(custom_debian_icon context root_indicator dir dir_writable vcs virtualenv)
fi

# You may need to manually set your language environment
export LANG=fr_FR:UTF-8
export LC_ALL="fr_FR.UTF-8"

# Preferred editor for local and remote sessions
export EDITOR='vim'


#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
