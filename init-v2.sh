#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
CYAN="\e[36m"


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
                prefix="$GREEN Debug : "
            ;;
            *)
                prefix=""
            ;;
        esac

        printf "%s$SHLVL$prefix%s$EOC%s\n" "$(date +'%Y/%m/%d %H:%M:%S')" "$2" 1>&2
    fi
}

# based on https://unix.stackexchange.com/questions/6345/how-can-i-get-distribution-name-and-version-number-in-a-simple-shell-script
# modification for my usecase
getDistro() {
  local UNAME DISTRO
  local OSFILE="/etc/os-release"
  local LSBFILE="/etc/lsb-release"

  if [ -f $OSFILE ];
  then # freedesktop.org and systemd
    DISTRO=$(grep "^ID=" /etc/os-release | tr -d '"' | sed -e 's/ID=//' | tr "[:upper:]" "[:lower:]")
    log info "[getDistro]: On cat /etc/release"
  elif type lsb_release >/dev/null 2>&1; then
    DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'// | tr "[:upper:]" "[:lower:]")
    log info "[getDistro]: On utilise la commande lsb_release"
  elif [ -f /etc/lsb-release ]; then # For some versions of Debian/Ubuntu without lsb_release command
    DISTRO=DISTRO=$(grep "^DISTRIB_ID=" /etc/os-release | sed -e 's/^DISTRIB_ID="//' -e 's/"$//')
    log info "[getDistro]: On cat /etc/debian_version: Old debian $VER"
  elif [ -f /etc/debian_version ]; then # Older Debian/Ubuntu/etc.
    VER=$(cat /etc/debian_version)
    log info "[getDistro]: On cat /etc/debian_version: Old debian $VER"
    DISTRO="debian"
#  elif [ -f /etc/SuSe-release ]; then
      # Older SuSE/etc.
#  elif [ -f /etc/redhat-release ]; then
      # Older Red Hat, CentOS, etc.
  else
      OS=$(uname -s)
      VER=$(uname -r)
     DISTRO="$OS$VER"
  fi
  echo $DISTRO
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
    log info "[copyGitBashPrompt]: On copy le git-prompt"
    if [[ ! -f ~/.git-prompt.sh ]]
    then
        cp linuxinit/git-prompt.sh ~/.git-prompt.sh
    else
        log info "[copyGitBashPrompt][SKIP]: ~/.git-prompt.sh exist"
    fi
}

addUserGroupSudoers()
{
  # :param: User
  RUN echo "$1 ALL=(ALL) NOPASSWD " >> /etc/sudoers
}

