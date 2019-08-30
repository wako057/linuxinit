cd
sudo apt-get install git
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs

sudp apt-get install zsh
cp .zshrc .zshrc.old
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp zshrc .zshrc

git clone https://github.com/ryanoasis/nerd-fonts.git --depth 1
cd nerd-fonts
# install nerd-font
./install.sh UbuntuMono Hack
