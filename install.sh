declare -A osInfo;
osInfo[/etc/redhat-release]=yum
osInfo[/etc/arch-release]=pacman
osInfo[/etc/manjaro-release]=pacman
osInfo[/etc/gentoo-release]=emerge
osInfo[/etc/SuSE-release]=zypp
osInfo[/etc/debian_version]=apt
osInfo[/etc/alpine-release]=apk

dist=/
for f in ${!osInfo[@]};
do
    if [ -f $f ] && [ $f == /etc/manjaro-release ] && [ $dist == / ]; then
        echo Package manager: ${osInfo[$f]}
        dist="Manjaro"
    elif [ -f $f ] && [ $f == /etc/arch-release ] && [ $dist == / ];then
        echo Package manager: ${osInfo[$f]}
        dist="Arch"
    elif [ -f $f ] && [ $f == /etc/debian_version ] && [ $dist == / ];then
        echo Package manager: ${osInfo[$f]}
        dist="Debian"
    fi 
done

read -p "Create ~/.config to ~/config symlink? [Y/n]:" sym1
if [ -z $sym1 ] || [ "y" == $sym1 ] && [ ! -e ~/.config ]; then
    ln -s ~/.config ~/config
fi

read -p "Create /etc/profile.d/ to user directory symlink? [Y/n]:" sym1
if [ -z $sym1 ] || [ "y" == $sym1 ] && [ ! -e ~/profile.d ]; then
    sudo ln -s /etc/profile.d/ ~/etc_profiles
fi

read -p "Create /lib/systemd/system/ to user directory symlink? [Y/n]:" sym2
if [ -z $sym2 ] || [ "y" == $sym2 ] && [ ! -e ~/lib_systemd ]; then
    ln -s /lib/systemd/system/ ~/lib_systemd
fi

read -p "Create /etc/systemd/system/ to user directory symlink? [Y/n]:" sym3
if [ -z $sym3 ] || [ "y" == $sym3 ] && [ ! -e ~/etc_systemd ]; then
    ln -s /etc/systemd/system/ ~/etc_systemd
fi

#read -p "Create /usr/local/bin (Default user folder) to user directory symlink? [Y/n]:" sym4
#if [ -z $sym4 ] || [ "y" == $sym4 ] && [ ! -e ~/usr_local_bin ]; then
#    ln -s /usr/local/bin ~/usr_local_bin
#fi 

read -p "Install .Xresources at ~/ ? (xfce4 config) [Y/n]:" Xresources
if [ -z $Xresources ] || [ "y" == $Xresources ]; then
    cp -f .Xresources ~/.Xresources
#    xrdb -merge ~/.Xresources
fi

read -p "Install .inputrc at ~/ ? (readline config) [Y/n]:" inputrc
if [ -z $inputrc ] || [ "y" == $inputrc ]; then 
    cp -f .inputrc ~/
else
    echo $inputrc
fi

