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
            sudo pacman -Su tttf-nerd-fonts-symbols-common tf-nerd-fonts-symbols-2048-em ttf-nerd-fonts-symbols-2048-em-mono ranger kitty xclip sshfs neovim mono go nodejs jre11-openjdk npm python atool bat calibre elinks ffmpegthumbnailer fontforge highlight imagemagick mupdf-tools odt2txt btm
    elif [ -f $f ] && [ $f == /etc/debian_version ];then
        echo Package manager: ${osInfo[$f]}
        pm=${osInfo[$f]}
        sudo apt update && sudo apt upgrade
        sudo apt install kitty ranger build-essential python2 python3 cmake neovim python3-dev python3-pip mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm atool bat elinks ffmpegthumbnailer fontforge highlight imagemagick jq libcaca0 odt2txt mupdf-tools 
        (cd ~/.local/share/fonts && wget https://github.com/vorillaz/devicons/archive/master.zip && wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hermit.zip && unzip master.zip Hermit.zip && yes | rm master.zip Hermit.zip && sudo fc-cache -fv)
    fi 
done



read -p "Install init.vim as user conf? (neovim conf at ~/.config/nvim/) [Y/n]:" init
if [ -z $init ]; then
    if [ ! -e ~/.config/nvim ]; then
        mkdir -p ~/.config/nvim
    fi
    cp -f init.vim ~/.config/nvim/

fi

read -p "Install init.vim and .vim/ at root with symlink? (neovim conf at /root/.config/nvim/ and /root/.vim) [Y/n]:" root

if [ -z $root ]; then
    if [ ! -e /root/.config/nvim ]; then
        sudo mkdir -p /root/.config/nvim
    fi
    sudo ln -s ~/.config/nvim/init.vim /root/.config/nvim/
    sudo ln -s ~/.vim /root/.vim


    #if ! grep -q vim_nvim.sh ~/.bashrc; then

    #    echo "if [[ -f ~/Applications/vim_nvim.sh ]]; then" >> ~/.bashrc
    #    echo "  . ~/Applications/vim_nvim.sh" >> ~/.bashrc
    #    echo "fi" >> ~/.bashrc
    #fi

fi

read -p "Install vim_nvim.sh at ~/.bash_aliases.d/? (vim related bash aliases) [Y/n]:" vim_nvim

if [ -z $vim_nvim ]; then 
    cp -f Applications/vim_nvim.sh ~/.bash_aliases.d/vim_nvim.sh

    read -p "Install vim_nvim.sh globally at /etc/profile.d/ ? [Y/n]:" gvim_nvim  
    if [ -z $gvim_nvim ]; then 
        sudo cp -f ~/.bash_aliases.d/vim_nvim.sh /etc/profile.d/
    fi
fi


read -p "Install rc.conf and rifle.conf? (ranger conf at ~/.conf/ranger/) [Y/n]:" rcc
if [ -z $rcc ]; then
    mkdir -p ~/.config/ranger/
    cp -f -t ~/.config/ranger rc.conf rifle.conf
fi

read -p "Install ranger plugins? (plugins at ~/.conf/ranger/plugins) [Y/n]:" rcc
if [ -z $rcc ]; then
    mkdir -p ~/.config/ranger/plugins
    git clone https://github.com/cdump/ranger-devicons2 ~/.config/ranger/plugins/devicons2
fi



#read -p "Install tmux.sh at ~/Applications? (tmux aliases) [Y/n]:" tmuxx
#if [ -z $tmuxx ]; then 
#    cp -f Applications/tmux.sh ~/Applications/
#    if ! grep -q tmux.sh ~/.bashrc; then
#        echo "if [[ -f ~/Applications/tmux.sh ]]; then" >> ~/.bashrc
#        echo "  . ~/Applications/tmux.sh" >> ~/.bashrc
#        echo "fi" >> ~/.bashrc
#    fi
#    read -p "Install tmux.sh globally? (/etc/profile.d/tmux.sh) [Y/n]:" gtmux 
#    if [ -z $gtmux ]; then 
#        sudo ln -s Applications/tmux.sh /etc/profile.d/
#    fi
#fi

#read -p "Install rc.conf? (ranger conf at ~/.config/ranger/) [Y/n]:" rangr
#if [ -z $rangr ]; then
#    ranger --copy-config=all
#    cp -f rc.conf ~/.config/ranger/
#fi

if [[ -d ~/.vim/bundle/YouCompleteMe/ ]];then
    sudo rm -rf ~/.vim/bundle/YouCompleteMe/
fi

if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
    sudo rm -rf ~/.vim/bundle/Vundle.vim
fi

if [[ -d ~/.config/ranger/plugins/ ]]; then
    sudo rm -rf ~/.config/ranger/plugins/
fi

mkdir ~/.config/ranger/plugins/

#git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
#git clone https://github.com/tmux-plugins/tmux-yank ~/.tmux/plugins/tmux-yank
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#git clone https://github.com/joouha/ranger_tmux ~/.config/ranger/plugins/ranger_tmux
#pip3 install ranger_tmux
#python3 -m ranger_tmux install
#python3 -m ranger_tmux --tmux install
nvim +PluginInstall +qall

if [ $pm == /etc/arch-release ]; then
    python ~/.vim/bundle/YouCompleteMe/install.py --all
elif [ $pm == /etc/debian_version ];then  
    python3 ~/.vim/bundle/YouCompleteMe/install.py --all
else

    python ~/.vim/bundle/YouCompleteMe/install.py --all
fi
