#!/bin/bash
#
clear
#
#>>[PREINSTALL]
echo -e "1. Checking required softwares"

echo -n "- cURL..."
command -v curl >/dev/null 2>&1 || { echo >&2 "cURL is not installed. Aborting."; exit 1; }
echo -e "is installed."

echo -n "- Git..."
command -v git  >/dev/null 2>&1 || { echo >&2 "Git is not installed. Aborting."; exit 1; }
echo -e "is installed."

echo -n "- Vim..."
command -v vim  >/dev/null 2>&1 || { echo >&2 "Vim is not installed. Aborting."; exit 1; }
echo -e "is installed."
#<<[PREINSTALL]
#
#>>[GIT]
echo -e "2. Installing bash-git-prompt"

if [ ! -d ~/.dotfiles/bash-git-prompt ]; then
    git clone https://github.com/magicmonty/bash-git-prompt.git ~/.dotfiles/bash-git-prompt --depth=1
fi

cp ~/.dotfiles/git/gitconfig ~/.gitconfig
echo -e "Done."
#<<[GIT]
#
#>>[BASH]
echo -e "3. Installing bashrc"

if [ ! -f ~/.bashrc ]; then
    touch ~/.bashrc
fi

ADDBASHRC="source ~/.dotfiles/bash/bashrc"
BASHRC="${HOME}/.bashrc"

if ! grep -q "$ADDBASHRC" "$BASHRC"; then
    echo "" >> ~/.bashrc
    echo "source ~/.dotfiles/bash/bashrc" >> ~/.bashrc
fi
echo -e "Done."
#<<[BASH]
#
#>>[SSH]
echo -e "4. Installing ssh"
if [ ! -d ~/.ssh ]; then
    mkdir -p ~/.ssh
fi

if [ ! -f ~/.ssh/config ]; then
    echo "Include ~/.ssh/common_config" > ~/.ssh/config
fi

if ! grep -q "COMMON CONFIG" ~/.ssh/config; then
    cat ~/.dotfiles/ssh/common_config >> ~/.ssh/config
fi

cp ~/.dotfiles/ssh/common_config ~/.ssh

echo -e "Done."
#<<[SSH]
#
#>>[VIM]
echo -e "5. Installing vim"

echo -e "- Determine if the terminal support true color"
source ~/.dotfiles/24-bit-color.sh

if [ ! -f ~/.vim/autoload/plug.vim ]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ ! -d ~/.vim/tmp/backup ]; then
    mkdir -p ~/.vim/tmp/backup
fi

if [ ! -d ~/.vim/tmp/swap ]; then
    mkdir -p ~/.vim/tmp/swap
fi

if [ ! -d ~/.vim/tmp/undo ]; then
    mkdir -p ~/.vim/tmp/undo
fi

echo -e "- Installing vim's plugins"
cp ~/.dotfiles/vim/vimrc ~/.vimrc
vim +'PlugInstall --sync' +qa
echo -e "Done."
#<<[VIM]
#
#>>[FINISH]
echo -e "4. Reloading bashrc"
source ~/.bashrc

echo 'Install .dotfiles successed!!!'
#<<[FINISH]
