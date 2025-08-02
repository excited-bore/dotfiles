#!/usr/bin/env bash

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

DIR=$(get-script-dir)

if ! test -f checks/check_envvar_aliases_completions_keybinds.sh; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar_aliases_completions_keybinds.sh)
else
    . ./checks/check_envvar_aliases_completions_keybinds.sh
fi

#. $DIR/setup_git_build_from_source.sh "y" "neovim" "https://github.com" "neovim/neovim" "stable" "sudo apt update; eval "$pac_ins ninja-build gettext libtool libtool-bin cmake g++ pkg-config unzip curl doxygen" "make CMAKE_BUILD_TYPE=RelWithDebInfo; sudo make install" "sudo make uninstall" "make distclean; make deps" "y""

if [[ "$distro_base" == "Debian" ]]; then

    vrs=0
    lazi=8
    #ruby=0.10.0

    #Minimum version for Lazy plugin manager
    vrs=$(apt search neovim 2>/dev/null | awk 'NR>2 {print;}' | grep '^neovim/' | awk '{print $2}' | sed 's/~.*//g' | sed 's|\(.*\..*\)\..*|\1|g' | cut -d. -f2)

    if version-higher $lazi $vrs; then
        echo "Neovim apt version ($(apt search neovim 2>/dev/null | awk 'NR>2 {print;}' | grep '^neovim/' | awk '{print $2}') is below 0.$lazi wich is too low to run Lazy.nvim (nvim plugin manager)"
        #version-higher $ruby $vrs && echo "Neovim apt version is below $ruby wich is too low to install ruby dependencies for nvim"
        if test -n "$(sudo apt list --installed 2>/dev/null | grep neovim)"; then
            readyn -p "Uninstall apt version of neovim?" nvmapt
            if [[ "y" == "$nvmapt" ]]; then
                eval "$pac_rm_y neovim"
            fi
        fi
    fi

    pre="makedeb"
    choices="appimage flatpak apt build"
    prompt="Which one (Makedeb/appimage/flatpak/apt/build from source)? [Makedeb/appimage/flatpak/apt/build]: "
    
    if [[ "$distro" == 'Ubuntu' ]]; then
	if ! echo $(check-ppa ppa:neovim-ppa/unstable) | grep -q 'NOT' && ! echo $(check-ppa ppa:neovim-ppa/stable) | grep -q 'NOT'; then  
            pre="ppa-stable"
            choices="ppa-unstable makedeb appimage flatpak apt build"
            prompt="Which one (Ppa-stable/ppa-unstable/makedeb/appimage/flatpak/apt/build from source)? [Ppa-stable/ppa-unstable/makedeb/appimage/flatpak/apt/build]: "
        elif ! echo $(check-ppa ppa:neovim-ppa/unstable) | grep -q 'NOT'; then
            pre="ppa-unstable"
            choices="makedeb appimage flatpak apt build"
            prompt="Which one (Ppa-unstable/makedeb/appimage/flatpak/apt/build from source)? [Ppa-unstable/makedeb/appimage/flatpak/apt/build]: "
        elif ! echo $(check-ppa ppa:neovim-ppa/stable) | grep -q 'NOT'; then
            pre="ppa-stable"
            choices="makedeb appimage flatpak apt build"
            prompt="Which one (Ppa-stable/makedeb/appimage/flatpak/apt/build from source)? [Ppa-stable/makedeb/appimage/flatpak/apt/build]: "
        fi
    else
        pre='makedeb' 
        choices="appimage flatpak apt build"
        prompt="Which one (Makedeb/appimage/flatpak/apt/build from source)? [Makedeb/appimage/flatpak/apt/build]: "
    fi
    
    if [[ "$arch" =~ "arm" ]]; then
        echo "${cyan}Arm architecture${normal} sadly still does not support ${red}appimages${normal}"
        if ! [[ "$pre" == 'ppa-unstable' ]] && ! [[ "$pre" == 'ppa-stable' ]]; then
            pre="makedeb"
            choices="flatpak apt build"
            prompt="Which one (makedeb/flatpak/apt/build from source)? [Makedeb/flatpak/apt/build]: "
        else
	    if [[ "$prompt" =~ 'ppa-unstable' ]] || [[ "$prompt" =~ 'ppa-stable' ]]; then
	    	if [[ "$prompt" =~ 'ppa-unstable' ]] && [[ "$prompt" =~ 'ppa-stable' ]]; then
		    pre='ppa-stable'
	            choices="ppa-unstable makedeb flatpak apt build"
		    prompt="Which one (Ppa-stable/ppa-unstable/makedeb/flatpak/build from source)? [Ppa-stable/ppa-unstable/makedeb/flatpak/apt/build]: "
	    	elif [[ "$prompt" =~ 'ppa-unstable' ]]; then
	    	    pre='ppa-unstable'
	            choices="makedeb flatpak apt build"
		    prompt="Which one (Ppa-unstable/makedeb/flatpak/build from source)? [Ppa-unstable/makedeb/flatpak/apt/build]: "
		elif [[ "$prompt" =~ 'ppa-stable' ]]; then
		    pre='ppa-stable'
	            choices="makedeb flatpak apt build"
		    prompt="Which one (Ppa-stable/makedeb/flatpak/build from source)? [Ppa-stable/makedeb/flatpak/apt/build]: "
		fi 
	    fi
        fi
    fi
    
    reade -Q "GREEN" -i "$pre $choices" -p "$prompt" nvmappmg
    if [[ "$nvmappmg" == 'ppa-unstable' ]]; then
        sudo add-apt-repository ppa:neovim-ppa/unstable
        eval "${pac_up}"
        eval "${pac_ins_y} neovim"
    elif [[ "$nvmappmg" == 'ppa-stable' ]]; then
        sudo add-apt-repository ppa:neovim-ppa/stable
        eval "${pac_up}"
        eval "${pac_ins_y} neovim"
    elif [[ "$nvmappmg" == 'makedeb' ]]; then
        if ! hash makedeb &> /dev/null; then
            if ! test -f install_makedeb.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_makedeb.sh)
            else
                . ./install_makedeb.sh 
            fi
        fi

        tmpd=$(mktemp -d)
        git clone https://mpr.makedeb.org/neovim $tmpd
        #if ! [[ "$arch" =~ arm ]]; then
            (cd $tmpd/
            makedeb -si)
        #else
        #    (cd $tmpd/
        #    makedeb -s
        #    cd neovim-*/
        #    make CMAKE_BULD_TYPE='release'
        #    sudo make CMAKE_INSTALL_PREFIX='/usr' install)
        #fi
    elif [[ "appimage" == "$nvmappmg" ]]; then
        if ! test -f checks/check_appimage_ready.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_appimage_ready.sh)
        else
            . ./checks/check_appimage_ready.sh
        fi
        if test -n "$(sudo apt list --installed 2>/dev/null | grep libfuse2)"; then
            if ! hash curl &>/dev/null; then
                eval "${pac_ins_y}" curl
            fi
            if ! hash jq &>/dev/null; then
                eval "${pac_ins_y}" jq
            fi
            ltstv=$(wget-curl https://api.github.com/repos/neovim/neovim/releases/latest | jq -r ".tag_name")
            tmpdir=$(mktemp -d -t nvim-XXXXXXXXXX)
            if [[ "$arch" == 'amd64' ]] || [[ "$arch" == 'amd32' ]] || [[ "$arch" == '386' ]]; then
                nvarch='x86_64' 
            elif [[ "$arch" =~ 'arm' ]]; then
                nvarch='arm64'
            fi
            wget-aria-name $tmpdir/nvim.appimage https://github.com/neovim/neovim/releases/download/$ltstv/nvim-linux-$nvarch.appimage
            
            # Shasum became unsupported in later versions ig 
            #wget-aria-name $tmpdir/nvim.appimage.sha256sum https://github.com/neovim/neovim/releases/download/$ltstv/nvim.appimage.sha256sum
            #if ! [[ "$(sha256sum $tmpdir/nvim.appimage | awk '{print $1}')" == "$(cat $tmpdir/nvim.appimage.sha256sum | awk '{print $1}')" ]]; then
            #    echo "Something went wrong: Sha256sums aren't the same. Try again later"
            #else
            chmod u+x $tmpdir/nvim.appimage
            sudo mv "$tmpdir/nvim.appimage" /usr/local/bin/nvim
            #fi
            #if [[ "$distro_base" == 'Debian' ]]; then
                # update default paths for Debian-based systems, taken straight from nvim github wiki 
                # https://github.com/neovim/neovim/wiki/Installing-Neovim/921fe8c40c34dd1f3fb35d5b48c484db1b8ae94b#debian

                # Set the above with the correct path, then run the rest of the commands:
                #CUSTOM_NVIM_PATH=/usr/local/bin/nvim.appimage
                #set -u
                #sudo update-alternatives --install /usr/bin/ex ex "${CUSTOM_NVIM_PATH}" 110
                #sudo update-alternatives --install /usr/bin/vi vi "${CUSTOM_NVIM_PATH}" 110
                #sudo update-alternatives --install /usr/bin/view view "${CUSTOM_NVIM_PATH}" 110
                #sudo update-alternatives --install /usr/bin/vim vim "${CUSTOM_NVIM_PATH}" 110
                #sudo update-alternatives --install /usr/bin/vimdiff vimdiff "${CUSTOM_NVIM_PATH}" 110 
            #fi
        else
            pre="flatpak"
            choices="build"
            prompt="Can't use appimages without libfuse2. What other method to install neovim would you try? (Flatpak/build from source)? [Flatpak/build]: "
            reade -Q "GREEN" -i "$pre $choices" -p "$prompt" nvmappmg
            if [[ "flatpak" == "$nvmappmg" ]]; then
                readyn -p "Install flatpak?" insflpk
                if [[ "y" == "$insflpk" ]]; then
                    if ! test -f install_flatpak.sh; then
                        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)
                    else
                        . ./install_flatpak.sh
                    fi
                fi
                flatpak install neovim
            elif [[ "build" == "$nvmappmg" ]]; then
                echo "Make sure you test yourself if branch stable fails. Check 'install_nvim.sh' and checkout different branches"
                if ! test -z "$(sudo apt list --installed | grep neovim)" &>/dev/null; then
                    echo "Lets start by removing stuff related to installed 'neovim' packages"
                    sudo apt autoremove -y neovim
                    echo "Then, install some necessary buildtools"
                fi
                sudo apt update
                eval "$pac_ins_y git ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen"
                tmpdir=$(mktemp -d -t nvim-XXXXXXXXXX)
                git clone https://github.com/neovim/neovim $tmpdir
                (
                    cd $tmpdir/neovim && git checkout neovim && git checkout stable && make CMAKE_BUILD_TYPE=RelWithDebInfo
                    cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
                )
            else
                echo "FYI: There's also snap (package manager) wich you could try"
                return 1
            fi
        fi
    elif [[ "flatpak" == "$nvmappmg" ]]; then
        readyn -p "Install flatpak? " insflpk
        if [[ "y" == "$insflpk" ]]; then
            if ! test -f install_flatpak.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)
            else
                . ./install_flatpak.sh
            fi
        fi
        flatpak install neovim
    elif [[ "build" == "$nvmappmg" ]]; then
        echo "Make sure you test yourself if branch stable fails. Check 'install_nvim.sh' and checkout different branches"
        if ! test -z "$(sudo apt list --installed 2>/dev/null | grep neovim)" &>/dev/null; then
            echo "Lets start by removing stuff related to installed 'neovim' packages"
            sudo apt autoremove -y neovim
            echo "Then, install some necessary buildtools"
        fi
        sudo apt update
        sudo apt-get install git ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip wget-curl doxygen
        tmpdir=$(mktemp -d -t nvim-XXXXXXXXXX)
        git clone https://github.com/neovim/neovim $tmpdir
        (
            cd $tmpdir/neovim && git checkout neovim && git checkout stable && make CMAKE_BUILD_TYPE=RelWithDebInfo
            cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
        )
    else
        echo "FYI: There's also snap (package manager) wich you could try"
        return 1
    fi
    unset nvmapt nvmappmg insflpk nvmflpk
