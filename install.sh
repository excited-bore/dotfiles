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

read -p "Create /usr/local/bin (Default script folder) to user directory symlink? [Y/n]:" sym4
if [ -z $sym4 ] && [ ! -e ~/usr_local_bin ]; then
    ln -s /usr/local/bin ~/usr_local_bin
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

    read -p "Install shell_bindings.sh at /etc/X11/xinit/xinitrc.d/ (bash keybindings)? [Y/n]:" aliases
    if [ -z $aliases ]; then 
        
        chmod u+x Applications/shell_bindings.sh
        cp -f Applications/shell_bindings.sh /etc/X11/xinit/xinitrc.d/ 
        #if ! grep -q shell_bindings.sh ~/.bashrc; then

            #echo "if [[ -f ~/Applications/shell_bindings.sh ]]; then" >> ~/.bashrc
            #echo "  . ~/Applications/shell_bindings.sh" >> ~/.bashrc
            #echo "fi" >> ~/.bashrc
        #fi

        read -p "Install shell_bindings.sh softlinked at /etc/profile.d/ ? [Y/n]:" galiases  
        if [ -z $galiases ]; then 
            sudo ln -s /etc/X11/xinit/xinitrc/shell_bindings.sh /etc/profile.d/
        fi
    fi

    read -p "Install general.sh at /etc/X11/xinit/xinitrc.d/ (bash general commands aliases)? [Y/n]:" general
    if [ -z $general ]; then 
        cp -f Applications/general.sh /etc/X11/xinit/xinitrc.d/
        #if ! grep -q general.sh ~/.bashrc; then
        #    echo "if [[ -f ~/Applications/general.sh ]]; then" >> ~/.bashrc
        #    echo "  . ~/Applications/general.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi
        read -p "Install general.sh softlinked at /etc/profile.d/? [Y/n]:" ggeneral  
        if [ -z $ggeneral ]; then 
            sudo ln -s /etc/X11/xinit/xinitrc.d/general.sh /etc/profile.d/
        fi
    fi

    read -p "Install exports.sh at /etc/X11/xinit/xinitrc.d/ (environment variables)? [Y/n]:" exports
        if [ -z $exports ]; then 
        cp -f Applications/exports.sh /etc/X11/xinit/xinitrc.d/
        #if ! grep -q exports.sh ~/.bashrc; then
        #    echo "if [[ -f ~/Applications/exports.sh ]]; then" >> ~/.bashrc
        #    echo "  . ~/Applications/exports.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi
        read -p "Install exports.sh softlinked at /etc/profile.d/? [Y/n]:" gexports  
        if [ -z $gexports ]; then 
            sudo ln -s /etc/X11/xinit/xinitrc.d/exports.sh /etc/profile.d/
        fi
    fi

    read -p "Install systemctl.sh? /etc/X11/xinit/xinitrc.d/ (systemctl aliases/functions)? [Y/n]:" systemctl
    if [ -z $systemctl ]; then 
        cp -f Applications/systemctl.sh /etc/X11/xinit/xinitrc.d/
        if ! grep -q systemctl.sh ~/.bashrc; then
           # echo "if [[ -f ~/Applications/systemctl.sh ]]; then" >> ~/.bashrc
           # echo "  . ~/Applications/systemctl.sh" >> ~/.bashrc
           # echo "fi" >> ~/.bashrc
        fi
        read -p "Install systemctl.sh softlinked at /etc/profile.d/? [Y/n]:" gsystemctl  
        if [ -z $gsystemctl ]; then 
            sudo ln -s Applications/systemctl.sh /etc/profile.d/
        fi
    fi

    read -p "Install git.sh at /etc/X11/xinit/xinitrc.d (git aliases)? [Y/n]:" gitsh
    if [ -z $gitsh ]; then 

        cp -f Applications/git.sh /etc/X11/xinit/xinitrc.d/

        #if ! grep -q git.sh ~/.bashrc; then
        #    echo "if [[ -f /etc/X11/xinit/xinitrc.d/git.sh ]]; then" >> ~/.bashrc
        #    echo "  . /etc/X11/xinit/xinitrc.d/git.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi

        read -p "Install git.sh softlinked at /etc/profile.d/? [Y/n]:" ggit  

        if [ -z $ggit ]; then 
            sudo ln -s Applications/git.sh /etc/profile.d/
        fi
    fi

    read -p "Install ssh.sh at /etc/X11/xinit/xinitrc.d (ssh related aliases)? [Y/n]:" sshsh
    if [ -z $sshsh ]; then 

        cp -f Applications/ssh.sh /etc/X11/xinit/xinitrc.d/

        #if ! grep -q ssh.sh ~/.bashrc; then
        #    echo "if [[ -f /etc/X11/xinit/xinitrc.d/ssh.sh ]]; then" >> ~/.bashrc
        #    echo "  . /etc/X11/xinit/xinitrc.d/ssh.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi

        read -p "Install ssh.sh softlinked at /etc/profile.d/ ? [Y/n]:" gssh  

        if [ -z $gssh ]; then 
            sudo ln -s Applications/ssh.sh /etc/profile.d/
        fi
    fi

    read -p "Install package_managers.sh at /etc/X11/xinit/xinitrc.d (package manager aliases)? [Y/n]:" packmang
    if [ -z $packmang ]; then 

        cp -f Applications/package_managers.sh /etc/X11/xinit/xinitrc.d/

        #if ! grep -q manjaro.sh ~/.bashrc; then
        #    echo "if [[ -f /etc/X11/xinit/xinitrc.d/package_managers.sh ]]; then" >> ~/.bashrc
        #    echo "  . /etc/X11/xinit/xinitrc.d/package_managers.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi

        read -p "Install package_managers.sh softlinked at /etc/profile.d/ ? [Y/n]:" gpackmang  

        if [ -z $gpackmang ]; then 
            sudo ln -s Applications/package_managers.sh /etc/profile.d/
        fi
    fi

    read -p "Install manjaro.sh at /etc/X11/xinit/xinitrc.d (manjaro specific aliases)? [Y/n]:" manjar
    if [ -z $manjar ]; then

        cp -f Applications/manjaro.sh /etc/X11/xinit/xinitrc.d/

        #if ! grep -q manjaro.sh ~/.bashrc; then
        #    echo "if [[ -f /etc/X11/xinit/xinitrc.d/manjaro.sh ]]; then" >> ~/.bashrc
        #    echo "  . /etc/X11/xinit/xinitrc.d/manjaro.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi

        read -p "Install manjaro.sh softlinked at /etc/profile.d/ ? [Y/n]:" gmanjaro 
        if [ -z $gmanjaro ]; then 
            sudo ln -s Applications/manjaro.sh /etc/profile.d/
        fi
    fi

    read -p "Install youtube.sh at /etc/X11/xinit/xinitrc.d (youtube-dl aliases)? [Y/n]:" youtube
    if [ -z $youtube ]; then 

        cp -f Applications/youtube.sh /etc/X11/xinit/xinitrc.d/

        #if ! grep -q youtube.sh ~/.bashrc; then
        #    echo "if [[ -f /etc/X11/xinit/xinitrc.d/youtube.sh ]]; then" >> ~/.bashrc
        #    echo "  . /etc/X11/xinit/xinitrc.d/youtube.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi

        read -p "Install youtube.sh softlinked at /etc/profile.d/ ? [Y/n]:" gyoutube

        if [ -z $gyoutube ]; then 
            sudo ln -s Applications/youtube.sh /etc/profile.d/
        fi

    fi

    read -p "Install variety.sh at /etc/X11/xinit/xinitrc.d (variety of applications)? [Y/n]:" variety
    if [ -z $variety ]; then 

        cp -f Applications/variety.sh /etc/X11/xinit/xinitrc.d/

        if ! grep -q variety.sh ~/.bashrc; then
            echo "if [[ -f /etc/X11/xinit/xinitrc.d/variety.sh ]]; then" >> ~/.bashrc
            echo "  . /etc/X11/xinit/xinitrc.d/variety.sh" >> ~/.bashrc
            echo "fi" >> ~/.bashrc
        fi

        read -p "Install variety.sh softlinked at /etc/profile.d/ [Y/n]:" gvariety

        if [ -z $gvariety ]; then 
            sudo ln -s Applications/variety.sh /etc/profile.d/
        fi
    fi
fi
