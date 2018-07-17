#!/bin/bash

USER=`whoami`
# Determine OS platform
UNAME=$(uname | tr "[:upper:]" "[:lower:]")
# If Linux, try to determine specific distribution
    # If available, use LSB to identify distribution
if [ "$UNAME" == "linux" ]; then
  if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
      DISTRO=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'//)
    else # Otherwise, use release info file
      DISTRO=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1)
  fi
  DISTRO=`echo $DISTRO| tr "[:upper:]" "[:lower:]"`
fi
# For everything else (or if above failed), just use generic identifier
[ "$DISTRO" == "" ] && DISTRO=$UNAME


if [ "$USER" == "root" ]; then

  if [ "$DISTRO" == "debian os" ]; then
    echo "on est debian os"
    cp linuxinit/bash_aliases_root ~/.bashrc
    cp linuxinit/git-bash-completion.sh ~/.git-bash-completion.sh
    cp linuxinit/git-prompt.sh ~/.git-prompt.sh
    cp linuxinit/vimrc ~/.vimrc
    if [ -d /home/debian/ ]; then
        cp linuxinit/bash_aliases_user /home/debian/.bash_aliases
        cp linuxinit/git-bash-completion.sh /home/debian/.git-bash-completion.sh
        cp linuxinit/git-prompt.sh /home/debian/.git-prompt.sh
        cp linuxinit/vimrc /home/debian/.vimrc
        chown -R debian:debian /home/debian/
    fi
  elif [ "$DISTRO" == "centos redhat system system" ]
  then
    echo "on est linux je pense a CentOs 6"
    cp linuxinit/bash_aliases_root ~/.bashrc
    cp linuxinit/git-bash-completion.sh ~/.git-bash-completion.sh
    cp linuxinit/git-prompt.sh ~/.git-prompt.sh
    cp linuxinit/vimrc ~/.vimrc
    cp linuxinit/bash_aliases_user /home/centos/.bashrc
    cp linuxinit/git-bash-completion.sh /home/centos/.git-bash-completion.sh
    cp linuxinit/git-prompt.sh /home/centos/.git-prompt.sh
    cp linuxinit/vimrc /home/centos/.vimrc
    chown -R centos:centos /home/centos
  elif [ "$DISTRO" == "alpine os" ]
  then
    cp linuxinit/bash_aliases_root /root/.bashrc
    cp linuxinit/git-bash-completion.sh /root/.git-bash-completion.sh
    cp linuxinit/git-prompt.sh /root/.git-prompt.sh
    cp linuxinit/vimrc /root/.vimrc
    echo "on est linux sur une alpine c'est du container"
  else 
    echo "on est linux je pense a une ubuntu"
    cp linuxinit/git-bash-completion.sh /root/.git-bash-completion.sh
    cp linuxinit/git-prompt.sh /root/.git-prompt.sh
    cp linuxinit/bash_aliases_root /root/.bash_aliases
    cp linuxinit/vimrc ~/.vimrc

  fi

  if [ ! -d /root/.ssh ]; then
    echo "on cree le reperoire ssh"
    mkdir -p /root/.ssh
  else
    echo "/root/.ssh existe deja"
  fi
  echo "on set les droit sur /root/.ssh"
  chmod 700 /root/.ssh

else

  cp nuxminimal/bash_aliases_user ~/.bash_aliases
  sudo cp nuxminimal/bash_aliases_root /root/.bash_aliases
  sudo cp nuxminimal/bash_aliases_root /root/.bash_aliases
  sudo cp nuxminimal/git-bash-completion.sh /root/.git-bash-completion.sh
  sudo cp nuxminimal/git-prompt.sh /root/.git-prompt.sh
  cp nuxminimal/vimrc .vimrc
  sudo cp .vimrc /root/
  mkdir .ssh && chmod 700 .ssh
  sudo mkdir /root/.ssh && sudo chmod 700 /root/.ssh

fi

rm -Rf ./nuxminimal
