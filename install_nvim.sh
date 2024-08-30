#!/usr/bin/env bash
 
#DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . checks/check_system.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "n" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

if ! test -f checks/check_aliases_dir.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)" 
else
    . ./checks/check_aliases_dir.sh
fi

if ! test -f checks/check_completions_dir.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
    . ./checks/check_completions_dir.sh
fi



#. $DIR/setup_git_build_from_source.sh "y" "neovim" "https://github.com" "neovim/neovim" "stable" "sudo apt update; sudo apt install ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y"

if test $machine == 'Mac' && type brew &> /dev/null; then
    brew install neovim
    if ! type xclip &> /dev/null; then
        reade -Q "GREEN" -i "y" -p "Install nvim clipboard? (xsel xclip) [Y/n]: " "n" clip
        if [ -z $clip ] || [ "y" == $clip ]; then
            brew install xsel xclip
            echo "${green} If this is for use with ssh on serverside, X11 needs to be forwarded"
            echo "${green} At clientside, 'ForwardX11 yes' also needs to be put in ~/.ssh/config under Host"
            echo "${green} Connection also need to start with -X flag (ssh -X ..@..)"
            reade -Q "GREEN" -i "n" -p "Forward X11 in /etc/ssh/sshd.config? [Y/n]: " "n" x11f
            if [ -z $x11f ] || [ "y" == $x11f ]; then
               sudo sed -i 's|.X11Forwarding yes|X11Forwarding yes|g' /etc/ssh/sshd_config
            fi
        fi
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim code language support (python, javascript, ruby, perl, ..)? [Y/n]: " "n" langs
    if type $langs == 'y'; then
        if ! type pylint &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-python? [Y/n]: " "n" pyscripts
            if [ -z $pyscripts ] || [ "y" == $pyscripts ]; then
                brew install python python-pynvim python-pipx
                pipx install pynvim 
                pipx install pylint
            fi
        fi
        if ! type npm &> /dev/null || ! npm list -g | grep neovim &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-javascript? [Y/n]: " "n" jsscripts
            if [ -z $jsscripts ] || [ "y" == $jsscripts ]; then
                brew install npm nodejs
                sudo npm install -g neovim
            fi
        fi
        if ! type gem &> /dev/null || ! gem list | grep neovim &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-ruby? [Y/n]: " "n" rubyscripts
            if [ -z $rubyscripts ] || [ "y" == $rubyscripts ]; then
                brew install ruby
                rver=$(echo $(ruby --version) | awk '{print $2}' | cut -d. -f-2)'.0'
                paths=$(gem environment | awk '/- GEM PATH/{flag=1;next}/- GEM CONFIGURATION/{flag=0}flag' | sed 's|     - ||g' | paste -s -d ':')
                if grep -q "GEM" $PATHVAR; then
                    sed -i "s|.export GEM_HOME=.*|export GEM_HOME=$HOME/.gem/ruby/$rver|g" $PATHVAR
                    sed -i "s|.export GEM_PATH=.*|export GEM_PATH=/usr/lib/ruby/gems/$rver:$HOME/.local/share/gem/ruby/$rver/bin|g" $PATHVAR
                    sed -i 's|.export PATH=$PATH:$GEM_PATH.*|export PATH=$PATH:$GEM_PATH:$GEM_HOME|g' $PATHVAR
                else
                    printf "export GEM_HOME=$HOME/.gem/ruby/$rver\n" >> $PATHVAR
                    printf "export GEM_PATH=/usr/lib/ruby/gems/$rver:$HOME/.local/share/gem/ruby/$rver/bin\n" >> $PATHVAR
                    printf "export PATH=\$PATH:\$GEM_PATH:\$GEM_HOME\n" >> $PATHVAR
                fi
                #source ~/.bashrc
                gem install neovim
            fi
        fi
        if ! type cpan &> /dev/null || ! cpan -l 2> /dev/null | grep Neovim::Ext &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-perl? [Y/n]: " "n" perlscripts
            if [ -z $perlscripts ] || [ "y" == $perlscripts ]; then
                brew install cpanminus
                cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
                sudo cpanm --sudo -n Neovim::Ext
                reade -Q "GREEN" -i "y" -p "Perl uses cpan for the installation of modules. Initialize cpan? (Will prevent nvim :checkhealth warning) [Y/n]: " cpn
                if [ "y" == $cpn ]; then
                    cpan -l
                fi
            fi
        fi
    fi
    if ! type ctags &> /dev/null; then 
        reade -Q "GREEN" -i "y" -p "Install ctags? [Y/n]: " "n" ctags
        if  [ "y" == $ctags ]; then
            brew install ctags
        fi
    fi
    
