 #DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./checks/check_pathvar.sh
. ./checks/check_distro.sh
. ./readline/rlwrap_scripts.sh

#. $DIR/setup_git_build_from_source.sh "y" "neovim" "https://github.com" "neovim/neovim" "stable" "sudo apt update; sudo apt install ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y"


if [[ $distro == "Arch" || $distro_base == "Arch" ]];then
    yes | sudo pacman -Su neovim 
    reade -Q "GREEN" -i "y" -p "Install nvim clipboard? (xsel xclip) [Y/n]:" "y n" clip
    if [ -z $clip ] || [ "y" == $clip ]; then
        yes | sudo pacman -Su xsel xclip
        echo "${green} If this is for use with ssh on serverside, X11 needs to be forwarded?"
        echo "${green} At clientside, 'ForwardX11 yes' also needs to be put in ~/.ssh/config under Host"
        echo "${green} Connection also need to start with -X flag (ssh -X ..@..)"
        reade -Q "GREEN" -i "n" -p "Forward X11 in /etc/ssh/sshd.config? [Y/n]:" "y n" x11f
        if [ -z $x11f ] || [ "y" == $x11f ]; then
           sudo sed -i 's|.X11Forwarding yes|X11Forwarding yes|g' /etc/ssh/sshd_config
        fi
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-python? [Y/n]:" "y n" pyscripts
    if [ -z $pyscripts ] || [ "y" == $pyscripts ]; then
        yes | sudo pacman -Su python python-pynvim python-pipx
        pipx install pynvim 
        pipx install pylint
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-javascript? [Y/n]:" "y n" jsscripts
    if [ -z $jsscripts ] || [ "y" == $jsscripts ]; then
        yes | sudo pacman -Su npm nodejs
        sudo npm install -g neovim
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-ruby? [Y/n]:" "y n" rubyscripts
    if [ -z $rubyscripts ] || [ "y" == $rubyscripts ]; then
        yes | sudo pacman -Su ruby
        paths=$(gem environment | awk '/- GEM PATH/{flag=1;next}/- GEM CONFIGURATION/{flag=0}flag' | sed 's|     - ||g' | paste -s -d ':')
        if grep -q "GEM" $PATHVAR; then
            sed -i "s|.export GEM_PATH=.*|GEM_PATH=/usr/lib/ruby/gems/3.0.0:$HOME/.local/share/gem/ruby/3.0.0/bin|g" $PATHVAR
            sed -i 's|.export PATH=$PATH:$GEM_PATH|export PATH=$PATH:$GEM_PATH|g' $PATHVAR
        else
            printf "export GEM_PATH=GEM_PATH=/usr/lib/ruby/gems/3.0.0:$HOME/.local/share/gem/ruby/3.0.0/bin\n" >> $PATHVAR
            printf "export PATH=\$PATH:\$GEM_PATH\n" >> $PATHVAR
        fi
        . ~/.bashrc
        gem install neovim
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-perl? [Y/n]:" "y n" perlscripts
    if [ -z $perlscripts ] || [ "y" == $perlscripts ]; then
        yes | sudo apt install cpanminus
        cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
        sudo cpanm --sudo -n Neovim::Ext
    fi