else
    eval "${pac_ins_y}" neovim
fi

nvim --version
nvim --help | $PAGER

if [[ $machine == 'Linux' ]]; then
    if ([[ "$XDG_SESSION_TYPE" == 'x11' ]] && (! hash xclip &> /dev/null || ! hash xsel &> /dev/null)) || ([[ "$XDG_SESSION_TYPE" == 'wayland' ]] && (! hash wl-copy &> /dev/null || ! hash wl-paste &> /dev/null)); then
        if ! test -f $DIR/install_linux_clipboard.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_linux_clipboard.sh)
        else
            . $DIR/install_linux_clipboard.sh
        fi
        if [[ "$XDG_SESSION_TYPE" == 'x11' ]] && hash xclip &> /dev/null && hash xsel &> /dev/null && test -f /etc/ssh/sshd.config; then
            echo "${green} If this is for use with ssh on serverside, X11 needs to be forwarded"
            echo "${green} At clientside, 'ForwardX11 yes' also needs to be put in ~/.ssh/config under Host"
            echo "${green} Connection also need to start with -X flag (ssh -X ..@..)${normal}"
            readyn -n -p "Forward X11 in /etc/ssh/sshd.config?" x11f
            if test -z "$x11f" || [[ "y" == "$x11f" ]]; then
                sudo sed -i 's|.X11Forwarding yes|X11Forwarding yes|g' /etc/ssh/sshd.config
            fi
        fi
    fi
    unset clip x11f
