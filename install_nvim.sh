 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. checks/check_distro.sh
. readline/rlwrap_scripts.sh

#. $DIR/setup_git_build_from_source.sh "y" "neovim" "https://github.com" "neovim/neovim" "stable" "sudo apt update; sudo apt install ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y"

if [[ $distro == "Arch" || $distro_base == "Arch" ]];then
    yes | sudo pacman -Su neovim 
    reade -Q "GREEN" -i "y" -p "Install nvim clipboard? (xsel) [Y/n]:" "y n" clip
    if [ -z $clip ] || [ "y" == $clip ]; then
        yes | sudo pacman -Su xsel   
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-python? [Y/n]:" "y n" pyscripts
    if [ -z $pyscripts ] || [ "y" == $pyscripts ]; then
        yes | sudo pacman -Su python python-pip python-pynvim   
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-javascript? [Y/n]:" "y n" jsscripts
    if [ -z $jsscripts ] || [ "y" == $jsscripts ]; then
        yes | sudo pacman -Su nodejs npm
        npm install -g neovim
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-ruby? [Y/n]:" "y n" rubyscripts
    if [ -z $rubyscripts ] || [ "y" == $rubyscripts ]; then
        yes | sudo pacman -Su ruby
        gem environment
        gem install neovim
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-perl? [Y/n]:" "y n" perlscripts
    if [ -z $perlscripts ] || [ "y" == $perlscripts ]; then
        yes | sudo pacman -Su cpanminus
        cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
        cpanm -n Neovim::Ext
    fi
elif [[ $distro == "Debian" || $distro_base == "Debian" ]];then 
    yes | sudo apt update
    yes | sudo apt install neovim 
    reade -Q "GREEN" -i "y" -p "Install nvim clipboard? (xsel) [Y/n]:" "y n" clip
    if [ -z $clip ] || [ "y" == $clip ]; then
        yes | sudo apt install xsel   
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-python? [Y/n]:" "y n" pyscripts
    if [ -z $pyscripts ] || [ "y" == $pyscripts ]; then
        yes | sudo apt install python3 python3-dev python3-pip  
        pip3 install pynvim
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-javascript? [Y/n]:" "y n" jsscripts
    if [ -z $jsscripts ] || [ "y" == $jsscripts ]; then
        yes | sudo apt install nodejs npm
        npm install -g neovim
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-ruby? [Y/n]:" "y n" rubyscripts
    if [ -z $rubyscripts ] || [ "y" == $rubyscripts ]; then
        yes | sudo apt install ruby
        gem environment
        gem install neovim
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-perl? [Y/n]:" "y n" perlscripts
    if [ -z $perlscripts ] || [ "y" == $perlscripts ]; then
        yes | sudo apt install cpanminus
        cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
        cpanm -n Neovim::Ext
    fi
fi

function instvim_r(){
    if ! sudo test -d /root/.config/nvim/; then
        mkdir /root/.config/nvim/
    fi
    sudo cp -fv vim/init.vim /root/.config/nvim/init.vim
    reade -Q "YELLOW" -p "Make symlink for init.vim at /root/.vimrc for user? (Might conflict with nvim +checkhealth) [Y/n]:" vimrc_r
    if [ -z $vimrc_r ] || [ "y" == $vimrc_r ] ; then
        ln -s ~/.config/nvim/init.vim ~/.vimrc
    fi
}

function instvim(){
    if [[ ! -d ~/.config/nvim/ ]]; then
        mkdir ~/.config/nvim/
    fi
    cp -fv vim/init.vim ~/.config/nvim/init.vim
    
    reade -Q "YELLOW" -p "Make symlink for init.vim at ~/.vimrc for user? (Might conflict with nvim +checkhealth) [Y/n]:" vimrc
    if [ -z $vimrc ]; then
        ln -s ~/.config/nvim/init.vim ~/.vimrc
    fi
    yes_edit_no instvim_r "vim/init.vim" "Install init.vim at /root/.config/nvim/init.vim ? (nvim config)" "edit" "YELLOW"
}
yes_edit_no instvim "vim/init.vim" "Install init.vim at ~/.config/nvim/init.vim ? (nvim config)" "edit" "GREEN"

nvim +PlugInstall +qall
nvim +checkhealth

vimsh_r(){ sudo cp -fv vim/vim_nvim.sh /root/.bash_aliases.d/; }

vimsh(){
    cp -fv vim/vim_nvim.sh ~/.bash_aliases.d/
    yes_edit_no vimsh_r "vim/vim_nvim.sh" "Install vim aliases at /root/.bash_aliases.d/? " "yes" "GREEN"
}
yes_edit_no vimsh "vim/vim_nvim.sh" "Install vim aliases at ~/.bash_aliases.d/? " "edit" "GREEN"
