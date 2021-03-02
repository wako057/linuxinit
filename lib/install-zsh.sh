###########################
# Zsh Install functions
###########################

installNerdFontUbuntu() {
    local fontVersion localFontDir

    fontVersion="2.1.0"
    localFontDir=~/.local/share/fonts/NerdFonts

    sudo apt-get install -y unzip
    mkdir -p $localFontDir
    cd $localFontDir
    curl -OsL https://github.com/ryanoasis/nerd-fonts/releases/download/v$(fontVersion)/UbuntuMono.zip
    unzip UbuntuMono.zip
    rm UbuntuMono.zip
    cd -
}

installOhMyZsh() {
#    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
    copyZshrc
    log warn "[installOhMyZsh]: To change your shell: chsh -s $(which zsh)"
}

installPowerLevel9k() {
    log info "[installPowerLevel9k] Install powerlevel9k"
    git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k
}

installZshOhMyZsh() {
    local currentUid
    currentUid=$(getCurrentUserUid)

    if [[ "$currentUid" -lt 1000 ]]; then
        log error "Current User Has uid below 1000 stop install"
        exit 1
    else
        sudo apt-get install -y zsh
        installOhMyZsh
        installPowerLevel9k

       if ! detectIfVirtualMachine && ! detectIfInContainer; then
            installNerdFontUbuntu
        else
            log info "[installZshOhMyZsh][SKIP][Nerd Font]: On est dans une VM ou un container"
        fi
    fi
}
