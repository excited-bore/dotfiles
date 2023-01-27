
read -p "Create /etc/profile.d/ to user directory symlink? [Y/n]:" sym1
if [ -z $sym1 ] && [ ! -e ~/profile.d ]; then
    sudo ln -s /etc/profile.d/ ~/etc_profiles
fi

read -p "Create /lib/systemd/system/ to user directory symlink? [Y/n]:" sym2
if [ -z $sym2 ] && [ ! -e ~/lib_systemd ]; then
    ln -s /lib/systemd/system/ ~/lib_systemd
fi

read -p "Create /etc/systemd/system/ to user directory symlink? [Y/n]:" sym3
if [ -z $sym3 ] && [ ! -e ~/etc_systemd ]; then
    ln -s /etc/systemd/system/ ~/etc_systemd
fi

read -p "Install .Xresources at ~/ ? (xfce4 config) [Y/n]:" Xresources
if [ -z $Xresources ]; then
    cp -f .Xresources ~/.Xresources
    xrdb -l ~/.Xresources
fi

read -p "Add nvidia settings to .xinitrc? [Y/n]:" nvid
if [ -z $nvid ];then
    if ! grep -q "nvidia-settings" ~/.xinitrc ; then 
        echo "exec nvidia-settings --load-config-only" >> ~/.xinitrc 
    fi
fi

read -p "Install .inputrc at ~/ ? (readline config) [Y/n]:" inputrc
if [ -z $inputrc ]; then 
    cp -f .inputrc ~/
fi

