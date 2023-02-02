
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
        sudo apt install neovim xclip build-essential cmake python3-dev mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
    fi 
done

read -p "Install init.vim as user conf? (neovim conf at ~/.config/nvim/) [Y/n]:" init
if [ -z $init ]; then
    if [ ! -e ~/.config/nvim ]; then
        mkdir -p ~/.config/nvim
    fi
    cp -f init.vim ~/.config/nvim/

    read -p "Install init.vim with root symlink? (neovim conf at /root/.config/nvim/) [Y/n]:" root
    if [ -z $root ]; then
        if [ ! -e /root/.config/nvim ]; then
            sudo mkdir -p /root/.config/nvim
        fi
        sudo cp -f init.vim /root/.config/nvim/
    fi
fi


read -p "Install vim.sh at ~/Applications/ (nvim aliases)? [Y/n]:" aliases
if [ -z $aliases ]; then 

    if [ ! -d ~/Applications ]; then
        mkdir ~/Applications
    fi

    cp -f Applications/vim_nvim.sh ~/Applications/
    if ! grep -q vim_nvim.sh ~/.bashrc; then

        echo "if [[ -f ~/Applications/vim_nvim.sh ]]; then" >> ~/.bashrc
        echo "  . ~/Applications/vim_nvim.sh" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi

    read -p "Install vim_nvim.sh globally at /etc/profile.d/ ? [Y/n]:" galiases  
    if [ -z $galiases ]; then 
        sudo ln -s Applications/vim_nvim.sh /etc/profile.d/
    fi
fi

if [[ -d ~/.vim/bundle/YouCompleteMe/ ]];then
    sudo rm -rf ~/.vim/bundle/YouCompleteMe/
fi

if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
    sudo rm -rf ~/.vim/bundle/Vundle.vim
fi
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
nvim +PluginInstall +qall

if [ $pm == /etc/arch-release ]; then
    python ~/.vim/bundle/YouCompleteMe/install.py --all
elif [ $pm == /etc/debian_version ];then  
    python3 ~/.vim/bundle/YouCompleteMe/install.py --all
else
    python ~/.vim/bundle/YouCompleteMe/install.py --all
fi