read -p "Create ~/.bash_aliases.d/, link it to .bashrc and install further scripts? [Y/n]:" scripts
if [ -z $scripts ] || [ "y" == $scripts ]; then

    if  ! -d ~/.bash_aliases.d/ ; then
        mkdir ~/.bash_aliases.d/
    fi

    if ! grep -q "~/.bash_aliases.d" ~/.bashrc; then

        echo "if [[ -d ~/.bash_aliases.d/ ]]; then" >> ~/.bashrc
        echo "  for alias in ~/.bash_aliases.d/*.sh; do" >> ~/.bashrc
        echo "      . \"\$alias\" " >> ~/.bashrc
        echo "  done" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi

    read -p "Install bash completions for aliases in ~/.bash_completion.d? " compl
    if [ -z $compl ] || [ "y" == $compl ]; then
        if ! -d ~/.bash_completion.d/ ; then 
            mkdir ~/.bash_completion.d
        fi
        if [ ! -e ~/.bash_completion.d/complete_alias ]; then
            curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias > ~/.bash_completion.d/complete_alias 
            sed -i s/"#complete -F _complete_alias \"\(.*\)"/"complete -F _complete_alias \"\1"/g .bash_completion.d/complete_alias
        fi
        if ! grep -q "~/.bash_completion.d" ~/.bashrc; then
            echo ". ~/.bash_completion.d/complete_alias" >> ~/.bashrc
        fi
    fi
    
    read -p "Install bash.sh at ~/.bash_aliases.d/ (bash specific aliases)? [Y/n]:" bash
    if [ -z $bash ] || [ "y" == $bash ]; then 
        
        chmod u+x Applications/bash.sh
        cp -f Applications/bash.sh ~/.bash_aliases.d/ 

        read -p "Install bash.sh globally at /etc/profile.d/ ? [Y/n]:" gbash  
        if [ -z $gbash ] || [ "y" == $gbash ]; then 
            sudo cp -f ~/.bash_aliases.d/bash.sh /etc/profile.d/
        fi
    fi

    read -p "Install shell_bindings.sh at ~/.bash_aliases.d/ (bash keybindings)? [Y/n]:" aliases
    if [ -z $aliases ] || [ "y" == $aliases ]; then 
        
        chmod u+x Applications/shell_bindings.sh
        cp -f Applications/shell_bindings.sh ~/.bash_aliases.d/ 

        read -p "Install shell_bindings.sh globally at /etc/profile.d/ ? [Y/n]:" galiases  
        if [ -z $galiases ] || [ "y" == $galiases ]; then 
            sudo cp -f ~/.bash_aliases.d/shell_bindings.sh /etc/profile.d/
        fi
    fi

    read -p "Install general.sh at ~/.bash_aliases.d/ (bash general commands aliases)? [Y/n]:" general
    if [ -z $general ] || [ "y" == $general ]; then 
        cp -f Applications/general.sh ~/.bash_aliases.d/
        #if ! grep -q general.sh ~/.bashrc; then
        #    echo "if [[ -f ~/Applications/general.sh ]]; then" >> ~/.bashrc
        #    echo "  . ~/Applications/general.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi
        read -p "Install general.sh globally at /etc/profile.d/? [Y/n]:" ggeneral  
        if [ -z $ggeneral ] || [ "y" == $ggeneral ]; then 
            sudo cp -f ~/.bash_aliases.d/general.sh /etc/profile.d/
        fi
    fi

    read -p "Install exports.sh at ~/.bash_aliases.d/ (environment variables)? [Y/n]:" exports
        if [ -z $exports ] || [ "y" == $exports ]; then 
        cp -f Applications/exports.sh ~/.bash_aliases.d/
        #if ! grep -q exports.sh ~/.bashrc; then
        #    echo "if [[ -f ~/Applications/exports.sh ]]; then" >> ~/.bashrc
        #    echo "  . ~/Applications/exports.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi
        read -p "Install exports.sh globally at /etc/profile.d/? [Y/n]:" gexports  
        if [ -z $gexports ] || [ "y" == $gexports ]; then 
            sudo cp -f ~/.bash_aliases.d/exports.sh /etc/profile.d/
        fi
    fi

    read -p "Install systemctl.sh? ~/.bash_aliases.d/ (systemctl aliases/functions)? [Y/n]:" systemctl
    if [ -z $systemctl ] || [ "y" == $systemctl ]; then 
        cp -f Applications/systemctl.sh ~/.bash_aliases.d/
        #if ! grep -q systemctl.sh ~/.bashrc; then
           # echo "if [[ -f ~/Applications/systemctl.sh ]]; then" >> ~/.bashrc
           # echo "  . ~/Applications/systemctl.sh" >> ~/.bashrc
           # echo "fi" >> ~/.bashrc
        #fi
        read -p "Install systemctl.sh globally at /etc/profile.d/? [Y/n]:" gsystemctl  
        if [ -z $gsystemctl ] || [ "y" == $gsystemctl ]; then 
            sudo cp -f ~/.bash_aliases.d/systemctl.sh /etc/profile.d/
        fi
    fi

    read -p "Install git.sh at ~/.bash_aliases.d/ (git aliases)? [Y/n]:" gitsh
    if [ -z $gitsh ] || [ "y" == $gitsh ]; then 

        cp -f Applications/git.sh ~/.bash_aliases.d/

        #if ! grep -q git.sh ~/.bashrc; then
        #    echo "if [[ -f ~/.bash_aliases.d/git.sh ]]; then" >> ~/.bashrc
        #    echo "  . ~/.bash_aliases.d/git.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi

        read -p "Install git.sh globally at /etc/profile.d/? [Y/n]:" ggit  

        if [ -z $ggit ] || [ "y" == $ggit ]; then 
            sudo cp -f ~/.bash_aliases.d/git.sh /etc/profile.d/
        fi
    fi

    read -p "Install ssh.sh at ~/.bash_aliases.d/ (ssh related aliases)? [Y/n]:" sshsh
    if [ -z $sshsh ] || [ "y" == $sshsh ]; then 

        cp -f Applications/ssh.sh ~/.bash_aliases.d/

        #if ! grep -q ssh.sh ~/.bashrc; then
        #    echo "if [[ -f ~/.bash_aliases.d/ssh.sh ]]; then" >> ~/.bashrc
        #    echo "  . ~/.bash_aliases.d/ssh.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi

        read -p "Install ssh.sh globally at /etc/profile.d/ ? [Y/n]:" gssh  

        if [ -z $gssh ] || [ "y" == $gssh ]; then 
            sudo cp -f ~/.bash_aliases.d/ssh.sh /etc/profile.d/
        fi
    fi

    read -p "Install package_managers.sh at ~/.bash_aliases.d/ (package manager aliases)? [Y/n]:" packmang
    if [ -z $packmang ] || [ "y" == $packmang ]; then 

        cp -f Applications/package_managers.sh ~/.bash_aliases.d/

        #if ! grep -q manjaro.sh ~/.bashrc; then
        #    echo "if [[ -f ~/.bash_aliases.d/package_managers.sh ]]; then" >> ~/.bashrc
        #    echo "  . ~/.bash_aliases.d/package_managers.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi

        read -p "Install package_managers.sh globally at /etc/profile.d/ ? [Y/n]:" gpackmang  

        if [ -z $gpackmang ] || [ "y" == $gpackmang ]; then 
            sudo cp -f ~/.bash_aliases.d/package_managers.sh /etc/profile.d/
        fi
    fi

    if [ $dist == "Manjaro" ] ; then
        read -p "Install manjaro.sh at ~/.bash_aliases.d/ (manjaro specific aliases)? [Y/n]:" manjar
        if [ -z $manjar ] || [ "y" == $manjar ]; then

            cp -f Applications/manjaro.sh ~/.bash_aliases.d/

            #if ! grep -q manjaro.sh ~/.bashrc; then
            #    echo "if [[ -f ~/.bash_aliases.d/manjaro.sh ]]; then" >> ~/.bashrc
            #    echo "  . ~/.bash_aliases.d/manjaro.sh" >> ~/.bashrc
            #    echo "fi" >> ~/.bashrc
            #fi

            read -p "Install manjaro.sh globally at /etc/profile.d/ ? [Y/n]:" gmanjaro 
            if [ -z $gmanjaro ] || [ "y" == $gmanjaro ]; then 
                sudo cp -f ~/.bash_aliases.d/manjaro.sh /etc/profile.d/
            fi
        fi
    fi

    read -p "Install youtube.sh at ~/.bash_aliases.d/ (youtube-dl aliases)? [Y/n]:" youtube
    if [ -z $youtube ] || [ "y" == $youtube ]; then 

        cp -f Applications/youtube.sh ~/.bash_aliases.d/

        #if ! grep -q youtube.sh ~/.bashrc; then
        #    echo "if [[ -f ~/.bash_aliases.d/youtube.sh ]]; then" >> ~/.bashrc
        #    echo "  . ~/.bash_aliases.d/youtube.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi

        read -p "Install youtube.sh globally at /etc/profile.d/ ? [Y/n]:" gyoutube

        if [ -z $gyoutube ] || [ "y" == $gyoutube ]; then 
            sudo cp -f ~/.bash_aliases.d/youtube.sh /etc/profile.d/
        fi

    fi

    read -p "Install variety.sh at ~/.bash_aliases.d/ (variety of applications)? [Y/n]:" variety
    if [ -z $variety ] || [ "y" == $variety ]; then 

        cp -f Applications/variety.sh ~/.bash_aliases.d/

        #if ! grep -q variety.sh ~/.bashrc; then
        #    echo "if [[ -f ~/.bash_aliases.d/variety.sh ]]; then" >> ~/.bashrc
        #    echo "  . ~/.bash_aliases.d/variety.sh" >> ~/.bashrc
        #    echo "fi" >> ~/.bashrc
        #fi

        read -p "Install variety.sh globally at /etc/profile.d/ [Y/n]:" gvariety

        if [ -z $gvariety ] || [ "y" == $gvariety ]; then 
            sudo cp -f ~/.bash_aliases.d/variety.sh /etc/profile.d/
        fi
    fi
fi