elif test $distro == "Arch" || test $distro == "Manjaro"; then
    if ! type nvim &> /dev/null; then
        sudo pacman -S neovim 
    fi
    if ! type xclip &> /dev/null; then
        reade -Q "GREEN" -i "y" -p "Install nvim clipboard? (xsel xclip) [Y/n]: " "n" clip
        if [ -z $clip ] || [ "y" == $clip ]; then
            sudo pacman -S xsel xclip
            echo "${green} If this is for use with ssh on serverside, X11 needs to be forwarded"
            echo "${green} At clientside, 'ForwardX11 yes' also needs to be put in ~/.ssh/config under Host"
            echo "${green} Connection also need to start with -X flag (ssh -X ..@..)"
            reade -Q "GREEN" -i "n" -p "Forward X11 in /etc/ssh/sshd.config? [Y/n]: " "n" x11f
            if [ -z $x11f ] || [ "y" == $x11f ]; then
               sudo sed -i 's|.X11Forwarding yes|X11Forwarding yes|g' /etc/ssh/sshd_config
            fi
        fi
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim code language support (python, javascript, ruby, perl, ..)? [Y/n]: " "n" langs
    if type $langs == 'y'; then
     
        if ! type pylint &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-python? [Y/n]: " "n" pyscripts
            if [ -z $pyscripts ] || [ "y" == $pyscripts ]; then
                sudo pacman -S python python-pynvim python-pipx
                pipx install pynvim 
                pipx install pylint
            fi
        fi
        if ! type npm &> /dev/null || ! npm list -g | grep neovim &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-javascript? [Y/n]: " "n" jsscripts
            if [ -z $jsscripts ] || [ "y" == $jsscripts ]; then
                sudo pacman -S npm nodejs
                sudo npm install -g neovim
            fi
        fi
        if ! type gem &> /dev/null || ! gem list | grep neovim &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-ruby? [Y/n]: " "n" rubyscripts
            if [ -z $rubyscripts ] || [ "y" == $rubyscripts ]; then
                sudo pacman -S ruby
                rver=$(echo $(ruby --version) | awk '{print $2}' | cut -d. -f-2)'.0'
                paths=$(gem environment | awk '/- GEM PATH/{flag=1;next}/- GEM CONFIGURATION/{flag=0}flag' | sed 's|     - ||g' | paste -s -d ':')
                if grep -q "GEM" $PATHVAR; then
                    sed -i "s|.export GEM_HOME=.*|export GEM_HOME=$HOME/.gem/ruby/$rver|g" $PATHVAR
                    sed -i "s|.export GEM_PATH=.*|export GEM_PATH=/usr/lib/ruby/gems/$rver:$HOME/.local/share/gem/ruby/$rver/bin|g" $PATHVAR
                    sed -i 's|.export PATH=$PATH:$GEM_PATH.*|export PATH=$PATH:$GEM_PATH:$GEM_HOME|g' $PATHVAR
                else
                    printf "export GEM_HOME=$HOME/.gem/ruby/$rver\n" >> $PATHVAR
                    printf "export GEM_PATH=/usr/lib/ruby/gems/$rver:$HOME/.local/share/gem/ruby/$rver/bin\n" >> $PATHVAR
                    printf "export PATH=\$PATH:\$GEM_PATH:\$GEM_HOME\n" >> $PATHVAR
                fi
                #source ~/.bashrc
                gem install neovim
            fi
        fi
        if ! type cpan &> /dev/null || ! cpan -l 2> /dev/null | grep Neovim::Ext &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-perl? [Y/n]: " "n" perlscripts
            if [ -z $perlscripts ] || [ "y" == $perlscripts ]; then
                sudo pacman -S cpanminus
                cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
                sudo cpanm --sudo -n Neovim::Ext
                reade -Q "GREEN" -i "y" -p "Perl uses cpan for the installation of modules. Initialize cpan? (Will prevent nvim :checkhealth warning) [Y/n]: " cpn
                if [ "y" == $cpn ]; then
                    cpan -l
                fi
            fi
        fi
    fi 
    if ! type ctags &> /dev/null; then 
        reade -Q "GREEN" -i "y" -p "Install ctags? [Y/n]: " "n" ctags
        if  [ "y" == $ctags ]; then
            sudo pacman -S ctags
        fi
    fi