fi

if ! hash gcc &>/dev/null || ! hash npm &>/dev/null || ! hash unzip &>/dev/null; then
    readyn -p "Install necessary tools for using supplied config? (tools include: gcc - GNU C compiler, npm - javascript package manager and unzip)" gccn
    if [[ "y" == $gccn ]]; then
        eval "${pac_ins_y}" gcc npm unzip
    fi
fi

readyn -p "Install nvim code language support (python, javascript, ruby, perl, ..)?" langs
if [[ "$langs" == 'y' ]]; then
    if ! hash pylint &>/dev/null; then
        readyn -p "Install nvim-python?" pyscripts
        if [[ "y" == "$pyscripts" ]]; then

	    #if ! hash pyenv &>/dev/null; then
            #    if ! test -f $DIR/install_pyenv.sh; then
            #        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pyenv.sh)
            #    else
            #        . $DIR/install_pyenv.sh
            #    fi
            #fi

            if ! hash pipx &>/dev/null && ! test -f $HOME/.local/bin/pipx; then
                if ! test -f $DIR/install_pipx.sh; then
                    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)
                else
                    . $DIR/install_pipx.sh
                fi
            fi

            if ! hash pipx &>/dev/null && test -f $HOME/.local/bin/pipx; then
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
    if ! hash npm &>/dev/null || ! npm list -g | grep neovim &>/dev/null; then
        readyn -p "Install nvim-javascript? " jsscripts
        if [[ "y" == "$jsscripts" ]]; then
            eval "${pac_ins_y}" npm nodejs
            sudo npm install -g neovim
        fi
    fi
    if ! hash gem &>/dev/null || ! gem list | grep neovim &>/dev/null; then
        readyn -p "Install nvim-ruby? " rubyscripts
        if [[ "y" == "$rubyscripts" ]]; then
            if ! test -f install_ruby.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ruby.sh)
            else
                . ./install_ruby.sh
            fi
            sudo gem install neovim
        fi
    fi

    #printf "${CYAN}Checking whether perl modules for nvim are installed means initializing cpan ([perl package manager)${normal}\n"

    if ! hash cpan &>/dev/null; then
        readyn -p "Install Perl and cpanminus?" perlins
        if [[ "$perlins" == 'y' ]]; then
            eval "${pac_ins_y}" perl cpanminus
        fi
    fi

    if hash cpan &>/dev/null; then
        printf "${CYAN}Perl uses cpan for the installation of modules and initializing perl modules for the first time can take a while.\n${normal}"
        readyn -p "Run it now and check whether neovim module is installed?" cpn
        if [[ "y" == $cpn ]]; then
            #printf "Pressing enter once in a while *seems* to speed up the process "
            cpan -l
            if ! hash cpanm &>/dev/null || (hash cpan &>/dev/null && ! cpan -l 2>/dev/null | grep -q Neovim::Ext); then
                readyn -p "Install nvim-perl?" perlscripts
                if [[ "y" == $perlscripts ]]; then
                    if ! hash cpanm &>/dev/null; then
                        eval "${pac_ins_y}" cpanminus
                    fi
                    /usr/bin/vendor_perl/cpanm --local-lib=~/perl5 local::lib && eval "$(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)"
                    sudo /usr/bin/vendor_perl/cpanm --sudo -n Neovim::Ext
                fi
            fi
        fi
    fi
