#!/bin/bash

# Globals
RED="\e[31m"
YELLOW="\e[33m"
GREEN="\e[32m"
CYAN="\e[36m"
# Determine directory for current script
HERE="$(cd "$(dirname "$0")" >/dev/null && pwd)"
# Debian Distribution we handle
DEBIAN_DISTRIB=("ubuntu" "debian" "debian os" "debian ec2 os")

source "${HERE}/lib/base.sh"
source "${HERE}/lib/host.sh"
source "${HERE}/lib/copy-files.sh"
source "${HERE}/lib/install-zsh.sh"

cleanup() {
    log info "[cleanup]: On supprime le repertoire linuxinit"
    rm -Rf ./linuxinit f
}

currentDistro=$(getDistro)
userUid1000=$(getUserByUid 1000)



if [[ -z "$USER" ]] || [[ "$USER" == "" ]]; then
    USER=$(whoami)
    log info "USER Not defined on essaye whoami [$USER]"
else
    log info "USER defined [$USER]"
fi
log info "---=== Debut de Configuration de becane pour User: [$USER] Distro: [$currentDistro] homeDir[$HOME] Uid: [$UID]===---"

if [[ "$USER" == "root" ]]; then
    if [[ $(contains "${DEBIAN_DISTRIB[@]}" "$currentDistro") == "yes" ]] || [[ "$currentDistro" == "alpine" ]]; then
        log info "On est sur une distro [$currentDistro] pour le [$USER]"
        createConfigureSshRoot
        copyRootEssentials
    elif [[ "$currentDistro" == "rhel" ]]; then
        log info "On est sur une distro [$currentDistro] pour le [$USER]"
        copyRootEssentials
    else
        log info "On est sur une distro [$currentDistro] pour le [$USER] UNKOWNW"
    fi

    if [[ "$userUid1000" == "jenkins" ]] && detectIfInContainer; then
        insertPS1BashBashrc
    fi

elif [[ "$USER" == "vagrant" ]]; then
    if [[ $(contains "${DEBIAN_DISTRIB[@]}" "$currentDistro") == "yes" ]]; then
        copyGitBashPrompt
        copyUserEssentials
    else
        log info "On est sur une distro [$currentDistro] pour le [$USER] UNKONW"
    fi

else
    if [[ $(contains "${DEBIAN_DISTRIB[@]}" "$currentDistro") == "yes" ]] || [[ "$currentDistro" == "alpine" ]]; then
        copyUserEssentials
    elif [[ "$currentDistro" == "rhel" ]]; then
        log info "On est sur une distro [$currentDistro] pour le [$USER]"
        copyUserEssentials
    fi

    if detectIfInContainer && [[ "$USER" == "jenkins" ]]; then
        echo "on est dans un container JENKINS ON on agit en consequence"
        echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\] [\D{%T}] \[\033[01;34m\]\w\[\033[00m\]\[\033[36;40m\]\[\033[00m\] > '" >>/etc/bash.bashrc

    fi
fi

cleanup
log info "---=== Fin de Configuration de becane ===---"