elif [  $distro_base == "Debian" ];then
    b=$(sudo apt search neovim | grep '^neovim/stable' | awk '{print $2}')
    #Minimum version for Lazy plugin manager
    if [[ $b < 0.8 ]]; then
        echo "Neovim version is below 0.8, wich is needed to run Lazy.nvim (nvim plugin manager)"
        
        reade -Q "GREEN" -i "y" -p "Install nvim through flatpak? [Y/n]:" "y n" nvmflpk
        if [ ! -x "$(command -v flatpak)" ]; then
            printf "%s\n" "${blue}No flatpak detected. (Independent package manager from Red Hat){normal}"
            reade -Q "GREEN" -i "y" -p "Install? [Y/n]:" "y n" insflpk 
            if [ "y" == "$insflpk" ]; then
               ./install_flatpak.sh 
            fi
            flatpak install neovim
        else
            yes | sudo apt update
            yes | sudo apt install neovim 
        fi
        unset insflpk nvmflpk
       
        #reade -Q "GREEN" -i "y" -p "Install nvim through binary? [Y/n]:" "y n" nvmbin
        #if [ -z $nvmbin ] || [ "y" == $nvmbin ]; then
            #ltstv=$(curl -sL https://api.github.com/repos/neovim/neovim/releases/latest | jq -r ".tag_name")
            #(mkdir /tmp/neovim
            #cd /tmp/neovim
            #wget https://github.com/neovim/neovim/releases/download/$ltstv/nvim-linux64.tar.gz 
            #wget https://github.com/neovim/neovim/releases/download/$ltstv/nvim-linux64.tar.gz.sha256sum 
            #if [ "$(sha256sum nvim-linux64.tar.gz)" != "$(cat nvim-linux64.tar.gz.sha256sum)" ]; then 
            #    echo "Something went wrong: Sha256sums aren't the same. Try again later"    
            #else
            #    tar -xvf nvim-linux64.tar.gz
            #    
            #    mv -v nvim-linux64 /usr/bin/nvim
            #fi
            #)
        #else
        #fi
    fi
        
    reade -Q "GREEN" -i "y" -p "Install nvim clipboard? (xsel xclip) [Y/n]:" "y n" clip
    if [ -z $clip ] || [ "y" == $clip ]; then
        yes | sudo apt install xsel xclip 
        echo "${green} If this is for use with ssh on serverside, X11 needs to be forwarded?"
        echo "${green} At clientside, 'ForwardX11 yes' also needs to be put in ~/.ssh/config under Host"
        echo "${green} Connection also need to start with -X flag (ssh -X ..@..)"
        reade -Q "GREEN" -i "n" -p "Forward X11 in /etc/ssh/sshd.config? [Y/n]:" "y n" x11f
        if [ -z $x11f ] || [ "y" == $x11f ]; then
           sudo sed -i 's|.X11Forwarding yes|X11Forwarding yes|g' /etc/ssh/sshd_config
        fi
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-python? [Y/n]:" "y n" pyscripts
    if [ -z $pyscripts ] || [ "y" == $pyscripts ]; then
        yes | sudo apt install python3 python3-dev pipx  
        pipx install pynvim
        pipx install pylint
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-javascript? [Y/n]:" "y n" jsscripts
    if [ -z $jsscripts ] || [ "y" == $jsscripts ]; then
        yes | sudo apt install nodejs npm
        sudo npm install -g neovim
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-ruby? [Y/n]:" "y n" rubyscripts
    if [ -z $rubyscripts ] || [ "y" == $rubyscripts ]; then
        yes | sudo apt install ruby
        paths=$(gem environment | awk '/- GEM PATH/{flag=1;next}/- GEM CONFIGURATION/{flag=0}flag' | sed 's|     - ||g' | paste -s -d ':')
        if grep -q "GEM" $PATHVAR; then
            sed -i "s|.export GEM_PATH=.*|GEM_PATH=/usr/lib/ruby/gems/3.0.0:$HOME/.local/share/gem/ruby/3.0.0/bin|g" $PATHVAR
            sed -i 's|.export PATH=$PATH:$GEM_PATH|export PATH=$PATH:$GEM_PATH|g' $PATHVAR
        else
            printf "export GEM_PATH=GEM_PATH=/usr/lib/ruby/gems/3.0.0:$HOME/.local/share/gem/ruby/3.0.0/bin\n" >> $PATHVAR
            printf "export PATH=\$PATH:\$GEM_PATH\n" >> $PATHVAR
        fi
        . ~/.bashrc
        gem install neovim
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim-perl? [Y/n]:" "y n" perlscripts
    if [ -z $perlscripts ] || [ "y" == $perlscripts ]; then
        yes | sudo apt install cpanminus
        cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
        sudo cpanm --sudo -n Neovim::Ext
    fi
fi

unset clip x11f pyscripts jsscripts rubyscripts perlscripts nvmbin

function instvim_r(){
    if ! sudo test -d /root/.config/nvim/; then
        sudo mkdir -p /root/.config/nvim/
    fi
    sudo cp -fv vim/init.vim /root/.config/nvim/init.vim
    sudo cp -fv vim/init.lua.vim ~/.config/nvim/
    sudo cp -fv vim/plug_lazy_adapter.vim ~/.config/nvim/

    if sudo grep -q "MYVIMRC" $PATHVAR_R; then
       sudo sed -i 's|.export MYVIMRC="|export MYVIMRC=~/.config/nvim/init.vim "|g' $PATHVAR_R
        sudo sed -i 's|.export MYGVIMRC="|export MYGVIMRC=~/.config/nvim/init.vim "|g' $PATHVAR_R
    else
        printf "export MYVIMRC=~/.config/nvim/init.vim\n" | sudo tee -a $PATHVAR_R
        printf "export MYGVIMRC=~/.config/nvim/init.vim\n" | sudo tee -a $PATHVAR_R
    fi

    reade -Q "GREEN" -i "y" -p "Set nvim as default for root EDITOR? [Y/n]:" "y n" vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
        if sudo grep -q "EDITOR" $PATHVAR_R; then
            sudo sed -i "s|.export EDITOR=.*|export EDITOR=~/.config/nvim/init.vim|g" $PATHVAR_R
        else
            printf "export EDITOR=~/.config/nvim/init.vim\n" | sudo tee -a $PATHVAR_R
        fi
    fi
    unset vimrc
    
    reade -Q "GREEN" -i "y" -p "Set nvim as default for root VISUAL? [Y/n]:" "y n" vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
       if sudo grep -q "VISUAL" $PATHVAR_R; then
            sudo sed -i "s|.export VISUAL=*|export VISUAL=~/.config/nvim/init.vim|g" $PATHVAR_R
        else
            printf "export VISUAL=~/.config/nvim/init.vim\n" | sudo tee -a $PATHVAR_R
        fi
    fi
    unset vimrc

    reade -Q "YELLOW" -i "y" -p "Make symlink for init.vim at /root/.vimrc for user? (Might conflict with nvim +checkhealth) [Y/n]:" "y n"  vimrc_r
    if [ -z $vimrc_r ] || [ "y" == $vimrc_r ] && [ ! -f /root/.vimrc ]; then
        sudo ln -s /root/.config/nvim/init.vim /root/.vimrc;
    fi
}