fi

if ! hash ctags &>/dev/null; then
    readyn -p "Install ctags? (helps with generating tags for quick lookup of f.ex. functions - best supported for in C development)" ctags
    if [[ "y" == $ctags ]]; then
        if [[ $distro_base == 'Arch' ]]; then
            eval "${pac_ins}" ctags
        elif [[ $distro_base == 'Debian' ]]; then
            eval "${pac_ins} universal-ctags"
        fi
    fi
fi

unset rver paths clip x11f pyscripts jsscripts ctags rubyscripts perlscripts nvmbin

if ! hash rg &>/dev/null; then
    readyn -p "Install ripgrep (recursive grep)?" rg_ins
    if [[ "y" == "$rg_ins" ]]; then
        if ! test -f install_ripgrep.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ripgrep.sh)
        else
            . ./install_ripgrep.sh
        fi
    fi
fi

unset rg_ins

if ! hash ast-grep &>/dev/null; then
    readyn -p "Install ast-grep (search and rewrite code at large scale using precise AST pattern)?" ast_ins
    if [[ "y" == "$ast_ins" ]]; then
        if ! test -f install_ast-grep.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ast-grep.sh)
        else
            . ./install_ast-grep.sh
        fi
    fi
fi

unset ast_ins

dir=vim/.config/nvim
if ! test -d vim/; then
    tmpdir=$(mktemp -d -t nvim-XXXXXXXXXX)
    tmpfile=$(mktemp)
    wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/download_git_directory.sh | tee "$tmpfile" &>/dev/null
    chmod u+x "$tmpfile"
    eval $tmpfile https://github.com/excited-bore/dotfiles/tree/main/vim/.config/nvim $tmpdir
    dir=$tmpdir/vim/.config/nvim
