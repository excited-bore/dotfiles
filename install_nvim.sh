
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

read -p "Install init.vim? (neovim conf) [Y/n]:" init
if [ -z $init ]; then
    cp -f init.vim ~/.config/nvim/
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