elif [  $distro_base == "Debian" ];then
    b=$(sudo apt search neovim | grep '^neovim/stable' | awk '{print $2}')
    #Minimum version for Lazy plugin manager
    if [[ $b < 0.8 ]]; then
        echo "Neovim apt version is below 0.8, wich too low to run Lazy.nvim (nvim plugin manager)"
        if ! test -z "$(sudo apt list --installed | grep neovim)"; then
            reade -Q "GREEN" -i "y" -p "Uninstall apt version of neovim? [Y/n]: " "n" nvmapt
            if [ "y" == $nvmapt ]; then
                sudo apt remove neovim
            fi
        fi
        if ! type nvim &> /dev/null; then
            reade -Q "YELLOW" -i "n" -p "Still wish to install through apt? [N/y]: " "y" nvmapt
            if [ "y" == $nvmapt ]; then
                sudo apt install neovim
            else
                reade -Q "GREEN" -i "y" -p "Install nvim through alternative means (appimage - flatpak - build from source)? [Y/n]: " "n" nvmappmg
                if ! test -z $nvmappmg || [ "y" == $nvmappmg ]; then
                    pre="appimage"
                    choices="flatpak build"
                    prompt="Which one (Appimage/flatpak/build from source)? [Flatpak/appimage/build]: "
                    if [[ "$arch" =~ "arm" ]]; then
                        echo "${cyan}Arm architecture${normal} sadly still does not support ${red}appimages${normal}"  
                        pre="flatpak"
                        choices="build"
                        prompt="Which one (Flatpak/build from source)? [Flatpak/build]: "
                    fi
                    reade -Q "GREEN" -i "$pre" -p "$prompt" "$choices" nvmappmg
                    if [ "appimage" == "$nvmappmg" ]; then
                        if ! test -f checks/check_appimage_ready.sh; then
                             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_appimage_ready.sh)" 
                        else
                            . ./checks/check_appimage_ready.sh
                        fi
                        if ! test -z "$(sudo apt list --installed | grep libfuse2)"; then
                            if ! type curl &> /dev/null; then
                                if test $distro == "Manjaro" || test $distro == "Arch"; then
                                    sudo pacman -S curl
                                elif test $distro_base == "Debian"; then
                                    sudo apt install curl
                                fi
                            fi
                            if ! type jq &> /dev/null; then
                                if test $distro == "Manjaro" || test $distro == "Arch"; then
                                    sudo pacman -S jq
                                elif test $distro_base == "Debian"; then
                                    sudo apt install jq
                                fi
                            fi
                            ltstv=$(curl -sL https://api.github.com/repos/neovim/neovim/releases/latest | jq -r ".tag_name")
                            tmpdir=$(mktemp -d -t nvim-XXXXXXXXXX)
                            wget -P $tmpdir https://github.com/neovim/neovim/releases/download/$ltstv/nvim.appimage 
                            wget -P $tmpdir https://github.com/neovim/neovim/releases/download/$ltstv/nvim.appimage.sha256sum 
                            if ! [ "$(sha256sum $tmpdir/nvim.appimage | awk '{print $1}')" == "$(cat $tmpdir/nvim.appimage.sha256sum | awk '{print $1}')" ]; then 
                                   echo "Something went wrong: Sha256sums aren't the same. Try again later"    
                            else
                                chmod u+x $tmpdir/nvim.appimage
                                sudo mv "$tmpdir/nvim.appimage" /usr/local/bin/nvim
                            fi
                        else
                            pre="flatpak"
                            choices="build"
                            prompt="Can't use appimages without libfuse2. What other method to install neovim would you try? (Flatpak/build from source)? [Flatpak/build]: "
                            reade -Q "GREEN" -i "$pre" -p "$prompt" "$choices" nvmappmg 
                            if test "flatpak" == "$nvmappmg"; then
                                reade -Q "GREEN" -i "y" -p "Install flatpak? [Y/n]: " "n" insflpk 
                                if [ "y" == "$insflpk" ]; then
                                    if ! test -f install_flatpak.sh; then
                                        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)" 
                                    else
                                        ./install_flatpak.sh 
                                    fi
                                fi
                                flatpak install neovim 
                            elif test "build" == "$nvmappmg"; then
                                echo "Make sure you test yourself if branch stable fails. Check 'install_nvim.sh' and checkout different branches"
                                if ! test -z "$(sudo apt list --installed | grep neovim)" &> /dev/null; then
                                    echo "Lets start by removing stuff related to installed 'neovim' packages"
                                    sudo apt autoremove neovim
                                    echo "Then, install some necessary buildtools"
                                fi
                                sudo apt update
                                sudo apt-get install git ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
                                tmpdir=$(mktemp -d -t nvim-XXXXXXXXXX)
                                git clone https://github.com/neovim/neovim $tmpdir
                                (cd $tmpdir/neovim && git checkout neovim && git checkout stable && make CMAKE_BUILD_TYPE=RelWithDebInfo
                                cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb)   
                            else
                                echo "FYI: There's also snap (package manager) wich you could try"
                                return 1
                            fi
                        fi
                    elif test "flatpak" == "$nvmappmg"; then
                        reade -Q "GREEN" -i "y" -p "Install flatpak? [Y/n]: " "n" insflpk 
                        if [ "y" == "$insflpk" ]; then
                            if ! test -f install_flatpak.sh; then
                                eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)" 
                            else
                                ./install_flatpak.sh 
                            fi
                        fi
                        flatpak install neovim 
                    elif test "build" == "$nvmappmg"; then
                        echo "Make sure you test yourself if branch stable fails. Check 'install_nvim.sh' and checkout different branches"
                        if ! test -z "$(sudo apt list --installed | grep neovim)" &> /dev/null; then
                            echo "Lets start by removing stuff related to installed 'neovim' packages"
                            sudo apt autoremove neovim
                            echo "Then, install some necessary buildtools"
                        fi
                        sudo apt update
                        sudo apt-get install git ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen
                        tmpdir=$(mktemp -d -t nvim-XXXXXXXXXX)
                        git clone https://github.com/neovim/neovim $tmpdir
                        (cd $tmpdir/neovim && git checkout neovim && git checkout stable && make CMAKE_BUILD_TYPE=RelWithDebInfo
                        cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb)   
                    else
                        echo "FYI: There's also snap (package manager) wich you could try"
                        return 1
                    fi
                fi
            fi
            unset nvmapt nvmappmg insflpk nvmflpk
        fi
    fi
        
    if ! type xclip &> /dev/null; then
        reade -Q "GREEN" -i "y" -p "Install nvim clipboard? (xsel xclip) [Y/n]: " "n" clip
        if [ -z $clip ] || [ "y" == $clip ]; then
            sudo apt install xsel xclip 
            echo "${green} If this is for use with ssh on serverside, X11 needs to be forwarded"
            echo "${green} At clientside, 'ForwardX11 yes' also needs to be put in ~/.ssh/config under Host"
            echo "${green} Connection also need to start with -X flag (ssh -X ..@..)"
            reade -Q "GREEN" -i "n" -p "Forward X11 in /etc/ssh/sshd.config? [Y/n]: " "n" x11f
            if [ -z $x11f ] || [ "y" == $x11f ]; then
               sudo sed -i 's|.X11Forwarding yes|X11Forwarding yes|g' /etc/ssh/sshd_config
            fi
        fi
    fi
    reade -Q "GREEN" -i "y" -p "Install nvim code language support (python, javascript, ruby, perl, ..)? [Y/n]: " "n" langs
    if type $langs == 'y'; then
     
        if ! type pylint &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-python? [Y/n]: " "n" pyscripts
            if [ -z $pyscripts ] || [ "y" == $pyscripts ]; then
                sudo apt install python3 python3-dev python3-pynvim pipx  
                pipx install pynvim
                pipx install pylint
            fi
        fi

        if ! type npm &> /dev/null || ! npm list -g | grep neovim  &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-javascript? [Y/n]: " "n" jsscripts
            if [ -z $jsscripts ] || [ "y" == $jsscripts ]; then
                sudo apt install nodejs npm
                sudo npm install -g neovim
                if [ $(which nvim) == "$HOME/.local/bin/flatpak/nvim" ]; then
                    qry=$(flatpak list | grep node)           
                    if [ ! -z "$qry" ] ; then
                        echo "${green} Flatpak version nvim needs flatpak's SDK for a node provider"
                        reade -Q "GREEN" -i "y" -p "Install flatpak node SDK and set in environment? [Y/n]: " "n" flpknode
                        if [ -z $flpknode ] || [ "y" == $flpknode ]; then 
                            flatpak install node18
                            #if grep -q "FLATPAK_ENABLE_SDK_EXT*.*node" $PATHVAR; then
                            #    sed -i "s|.export FLATPAK_ENABLE_SDK_EXT=|export FLATPAK_ENABLE_SDK_EXT=|g" $PATHVAR  
                            #    sed -i 's|export FLATPAK_ENABLE_SDK_EXT=\(.*\)node..\(.*\)|export FLATPAK_ENABLE_SDK_EXT=\1node18\2|g' $PATHVAR
                            #elif grep -q "FLATPAK_ENABLE_SDK_EXT" $PATHVAR; then
                            #    sed -i 's|.export FLATPAK_ENABLE_SDK_EXT=|export FLATPAK_ENABLE_SDK_EXT=|g' $PATHVAR
                            #    sed -i 's|export FLATPAK_ENABLE_SDK_EXT=\(.*\)|export FLATPAK_ENABLE_SDK_EXT=\1,node18|g' $PATHVAR
                            #else
                            #    echo 'export FLATPAK_ENABLE_SDK_EXT=node18' $PATHVAR
                            #fi
                            
                        fi
                    fi
                    unset flpknode qry
                    
                fi
            fi
        fi
        
        if ! type gem &> /dev/null || ! gem list | grep neovim &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-ruby? [Y/n]: " "n" rubyscripts
            if [ -z $rubyscripts ] || [ "y" == $rubyscripts ]; then
                sudo apt install ruby ruby-dev
                rver=$(echo $(ruby --version) | awk '{print $2}' | cut -d. -f-2)'.0'
                paths=$(gem environment | awk '/- GEM PATH/{flag=1;next}/- GEM CONFIGURATION/{flag=0}flag' | sed 's|     - ||g' | paste -s -d ':')
                if grep -q "GEM" $PATHVAR; then
                    sed -i "s|.export GEM_HOME=.*|export GEM_HOME=$HOME/.gem/ruby/$rver|g" $PATHVAR
                    
                    sed -i "s|.export GEM_PATH=.*|export GEM_PATH=/usr/lib/ruby/gems/$rver:$HOME/.local/share/gem/ruby/$rver/bin|g" $PATHVAR
                    sed -i 's|.export PATH=$PATH:$GEM_PATH.*|export PATH=$PATH:$GEM_PATH:$GEM_HOME|g' $PATHVAR
                else
                    printf "export GEM_HOME=$HOME/.gem/ruby/$rver\n" >> $PATHVAR
                    
                    printf "export GEM_PATH=/usr/lib/ruby/gems/$rver:$HOME/.local/share/gem/ruby/$rver/bin\n" >> $PATHVAR
                    printf "export PATH=\$PATH:\$GEM_PATH:\$GEM_HOME\n" >> $PATHVAR
                fi
                source ~/.bashrc
                gem install neovim 
            fi
        fi
        
        if ! type cpan &> /dev/null || ! cpan -l 2> /dev/null | grep Neovim::Ext &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Install nvim-perl? [Y/n]: " "n" perlscripts
            if [ -z $perlscripts ] || [ "y" == $perlscripts ]; then
                sudo apt install cpanminus
                cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
                sudo cpanm --sudo -n Neovim::Ext
                reade -Q "GREEN" -i "y" -p "Perl uses cpan for the installation of modules. Initialize cpan? (Will prevent nvim :checkhealth warning) [Y/n]: " cpn
                if [ "y" == $cpn ]; then
                    cpan -l
                fi
            fi
        fi
    fi 

    if ! type ctags &> /dev/null; then
        reade -Q "GREEN" -i "y" -p "Install ctags? [Y/n]: " "n" ctags
        if  [ "y" == $ctags ]; then
            sudo apt install universal-ctags
        fi
    fi
