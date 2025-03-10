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
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

#if ! type reade &> /dev/null; then
#     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
#else
#    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
#fi

if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
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

if ! test -f aliases/.bash_aliases.d/package_managers.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/package_managers.sh)" 
else
    source aliases/.bash_aliases.d/package_managers.sh
fi



#. $DIR/setup_git_build_from_source.sh "y" "neovim" "https://github.com" "neovim/neovim" "stable" "sudo apt update; eval "$pac_ins ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y""

if test $machine == 'Mac' && type brew &> /dev/null; then
    if ! type nvim &> /dev/null; then
        brew install neovim
    fi
    if ! type xclip &> /dev/null; then
        readyn -p "Install nvim clipboard? (xsel xclip)" clip
        if [ -z $clip ] || [ "y" == $clip ]; then
            brew install xsel xclip
            echo "${green} If this is for use with ssh on serverside, X11 needs to be forwarded"
            echo "${green} At clientside, 'ForwardX11 yes' also needs to be put in ~/.ssh/config under Host"
            echo "${green} Connection also need to start with -X flag (ssh -X ..@..)${normal}"
            readyn -p "Forward X11 in /etc/ssh/sshd.config?" x11f
            if [ -z $x11f ] || [ "y" == $x11f ]; then
               sudo sed -i 's|.X11Forwarding yes|X11Forwarding yes|g' /etc/ssh/sshd.config
            fi
        fi
    fi
    readyn -p "Install nvim code language support (python, javascript, ruby, perl, ..)?" langs
    if test "$langs" == 'y'; then
        if ! type pylint &> /dev/null; then
            readyn -p "Install nvim-python?" pyscripts
            if [ -z $pyscripts ] || [ "y" == $pyscripts ]; then
                if ! type pyenv &> /dev/null; then 
                    if ! test -f install_pyenv.sh; then
                         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pyenv.sh)" 
                    else
                        ./install_pyenv.sh
                    fi
                fi 

                if ! type pipx &> /dev/null && ! test -f $HOME/.local/bin/pipx; then
                    if ! test -f install_pipx.sh ; then
                         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)" 
                    else
                        ./install_pipx.sh
                    fi
                fi

                if ! type pipx &> /dev/null && test -f $HOME/.local/bin/pipx; then
                    $HOME/.local/bin/pipx install pynvim
                    $HOME/.local/bin/pipx install pylint 
                    $HOME/.local/bin/pipx install jedi 
                else
                    pipx install pynvim 
                    pipx install pylint
                    pipx install jedi
                fi
            fi
        fi
        if ! type npm &> /dev/null || ! npm list -g | grep neovim &> /dev/null; then
            readyn -p "Install nvim-javascript? " jsscripts
            if [ -z $jsscripts ] || [ "y" == $jsscripts ]; then
                brew install npm nodejs
                sudo npm install -g neovim
            fi
        fi
        if ! type gem &> /dev/null || ! gem list | grep neovim &> /dev/null; then
            readyn -p "Install nvim-ruby? " rubyscripts
            if [ -z $rubyscripts ] || [ "y" == $rubyscripts ]; then
                brew install ruby
                if ! test -f install_ruby.sh; then
                     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ruby.sh)" 
                else
                    ./install_ruby.sh
                fi
                gem install neovim
            fi
        fi
         
        #printf "${CYAN}Checking whether perl modules for nvim are installed means initializing cpan ([perl package manager)${normal}\n" 
        if ! type cpanm &> /dev/null; then
            if ! test -f install_cpanm.sh; then
                 eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cpanm.sh)" 
            else
                ./install_cpanm.sh
            fi 
        fi
        readyn -p "Initialize cpan?" cpan_ini
         
        if ! type cpan &> /dev/null || ! cpan -l 2> /dev/null | grep Neovim::Ext &> /dev/null; then
            readyn -p "Install nvim-perl?" perlscripts
            if [ -z $perlscripts ] || [ "y" == $perlscripts ]; then
                brew install cpanminus
                cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
                sudo cpanm --sudo -n Neovim::Ext
                readyn -p "Perl uses cpan for the installation of modules. Initialize cpan? (Will prevent nvim :checkhealth warning)" cpn
                if [ "y" == $cpn ]; then
                    cpan -l
                fi
            fi
        fi
    fi
    if ! type ctags &> /dev/null; then 
        readyn -p "Install ctags?" ctags
        if  [ "y" == $ctags ]; then
            brew install ctags
        fi
    fi
    
