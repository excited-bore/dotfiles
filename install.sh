#!/bin/bash

if [[ ! -d ~/.config/nvim/ ]]; then
    mkdir ~/.config/nvim/
fi
cp -f .inputrc ~/.inputrc
cp -f init.vim ~/.config/nvim/
cp -f .tmux.conf ~/.tmux.conf
cp -f .bash_aliases ~/.bash_aliases
cp -f .Xresources ~/.Xresources
xrdb -l ~/.Xresources
sudo cp -f doas.conf /etc/doas.conf
sudo cp -f 49-nopasswd_global.rules /etc/polkit-1/rules.d/49-nopasswd_global.rules

if [ ! -d ~/Applications ]; then
    mkdir ~/Applications
fi

cp -f Applications/general.sh ~/Applications
cp -f Applications/doas.sh ~/Applications
cp -f Applications/package_managers.sh ~/Applications
cp -f Applications/variety.sh ~/Applications
cp -f Applications/manjaro.sh ~/Applications
cp -f Applications/systemctl.sh ~/Applications
cp -f Applications/git.sh ~/Applications
cp -f Applications/tmux.sh ~/Applications
cp -f Applications/youtube.sh ~/Applications
cp -f Applications/ssh.sh ~/Applications

if ! grep -q .bash_aliases ~/.bashrc; then
    echo "if [[ -f ~/.bash_aliases ]]; then" >> ~/.bashrc
    echo "  . ~/.bash_aliases" >> ~/.bashrc
    echo "fi" >> ~/.bashrc
fi

if ! grep -q .bash_aliases /etc/profile; then
    sudo echo "if [[ -f ~/.bash_aliases ]]; then" >> /etc/profile
    sudo echo "  . ~/.bash_aliases" >> /etc/profile
    sudo echo "fi" >> /etc/profile
fi

. ~/.bash_aliases 

read -p "Install nvidia settings? (y/n): " $var
if [ "y" = $var ];then
    if ! grep -q "nvidia-settings"; then 
        echo "exec nvidia-settings --load-config-only" >> ~/.xinitrc 
    fi
fi

if [ ! -e ~/lib_systemd ]; then
    ln -s /lib/systemd/system/ ~/lib_systemd
fi

if [ ! -e ~/etc_systemd ]; then
    ln -s /etc/systemd/system/ ~/etc_systemd
fi

if [ ! -e ~/.vimrc ]; then
    ln -s .config/nvim/init.vim ~/.vimrc
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
        sudo pacman -Su flatpak libpamac-flatpak-plugin snap opendoas xclip sshfs reptyr gdb neovim mono go nodejs jre11-openjdk npm python ranger atool bat calibre elinks ffmpegthumbnailer fontforge highlight imagemagick kitty mupdf-tools odt2txt btm
    elif [ -f $f ] && [ $f == /etc/debian_version ];then
        echo Package manager: ${osInfo[$f]}
        pm=${osInfo[$f]}
        sudo apt install flatpak snap doas xclip gdb sshfs reptyr build-essential python2 python3 sshfs cmake vim-nox python3-dev python3-pip mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm ranger atool bat elinks ffmpegthumbnailer fontforge highlight imagemagick jq kitty libcaca0 odt2txt mupdf-tools 
    fi 
done
    ranger --copy-config=all
    tmux +Prefix+I
    cp -f rc.conf ~/.config/ranger/

if [[ -d ~/.vim/bundle/YouCompleteMe/ ]];then
    #sudo rm -rf ~/.vim/bundle/YouCompleteMe/
fi

if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
    #sudo rm -rf ~/.vim/bundle/Vundle.vim
fi

if [[ -d ~/.tmux/plugins/tpm ]]; then
    #sudo rm -rf ~/.tmux/plugins/tpm
fi

if [[ -d ~/.tmux/plugins/tmux-yank ]]; then
    #sudo rm -rf ~/.tmux/plugins/tmux-yank
fi

if [[ -d ~/.config/ranger/plugins/ ]]; then
    #sudo rm -rf ~/.config/ranger/plugins/
fi

mkdir ~/.config/ranger/plugins/

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tmux-yank ~/.tmux/plugins/tmux-yank
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/joouha/ranger_tmux ~/.config/ranger/plugins/ranger_tmux
python -m ranger_tmux install
python -m ranger_tmux --tmux install
nvim +PluginInstall +qall

if [ $pm == /etc/arch-release ]; then
    python ~/.vim/bundle/YouCompleteMe/install.py --all
elif [ $pm == /etc/debian_version ];then  
    python3 ~/.vim/bundle/YouCompleteMe/install.py --all
else
    python ~/.vim/bundle/YouCompleteMe/install.py --all
fi

#if ! grep -q nvim ~/.bashrc; then
#    echo "Added alias and export for vim in .bashrc"
#    echo 'alias vim="nvim"' >> ~/.bashrc
#    echo 'export EDITOR="nvim"' >> ~/.bashrc
#fi

echo "Print: chown root:root -c /etc/doas.conf; chmod 0644 -c /etc/doas.conf; doas -C /etc/doas.conf && echo 'config ok' || echo 'config error' ";
su -;
echo "Restart if errors, otherwise don't forget to 'sudo chmod +s /usr/bin/gdb' en when opening tmux, Prefix + I";
doas chmod +s /usr/bin/gdb && usermod -aG wheel "$USER"
echo "Also, don't forget to open tmux and Prefix+I !"