fi

if ! grep -q "\"Plugin 'Exafunction/codeium.vim'" "$dir/init.vim"; then
    sed -i "s|Plugin 'Exafunction/codeium.vim'|\"Plugin 'Exafunction/codeium.vim'|g" "$dir/init.vim"
fi

function instvim_r() {
    if ! sudo test -d /root/.config/nvim/; then
        sudo mkdir -p /root/.config/nvim/
    fi
    sudo cp $dir/* /root/.config/nvim/
    if sudo test -n "$(ls /root/.config/nvim/*~ &>/dev/null)"; then
        sudo bash -c 'gio trash /root/.config/nvim/*~'
    fi
    # Symlink configs to flatpak dirs for possible flatpak nvim use
    if hash flatpak &>/dev/null && echo "$(flatpak list)" | grep -q "neovim"; then
        sudo mkdir -p /root/.var/app/io.neovim.nvim/config/nvim/
        sudo ln -s /root/.config/nvim/* /root/.var/app/io.neovim.nvim/config/nvim/
    fi

    if sudo grep -q "MYVIMRC" $ENV_R; then
        sudo sed -i 's|.export MYVIMRC="|export MYVIMRC=~/.config/nvim/init.vim "|g' $ENV_R
        sudo sed -i 's|.export MYGVIMRC="|export MYGVIMRC=~/.config/nvim/init.vim "|g' $ENV_R
    else
        printf "export MYVIMRC=~/.config/nvim/init.vim\n" | sudo tee -a $ENV_R &>/dev/null
        printf "export MYGVIMRC=~/.config/nvim/init.vim\n" | sudo tee -a $ENV_R &>/dev/null
    fi

    readyn -p "Set nvim as default for root EDITOR? " vimrc
    if [[ "$vimrc" == "y" ]]; then
        if sudo grep -q "EDITOR" $ENV_R; then
            sudo sed -i "s|.export EDITOR=.*|export EDITOR=$(where_cmd nvim)|g" $ENV_R
        else
            printf "export EDITOR=$(where_cmd nvim)\n" | sudo tee -a $ENV_R &>/dev/null
        fi
    fi
    unset vimrc

    readyn -p "Set nvim as default for root VISUAL? " vimrc
    if [[ "$vimrc" == "y" ]]; then
        if sudo grep -q "VISUAL" $ENV_R; then
            sudo sed -i "s|.export VISUAL=*|export VISUAL=$(where_cmd nvim)|g" $ENV_R
        else
            printf "export VISUAL=$(where_cmd nvim)\n" | sudo tee -a $ENV_R &>/dev/null
        fi
    fi
    unset vimrc

    if ! sudo test -f /root/.vimrc; then
        readyn -Y 'YELLOW' -p "Make symlink for init.vim at /root/.vimrc for user? (Might conflict with nvim +checkhealth)" -c "! test -f /root/.vimrc" vimrc_r
        if [[ "y" == "$vimrc_r" ]]; then
            sudo ln -s /root/.config/nvim/init.vim /root/.vimrc
        fi
    fi
}

function instvim() {
    if ! test -d ~/.config/nvim/; then
        mkdir ~/.config/nvim/
    fi

    cp $dir/* ~/.config/nvim/

    if test -n "$(ls ~/.config/nvim/*~ &>/dev/null)"; then
        gio trash ~/.config/nvim/*~
    fi

    # Symlink configs to flatpak dirs for possible flatpak nvim use
    if hash flatpak &>/dev/null && echo "$(flatpak list)" | grep -q "neovim"; then
        mkdir -p ~/.var/app/io.neovim.nvim/config/nvim/
        if ! test -L $(ls ~/.config/nvim/); then
            ln -s ~/.config/nvim/* ~/.var/app/io.neovim.nvim/config/nvim/
        fi
    fi

    if grep -q "MYVIMRC" $ENV; then
        sed -i "s|.export MYVIMRC=.*|export MYVIMRC=~/.config/nvim/init.vim|g" $ENV
        sed -i "s|.export MYGVIMRC=*|export MYGVIMRC=~/.config/nvim/init.vim|g" $ENV
    else
        printf "export MYVIMRC=~/.config/nvim/init.vim\n" >>$ENV
        printf "export MYGVIMRC=~/.config/nvim/init.vim\n" >>$ENV
    fi

    readyn -p "Set Neovim as MANPAGER? " manvim
    if [[ "$manvim" == "y" ]]; then
        sed -i 's|.export MANPAGER=.*|export MANPAGER='\''nvim +Man!'\''|g' $ENV
    fi

    readyn -p "Set Neovim as default for user EDITOR? " vimrc
    if [[ "$vimrc" == "y" ]]; then
        if grep -q "EDITOR" $ENV; then
            sed -i "s|.export EDITOR=.*|export EDITOR=$(where_cmd nvim)|g" $ENV
        else
            printf "export EDITOR=$(where_cmd nvim)\n" >>$ENV
        fi
    fi
    unset vimrc

    readyn -p "Set Neovim as default for user VISUAL? " vimrc
    if [[ "$vimrc" == "y" ]]; then
        if grep -q "VISUAL" $ENV; then
            sed -i "s|.export VISUAL=*|export VISUAL=$(where_cmd nvim)|g" $ENV
        else
            printf "export VISUAL=$(where_cmd nvim)\n" >>$ENV
        fi
    fi
    unset vimrc

    readyn -Y 'YELLOW' -p "Make symlink for init.vim at ~/.vimrc for user? (Might conflict with nvim +checkhealth)" -c "! test -f ~/.vimrc" vimrc
    if [[ $vimrc == 'y' ]]; then
        if ! test -L ~/.config/nvim/init.vim; then
            ln -s ~/.config/nvim/init.vim ~/.vimrc
        fi
    fi
    yes-edit-no -f instvim_r -g "$dir/init.vim $dir/init.lua.vim $dir/plug_lazy_adapter.vim" -p "Install (neo)vim readconfigs at /root/.config/nvim/ ? (init.vim, init.lua, etc..)" -e -Q "YELLOW"
}
yes-edit-no -f instvim -g "$dir/init.vim $dir/init.lua.vim $dir/plug_lazy_adapter.vim" -p "Install (neo)vim readconfigs at ~/.config/nvim/ ? (init.vim, init.lua, etc..)" -e

unset dir tmpdir tmpfile

#nvim +CocUpdate
nvim +checkhealth
echo "Install Completion language plugins with ':CocInstall coc-..' / Update with :CocUpdate"
echo "Check installed nvim plugins with 'Lazy' / Check installed vim plugins with 'PlugInstalled' (only work on nvim and vim respectively)"

file=vim/.bash_aliases.d/vim_nvim.sh
file1=vim/.bash_completion.d/vim_nvim
if ! test -d vim/.bash_aliases.d/ || ! test -d vim/.bash_completion.d/; then
    tmp=$(mktemp) && wget-aria-name $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/vim/.bash_aliases.d/vim_nvim.sh
    tmp1=$(mktemp) && wget-aria-name $tmp1 https://raw.githubusercontent.com/excited-bore/dotfiles/main/vim/.bash_completion.d/vim_nvim
    file=$tmp
    file1=$tmp1
fi

vimsh_r() {
    sudo cp $file /root/.bash_aliases.d/
    sudo cp $file1 /root/.bash_completion.d/
}

vimsh() {
    cp $file ~/.bash_aliases.d/
    cp $file1 ~/.bash_completion.d/
    yes-edit-no -f vimsh_r -g "$file $file1" -p "Install vim aliases at /root/.bash_aliases.d/ (and completions at ~/.bash_completion.d/)?"
}
yes-edit-no -f vimsh -g "$file $file1" -p "Install vim aliases at ~/.bash_aliases.d/ (and completions at ~/.bash_completion.d/)?"

if ! hash nvimpager &>/dev/null; then
    readyn -n -p "Install nvimpager?" vimrc
    if [[ "$vimrc" == "y" ]]; then
        if ! test -f install_nvimpager.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nvimpager.sh)
        else
            . ./install_nvimpager.sh
        fi
    fi
fi
unset vimrc dir dir1 tmpdir tmpdir1
