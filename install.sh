
. ./readline/rlwrap_scripts.sh
. ./checks/check_distro.sh
. ./checks/check_rlwrap.sh


if [ ! -e ~/config ]; then
    reade -Q "BLUE" -i "y" -p "Create ~/.config to ~/config symlink? [Y/n]:" "y n" sym1
    if [ -z $sym1 ] || [ "y" == $sym1 ] && [ ! -e ~/config ]; then
        ln -s ~/.config ~/config
    fi
fi

if [ ! -e ~/lib_systemd ]; then
    reade -Q "BLUE" -i "y" -p "Create /lib/systemd/system/ to user directory symlink? [Y/n]:" "y n" sym2
    if [ -z $sym2 ] || [ "y" == $sym2 ] && [ ! -e ~/lib_systemd ]; then
        ln -s /lib/systemd/system/ ~/lib_systemd
    fi
fi

if [ ! -e ~/etc_systemd ]; then
    reade -Q "BLUE" -i "y" -p "Create /etc/systemd/system/ to user directory symlink? [Y/n]:" "y n" sym3
    if [ -z $sym3 ] || [ "y" == $sym3 ] && [ ! -e ~/etc_systemd ]; then
        ln -s /etc/systemd/system/ ~/etc_systemd
    fi
fi


reade -Q "GREEN" -i "y" -p "Check existence (and create) ~/.bash_aliases.d/, link it to .bashrc and start installation scripts? [Y/n]:" "y n" scripts
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


    reade -Q "YELLOW" -i "y" -p "Create /root/.bash_aliases.d/, link it to /root/.bashrc [Y/n]:" "y n" rscripts
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
    

    # Xresources
    
    function xresources_r(){
        sudo cp -fv xterm/.Xresources /root/.Xresources
        sudo cp -fv xterm/xterm.sh /root/xterm.sh
    }
    function xresources(){
        cp -fv xterm/.Xresources ~/.Xresources
        cp -fv xterm/xterm.sh ~/xterm.sh
        yes_edit_no xresources_r "xterm/.Xresources xterm/xterm.sh" "Install .Xresources and xterm.sh at /root/?" "edit" "RED"
    }
    yes_edit_no xresources "xterm/.Xresources xterm/xterm.sh" "Install .Xresources and xterm.sh at ~/.bash_aliases.d/ ? (readline config)" "edit" "YELLOW"
    
    # Tty keybinding

    stty_r(){
         sudo cp -fv aliases/01-tty.sh /root/.bash_aliases.d/
    }
    stty_n(){
        cp -fv aliases/01-tty.sh ~/.bash_aliases.d/
        yes_edit_no stty_r "aliases/01-tty.sh" "Install 01-stty.sh at /root/.bash_aliases.d/?" "yes" "YELLOW"
    }
    yes_edit_no stty_n "aliases/01-tty.sh" "Install 01-stty.sh at ~/.bash_aliases.d/ (Tty keybindings and other startup lines) ? " "edit" "YELLOW"

    # Readline
    
    function inputrc_r(){
         sudo cp -fv readline/.inputrc /root/.inputrc
    }
    function inputrc() {
        cp -fv readline/.inputrc ~/
        yes_edit_no inputrc_r "readline/.inputrc" "Install .inputrc at /root/?" "edit" "GREEN"
    }
    yes_edit_no inputrc "readline/.inputrc" "Install .inputrc at ~/ ? (readline config)" "edit" "GREEN"
    
    # Shell-keybindings
    
    if grep -q "bind -x '\"\\\C-s\": ctrl-s'" ./aliases/shell_keybindings.sh && ! grep -q "#bind -x '\"\\\C-s\": ctrl-s'" ./aliases/shell_keybindings.sh; then
        sed -i 's|bind -x '\''"\\C-s\": ctrl-s'\''|#bind -x '\''"\\C-s\": ctrl-s'\''|g' ./aliases/shell_keybindings.sh
        sed -i 's|bind -x '\''"\\eOR\": ctrl-s'\''|#bind -x '\''"\\eOR\": ctrl-s'\''|g' ./aliases/shell_keybindings.sh
    fi

    if grep -q "bind -x '\"\\\eOQ\": ranger'" readline/shell_keybindings.sh; then
        sed -i 's|bind -x '\''"\\eOQ\": ranger'\''|#bind -x '\''"\\eOQ\": ranger'\''|g' ./readline/shell_keybindings.sh
    fi

    function shell-keybindings_r(){
         sudo cp -fv aliases/shell_keybindings.sh /root/.bash_aliases.d/
    }
    function shell-keybindings() {
        cp -fv aliases/shell_keybindings.sh ~/.bash_aliases.d/
        yes_edit_no shell-keybindings_r "aliases/shell_keybindings.sh" "Install shell_keybindings.sh at /root/.bash_aliases/?" "edit" "RED"
    }
    yes_edit_no shell-keybindings "aliases/shell_keybindings.sh" "Install shell-keybindings.sh at ~/.bash_aliases/ ? (bind commands)" "yes" "GREEN"

    # Pathvariables
    if grep -q "export MOAR=" aliases/00-pathvariables.sh && ! grep -q "#export MOAR=" aliases/00-pathvariables.sh ; then
        sed -i "s/export MOAR=/#export MOAR=/g" aliases/00-pathvariables.sh 
        sed -i "s/export PAGER=/#export PAGER=/g" aliases/00-pathvariables.sh
        sed -i "s/export SYSTEMD_PAGER=/#export SYSTEMD_PAGER=/g" aliases/00-pathvariables.sh
        sed -i "s/export SYSTEMD_PAGERSECURE=/#export SYSTEMD_PAGERSECURE=/g" aliases/00-pathvariables.sh
    fi

    if grep -q "export FZF_DEFAULT_COMMAND" aliases/00-pathvariables.sh && ! grep -q "#export FZF_DEFAULT_COMMAND" aliases/00-pathvariables.sh ; then
        sed -i 's|export FZF_DEFAULT_COMMAND|#export FZF_DEFAULT_COMMAND|g' aliases/00-pathvariables.sh
        sed -i 's|export FZF_CTRL_T_COMMAND|#export FZF_CTRL_T_COMMAND|g' aliases/00-pathvariables.sh  
    fi

    pathvariables_r(){
         sudo cp -fv aliases/00-pathvariables.sh /root/.bash_aliases.d/00-pathvariables.sh
    }                                            
    pathvariables(){
        cp -fv aliases/00-pathvariables.sh ~/.bash_aliases.d/00-pathvariables.sh
        yes_edit_no pathvariables_r "aliases/00-pathvariables.sh" "Install 00-pathvariables.sh at /root/.bash_aliases.d/?" "yes" "YELLOW"
    }
    yes_edit_no pathvariables "aliases/00-pathvariables.sh" "Install 00-pathvariables.sh at ~/.bash_aliases.d/ ? " "edit" "YELLOW"
    
    # Moar (Custom pager instead of less)
    
    if [ ! -x "$(command -v moar)" ]; then
        reade -Q "GREEN" -i "y" -p "Install moar? (Custom pager instead of less with linenumbers) [Y/n]: " "y n" moar
        if [ -z $moar ] || [ "Y" == $moar ] || [ $moar == "y" ]; then
            . ./install_moar.sh 
            reade -Q "GREEN" -i "y" -p "Set moar default pager for $USER? [Y/n]: " "y n" moar_usr
            if [ -z "$moar_usr" ] || [ "y" == "$moar_usr" ] || [ "Y" == "$moar_usr" ]; then
                path=~/.bashrc
                if [ -f ~/.bash_aliases/00-pathvariables.sh ]; then
                    path=~/.bash_aliases/00-pathvariables.sh
                fi
                sed -i "s/#export MOAR=/export MOAR=/g" $path 
                sed -i "s/#export PAGER=/export PAGER=/g" $path
                sed -i "s/#export SYSTEMD_PAGER=/export SYSTEMD_PAGER=/g" $path
                sed -i "s/#export SYSTEMD_PAGERSECURE=/export SYSTEMD_PAGERSECURE=/g" $path
            fi
            
            reade -Q "YELLOW" -i "y" -p "Set moar default pager for root? [Y/n]: " "y n" moar_root
            if [ -z "$moar_root" ] || [ "y" == "$moar_root" ] || [ "Y" == "$moar_root" ]; then
                path=/root/.bashrc
                if [ -f /root/.bash_aliases/00-pathvariables.sh ]; then
                    path=/root/.bash_aliases/00-pathvariables.sh
                fi
                sudo sed -i "s/#export MOAR=/export MOAR=/g" $path 
                sudo sed -i "s/#export PAGER=/export PAGER=/g" $path
                sudo sed -i "s/#export SYSTEMD_PAGER=/export SYSTEMD_PAGER=/g" $path
                sudo sed -i "s/#export SYSTEMD_PAGERSECURE=/export SYSTEMD_PAGERSECURE=/g" $path
            fi
        fi
    fi

    # Fzf (Fuzzy Finder)
    . ./install_fzf.sh 
    
    # Ranger (File explorer)
    . ./install_ranger.sh 
    
    reade -Q "GREEN" -i "y" -p "Install bash completions for aliases in ~/.bash_completion.d? [Y/n]:" "y n" compl
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
        
        reade -Q "YELLOW" -i "y" -p "Install bash completions for aliases in /root/.bash_completion.d? [Y/n]:" "y n" rcompl
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
    
    #reade -Q "GREEN" -i "y" -p "Install python completions in */.bash_completion.d? [Y/n]:" "y n" pycomp
    #if [ -z $pycomp ] || [ "y" == $pycomp ]; then
    #    . install_pythonCompletions_bash.sh
    #fi

    
    #keybinds_r(){
        #sudo cp -fv aliases/shell_keybindings.sh /root/.bash_aliases.d
    #}
    #keybinds(){
    #    cp -fv aliases/shell_keybindings.sh ~/.bash_aliases.d/
    #    # To prevent stuff from breaking when on a system without a keyboard (raspi)
    #    if ! grep -q "#setxkbmap" aliases/shell_keybindings.sh; then
    #        sed -i "s|"setxkbmap\(.*\)"|"#setxkbmap\1"|g" aliases/shell_keybindings.sh  
    #    fi                                               
    #    yes_edit_no keybinds_r "aliases/shell_keybindings.sh" "Install shell_keybindings.sh at /root/?" "yes" "YELLOW" 
    #}
    #yes_edit_no keybinds "aliases/shell_keybindings.sh" "Install shell_keybindings.sh at ~/ ? (generally related to keybinds)? " "yes" "GREEN";
    
    function bash_yes_r(){
        sudo cp -fv aliases/bash.sh /root/.bash_aliases.d/;
    }

    function bash_yes() {
        cp -fv aliases/bash.sh ~/.bash_aliases.d/;
        yes_edit_no bash_yes_r "aliases/bash.sh" "Install bash.sh at /root/?" "yes" "YELLOW";
    }

    yes_edit_no bash_yes "aliases/bash.sh" "Install bash.sh at ~/ ? (bash specific aliases)?" "yes" "GREEN";


    general_r(){
         sudo cp -fv aliases/general.sh /root/.bash_aliases.d/
    }
    general(){
        cp -fv aliases/general.sh ~/.bash_aliases.d/
        yes_edit_no general_r "aliases/general.sh" "Install general.sh at /root/?" "yes" "GREEN"
    }
    yes_edit_no general "aliases/general.sh" "Install general.sh at ~/ ? (general terminal related aliases) " "yes" "YELLOW"


    systemd_r(){
        sudo cp -fv aliases/systemctl.sh /root/.bash_aliases.d/
    }
    systemd(){
        cp -fv aliases/systemctl.sh ~/.bash_aliases.d/
        yes_edit_no systemd_r "aliases/systemctl.sh" "Install systemctl.sh at /root/?" "yes" "GREEN" 
    }
    yes_edit_no systemd "aliases/systemctl.sh" "Install systemctl.sh? ~/.bash_aliases.d/ (systemctl aliases/functions)?" "edit" "GREEN"
        
    dosu_r(){
        sudo cp -fv aliases/sudo.sh /root/.bash_aliases.d/;
    }

    dosu(){
        cp -fv aliases/sudo.sh ~/.bash_aliases.d/
        yes_edit_no dosu_r "aliases/sudo.sh" "Install sudo.sh at /root/?" "yes" "GREEN" 
    }

    yes_edit_no dosu "aliases/sudo.sh" "Install sudo.sh at ~/.bash_aliases.d/ (sudo aliases)? " "edit" "GREEN"

    packman_r(){
        sudo cp -fv aliases/package_managers.sh /root/.bash_aliases.d/;
    }

    packman(){
        cp -fv aliases/package_managers.sh ~/.bash_aliases.d/
        yes_edit_no packman_r "aliases/package_managers.sh" "Install package_managers.sh at /root/?" "edit" "YELLOW" 
    }

    yes_edit_no packman "aliases/package_managers.sh" "Install package_managers.sh at ~/.bash_aliases.d/ (package manager aliases)? " "edit" "GREEN"
    
    
    ssh_r(){
        sudo cp -fv aliases/ssh.sh /root/.bash_aliases.d/;
    }

    sshh(){
        cp -fv aliases/ssh.sh ~/.bash_aliases.d/
        yes_edit_no ssh_r "aliases/ssh.sh" "Install ssh.sh at /root/?" "edit" "YELLOW" 
    }

    yes_edit_no sshh "aliases/ssh.sh" "Install ssh.sh at ~/.bash_aliases.d/ (ssh aliases)? " "edit" "GREEN"

    git_r(){
        sudo cp -fv aliases/git.sh /root/.bash_aliases.d/;
    }

    gitt(){
        if [ $distro == "Arch" ] || [ $distro_base == "Arch" ]; then
            yes | sudo pacman -Su git
        elif [ $distro == "Debian" ] || [ $distro_base == "Debian" ]; then
            yes | sudo apt update
            yes | sudo apt install git
        fi
        #if [ git config --list | grep -q user.email ]; then
        read -p "Configure global user and email git? [Y/n]: " gitcnf
        if [ -z $gitcnf ] || [ "y" == $gitcnf ]; then
            read -p "Email: " mail
            read -p "Gitname: " name
            git config --global user.email "$mail"
            git config --global user.name "$name"
        fi 
        cp -fv aliases/git.sh ~/.bash_aliases.d/
        
        . install_copy-conf.sh
        #yes_edit_no git_r "aliases/git.sh" "Install git.sh at /root/?" "no" "RED" 
    }
    yes_edit_no gitt "aliases/git.sh" "Install git.sh at ~/.bash_aliases.d/ (git aliases)? " "yes" "GREEN"
    
    ps1_r(){
        sudo cp -fv aliases/PS1_colours.sh /root/.bash_aliases.d/;
    }

    ps11(){
        cp -fv aliases/PS1_colours.sh ~/.bash_aliases.d/
        yes_edit_no ps1_r "aliases/PS1_colours.sh" "Install PS1_colours.sh at /root/?" "yes" "GREEN" 
    }
    yes_edit_no ps11 "aliases/PS1_colours.sh" "Install PS1_colours.sh at ~/.bash_aliases.d/ (Coloured command prompt)? " "yes" "GREEN"
    
    if [ $distro == "Manjaro" ] ; then
        manj_r(){
            sudo cp -fv aliases/manjaro.sh /root/.bash_aliases.d/;
        }

        manj(){
            cp -fv aliases/manjaro.sh ~/.bash_aliases.d/
            yes_edit_no manj_r "aliases/manjaro.sh" "Install manjaro.sh at /root/?" "yes" "GREEN" 
        }
        yes_edit_no manj "aliases/manjaro.sh" "Install manjaro.sh at ~/.bash_aliases.d/ (manjaro specific aliases)? " "yes" "GREEN"
    fi
    
    variti_r(){
        sudo cp -fv aliases/variety.sh /root/.bash_aliases.d/;
    }

    variti(){
        cp -fv aliases/variety.sh ~/.bash_aliases.d/
        yes_edit_no variti_r "aliases/variety.sh" "Install variety.sh at /root/?" "no" "YELLOW" 
    }
    yes_edit_no variti "aliases/variety.sh" "Install variety.sh at ~/.bash_aliases.d/ (aliases for a variety of tools)? " "edit" "GREEN" 
    
   
    ytbe_r(){
        sudo cp -fv aliases/youtube.sh /root/.bash_aliases.d/;
    }

    ytbe(){
        . ./check_youtube.sh
        cp -fv aliases/youtube.sh ~/.bash_aliases.d/
        yes_edit_no ytbe_r "aliases/youtube.sh" "Install youtube.sh at /root/?" "no" "YELLOW" 
    }
    yes_edit_no ytbe "aliases/youtube.sh" "Install yt-dlp (youtube cli download) and youtube.sh at ~/.bash_aliases.d/ (yt-dlp aliases)? " "yes" "GREEN"

fi


. ~/.bashrc