elif test $distro_base == "Arch"; then
    if ! type nvim &> /dev/null; then
        eval "$pac_ins neovim "
    fi
    if ! type xclip &> /dev/null; then
        readyn -p "Install nvim clipboard? (xsel xclip)" clip
        if [ -z $clip ] || [ "y" == $clip ]; then
            eval "$pac_ins xsel xclip"
            echo "${green} If this is for use with ssh on serverside, X11 needs to be forwarded"
            echo "${green} At clientside, 'ForwardX11 yes' also needs to be put in ~/.ssh/config under Host"
            echo "${green} Connection also need to start with -X flag (ssh -X ..@..)"
            readyn -p "Forward X11 in /etc/ssh/sshd.config?" x11f
            if [ -z $x11f ] || [ "y" == $x11f ]; then
               sudo sed -i 's|.X11Forwarding yes|X11Forwarding yes|g' /etc/ssh/sshd_config
            fi
        fi
    fi
    readyn -p "Install nvim code language support (python, javascript, ruby, perl, ..)?" langs
    if test "$langs" == 'y'; then
        if ! type pylint &> /dev/null; then
            readyn -p "Install nvim-python?" pyscripts
            if [ -z $pyscripts ] || [ "y" == $pyscripts ]; then
                if ! type pyenv &> /dev/null; then 
                    if ! test -f install_pyenv.sh; then
                         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pyenv.sh)" 
                    else
                        ./install_pyenv.sh
                    fi
                fi 
                 
                if ! type pipx &> /dev/null && ! test -f $HOME/.local/bin/pipx; then
                    if ! test -f install_pipx.sh; then
                         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)" 
                    else
                        ./install_pipx.sh
                    fi
                fi 

                if ! type pipx &> /dev/null && test -f $HOME/.local/bin/pipx; then
                    $HOME/.local/bin/pipx install pynvim
                    $HOME/.local/bin/pipx install pylint 
                    $HOME/.local/bin/pipx install jedi 
                else
                    pipx install pynvim 
                    pipx install pylint
                    pipx install jedi
                fi
            fi
        fi
        if ! type npm &> /dev/null || ! npm list -g | grep neovim &> /dev/null; then
            readyn -p "Install nvim-javascript?" jsscripts
            if [ -z $jsscripts ] || [ "y" == $jsscripts ]; then
                eval "$pac_ins npm nodejs"
                sudo npm install -g neovim
            fi
        fi
        if ! type gem &> /dev/null || ! gem list | grep neovim &> /dev/null; then
            readyn -p "Install nvim-ruby?" rubyscripts
            if [ -z $rubyscripts ] || [ "y" == $rubyscripts ]; then
                eval "$pac_ins ruby"
                if ! test -f install_ruby.sh; then
                     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ruby.sh)" 
                else
                    ./install_ruby.sh
                fi
                gem install neovim
            fi
        fi
        printf "${red}This next prompt might take a while to load since it might initialize cpan (perl)${normal}\n" 
        if ! type cpan &> /dev/null || ! cpan -l 2> /dev/null | grep Neovim::Ext &> /dev/null; then
            readyn -p "Install nvim-perl?" perlscripts
            if [ -z $perlscripts ] || [ "y" == $perlscripts ]; then
                eval "$pac_ins cpanminus"
                cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
                sudo cpanm --sudo -n Neovim::Ext
                readyn -p "Perl uses cpan for the installation of modules. Initialize cpan? (Will prevent nvim :checkhealth warning)" cpn
                if [ "y" == $cpn ]; then
                    cpan -l
                fi
            fi
        fi
    fi 
    if ! type ctags &> /dev/null; then 
        readyn -p "Install ctags?" ctags
        if  [ "y" == $ctags ]; then
            eval "$pac_ins ctags"
        fi
    fi
