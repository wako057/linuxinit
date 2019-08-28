#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
CYAN="\e[36m"
#BLACK=$(tput setaf 0)
#RED=$(tput setaf 1)
#GREEN=$(tput setaf 2)
#YELLOW=$(tput setaf 3)
#LIME_YELLOW=$(tput setaf 190)
#POWDER_BLUE=$(tput setaf 153)
#BLUE=$(tput setaf 4)
#MAGENTA=$(tput setaf 5)
#CYAN=$(tput setaf 6)
#WHITE=$(tput setaf 7)
#BRIGHT=$(tput bold)
#NORMAL=$(tput sgr0)
#BLINK=$(tput blink)
#REVERSE=$(tput smso)
#UNDERLINE=$(tput smul)



log () {
    # Display log messages
    # :param: Log level : error, info or debug
    # :param: Message

    if [ "$1" != "debug" ] || { [ "$1" = "debug" ] && [ "$DC_DEBUG" = 1 ];}; then
        case "$1" in
            error)
                prefix="$RED Error : "
            ;;
            info)
                prefix="$CYAN Info : "
            ;;
            debug)
                prefix="$CYAN Debug : "
            ;;
            *)
                prefix=""
            ;;
        esac

        printf "%s$SHLVL$prefix%s$EOC%s\n" "$(date +'%Y/%m/%d %H:%M:%S')" "$2" 1>&2
    fi
}

