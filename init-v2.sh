#!/bin/bash

RED="\e[31m"
#GREEN="\e[32m"
CYAN="\e[36m"
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

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
                prefix=" Info : "
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
            DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
        else # Otherwise, use release info file
             # shellcheck disable=SC2010
            DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
        fi
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
    log info "[copyRootBashrc]: On copy le bashrc User"
    cp linuxinit/bash_aliases_user ~/.bash_aliases
}

copyShAliases() {
    log info "[copyRootBashrc]: On copy le Sh_Aliases"
    cp linuxinit/sh_aliases ~/.sh_aliases
}

copyVimrc() {
    log info "[copyRootBashrc]: On copy le Vimrc"
    cp linuxinit/vimrc ~/.vimrc
}

copyPsqlRc() {
    log info "[copyRootBashrc]: On copy le PqlRc "
    cp linuxinit/psqlrc ~/.psqlrc
}

copyZshrc() {
    log info "[copyRootBashrc]: On copy et on parametre le ZshRc"
    cp linuxinit/zshrc ~/.zshrc
    sed -i 's/__USERNAME__/'"$USER"'/g' ~/.zshrc
}

copyGitconfig() {
    log info "[copyRootBashrc]: On copy et on parametre le GitConfig"
    cp linuxinit/gitconfig ~/.gitconfig
    sed -i 's/__USERNAME__/'"$USER"'/g' ~/.gitconfig
}

createConfigureSshRoot() {
  if [ "$USER" == "root" ]; then
    if [ ! -d /root/.ssh ]; then
      log info "on cree le reperoire ssh"
      mkdir -p /root/.ssh
    else
      log info "/root/.ssh existe deja"
    fi
    log info "on set les droit sur /root/.ssh"
    chmod 700 /root/.ssh
  fi
}

currentDistro=$(getDistro)

log info "On parametre le compte pour [$USER]"
if [ "$USER" == "root" ]; then
    if [ "$DISTRO" == "debian os" ]; then
        createConfigureSshRoot
        copyRootBashrc
        copyShAliases
        copyVimrc
        copyPsqlRc
    fi
fi

echo "$currentDistro"