function instvim(){
    if [[ ! -d ~/.config/nvim/ ]]; then
        mkdir ~/.config/nvim/
    fi
    cp -fv vim/init.vim ~/.config/nvim/
    cp -fv vim/init.lua.vim ~/.config/nvim/
    cp -fv vim/plug_lazy_adapter.vim ~/.config/nvim/
    
    if grep -q "MYVIMRC" $PATHVAR; then
        sed -i "s|.export MYVIMRC=.*|export MYVIMRC=~/.config/nvim/init.vim|g" $PATHVAR
        sed -i "s|.export MYGVIMRC=*|export MYGVIMRC=~/.config/nvim/init.vim|g" $PATHVAR
    else
        printf "export MYVIMRC=~/.config/nvim/init.vim\n" >> $PATHVAR
        printf "export MYGVIMRC=~/.config/nvim/init.vim\n" >> $PATHVAR
    fi
    
    reade -Q "GREEN" -i "y" -p "Set nvim as default for user EDITOR? [Y/n]:" "y n" vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
        if grep -q "EDITOR" $PATHVAR; then
            sed -i "s|.export EDITOR=.*|export EDITOR=~/.config/nvim/init.vim|g" $PATHVAR
        else
            printf "export EDITOR=~/.config/nvim/init.vim\n" >> $PATHVAR
        fi
    fi
    unset vimrc
    
    reade -Q "GREEN" -i "y" -p "Set nvim as default for user VISUAL? [Y/n]:" "y n" vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
       if grep -q "VISUAL" $PATHVAR; then
            sed -i "s|.export VISUAL=*|export VISUAL=~/.config/nvim/init.vim|g" $PATHVAR
        else
            printf "export VISUAL=~/.config/nvim/init.vim\n" >> $PATHVAR
        fi
    fi
    unset vimrc
    
    reade -Q "YELLOW" -i "y" -p "Make symlink for init.vim at ~/.vimrc for user? (Might conflict with nvim +checkhealth) [Y/n]:" "y n" vimrc
    if [ -z $vimrc ]; then
        ln -s ~/.config/nvim/init.vim ~/.vimrc
    fi
    yes_edit_no instvim_r "vim/init.vim" "Install (neo)vim readconfigs at /root/.config/nvim/ ? (init.vim, init.lua, etc..)" "edit" "YELLOW"
}
yes_edit_no instvim "vim/init.vim vim/init.lua.vim vim.plug_lazy_adapter.vim" "Install (neo)vim readconfigs at ~/.config/nvim/ ? (init.vim, init.lua, etc..)" "edit" "GREEN"

nvim +checkhealth
echo "Install Completion language plugins with ':CocInstall coc-..' / Update with :CocUpdate"
echo "Check installed nvim plugins with 'Lazy'/ Check installed vim plugins with 'PlugInstalled' (only work on vim and nvim respectively)"


vimsh_r(){ 
    sudo mkdir -p /root/.bash_aliases.d/
    sudo cp -fv vim/vim_nvim.sh /root/.bash_aliases.d/; 
}

vimsh(){
    mkdir -p ~/.bash_aliases.d/
    cp -fv vim/vim_nvim.sh ~/.bash_aliases.d/
    yes_edit_no vimsh_r "vim/vim_nvim.sh" "Install vim aliases at /root/.bash_aliases.d/? " "yes" "GREEN"
}
yes_edit_no vimsh "vim/vim_nvim.sh" "Install vim aliases at ~/.bash_aliases.d/? " "edit" "GREEN"
