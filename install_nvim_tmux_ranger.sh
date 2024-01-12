# !/bin/bash
. ./checks/check_distro.sh

if [[ ! -d ~/.config/nvim/ ]]; then
    mkdir ~/.config/nvim/
fi

if [ $distro_base == "Arch" ]; then
    sudo pacman -Su xclip mono go nodejs jre11-openjdk npm python ranger atool bat calibre elinks ffmpegthumbnailer fontforge highlight imagemagick kitty mupdf-tools odt2txt btm
elif [ $distro_base == "Debian" ]; then  
    sudo apt install build-essential python2 python3 cmake python3-dev python3-pip mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm atool bat elinks ffmpegthumbnailer fontforge highlight imagemagick jq libcaca0 odt2txt mupdf-tools 
fi 

read -p "Install nvim? [Y/n]:" nvim
if [ -z $nvim ] || [ "y" == $nvim ]; then
    ./install_nvim.sh
fi


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

else 

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


read -p "Install tmux.conf? (tmux conf at ~/.tmux.conf) [Y/n]:" tmuxc
if [ -z $tmuxc ]; then
    cp -f .tmux.conf ~/
    tmux source-file ~/.tmux.conf
fi



read -p "Install tmux.sh at ~/Applications? (tmux aliases) [Y/n]:" tmuxx
if [ -z $tmuxx ]; then 
    cp -f Applications/tmux.sh ~/Applications/
    if ! grep -q tmux.sh ~/.bashrc; then
        echo "if [[ -f ~/Applications/tmux.sh ]]; then" >> ~/.bashrc
        echo "  . ~/Applications/tmux.sh" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi
    read -p "Install tmux.sh globally? (/etc/profile.d/tmux.sh) [Y/n]:" gtmux 
    if [ -z $gtmux ]; then 
        sudo ln -s Applications/tmux.sh /etc/profile.d/
    fi
fi

read -p "Install rc.conf? (ranger conf at ~/.config/ranger/) [Y/n]:" rangr
if [ -z $rangr ]; then
    ranger --copy-config=all
    cp -f rc.conf ~/.config/ranger/
fi

if [[ -d ~/.vim/bundle/YouCompleteMe/ ]];then
    sudo rm -rf ~/.vim/bundle/YouCompleteMe/
fi

if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
    sudo rm -rf ~/.vim/bundle/Vundle.vim
fi

if [[ -d ~/.tmux/plugins/tpm ]]; then
    sudo rm -rf ~/.tmux/plugins/tpm
fi

if [[ -d ~/.tmux/plugins/tmux-yank ]]; then
    sudo rm -rf ~/.tmux/plugins/tmux-yank
fi

if [[ -d ~/.config/ranger/plugins/ ]]; then
    sudo rm -rf ~/.config/ranger/plugins/
fi

mkdir ~/.config/ranger/plugins/

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tmux-yank ~/.tmux/plugins/tmux-yank
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#git clone https://github.com/joouha/ranger_tmux ~/.config/ranger/plugins/ranger_tmux
pip3 install ranger_tmux
python3 -m ranger_tmux install
python3 -m ranger_tmux --tmux install
nvim +PluginInstall +qall

if [ $pm == /etc/arch-release ]; then
    python ~/.vim/bundle/YouCompleteMe/install.py --all
elif [ $pm == /etc/debian_version ];then  
    python3 ~/.vim/bundle/YouCompleteMe/install.py --all
else

    python ~/.vim/bundle/YouCompleteMe/install.py --all
fi
