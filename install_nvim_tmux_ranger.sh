# !/bin/bash

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
            sudo pacman -Su xclip sshfs neovim mono go nodejs jre11-openjdk npm python ranger atool bat calibre elinks ffmpegthumbnailer fontforge highlight imagemagick kitty mupdf-tools odt2txt btm
    elif [ -f $f ] && [ $f == /etc/debian_version ];then
        echo Package manager: ${osInfo[$f]}
        pm=${osInfo[$f]}
        sudo apt install build-essential python2 python3 cmake neovim python3-dev python3-pip mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm ranger atool bat elinks ffmpegthumbnailer fontforge highlight imagemagick jq libcaca0 odt2txt mupdf-tools 
        fi 
    done

    cp -f init.vim ~/.config/nvim/
    cp -f .tmux.conf ~/.tmux.conf
    tmux source-file ~/.tmux.conf
    ranger --copy-config=all
    cp -f rc.conf ~/.config/ranger/
    read -p "Install tmux.sh? (tmux aliases) [Y/n]:" tmuxx
    if [ -z $tmuxx ]; then 
        cp -f Applications/tmux.sh ~/Applications/
        if ! grep -q tmux.sh ~/.bashrc; then
            echo "if [[ -f ~/Applications/tmux.sh ]]; then" >> ~/.bashrc
            echo "  . ~/Applications/tmux.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi
        read -p "Install tmux.sh globally? [Y/n]:" gtmux 
        if [ -z $gtmux ]; then 
            sudo ln -s Applications/tmux.sh /etc/profile.d/
        fi
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
