. ./check_distro.sh

if [[ ! -d ~/.config/nvim/ ]]; then
    mkdir ~/.config/nvim/
fi


if [[ $dist == "Manjaro" || $dist == "Arch" ]];then
    sudo pacman -Su neovim cmake xclip python go ninja nodejs mono openjdk17-src python-pynvim
elif [[ $dist == "Debian" || $dist == "Raspbian" ]];then
    sudo apt install build-essential xclip cmake python3-dev mono-complete golang gopls nodejs openjdk-17-jdk openjdk-17-jre npm python3-pip 
    read -p "Neovim on apt Debian is usually deprecated. Install from elsewhere? [ Nx (Nix package manager)/ s (build from source)/ n (apt)]:" snp
    if [[ -z $snp || $snp == "Nx" ]]; then
        read -p "Install Nix? [Y/n]: " nx
        if [[ -z $nx || $nx == "y" ]]; then
            . ./install_nix_package_man.sh
        fi
        pip3 install --upgrade pynvim
        nix-env -iA nixpkgs.neovim
    elif [ $snp == "s" ]; then
        echo "Begin installation neovim stable from source"
        pip3 install --upgrade pynvim
        sudo apt install gettext
        ./setup_git_build_from_source.sh "y" "neovim" "https://github.com" "neovim/neovim" "releases/stable" "make CMAKE_BUILD_TYPE=RelWithDebInfo && sudo make install" "sudo make uninstall" "sudo rm -rf build/" "y"
    elif [ $snp == "n" ]; then
        sudo apt install neovim python3-pynvim
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

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
nvim +PluginInstall +qall
python3 ~/.vim/bundle/YouCompleteMe/install.py --all
