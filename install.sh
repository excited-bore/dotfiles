. ./readline/rlwrap_scripts.sh
. ./checks/check_distro.sh

reade -Q "GREEN" -P "y" -p "Create ~/.bash_aliases.d/, link it to .bashrc and install scripts? (Readline included) [Y/n]:" "y n" scripts
if [ -z $scripts ] || [ "y" == $scripts ]; then

    if [ ! -d ~/.bash_aliases.d/ ]; then
        mkdir ~/.bash_aliases.d/
    fi

    if ! grep -q "~/.bash_aliases.d" ~/.bashrc; then

        #echo "alias pwd-bash=\"cd -- \"\$( dirname -- \"\${BASH_SOURCE[0]}\" )\" &> /dev/null && pwd"
        echo "if [[ -d ~/.bash_aliases.d/ ]]; then" >> ~/.bashrc
        echo "  for alias in ~/.bash_aliases.d/*.sh; do" >> ~/.bashrc
        echo "      . \"\$alias\" " >> ~/.bashrc
        echo "  done" >> ~/.bashrc
        echo "fi" >> ~/.bashrc
    fi
    
    cp -fv checks/check_distro.sh ~/.bash_aliases.d/check_distro.sh
    cp -fv readline/rlwrap_scripts.sh ~/.bash_aliases.d/rlwrap_scripts.sh


    reade -Q "YELLOW" -P "y" -p "Create /root/.bash_aliases.d/, link it to /root/.bashrc [Y/n]:" "y n" rscripts
    if [ -z $rscripts ] || [ "y" == $rscripts ]; then

        if ! sudo test -d /root/.bash_aliases.d/ ; then
            sudo mkdir /root/.bash_aliases.d/
        fi

        if ! sudo grep -q "/root/.bash_aliases.d" /root/.bashrc; then

            printf "\nif [[ -d /root/.bash_aliases.d/ ]]; then\n  for alias in /root/.bash_aliases.d/*.sh; do\n      . \"\$alias\" \n  done\nfi" | sudo tee -a /root/.bashrc > /dev/null
        fi
        
        sudo cp -fv checks/check_distro.sh /root/.bash_aliases.d/check_distro.sh
        sudo cp -fv readline/rlwrap_scripts.sh ~/.bash_aliases.d/rlwrap_scripts.sh 
    fi
    
    function inputrc_r(){
         sudo cp -fv readline/.inputrc /root/.inputrc
         sudo cp -fv readline/shell_keybindings.sh /root/.bash_aliases.d/
    }
    function inputrc() {
        cp -fv readline/.inputrc ~/
        cp -fv readline/shell_keybindings.sh ~/.bash_aliases.d/
        yes_edit_no inputrc_r "readline/.inputrc readline/shell_keybindings.sh" "Install .inputrc at /root/?" "edit" "RED"
    }
    yes_edit_no inputrc "readline/.inputrc readline/shell_keybindings.sh" "Install .inputrc at ~/ ? (readline config)" "edit" "YELLOW"


    function xresources_r(){
        sudo cp -fv xterm/.Xresources /root/.Xresources
    }
    function xresources(){
        cp -fv xterm/.Xresources ~/.Xresources
        yes_edit_no xresources_r "xterm/.Xresources" "Install .Xresources at /root/?" "edit" "RED"
    }
    yes_edit_no xresources "xterm/.Xresources" "Install .Xresources at ~/ ? (readline config)" "edit" "YELLOW"



    reade -Q "GREEN" -P "y" -p "Install bash completions for aliases in ~/.bash_completion.d? [Y/n]:" "y n" compl
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
        
        reade -Q "YELLOW" -P "y" -p "Install bash completions for aliases in /root/.bash_completion.d? [y/n]:" "y n" rcompl
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
    
    reade -Q "GREEN" -P "y" -p "Install python completions in */.bash_completion.d? [Y/n]:" "y n" pycomp
    if [ -z $pycomp ] || [ "y" == $pycomp ]; then
        . install_pythonCompletions_bash.sh
        sleep 10
    fi

    function bash_yes_r(){
        sudo cp -fv Applications/bash.sh /root/.bash_aliases.d/;
    }

    function bash_yes() {
        cp -fv Applications/bash.sh ~/.bash_aliases.d/;
        yes_edit_no bash_yes_r "Applications/bash.sh" "Install bash.sh at /root/?" "yes" "YELLOW";
    }

    yes_edit_no bash_yes "Applications/bash.sh" "Install bash.sh at ~/ ? (bash specific aliases)?" "yes" "GREEN";
    
    keybinds_r(){
        sudo cp -fv Applications/shell_keybindings.sh /root/.bash_aliases.d
    }
    keybinds(){
        cp -fv Applications/shell_keybindings.sh ~/.bash_aliases.d/
        # To prevent stuff from breaking when on a system without a keyboard (raspi)
        if ! grep -q "#setxkbmap" Applications/shell_keybindings.sh; then
            sed -i "s|"setxkbmap\(.*\)"|"#setxkbmap\1"|g" Applications/shell_keybindings.sh  
        fi                                               
        yes_edit_no keybinds_r "Applications/shell_keybindings.sh" "Install shell_keybindings.sh at /root/?" "yes" "YELLOW" 
    }
    yes_edit_no keybinds "Applications/shell_keybindings.sh" "Install shell_keybindings.sh at ~/ ? (generally related to keybinds)? " "yes" "GREEN";
    

    pathvariables_r(){
         sudo cp -fv Applications/pathvariables.sh /root/.bash_aliases.d/
    }
    pathvariables(){
        cp -fv Applications/pathvariables.sh ~/.bash_aliases.d/
        yes_edit_no pathvariables_r "Applications/pathvariables.sh" "Install pathvariables.sh at /root/?" "yes" "YELLOW"
    }
    yes_edit_no pathvariables "Applications/pathvariables.sh" "Install pathvariables.sh at ~/ ? " "edit" "YELLOW"


    general_r(){
         sudo cp -fv Applications/general.sh /root/.bash_aliases.d/
    }
    general(){
        cp -fv Applications/general.sh ~/.bash_aliases.d/
        yes_edit_no general_r "Applications/general.sh" "Install general.sh at /root/?" "yes" "GREEN"
    }
    yes_edit_no general "Applications/general.sh" "Install general.sh at ~/ ? (general terminal related aliases) " "yes" "YELLOW"


    systemd_r(){
        sudo cp -fv Applications/systemctl.sh /root/.bash_aliases.d/
    }
    systemd(){
        cp -fv Applications/systemctl.sh ~/.bash_aliases.d/
        yes_edit_no systemd_r "Applications/systemctl.sh" "Install systemctl.sh at /root/?" "yes" "GREEN" 
    }
    yes_edit_no systemd "Applications/systemctl.sh" "Install systemctl.sh? ~/.bash_aliases.d/ (systemctl aliases/functions)?" "edit" "GREEN"
        
    dosu_r(){
        sudo cp -fv Applications/sudo.sh /root/.bash_aliases.d/;
    }

    dosu(){
        cp -fv Applications/sudo.sh ~/.bash_aliases.d/
        yes_edit_no dosu_r "Applications/sudo.sh" "Install sudo.sh at /root/?" "yes" "GREEN" 
    }

    yes_edit_no dosu "Applications/sudo.sh" "Install sudo.sh at ~/.bash_aliases.d/ (sudo aliases)? " "edit" "GREEN"

    packman_r(){
        sudo cp -fv Applications/package_managers.sh /root/.bash_aliases.d/;
    }

    packman(){
        cp -fv Applications/package_managers.sh ~/.bash_aliases.d/
        yes_edit_no packman_r "Applications/package_managers.sh" "Install package_managers.sh at /root/?" "edit" "YELLOW" 
    }

    yes_edit_no packman "Applications/package_managers.sh" "Install package_managers.sh at ~/.bash_aliases.d/ (package manager aliases)? " "edit" "GREEN"
    
    
    ssh_r(){
        sudo cp -fv Applications/ssh.sh /root/.bash_aliases.d/;
    }

    sshh(){
        cp -fv Applications/ssh.sh ~/.bash_aliases.d/
        yes_edit_no ssh_r "Applications/ssh.sh" "Install ssh.sh at /root/?" "edit" "YELLOW" 
    }

    yes_edit_no sshh "Applications/ssh.sh" "Install ssh.sh at ~/.bash_aliases.d/ (ssh aliases)? " "edit" "GREEN"

    git_r(){
        sudo cp -fv Applications/git.sh /root/.bash_aliases.d/;
    }

    gitt(){
        if [ $distro == "Arch" ] || [ $distro_base == "Arch" ]; then
            sudo pacman -Su git
        elif [ $distro == "Debian" ] || [ $distro_base == "Debian" ]; then
            sudo apt install git
        fi
        read -p "Configure global user and email git? [Y/n]: " gitcnf
        if [ -z $gitcnf ] || [ "y" == $gitcnf ]; then
            read -p "Email: " mail
            read -p "Gitname: " name
            git config --global user.email "$mail"
            git config --global user.name "$name"
        fi 
        cp -fv Applications/git.sh ~/.bash_aliases.d/
        yes_edit_no git_r "Applications/git.sh" "Install git.sh at /root/?" "no" "RED" 
    }
    yes_edit_no gitt "Applications/git.sh" "Install git.sh at ~/.bash_aliases.d/ (git aliases)? " "yes" "GREEN"
    
    ps1_r(){
        sudo cp -fv Applications/PS1_colours.sh /root/.bash_aliases.d/;
    }

    ps11(){
        cp -fv Applications/PS1_colours.sh ~/.bash_aliases.d/
        yes_edit_no ps1_r "Applications/PS1_colours.sh" "Install PS1_colours.sh at /root/?" "yes" "GREEN" 
    }
    yes_edit_no ps11 "Applications/PS1_colours.sh" "Install PS1_colours.sh at ~/.bash_aliases.d/ (Coloured command prompt)? " "yes" "GREEN"
    
    if [ $distro == "Manjaro" ] ; then
        manj_r(){
            sudo cp -fv Applications/manjaro.sh /root/.bash_aliases.d/;
        }

        manj(){
            cp -fv Applications/manjaro.sh ~/.bash_aliases.d/
            yes_edit_no manj_r "Applications/manjaro.sh" "Install manjaro.sh at /root/?" "yes" "GREEN" 
        }
        yes_edit_no manj "Applications/manjaro.sh" "Install manjaro.sh at ~/.bash_aliases.d/ (manjaro specific aliases)? " "yes" "GREEN"
    fi
    
    variti_r(){
        sudo cp -fv Applications/variety.sh /root/.bash_aliases.d/;
    }

    variti(){
        cp -fv Applications/variety.sh ~/.bash_aliases.d/
        yes_edit_no variti_r "Applications/variety.sh" "Install variety.sh at /root/?" "no" "YELLOW" 
    }
    yes_edit_no variti "Applications/variety.sh" "Install variety.sh at ~/.bash_aliases.d/ (aliases for a variety of tools)? " "edit" "GREEN" 
    
   
    ytbe_r(){
        sudo cp -fv Applications/youtube.sh /root/.bash_aliases.d/;
    }

    ytbe(){
        . ./check_youtube.sh
        cp -fv Applications/youtube.sh ~/.bash_aliases.d/
        yes_edit_no ytbe_r "Applications/youtube.sh" "Install youtube.sh at /root/?" "no" "YELLOW" 
    }
    yes_edit_no ytbe "Applications/youtube.sh" "Install yt-dlp (youtube cli download) and youtube.sh at ~/.bash_aliases.d/ (yt-dlp aliases)? " "yes" "GREEN"

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

reade -Q "GREEN" -P "y" -p "Install moar? (Pager with linenumbers) [Y/n]: " "y n" moar
if [ -z $moar ] || [ "Y" == $moar ] || [ $moar == "y" ]; then
   . ./install_moar.sh 
fi

. ~/.bashrc