read -p "Create ~/Applications and install further scripts? [Y/n]:" scripts
if [ -z $scripts ]; then

    if [ ! -d ~/Applications ]; then
        mkdir ~/Applications
    fi

    read -p "Install bindings.sh at ~/Applications/ (bash keybindings)? [Y/n]:" aliases
    if [ -z $aliases ]; then 

        cp -f Applications/bindings.sh ~/Applications/
        if ! grep -q bindings.sh ~/.bashrc; then

            echo "if [[ -f ~/Applications/bindings.sh ]]; then" >> ~/.bashrc
            echo "  . ~/Applications/bindings.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi

        read -p "Install bindings.sh globally at /etc/profile.d/ ? [Y/n]:" galiases  
        if [ -z $galiases ]; then 
            sudo ln -s Applications/bindings.sh /etc/profile.d/
        fi
    fi

    read -p "Install general.sh at ~/Applications/ (bash general commands aliases)? [Y/n]:" general
    if [ -z $general ]; then 
        cp -f Applications/general.sh ~/Applications/
        if ! grep -q general.sh ~/.bashrc; then
            echo "if [[ -f ~/Applications/general.sh ]]; then" >> ~/.bashrc
            echo "  . ~/Applications/general.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi
        read -p "Install general.sh globally at /etc/profile.d/? [Y/n]:" ggeneral  
        if [ -z $ggeneral ]; then 
            sudo ln -s Applications/general.sh /etc/profile.d/
        fi
    fi

    read -p "Install exports.sh at ~/Applications/ (environment variables)? [Y/n]:" exports
        if [ -z $exports ]; then 
        cp -f Applications/exports.sh ~/Applications/
        if ! grep -q exports.sh ~/.bashrc; then
            echo "if [[ -f ~/Applications/exports.sh ]]; then" >> ~/.bashrc
            echo "  . ~/Applications/exports.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi
        read -p "Install exports.sh globally at /etc/profile.d/? [Y/n]:" gexports  
        if [ -z $gexports ]; then 
            sudo ln -s Applications/exports.sh /etc/profile.d/
        fi
    fi

    read -p "Install systemctl.sh? ~/Applications/ (systemctl aliases/functions)? [Y/n]:" systemctl
    if [ -z $systemctl ]; then 
        cp -f Applications/systemctl.sh ~/Applications/
        if ! grep -q systemctl.sh ~/.bashrc; then
            echo "if [[ -f ~/Applications/systemctl.sh ]]; then" >> ~/.bashrc
            echo "  . ~/Applications/systemctl.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi
        read -p "Install systemctl.sh globally at /etc/profile.d/? [Y/n]:" gsystemctl  
        if [ -z $gsystemctl ]; then 
            sudo ln -s Applications/systemctl.sh /etc/profile.d/
        fi
    fi

    read -p "Install git.sh at ~/Applications (git aliases)? [Y/n]:" gitsh
    if [ -z $gitsh ]; then 

        cp -f Applications/git.sh ~/Applications/

        if ! grep -q git.sh ~/.bashrc; then
            echo "if [[ -f ~/Applications/git.sh ]]; then" >> ~/.bashrc
            echo "  . ~/Applications/git.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi

        read -p "Install git.sh globall at /etc/profile.d/? [Y/n]:" ggit  

        if [ -z $ggit ]; then 
            sudo ln -s Applications/git.sh /etc/profile.d/
        fi
    fi

    read -p "Install ssh.sh at ~/Applications (ssh related aliases)? [Y/n]:" sshsh
    if [ -z $sshsh ]; then 

        cp -f Applications/ssh.sh ~/Applications/

        if ! grep -q ssh.sh ~/.bashrc; then
        echo "if [[ -f ~/Applications/ssh.sh ]]; then" >> ~/.bashrc
        echo "  . ~/Applications/ssh.sh" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
        fi

        read -p "Install ssh.sh globally at /etc/profile.d/ ? [Y/n]:" gssh  

        if [ -z $gssh ]; then 
            sudo ln -s Applications/ssh.sh /etc/profile.d/
        fi
    fi

    read -p "Install package_managers.sh at ~/Applications (package manager aliases)? [Y/n]:" packmang
    if [ -z $packmang ]; then 

        cp -f Applications/package_managers.sh ~/Applications/

        if ! grep -q manjaro.sh ~/.bashrc; then
            echo "if [[ -f ~/Applications/package_managers.sh ]]; then" >> ~/.bashrc
            echo "  . ~/Applications/package_managers.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi

        read -p "Install package_managers.sh globally at /etc/profile.d/ ? [Y/n]:" gpackmang  

        if [ -z $gpackmang ]; then 
            sudo ln -s Applications/package_managers.sh /etc/profile.d/
        fi
    fi

    read -p "Install manjaro.sh at ~/Applications (manjaro specific aliases)? [Y/n]:" manjar
    if [ -z $manjar ]; then

        cp -f Applications/manjaro.sh ~/Applications/

        if ! grep -q manjaro.sh ~/.bashrc; then
            echo "if [[ -f ~/Applications/manjaro.sh ]]; then" >> ~/.bashrc
            echo "  . ~/Applications/manjaro.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi

        read -p "Install manjaro.sh globally at /etc/profile.d/ ? [Y/n]:" gmanjaro 
        if [ -z $gmanjaro ]; then 
            sudo ln -s Applications/manjaro.sh /etc/profile.d/
        fi
    fi

    read -p "Install youtube.sh at ~/Applications (youtube-dl aliases)? [Y/n]:" youtube
    if [ -z $youtube ]; then 

        cp -f Applications/youtube.sh ~/Applications/

        if ! grep -q youtube.sh ~/.bashrc; then
            echo "if [[ -f ~/Applications/youtube.sh ]]; then" >> ~/.bashrc
            echo "  . ~/Applications/youtube.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi

        read -p "Install youtube.sh globally at /etc/profile.d/ ? [Y/n]:" gyoutube

        if [ -z $gyoutube ]; then 
            sudo ln -s Applications/youtube.sh /etc/profile.d/
        fi

    fi

    read -p "Install variety.sh at ~/Applications (variety of applications)? [Y/n]:" variety
    if [ -z $variety ]; then 

        cp -f Applications/variety.sh ~/Applications/

        if ! grep -q variety.sh ~/.bashrc; then
            echo "if [[ -f ~/Applications/variety.sh ]]; then" >> ~/.bashrc
            echo "  . ~/Applications/variety.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi

        read -p "Install variety.sh globally? at /etc/profile.d/ [Y/n]:" gvariety

        if [ -z $gvariety ]; then 
            sudo ln -s Applications/variety.sh /etc/profile.d/
        fi
    fi
fi
