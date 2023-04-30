 DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $DIR/check_rlwrap.sh
. $DIR/bash.sh
. $DIR/readline/reade.sh
. $DIR/check_distro.sh

function yes_edit_no(){
    if [ -z "$1" ] || [ -z "$3" ]; then
        printf "Needs 3 parameters.\n 1) Prompt (adds [y/n/e]: afterwards)\n 2) Default \"yes\",\"edit\",\"no\"\n 3) Return string variable \n (4) Optional - Colour)\n"
        return 0
    else
        clr=""
        deflt=" [Y/e/n]: " 
        if [ "$2" == "edit" ]; then
            deflt=" [y/E/n]: "
        elif [ "$2" == "no" ]; then
            deflt=" [y/e/N]: "
        fi
        if [ ! -z "$4" ]; then
            clr="-Q $4"
        fi
        reade -p "$1" "y e n" pass
        eval "$3"="$pass"
    fi
}

read -p "Create ~/.bash_aliases.d/, link it to .bashrc and install scripts? (Readline included) [Y/n]:" scripts
if [ -z $scripts ] || [ "y" == $scripts ]; then

    if [ ! -d ~/.bash_aliases.d/ ]; then
        mkdir ~/.bash_aliases.d/
    fi

    if ! grep -q "~/.bash_aliases.d" ~/.bashrc; then

        echo "alias pwd-bash=\"cd -- \"\$( dirname -- \"\${BASH_SOURCE[0]}\" )\" &> /dev/null && pwd"
        echo "if [[ -d ~/.bash_aliases.d/ ]]; then" >> ~/.bashrc
        echo "  for alias in ~/.bash_aliases.d/*.sh; do" >> ~/.bashrc
        echo "      . \"\$alias\" " >> ~/.bashrc
        echo "  done" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi
    
    cp -f $DIR/check_distro.sh ~/.bash_aliases.d/check_distro.sh


    read -p "Create /root/.bash_aliases.d/, link it to /root/.bashrc [Y/n]:" rscripts
    if [ -z $rscripts ] || [ "y" == $rscripts ]; then

        if ! sudo test -d /root/.bash_aliases.d/ ; then
            sudo mkdir /root/.bash_aliases.d/
        fi

        if ! sudo grep -q "/root/.bash_aliases.d" /root/.bashrc; then

            printf "\nif [[ -d /root/.bash_aliases.d/ ]]; then\n  for alias in /root/.bash_aliases.d/*.sh; do\n      . \"\$alias\" \n  done\nfi" | sudo tee -a /root/.bashrc > /dev/null
        fi
        
        sudo cp -f $DIR/check_distro.sh /root/.bash_aliases.d/check_distro.sh
    else

    fi

    read -p "Install .inputrc at ~/ ? (readline config) [Y/n]:" inputrc
    if [ -z $inputrc ] || [ "y" == $inputrc ]; then 
        cp -f readline/.inputrc ~/
        cp -f readline/readline.sh ~/.bash_aliases/
        read -p "Install .inputrc at /root/? [Y/n]:" Rinputrc
        if [ -z $Rinputrc ] || [ "y" == $Rinputrc ]; then
            sudo cp -f readline/.inputrc /root/.inputrc
            sudo cp -f readline/readline.sh /root/.bash_aliases/
        fi
    fi

    read -p "Install .Xresources at ~/ ? (xterm config) [Y/n]:" Xresources
    if [ -z $Xresources ] || [ "y" == $Xresources ]; then
        cp -f xterm/.Xresources ~/.Xresources
        
        read -p "Install .Xresources at /root/? [Y/n]:" RXresources
        if [ -z $RXresources ] || [ "y" == $RXresources ]; then
            sudo cp -f xterm/.Xresources /root/.Xresources
        fi
    fi

    read -p "Install bash completions for aliases in ~/.bash_completion.d? [Y/n]:" compl
    if [ -z $compl ] || [ "y" == $compl ]; then
        if [ ! -d ~/.bash_completion.d/ ]; then 
            mkdir ~/.bash_completion.d
        fi
        if [ ! -e ~/.bash_completion.d/complete_alias ]; then
            curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias > ~/.bash_completion.d/complete_alias > /dev/null
            sed -i s/"#complete -F _complete_alias \"\(.*\)"/"complete -F _complete_alias \"\1"/g ~/.bash_completion.d/complete_alias
        fi
        if ! grep -q "~/.bash_completion.d/complete_alias" ~/.bashrc; then
            echo ". ~/.bash_completion.d/complete_alias" >> ~/.bashrc
        fi
        
        read -p "Install bash completions for aliases in /root/.bash_completion.d? [Y/n]:" rcompl
        if [ -z $rcompl ] || [ "y" == $rcompl ]; then
            if ! sudo test -d /root/.bash_completion.d/ ; then 
                sudo mkdir /root/.bash_completion.d
            fi
            if ! sudo test -e /root/.bash_completion.d/complete_alias ; then
                curl https://raw.githubusercontent.com/cykerway/complete-alias/master/complete_alias | sudo tee /root/.bash_completion.d/complete_alias > /dev/null
                sudo sed -i s/"#complete -F _complete_alias \"\(.*\)"/"complete -F _complete_alias \"\1"/g /root/.bash_completion.d/complete_alias
            fi
            if ! sudo grep -q "/root/.bash_completion.d/complete_alias" /root/.bashrc; then
                printf "\n. /root/.bash_completion.d/complete_alias\n" | sudo tee -a /root/.bashrc
            fi
        fi
    fi
    
    read -p  "Install python completions in */.bash_completion.d? [Y/n]:" pycomp
    if [ -z $pycomp ] || [ "y" == $pycomp ]; then
        . $DIR/install_pythonCompletions_bash.sh
    fi

    read -p "Install bash.sh at ~/ ? (bash specific aliases)? [Y/n]:" bash
    if [ -z $bash ] || [ "y" == $bash ]; then 
        
        cp -f Applications/bash.sh ~/.bash_aliases.d/ 
        
        reade -p "Install bash.sh at /root/?" "edit" rbash "red"
        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/bash.sh /root/.bash_aliases.d/
        fi
    fi

    read -p "Install shell_keybindings.sh at ~/.bash_aliases.d/ (bash keybindings)? [Y/n]:" aliases
    if [ -z $aliases ] || [ "y" == $aliases ]; then 
        # To prevent stuff from breaking when on a system without a keyboard (raspi)
        if ! grep -q "#setxkbmap" Applications/shell_keybindings.sh; then
            sed -i s/"setxkbmap\(.*\)"/"#setxkbmap\1"/g Applications/shell_keybindings.sh  
        fi
        cp -f Applications/shell_keybindings.sh ~/.bash_aliases.d/ 

        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/shell_keybindings.sh /root/.bash_aliases.d/
        fi
    fi


    read -p "Install general.sh at ~/.bash_aliases.d/ (bash general commands aliases)? [Y/n]:" general
    if [ -z $general ] || [ "y" == $general ]; then 
        cp -f Applications/general.sh ~/.bash_aliases.d/
        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/general.sh /root/.bash_aliases.d/
        fi
    fi

    read -p "Install pathvariables.sh at ~/.bash_aliases.d/ (environment variables)? [Y/n]:" exports
        if [ -z $exports ] || [ "y" == $exports ]; then 
        cp -f Applications/pathvariables.sh ~/.bash_aliases.d/
        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/pathvariables.sh /root/.bash_aliases.d/
        fi
    fi

    read -p "Install systemctl.sh? ~/.bash_aliases.d/ (systemctl aliases/functions)? [Y/n]:" systemctl
    if [ -z $systemctl ] || [ "y" == $systemctl ]; then 
        cp -f Applications/systemctl.sh ~/.bash_aliases.d/
        
        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/systemctl.sh /root/.bash_aliases.d/
        fi
    fi

    read -p "Install sudo.sh at ~/.bash_aliases.d/ (sudo aliases)? [Y/n]:" dosu
    if [ -z $dosu ] || [ "y" == $packmang ]; then 

        cp -f Applications/sudo.sh ~/.bash_aliases.d/

        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/sudo.sh /root/.bash_aliases.d/
        fi
    fi
    
    read -p "Install git.sh at ~/.bash_aliases.d/ (git aliases)? [Y/n]:" gitsh
    if [ -z $gitsh ] || [ "y" == $gitsh ]; then 
        read -p "Configure global user and email git? [Y/n]: " gitcnf
        if [ -z $gitcnf ] || [ "y" == $gitcnf ]; then
            read -p "Email: " mail
            read -p "Gitname: " name
            git config --global user.email "$mail"
            git config --global user.name "$name"
        fi

        cp -f Applications/git.sh ~/.bash_aliases.d/

        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/git.sh /root/.bash_aliases.d/
        fi
    fi
    
    read -p "Install ssh.sh at ~/.bash_aliases.d/ (ssh related aliases)? [Y/n]:" sshsh
    if [ -z $sshsh ] || [ "y" == $sshsh ]; then 

        cp -f Applications/ssh.sh ~/.bash_aliases.d/

        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/ssh.sh /root/.bash_aliases.d/
        fi
    fi
    
    read -p "Install package_managers.sh at ~/.bash_aliases.d/ (package manager aliases)? [Y/n]:" packmang
    if [ -z $packmang ] || [ "y" == $packmang ]; then 

        cp -f Applications/package_managers.sh ~/.bash_aliases.d/

        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/package_managers.sh /root/.bash_aliases.d/
        fi
    fi
    
    read -p "Install PS1_colours.sh at ~/.bash_aliases.d/ (terminal colours)? [Y/n]:" colors
    if [ -z $bash ] || [ "y" == $bash ]; then 
        
        cp -f Applications/PS1_colours.sh ~/.bash_aliases.d/ 

        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/PS1_colours.sh /root/.bash_aliases.d/
        fi
    fi

    if [ $dist == "Manjaro" ] ; then
        read -p "Install manjaro.sh at ~/.bash_aliases.d/ (manjaro specific aliases)? [Y/n]:" manjar
        if [ -z $manjar ] || [ "y" == $manjar ]; then

            cp -f Applications/manjaro.sh ~/.bash_aliases.d/

            if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
                sudo cp -f Applications/manjaro.sh /root/.bash_aliases.d/
            fi
        fi
    fi

    read -p "Install youtube.sh at ~/.bash_aliases.d/ (youtube-dl aliases)? [Y/n]:" youtube
    if [ -z $youtube ] || [ "y" == $youtube ]; then 

        cp -f Applications/youtube.sh ~/.bash_aliases.d/

        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/youtube.sh /root/.bash_aliases.d/
        fi

    fi

    read -p "Install variety.sh at ~/.bash_aliases.d/ (variety of applications)? [Y/n]:" variety
    if [ -z $variety ] || [ "y" == $variety ]; then 

        cp -f Applications/variety.sh ~/.bash_aliases.d/

        if [ -z $rscripts ] || [ "y" == $rscripts ]; then 
            sudo cp -f Applications/variety.sh /root/.bash_aliases.d/
        fi
    fi
fi

read -p "Create ~/.config to ~/config symlink? [Y/n]:" sym1
if [ -z $sym1 ] || [ "y" == $sym1 ] && [ ! -e ~/config ]; then
    ln -s ~/.config ~/config
fi

read -p "Create /lib/systemd/system/ to user directory symlink? [Y/n]:" sym2
if [ -z $sym2 ] || [ "y" == $sym2 ] && [ ! -e ~/lib_systemd ]; then
    ln -s /lib/systemd/system/ ~/lib_systemd
fi

read -p "Create /etc/systemd/system/ to user directory symlink? [Y/n]:" sym3
if [ -z $sym3 ] || [ "y" == $sym3 ] && [ ! -e ~/etc_systemd ]; then
    ln -s /etc/systemd/system/ ~/etc_systemd
fi

read -p "Install moar? [Y/n]: " moar
if [ -z $moar ] || [ "Y" == $moar ] || [ $moar == "y" ]; then
   . $DIR/install_moar.sh 
fi

. ~/.bashrc
