 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./checks/check_distro.sh

if [[ ! -d ~/.config/nvim/ ]]; then
    mkdir ~/.config/nvim/
fi


if [[ $distro == "Arch" || $distro_base == "Arch" ]];then
    sudo pacman -Su neovim cpanminus make cmake gcc xclip python go ninja nodejs mono openjdk17-src python-pynvim
    cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
    cpanm -n Neovim::Ext
elif [[ $distro == "Debian" || $distro_base == "Debian" ]];then                                                         
    sudo apt install cpanminus build-essential xclip python3-dev make mono-complete golang gopls nodejs openjdk-17-jdk openjdk-17-jre npm python3-pip 
    pip3 install --user cmake pynvim
    cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
    cpanm -n Neovim::Ext
    read -p "Neovim on apt Debian is usually deprecated. Install from elsewhere? [ X (Install apx package manager wrapper) / s (Build from source) / a (just use apt) ]: " snp
    if [[ -z $snp || $snp == "X" ]]; then
        if [ -x "$(command -v apx help)" ]; then
            . ./install_apx.sh
        fi
        apx install neovim
    elif [ $snp == "n" ]; then
        echo "Begin installation neovim stable from source using tag 'stable'"
        sudo apt install ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen
        . $DIR/setup_git_build_from_source.sh "y" "neovim" "https://github.com" "neovim/neovim" "stable" "sudo apt update; sudo apt install ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y"
    elif [ $snp == "a" ]; then
        sudo apt install neovim
    fi
    
fi 

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


git clone https://github.com/excited-bore/VundleVimCopy.git ~/.vim/bundle/Vundle.vim
nvim +PluginInstall +qall
python3 ~/.vim/bundle/YouCompleteMe/install.py --all