fi

unset rver paths clip x11f pyscripts jsscripts ctags rubyscripts perlscripts nvmbin

if ! test -d vim/; then
    tmpdir=$(mktemp -d -t nvim-XXXXXXXXXX)
    tmpfile=$(mktemp)
    curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/download_git_directory.sh | tee "$tmpfile" &> /dev/null
    chmod u+x "$tmpfile"
    eval $tmpfile https://github.com/excited-bore/dotfiles/tree/main/vim/.config/nvim $tmpdir
    dir=$tmpdir/vim/.config/nvim
else
    dir=vim/.config/nvim 
fi

if ! grep -q "\"Plugin 'Exafunction/codeium.vim'" "$dir/init.vim"; then
    sed -i "s|Plugin 'Exafunction/codeium.vim'|\"Plugin 'Exafunction/codeium.vim'|g" "$dir/init.vim" 
fi

function instvim_r(){
    if ! sudo test -d /root/.config/nvim/; then
        sudo mkdir -p /root/.config/nvim/
    fi
    sudo cp -bfv $dir/* /root/.config/nvim/
    if ! sudo test -z $(ls /root/.config/nvim/*~ &> /dev/null); then 
        sudo bash -c 'gio trash /root/.config/nvim/*~'
    fi
    # Symlink configs to flatpak dirs for possible flatpak nvim use
    if [ -x "$(command -v flatpak)" ] && echo "$(flatpak list)" | grep -q "neovim"; then
        sudo mkdir -p /root/.var/app/io.neovim.nvim/config/nvim/
        sudo ln -s /root/.config/nvim/* /root/.var/app/io.neovim.nvim/config/nvim/
    fi

    if sudo grep -q "MYVIMRC" $PATHVAR_R; then
        sudo sed -i 's|.export MYVIMRC="|export MYVIMRC=~/.config/nvim/init.vim "|g' $PATHVAR_R
        sudo sed -i 's|.export MYGVIMRC="|export MYGVIMRC=~/.config/nvim/init.vim "|g' $PATHVAR_R
    else
        printf "export MYVIMRC=~/.config/nvim/init.vim\n" | sudo tee -a $PATHVAR_R
        printf "export MYGVIMRC=~/.config/nvim/init.vim\n" | sudo tee -a $PATHVAR_R
    fi

    reade -Q "GREEN" -i "y" -p "Set nvim as default for root EDITOR? [Y/n]: " "n" vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
        if sudo grep -q "EDITOR" $PATHVAR_R; then
            sudo sed -i "s|.export EDITOR=.*|export EDITOR=~/.config/nvim/init.vim|g" $PATHVAR_R
        else
            printf "export EDITOR=~/.config/nvim/init.vim\n" | sudo tee -a $PATHVAR_R
        fi
    fi
    unset vimrc
    
    reade -Q "GREEN" -i "y" -p "Set nvim as default for root VISUAL? [Y/n]: " "n" vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
       if sudo grep -q "VISUAL" $PATHVAR_R; then
            sudo sed -i "s|.export VISUAL=*|export VISUAL=~/.config/nvim/init.vim|g" $PATHVAR_R
        else
            printf "export VISUAL=~/.config/nvim/init.vim\n" | sudo tee -a $PATHVAR_R
        fi
    fi
    unset vimrc

    if ! sudo test -f /root/.vimrc; then
        reade -Q "YELLOW" -i "y" -p "Make symlink for init.vim at /root/.vimrc for user? (Might conflict with nvim +checkhealth) [Y/n]: " "n"  vimrc_r
        if [ -z $vimrc_r ] || [ "y" == $vimrc_r ] && [ ! -f /root/.vimrc ]; then
            sudo ln -s /root/.config/nvim/init.vim /root/.vimrc;
        fi
    fi
}


function instvim(){
    if [[ ! -d ~/.config/nvim/ ]]; then
        mkdir ~/.config/nvim/
    fi
    
    cp -bfv $dir/* ~/.config/nvim/

    if ! test -z $(ls ~/.config/nvim/*~ &> /dev/null); then
        gio trash ~/.config/nvim/*~
    fi

    # Symlink configs to flatpak dirs for possible flatpak nvim use
    if [ -x "$(command -v flatpak)" ] && echo "$(flatpak list)" | grep -q "neovim"; then
        mkdir -p ~/.var/app/io.neovim.nvim/config/nvim/
        ln -s ~/.config/nvim/* ~/.var/app/io.neovim.nvim/config/nvim/
    fi

    if grep -q "MYVIMRC" $PATHVAR; then
        sed -i "s|.export MYVIMRC=.*|export MYVIMRC=~/.config/nvim/init.vim|g" $PATHVAR
        sed -i "s|.export MYGVIMRC=*|export MYGVIMRC=~/.config/nvim/init.vim|g" $PATHVAR
    else
        printf "export MYVIMRC=~/.config/nvim/init.vim\n" >> $PATHVAR
        printf "export MYGVIMRC=~/.config/nvim/init.vim\n" >> $PATHVAR
    fi

    reade -Q "GREEN" -i "y" -p "Set Neovim as MANPAGER? [Y/n]: " "n" manvim
    if [ "$manvim" == "y" ]; then
       sed -i 's|.export MANPAGER=.*|export MANPAGER='\''nvim +Man!'\''|g' $PATHVAR
    fi

    reade -Q "GREEN" -i "y" -p "Set Neovim as default for user EDITOR? [Y/n]: " "n" vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
        if grep -q "EDITOR" $PATHVAR; then
            sed -i "s|.export EDITOR=.*|export EDITOR=~/.config/nvim/init.vim|g" $PATHVAR
        else
            printf "export EDITOR=~/.config/nvim/init.vim\n" >> $PATHVAR
        fi
    fi
    unset vimrc
    
    reade -Q "GREEN" -i "y" -p "Set Neovim as default for user VISUAL? [Y/n]: " "n" vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
       if grep -q "VISUAL" $PATHVAR; then
            sed -i "s|.export VISUAL=*|export VISUAL=~/.config/nvim/init.vim|g" $PATHVAR
        else
            printf "export VISUAL=~/.config/nvim/init.vim\n" >> $PATHVAR
        fi
    fi
    unset vimrc
    
    reade -Q "YELLOW" -i "y" -p "Make symlink for init.vim at ~/.vimrc for user? (Might conflict with nvim +checkhealth) [Y/n]: " "n" vimrc
    if [ -z $vimrc ] && [ ! -f ~/.vimrc ]; then
        ln -s ~/.config/nvim/init.vim ~/.vimrc
    fi
    yes_edit_no instvim_r "$dir/init.vim $dir/init.lua.vim $dir/plug_lazy_adapter.vim" "Install (neo)vim readconfigs at /root/.config/nvim/ ? (init.vim, init.lua, etc..)" "edit" "YELLOW"
}
yes_edit_no instvim "$dir/init.vim $dir/init.lua.vim $dir/plug_lazy_adapter.vim" "Install (neo)vim readconfigs at ~/.config/nvim/ ? (init.vim, init.lua, etc..)" "edit" "GREEN"

unset dir tmpdir tmpfile

nvim +CocUpdate
nvim +checkhealth
echo "Install Completion language plugins with ':CocInstall coc-..' / Update with :CocUpdate"
echo "Check installed nvim plugins with 'Lazy' / Check installed vim plugins with 'PlugInstalled' (only work on nvim and vim respectively)"

dir=vim/.bash_aliases.d
dir1=vim/.bash_completions.d
if ! test -d vim/.bash_aliases.d/ || ! test -d vim/.bash_completions.d/; then
    tmpdir=$(mktemp -d -t nvim-XXXXXXXXXX)
    tmpdir1=$(mktemp -d -t nvim-XXXXXXXXXX)
    wget -P $tmpdir https://raw.githubusercontent.com/excited-bore/dotfiles/main/vim/.bash_aliases.d/vim_nvim.sh
    wget -P $tmpdir1 https://raw.githubusercontent.com/excited-bore/dotfiles/main/vim/.bash_completions.d/vim_nvim
    dir=$tmpdir
    dir1=$tmpdir1
fi

vimsh_r(){ 
    sudo cp -fv $dir/vim_nvim.sh /root/.bash_aliases.d/; 
    sudo cp -fv $dir1/vim_nvim /root/.bash_completion.d/; 
}

vimsh(){
    cp -fv $dir/vim_nvim.sh ~/.bash_aliases.d/
    cp -fv $dir1/vim_nvim ~/.bash_completion.d/;
    yes_edit_no vimsh_r "$dir/vim_nvim.sh $dir1/vim_nvim" "Install vim aliases at /root/.bash_aliases.d/ (and completions at ~/.bash_completion.d/)? " "yes" "GREEN"
}
yes_edit_no vimsh "$dir/vim_nvim.sh $dir1/vim_nvim" "Install vim aliases at ~/.bash_aliases.d/ (and completions at ~/.bash_completion.d/)? " "edit" "GREEN"

if ! type nvimpager &> /dev/null; then
    reade -Q "YELLOW" -i "n" -p "Install nvimpager? [N/y]: " "n" vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
        if ! test -f install_nvimpager.sh; then
             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nvimpager.sh)" 
        else
            ./install_nvimpager.sh
        fi
    fi
fi
unset vimrc dir dir1 tmpdir tmpdir1
