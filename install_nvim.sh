
if [[ ! -d ~/.config/nvim/ ]]; then
    mkdir ~/.config/nvim/
fi

declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt
osInfo[/etc/alpine-release]=apk

pm=/
for f in ${!osInfo[@]}
do
    if [ -f $f ] && [ $f == /etc/arch-release ];then
        echo Package manager: ${osInfo[$f]}
        pm=${osInfo[$f]}
        sudo pacman -Su xclip neovim cmake python go nodejs mono openjdk17-src
    elif [ -f $f ] && [ $f == /etc/debian_version ];then
        echo Package manager: ${osInfo[$f]}
        pm=${osInfo[$f]}
        sudo apt install neovim xclip build-essential cmake python3-dev mono-complete golang gopls nodejs openjdk-17-jdk openjdk-17-jre npm
    fi 
done

read -p "Install init.vim as user conf? (neovim conf at ~/.config/nvim/) [Y/n]:" init
if [ -z $init ]; then
    if [ ! -e ~/.config/nvim ]; then
        mkdir -p ~/.config/nvim
    fi
    cp -f vim/init.vim ~/.config/nvim/

    read -p "Install .vimrc for user with symlink? (vim conf at ~/.vimrc) [Y/n]:" vimrc
    if [ -z $vimrc ]; then
        ln -s ~/.config/nvim/init.vim ~/.vimrc
    fi

    read -p "Install init.vim, .vimrc and .vim/ with root symlink? (neovim and vim conf at /root/) [Y/n]:" root
    if [ -z $root ]; then
        if [ ! -e /root/.config/nvim ]; then
            sudo mkdir -p /root/.config/nvim
        fi
        sudo ln -s ~/.config/nvim/init.vim /root/.config/nvim/
        sudo ln -s ~/.config/nvim/init.vim /root/.vimrc
        sudo ln -s ~/.vim /root/
    fi
fi


read -p "Install vim_nvim.sh at ~/.bash_aliases.d/ (nvim aliases)? [Y/n]:" aliases
if [ -z $aliases ]; then 

    cp -f vim/vim_nvim.sh ~/.bash_aliases.d/

    read -p "Install vim_nvim.sh at /root/bash_aliases.d/ ? [Y/n]:" galiases  
    if [ -z $galiases ]; then
        if ! sudo test -d /root/.bash_aliases.d/ ; then
            sudo mkdir /root/.bash_aliases.d/
        fi

        if ! sudo grep -q "/root/.bash_aliases.d" /root/.bashrc; then
             printf "if [[ -d /root/.bash_aliases.d/ ]]; then\n  for alias in /root/.bash_aliases.d/*.sh; do\n      . \"\$alias\" \n  done\nfi" | sudo tee -a /root/.bashrc > /dev/null
        fi
        sudo cp -f ~/.bash_aliases.d/vim_nvim.sh /root/.bash_aliases.d/
    fi
fi

#if [[ -d ~/.vim/bundle/YouCompleteMe/ ]];then
#    sudo rm -rf ~/.vim/bundle/YouCompleteMe/
#fi
#
#if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
#    sudo rm -rf ~/.vim/bundle/Vundle.vim
#fi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
nvim +PluginInstall +qall

python3 ~/.vim/bundle/YouCompleteMe/install.py --all