copyRootBashrc() {
    log info "[copyRootBashrc]: On copy le bashrc Root"
    if [[ ! -f ~/.bashrc ]]
    then
        cp linuxinit/bash_aliases_root ~/.bashrc
    else
        log info "[copyRootBashrc][SKIP]: ~/.bashrc exist - on insere dans bashrc"
        {
          echo -e "if [ -f ~/.git-bash-completion.sh ]; then\n   . ~/.git-bash-completion.sh\nfi\n\n"
          echo -e "if [ -f ~/.git-prompt.sh ]; then\n   . ~/.git-prompt.sh\nfi\n\n"
          echo -e "if [ -f ~/.sh_aliases ]; then\n   . ~/.sh_aliases\nfi\n\n"
          echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\] [\D{%T}] \[\033[01;34m\]\w\[\033[00m\]\[\033[36;40m\]$(__git_ps1 "(%s)")\[\033[00m\] > '"
        } >> ~/.bashrc
    fi
}

copyUserBashrc() {
    log info "[copyUserBashrc]: On copy le bashrc User"
    if [[ ! -f ~/.bashrc ]]
    then
        cp linuxinit/bash_aliases_user ~/.bashrc
    else
        log info "[copyUserBashrc][SKIP]: ~/.bashrc exist - on insere dans bashrc"
    fi
}


copyUserBashAliases() {
    log info "[copyUserBashAliases]: On copy le bash_aliases User"

    if [[ ! -f ~/.bashrc ]]
    then
      log info "[copyUserBashAliases][INIT]: ~/.bashrc doesnt exist we create it"
        cp linuxinit/bash_aliases_user ~/.bashrc || log info "[copyUserBashAliases][ERROR]: copy failed"
    else
        log info "[copyUserBashAliases][SKIP]: ~/.bashrc exist"
    fi

    if [[ ! -f ~/.bash_aliases ]]
    then
        cp linuxinit/bash_aliases_user ~/.bash_aliases
    else
        log info "[copyUserBashAliases][SKIP]: ~/.bash_aliases exist"
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


copyIncludeEnvInitPath() {
    log info "[copyIncludeEnvInitPath]: On copy le include-env"
    if [[ ! -f ~/.include-env ]]
    then
        cp linuxinit/include-env ~/.include-env
    else
        log info "[copyIncludeEnvInitPath][SKIP]: ~/.init-path exist"
    fi

    if [[ ! -f ~/.init-path ]]
    then
        cp linuxinit/init-path ~/.init-path
    else
        log info "[copyIncludeEnvInitPath][SKIP]: ~/.init-path exist"
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
    rm -Rf ./linuxinit f
}

detectIfInContainer() {
 local chk
 chk=$(grep -cE '/(lxc|docker)/[[:xdigit:]]{64}' /proc/1/cgroup)
 if [[ $chk -gt 0 ]]
 then
   log info "[detectIfInContainer]: On est dans un container"
	 return 0
 else
   log info "[detectIfInContainer]: On est PAS dans un container"
	 return 1
 fi
}


getUserByUid() {
  # Get the username of the Uid parameters
  # :param: Uid
  local name
  name=$(getent passwd "$1" | cut -d: -f1)
  log info "[getUserByUid]: Le user avec l'uid [$1] est: [$name]"
  echo "$name"
}


insertPS1BashBashrc() {
  log info "[insertPS1BashBashrc]: Cas particulier on dirait, on force le bash.bashrc"

  {
    echo "########### CUSTOM /etc/bash.bashrc due to no healthy HOME ###########"
    echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] [\D{%T}] \[\033[01;34m\]\w\[\033[00m\]\[\033[36;40m\]\[\033[00m\] > '"
    cat ./linuxinit/sh_aliases
  } >> /etc/bash.bashrc



#  echo -e "if [ -f ~/.git-bash-completion.sh ]; then\n   . ~/.git-bash-completion.sh\nfi\n\n" >> ~/.bashrc
#  echo -e "if [ -f ~/.git-prompt.sh ]; then\n   . ~/.git-prompt.sh\nfi\n\n" >> ~/.bashrc
#  echo -e "if [ -f ~/.sh_aliases ]; then\n   . ~/.sh_aliases\nfi\n\n" >> ~/.bashrc
}

currentDistro=$(getDistro)
userUid1000=$(getUserByUid 1000)

#echo $currentDistro
#exit;

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
    if [[ "$currentDistro" == "debian" ]] || [[ "$currentDistro" == "debian os" ]] || [[ "$currentDistro" == "debian ec2 os" ]] || [[ "$currentDistro" == "alpine" ]]
    then
        log info "On est sur une distro [$currentDistro] pour le [$USER]"
        createConfigureSshRoot
        copyGitBashCompletion
        copyGitBashPrompt
        copyRootBashrc
        copyShAliases
        copyVimrc
        copyPsqlRc

    elif [[ "$currentDistro" == "rhel" ]];
    then
        log info "On est sur une distro [$currentDistro] pour le [$USER]"
        copyGitBashCompletion
        copyGitBashPrompt
        copyRootBashrc
        copyShAliases
        copyVimrc

    else
        log info "On est sur une distro [$currentDistro] pour le [$USER] UNKOWNW"
    fi

    if [[ "$userUid1000" == "jenkins" ]] && detectIfInContainer
    then
      insertPS1BashBashrc
    fi

elif [[ "$USER" == "vagrant" ]]
then

    if  [[ "$currentDistro" == "ubuntu" ]] || [[ "$currentDistro" == "debian os" ]] || [[ "$currentDistro" == "debian ec2 os" ]]
    then
        copyGitBashCompletion
        copyGitBashPrompt
        copyUserBashrc
        copyUserBashAliases
        copyShAliases
        copyIncludeEnvInitPath
        copyVimrc
        copyPsqlRc
    else
        log info "On est sur une distro [$currentDistro] pour le [$USER] UNKONW"
    fi

else
    if [[ "$currentDistro" == "ubuntu" ]] || [[ "$currentDistro" == "debian" ]] || [[ "$currentDistro" == "debian os" ]] || [[ "$currentDistro" == "debian ec2 os" ]] || [[ "$currentDistro" == "alpine" ]]
    then
        copyGitBashPrompt
        copyUserBashrc
        copyUserBashAliases
        copyShAliases
        copyIncludeEnvInitPath
        copyVimrc
        copyPsqlRc

    elif [[ "$currentDistro" == "rhel" ]];
    then
        log info "On est sur une distro [$currentDistro] pour le [$USER]"
        copyGitBashCompletion
        copyUserBashrc
        copyUserBashAliases
        copyShAliases
        copyIncludeEnvInitPath
        copyVimrc

#    else
#        log info "On est sur une distro [$currentDistro] pour le [$USER] UNKONW"
    fi

    if detectIfInContainer && [[ "$USER" == "jenkins" ]]
    then
      echo "on est dans un container JENKINS ON on agit en consequence"
      echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\] [\D{%T}] \[\033[01;34m\]\w\[\033[00m\]\[\033[36;40m\]\[\033[00m\] > '" >> /etc/bash.bashrc

    fi

fi


cleanup
log info "---=== Fin de Configuration de becane ===---"