elif [ $distro_base == "Debian" ];then
    b=$(apt search neovim 2> /dev/null | awk 'NR>2 {print;}' | grep '^neovim/' | awk '{print $2}' | sed 's/~.*//g' | sed 's|\(.*\..*\)\..*|\1|g')
    #Minimum version for Lazy plugin manager
    if [[ $b < 0.8 ]]; then
        echo "Neovim apt version is below 0.8, wich too low to run Lazy.nvim (nvim plugin manager)"
        if ! test -z "$(sudo apt list --installed 2> /dev/null | grep neovim)"; then
            readyn -p "Uninstall apt version of neovim?" nvmapt
            if [ "y" == $nvmapt ]; then
                sudo apt remove neovim
            fi
        fi
        #if ! type nvim &> /dev/null; then
         readyn -n -p "Still wish to install through apt?" nvmapt
         if [ "y" == $nvmapt ]; then
            eval "$pac_ins neovim"
         else
            readyn -p "Install nvim through alternative means (appimage - flatpak - build from source (+ Ubuntu: ppa))?" nvmappmg
            if ! test -z $nvmappmg || [ "y" == $nvmappmg ]; then
                pre="appimage"
                choices="flatpak build"
                prompt="Which one (Appimage/flatpak/build from source)? [Flatpak/appimage/build]: "
                if type add-apt-repository &> /dev/null; then
                    if ! echo $(check-ppa ppa:neovim-ppa/unstable) | grep -q 'NOT'; then
                        pre="ppa-unstable"                        
                        choices="appimage flatpak build"
                        prompt="Which one (Ppa-unstable/appimage/flatpak/build from source)? [Ppa-unstable/appimage/flatpak/build]: "
                    fi
                fi
                if [[ "$arch" =~ "arm" ]]; then
                    echo "${cyan}Arm architecture${normal} sadly still does not support ${red}appimages${normal}"  
                    if ! test $pre == 'ppa-unstable'; then 
                        pre="flatpak"
                        choices="build"
                        prompt="Which one (Flatpak/build from source)? [Flatpak/build]: "
                    else
                        pre="ppa-unstable"
                        choices="flatpak build"
                        prompt="Which one (Ppa-unstable/flatpak/build from source)? [Ppa-unstable/flatpak/build]: "
                    fi
                fi
                reade -Q "GREEN" -i "$pre $choices" -p "$prompt" nvmappmg
                if test "$nvmappmg" == 'ppa-unstable'; then
                    sudo add-apt-repository ppa:neovim-ppa/unstable
                    sudo apt update
                    eval "$pac_ins neovim"
                elif [ "appimage" == "$nvmappmg" ]; then
                    if ! test -f checks/check_appimage_ready.sh; then
                         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_appimage_ready.sh)" 
                    else
                        . ./checks/check_appimage_ready.sh
                    fi
                    if ! test -z "$(sudo apt list --installed 2> /dev/null | grep libfuse2)"; then
                        if ! type curl &> /dev/null; then
                            if test $distro == "Manjaro" || test $distro == "Arch"; then
                                eval "$pac_ins curl"
                            elif test $distro_base == "Debian"; then
                                eval "$pac_ins curl"
                            fi
                        fi
                        if ! type jq &> /dev/null; then
                            if test $distro_base == "Arch"; then
                                eval "$pac_ins jq"
                            elif test $distro_base == "Debian"; then
                                eval "$pac_ins jq"
                            fi
                        fi
                        ltstv=$(curl -sL https://api.github.com/repos/neovim/neovim/releases/latest | jq -r ".tag_name")
                        tmpdir=$(mktemp -d -t nvim-XXXXXXXXXX)
                        curl -o $tmpdir/nvim.appimage https://github.com/neovim/neovim/releases/download/$ltstv/nvim.appimage 
                        curl -o $tmpdir/nvim.appimage.sha256sum https://github.com/neovim/neovim/releases/download/$ltstv/nvim.appimage.sha256sum 
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
                        reade -Q "GREEN" -i "$pre $choices" -p "$prompt"  nvmappmg 
                        if test "flatpak" == "$nvmappmg"; then
                            readyn -p "Install flatpak?" insflpk 
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
                    readyn -p "Install flatpak? " insflpk 
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
                    if ! test -z "$(sudo apt list --installed 2> /dev/null | grep neovim)" &> /dev/null; then
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
    else 
        ${pac_ins} -y neovim 
    fi
        
    if ! type xclip &> /dev/null; then
        readyn -p "Install nvim clipboard? (xsel xclip)" clip
        if [ -z $clip ] || [ "y" == $clip ]; then
            eval "$pac_ins xsel xclip "
            echo "${green} If this is for use with ssh on serverside, X11 needs to be forwarded"
            echo "${green} At clientside, 'ForwardX11 yes' also needs to be put in ~/.ssh/config under Host"
            echo "${green} Connection also need to start with -X flag (ssh -X ..@..)${normal}"
            readyn -n -p "Forward X11 in /etc/ssh/sshd.config?" x11f
            if [ -z $x11f ] || [ "y" == $x11f ]; then
               sudo sed -i 's|.X11Forwarding yes|X11Forwarding yes|g' /etc/ssh/sshd_config
            fi
        fi
    fi
    readyn -p "Install nvim code language support (python, javascript, ruby, perl, ..)?" langs
    if test "$langs" == 'y'; then
        if ! type pylint &> /dev/null; then
            readyn -p "Install nvim-python?" pyscripts
            if [ -z $pyscripts ] || [ "y" == $pyscripts ]; then
                if ! type pyenv &> /dev/null; then 
                    if ! test -f install_pyenv.sh; then
                         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pyenv.sh)" 
                    else
                        ./install_pyenv.sh
                    fi
                fi 
                if ! test -f install_pipx.sh; then
                     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)" 
                else
                    ./install_pipx.sh
                fi

                if ! test -z $upg_pipx && test $upg_pipx == 'y'; then
                    $HOME/.local/bin/pipx install pynvim
                    $HOME/.local/bin/pipx install pylint 
                    $HOME/.local/bin/pipx install jedi 
                else
                    pipx install pynvim 
                    pipx install pylint
                    pipx install jedi
                fi
            fi
        fi

        if ! type npm &> /dev/null || ! npm list -g | grep neovim  &> /dev/null; then
            readyn -p "Install nvim-javascript?" jsscripts
            if [ -z $jsscripts ] || [ "y" == $jsscripts ]; then
                eval "$pac_ins nodejs npm"
                sudo npm install -g neovim
                if [ $(which nvim) == "$HOME/.local/bin/flatpak/nvim" ]; then
                    qry=$(flatpak list | grep node)           
                    if [ ! -z "$qry" ] ; then
                        echo "${green} Flatpak version nvim needs flatpak's SDK for a node provider"
                        readyn -p "Install flatpak node SDK and set in environment?" flpknode
                        if [ -z $flpknode ] || [ "y" == $flpknode ]; then 
                            flatpak install node18
                            #if grep -q "FLATPAK_ENABLE_SDK_EXT*.*node" $ENVVAR; then
                            #    sed -i "s|.export FLATPAK_ENABLE_SDK_EXT=|export FLATPAK_ENABLE_SDK_EXT=|g" $ENVVAR  
                            #    sed -i 's|export FLATPAK_ENABLE_SDK_EXT=\(.*\)node..\(.*\)|export FLATPAK_ENABLE_SDK_EXT=\1node18\2|g' $ENVVAR
                            #elif grep -q "FLATPAK_ENABLE_SDK_EXT" $ENVVAR; then
                            #    sed -i 's|.export FLATPAK_ENABLE_SDK_EXT=|export FLATPAK_ENABLE_SDK_EXT=|g' $ENVVAR
                            #    sed -i 's|export FLATPAK_ENABLE_SDK_EXT=\(.*\)|export FLATPAK_ENABLE_SDK_EXT=\1,node18|g' $ENVVAR
                            #else
                            #    echo 'export FLATPAK_ENABLE_SDK_EXT=node18' $ENVVAR
                            #fi
                            
                        fi
                    fi
                    unset flpknode qry
                    
                fi
            fi
        fi
        
        if ! type gem &> /dev/null || ! gem list | grep neovim &> /dev/null; then
            readyn -p "Install nvim-ruby?" rubyscripts
            if [ -z $rubyscripts ] || [ "y" == $rubyscripts ]; then
                eval "$pac_ins ruby ruby-dev"
                if ! test -f install_ruby.sh; then
                     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ruby.sh)" 
                else
                    ./install_ruby.sh
                fi
                gem install neovim 
            fi
        fi
        
        if ! type cpan &> /dev/null || ! cpan -l 2> /dev/null | grep Neovim::Ext &> /dev/null; then
            readyn -p "Install nvim-perl? " perlscripts
            if [ -z $perlscripts ] || [ "y" == $perlscripts ]; then
                eval "$pac_ins cpanminus"
                cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)
                sudo cpanm --sudo -n Neovim::Ext
                readyn -y -p "Perl uses cpan for the installation of modules. Initialize cpan? (Will prevent nvim :checkhealth warning)" cpn
                if [ "y" == $cpn ]; then
                    cpan -l
                fi
            fi
        fi
    fi 
    
    if ! type ctags &> /dev/null; then
        readyn -p "Install ctags?" ctags
        if [ "y" == $ctags ]; then
            ${pac_ins} universal-ctags
        fi
    fi
