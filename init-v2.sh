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

copyRootBashrc() {
    log info "[copyRootBashrc]: On copy le bashrc Root"
    cp linuxinit/bash_aliases_root ~/.bashrc
}

copyUserBashrc() {
    log info "[copyUserBashrc]: On copy le bashrc User"
    cp linuxinit/bash_aliases_user ~/.bash_aliases
}

copyShAliases() {
    log info "[copyShAliases]: On copy le Sh_Aliases"
    cp linuxinit/sh_aliases ~/.sh_aliases
}

copyVimrc() {
    log info "[copyVimrc]: On copy le Vimrc"
    cp linuxinit/vimrc ~/.vimrc
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

log info "---=== Debut de Configuration de becane pour [$USER] [$currentDistro] ===---"
if [[ "$USER" == "root" ]]
then
    if [[ "$currentDistro" == "debian os" ]] || [[ "$currentDistro" == "debian ec2 os" ]]
    then
        log info "On est sur une distro [$currentDistro] pour le [$USER]"
        createConfigureSshRoot
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