getDistro() {
    local UNAME DISTRO
    UNAME=$(uname | tr "[:upper:]" "[:lower:]")

    if [ "$UNAME" == "linux" ]; then
        if [ -f /etc/lsb-release ] && [ -d /etc/lsb-release.d ]; then
            log info "On a trouve des informatiosn dans lsb-release"
            DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
        else # Otherwise, use release info file
            log info "On a pas trouve lsb-release on regarde /etc/[a-z]-_version on /etc/[a-z]-_release"
             # shellcheck disable=SC2010
            DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
        fi
        log info "On forge un retour a peu pres coherent"
        DISTRO=$(echo "$DISTRO" | tr "[:upper:]" "[:lower:]" | tr '\n' ' ' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    fi
    log info "UNAME: [$UNAME]  -  Distro: [$DISTRO]"
    echo "$DISTRO"
}

copyGitBashCompletion() {
    log info "[copyGitBashCompletion]: On copy le bashrc User"
    if [[ ! -f ~/.git-bash-completion.sh ]]
    then
        cp linuxinit/git-bash-completion.sh ~/.git-bash-completion.sh
    else
        log info "[copyUserBashrc][SKIP]: ~/.git-bash-completion.sh exist"
    fi
}

copyGitBashPrompt() {
    log info "[copyGitBashPrompt]: On copy le bashrc User"
    if [[ ! -f ~/.git-prompt.sh ]]
    then
        cp linuxinit/git-prompt.sh ~/.git-prompt.sh
    else
        log info "[copyGitBashPrompt][SKIP]: ~/.git-prompt.sh exist"
    fi
}


copyRootBashrc() {
    log info "[copyRootBashrc]: On copy le bashrc Root"
    if [[ ! -f ~/.bashrc ]]
    then
        cp linuxinit/bash_aliases_root ~/.bashrc
    else
        log info "[copyRootBashrc][SKIP]: ~/.bashrc exist - on insere dans bashrc"
        echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\] [\D{%T}] \[\033[01;34m\]\w\[\033[00m\]\[\033[36;40m\]$(__git_ps1 "(%s)")\[\033[00m\] > '" >> ~/.bashrc
        echo -e "if [ -f ~/.git-bash-completion.sh ]; then\n   . ~/.git-bash-completion.sh\nfi\n\n" >> ~/.bashrc
        echo -e "if [ -f ~/.git-prompt.sh ]; then\n   . ~/.git-prompt.sh\nfi\n\n" >> ~/.bashrc
        echo -e "if [ -f ~/.sh_aliases ]; then\n   . ~/.sh_aliases\nfi\n\n" >> ~/.bashrc
    fi
}

copyUserBashrc() {
    log info "[copyUserBashrc]: On copy le bashrc User"

    if [[ ! -f ~/.bashrc ]]
    then
      log info "[copyUserBashrc][SKIP]: ~/.bashrc doesnt exist"
        cp linuxinit/bash_aliases_user ~/.bashrc
    else
        log info "[copyUserBashrc][SKIP]: ~/.bashrc exist"
    fi

    if [[ ! -f ~/.bash_aliases ]]
    then
        cp linuxinit/bash_aliases_user ~/.bash_aliases
    else
        log info "[copyUserBashrc][SKIP]: ~/.bash_aliases exist"
    fi
}

copyShAliases() {
    log info "[copyShAliases]: On copy le Sh_Aliases"
    if [[ ! -f ~/.sh_aliases ]]
    then
        cp linuxinit/sh_aliases ~/.sh_aliases
    else
        log info "[copyShAliases][SKIP]: ~/.sh_aliases exist"
    fi
}

copyVimrc() {
    log info "[copyVimrc]: On copy le Vimrc"
    if [[ ! -f ~/.vimrc ]]
    then
        cp linuxinit/vimrc ~/.vimrc
    else
        log info "[copyVimrc][SKIP]: ~/.vimrc exist"
    fi
}

copyPsqlRc() {
    log info "[copyPsqlRc]: On copy le PqlRc "
    if [[ ! -f ~/.psqlrc ]]
    then
        cp linuxinit/psqlrc ~/.psqlrc
    else
        log info "[copyPsqlRc][SKIP]: ~/.psqlrc exist"
    fi
}

copyZshrc() {
    log info "[copyZshrc]: On copy et on parametre le ZshRc"
    if [[ ! -f ~/.zshrc ]]
    then
        cp linuxinit/zshrc ~/.zshrc
    else
        log info "[copyZshrc][SKIP]: ~/.zshrc exist"
    fi
    sed -i 's/__USERNAME__/'"$USER"'/g' ~/.zshrc
}

copyGitconfig() {
    log info "[copyGitconfig]: On copy et on parametre le GitConfig"
    if [[ ! -f ~/.gitconfig ]]
    then
        cp linuxinit/gitconfig ~/.gitconfig
    else
        log info "[copyGitconfig][SKIP]: ~/.gitconfig exist"
    fi
    sed -i 's/__USERNAME__/'"$USER"'/g' ~/.gitconfig
}

createConfigureSshRoot() {
    if [[ "$USER" == "root" ]]
    then
        if [[ ! -d /root/.ssh ]]
        then
            log info "[createConfigureSshRoot]: On cree le reperoire ssh"
            mkdir -p /root/.ssh
        else
            log info "[createConfigureSshRoot]: Repertoire /root/.ssh existe deja"
        fi
        log info "[createConfigureSshRoot]: On set les droit sur /root/.ssh"
        chmod 700 /root/.ssh
    fi
}

cleanup() {
    log info "[cleanup]: On supprime le repertoire linuxinit"
    rm -Rf ./linuxinit
}

currentDistro=$(getDistro)
if [[ -z "$USER" ]] || [[ "$USER" == "" ]]
then
    USER=$(whoami)
    log info "USER Not defined on essaye whoami [$USER]"
else
    log info "USER defined [$USER]"
fi

log info "---=== Debut de Configuration de becane pour User: [$USER] Distro: [$currentDistro] homeDir[$HOME] Uid: [$UID]===---"

if [[ "$USER" == "root" ]]
then
    if [[ "$currentDistro" == "debian os" ]] || [[ "$currentDistro" == "debian ec2 os" ]]
    then
        log info "On est sur une distro [$currentDistro] pour le [$USER]"
        createConfigureSshRoot
        copyGitBashCompletion
        copyGitBashPrompt
        copyRootBashrc
        copyShAliases
        copyVimrc
        copyPsqlRc
    else
        log info "On est sur une distro [$currentDistro] pour le [$USER] UNKOWNW"
    fi

elif [[ "$USER" == "vagrant" ]]
then

    if [[ "$currentDistro" == "debian os" ]] || [[ "$currentDistro" == "debian ec2 os" ]]
    then
        copyGitBashCompletion
        copyGitBashPrompt
        copyUserBashrc
        copyShAliases
        copyVimrc
        copyPsqlRc
    else
        log info "On est sur une distro [$currentDistro] pour le [$USER] UNKONW"
    fi
else
    if [[ "$currentDistro" == "debian os" ]] || [[ "$currentDistro" == "debian ec2 os" ]]
    then
        copyUserBashrc
        copyShAliases
        copyVimrc
        copyPsqlRc
    else
        log info "On est sur une distro [$currentDistro] pour le [$USER] UNKONW"
    fi
fi

cleanup
log info "---=== Fin de Configuration de becane ===---"