fi

cargo install ast-grep

unset rver paths clip x11f pyscripts jsscripts ctags rubyscripts perlscripts nvmbin

if ! type rg &> /dev/null; then
    readyn -p "Install ripgrep (recursive grep)?" rg_ins
    if  [ "y" == $rg_ins ]; then
        if ! test -f install_ripgrep.sh; then
             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ripgrep.sh)" 
        else
            ./install_ripgrep.sh
        fi
    fi
fi

unset rg_ins

if ! type ast-grep &> /dev/null; then
    readyn -p "Install ast-grep (search and rewrite code at large scale using precise AST pattern)?" ast_ins
    if [ "y" == $ast_ins ]; then
        if ! test -f install_ast-grep.sh; then
             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ast-grep.sh)" 
        else
            ./install_ast-grep.sh
        fi
    fi
fi

unset ast_ins

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

    if sudo grep -q "MYVIMRC" $ENVVAR_R; then
        sudo sed -i 's|.export MYVIMRC="|export MYVIMRC=~/.config/nvim/init.vim "|g' $ENVVAR_R
        sudo sed -i 's|.export MYGVIMRC="|export MYGVIMRC=~/.config/nvim/init.vim "|g' $ENVVAR_R
    else
        printf "export MYVIMRC=~/.config/nvim/init.vim\n" | sudo tee -a $ENVVAR_R
        printf "export MYGVIMRC=~/.config/nvim/init.vim\n" | sudo tee -a $ENVVAR_R
    fi

    readyn -p "Set nvim as default for root EDITOR? " vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
        if sudo grep -q "EDITOR" $ENVVAR_R; then
            sudo sed -i "s|.export EDITOR=.*|export EDITOR=$(where_cmd nvim)|g" $ENVVAR_R
        else
            printf "export EDITOR=$(where_cmd nvim)\n" | sudo tee -a $ENVVAR_R
        fi
    fi
    unset vimrc
    
    readyn -p "Set nvim as default for root VISUAL? " vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
       if sudo grep -q "VISUAL" $ENVVAR_R; then
            sudo sed -i "s|.export VISUAL=*|export VISUAL=$(where_cmd nvim)|g" $ENVVAR_R
        else
            printf "export VISUAL=$(where_cmd nvim)\n" | sudo tee -a $ENVVAR_R
        fi
    fi
    unset vimrc

    if ! sudo test -f /root/.vimrc; then
        readyn -Y 'YELLOW' -p "Make symlink for init.vim at /root/.vimrc for user? (Might conflict with nvim +checkhealth) "  vimrc_r
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

    if grep -q "MYVIMRC" $ENVVAR; then
        sed -i "s|.export MYVIMRC=.*|export MYVIMRC=~/.config/nvim/init.vim|g" $ENVVAR
        sed -i "s|.export MYGVIMRC=*|export MYGVIMRC=~/.config/nvim/init.vim|g" $ENVVAR
    else
        printf "export MYVIMRC=~/.config/nvim/init.vim\n" >> $ENVVAR
        printf "export MYGVIMRC=~/.config/nvim/init.vim\n" >> $ENVVAR
    fi

    readyn -p "Set Neovim as MANPAGER? " manvim
    if [ "$manvim" == "y" ]; then
       sed -i 's|.export MANPAGER=.*|export MANPAGER='\''nvim +Man!'\''|g' $ENVVAR
    fi

    readyn -p "Set Neovim as default for user EDITOR? " vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
        if grep -q "EDITOR" $ENVVAR; then
            sed -i "s|.export EDITOR=.*|export EDITOR=$(where_cmd nvim)|g" $ENVVAR
        else
            printf "export EDITOR=$(where_cmd nvim)\n" >> $ENVVAR
        fi
    fi
    unset vimrc
    
    readyn -p "Set Neovim as default for user VISUAL? " vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
       if grep -q "VISUAL" $ENVVAR; then
            sed -i "s|.export VISUAL=*|export VISUAL=$(where_cmd nvim)|g" $ENVVAR
        else
            printf "export VISUAL=$(where_cmd nvim)\n" >> $ENVVAR
        fi
    fi
    unset vimrc
    
    readyn -Y 'YELLOW' -p "Make symlink for init.vim at ~/.vimrc for user? (Might conflict with nvim +checkhealth)" vimrc
    if [ -z $vimrc ] && [ ! -f ~/.vimrc ]; then
        ln -s ~/.config/nvim/init.vim ~/.vimrc
    fi
    yes-no-edit -f instvim_r -g "$dir/init.vim $dir/init.lua.vim $dir/plug_lazy_adapter.vim" -p "Install (neo)vim readconfigs at /root/.config/nvim/ ? (init.vim, init.lua, etc..)" -i "e" -Q "YELLOW"
}
yes-no-edit -f instvim -g "$dir/init.vim $dir/init.lua.vim $dir/plug_lazy_adapter.vim" -p "Install (neo)vim readconfigs at ~/.config/nvim/ ? (init.vim, init.lua, etc..)" -i "e" -Q "GREEN"

