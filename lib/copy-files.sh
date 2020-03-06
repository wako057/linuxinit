#####################
# Copy files functions
#####################

copyGitBashCompletion() {
    log info "[copyGitBashCompletion]: On copy le bashrc User"
    if [[ ! -f ~/.git-bash-completion.sh ]]; then
        cp linuxinit/git-bash-completion.sh ~/.git-bash-completion.sh
    else
        log info "[copyUserBashrc][SKIP]: ~/.git-bash-completion.sh exist"
    fi
}

copyGitBashPrompt() {
    log info "[copyGitBashPrompt]: On copy le git-prompt"
    if [[ ! -f ~/.git-prompt.sh ]]; then
        cp linuxinit/git-prompt.sh ~/.git-prompt.sh
    else
        log info "[copyGitBashPrompt][SKIP]: ~/.git-prompt.sh exist"
    fi
}

copyRootBashrc() {
    log info "[copyRootBashrc]: On copy le bashrc Root"
    if [[ ! -f ~/.bashrc ]]; then
        cp linuxinit/bash_aliases_root ~/.bashrc
    else
        log info "[copyRootBashrc][SKIP]: ~/.bashrc exist - on insere dans bashrc"
        {
            echo -e "if [ -f ~/.git-bash-completion.sh ]; then\n   . ~/.git-bash-completion.sh\nfi\n\n"
            echo -e "if [ -f ~/.git-prompt.sh ]; then\n   . ~/.git-prompt.sh\nfi\n\n"
            echo -e "if [ -f ~/.sh_aliases ]; then\n   . ~/.sh_aliases\nfi\n\n"
            echo "PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\] [\D{%T}] \[\033[01;34m\]\w\[\033[00m\]\[\033[36;40m\]$(__git_ps1 "(%s)")\[\033[00m\] > '"
        } >>~/.bashrc
    fi
}

copyUserBashrc() {
    log info "[copyUserBashrc]: On copy le bashrc User"
    if [[ ! -f ~/.bashrc ]]; then
        log info "[copyUserBashrc][INIT]: ~/.bashrc doesnt exist we create it"
        cp linuxinit/bash_aliases_user ~/.bashrc || log info "[copyUserBashrc][ERROR]: copy failed"
    else
        log info "[copyUserBashrc][SKIP]: ~/.bashrc exist - on insere dans bashrc"
    fi
}

copyUserBashAliases() {
    log info "[copyUserBashAliases]: On copy le bash_aliases User"

    if [[ ! -f ~/.bashrc ]]; then
        copyUserBashrc
    fi

    if [[ ! -f ~/.bash_aliases ]]; then
        log info "[copyUserBashAliases][INIT]: ~/.bash_aliases doesnt exist we create it"
        cp linuxinit/bash_aliases_user ~/.bash_aliases
    else
        log info "[copyUserBashAliases][SKIP]: ~/.bash_aliases exist"
    fi
}

copyShAliases() {
    log info "[copyShAliases]: On copy le Sh_Aliases"
    if [[ ! -f ~/.sh_aliases ]]; then
        cp linuxinit/sh_aliases ~/.sh_aliases
    else
        log info "[copyShAliases][SKIP]: ~/.sh_aliases exist"
    fi
}

copyIncludeEnvInitPath() {
    log info "[copyIncludeEnvInitPath]: On copy le include-env"
    if [[ ! -f ~/.include-env ]]; then
        cp linuxinit/include-env ~/.include-env
    else
        log info "[copyIncludeEnvInitPath][SKIP]: ~/.init-path exist"
    fi

    if [[ ! -f ~/.init-path ]]; then
        cp linuxinit/init-path ~/.init-path
    else
        log info "[copyIncludeEnvInitPath][SKIP]: ~/.init-path exist"
    fi
}

copyVimrc() {
    log info "[copyVimrc]: On copy le Vimrc"
    if [[ ! -f ~/.vimrc ]]; then
        cp linuxinit/vimrc ~/.vimrc
    else
        log info "[copyVimrc][SKIP]: ~/.vimrc exist"
    fi
}

copyPsqlRc() {
    log info "[copyPsqlRc]: On copy le PqlRc "
    if [[ ! -f ~/.psqlrc ]]; then
        cp linuxinit/psqlrc ~/.psqlrc
    else
        log info "[copyPsqlRc][SKIP]: ~/.psqlrc exist"
    fi
}

copyZshrc() {
    log info "[copyZshrc]: On copy et on parametre le ZshRc"
    if [[ ! -f ~/.zshrc ]]; then
        cp linuxinit/zshrc ~/.zshrc
    else
        log info "[copyZshrc][SKIP]: ~/.zshrc exist"
    fi
    sed -i 's/__USERNAME__/'"$USER"'/g' ~/.zshrc
}

copyGitconfig() {
    log info "[copyGitconfig]: On copy et on parametre le GitConfig"
    if [[ ! -f ~/.gitconfig ]]; then
        cp linuxinit/gitconfig ~/.gitconfig
    else
        log info "[copyGitconfig][SKIP]: ~/.gitconfig exist"
    fi
    sed -i 's/__USERNAME__/'"$USER"'/g' ~/.gitconfig
}

copyUserEssentials() {
    copyUserBashAliases
    copyShAliases
    copyIncludeEnvInitPath
    copyVimrc
    copyPsqlRc
    copyGitconfig
}

copyRootEssentials() {
    copyGitBashPrompt
    copyRootBashrc
    copyShAliases
    copyVimrc
    copyPsqlRc
}