unset dir tmpdir tmpfile

#nvim +CocUpdate
nvim +checkhealth
echo "Install Completion language plugins with ':CocInstall coc-..' / Update with :CocUpdate"
echo "Check installed nvim plugins with 'Lazy' / Check installed vim plugins with 'PlugInstalled' (only work on nvim and vim respectively)"

file=vim/.bash_aliases.d/vim_nvim.sh
file1=vim/.bash_completion.d/vim_nvim
if ! test -d vim/.bash_aliases.d/ || ! test -d vim/.bash_completion.d/; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/vim/.bash_aliases.d/vim_nvim.sh
    tmp1=$(mktemp) && curl -o $tmp1 https://raw.githubusercontent.com/excited-bore/dotfiles/main/vim/.bash_completion.d/vim_nvim
    file=$tmp
    file1=$tmp1
fi

vimsh_r(){ 
    sudo cp -fv $file /root/.bash_aliases.d/; 
    sudo cp -fv $file1 /root/.bash_completion.d/; 
}

vimsh(){
    cp -fv $file ~/.bash_aliases.d/
    cp -fv $file1 ~/.bash_completion.d/;
    yes-no-edit vimsh_r -g "$dir/vim_nvim.sh $dir1/vim_nvim" -p "Install vim aliases at /root/.bash_aliases.d/ (and completions at ~/.bash_completion.d/)? " -i "y" -Q "GREEN"
}
yes-no-edit -f vimsh -g "$dir/vim_nvim.sh $dir1/vim_nvim" -p "Install vim aliases at ~/.bash_aliases.d/ (and completions at ~/.bash_completion.d/)? " -i "y" -Q "GREEN"

if ! type nvimpager &> /dev/null; then
    readyn -n -p "Install nvimpager?" vimrc 
    if [ -z "$vimrc" ] || [ "$vimrc" == "y" ]; then
        if ! test -f install_nvimpager.sh; then
             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nvimpager.sh)" 
        else
            ./install_nvimpager.sh
        fi
    fi
fi
unset vimrc dir dir1 tmpdir tmpdir1
