#!/bin/bash

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

#  Pathvariables

pathvr=$(pwd)/pathvars/.pathvariables.env
if ! test -f $pathvr; then
    wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/pathvars/.pathvariables.env
    pathvr=$TMPDIR/.pathvariables.env
fi

pre='y'
othr='n'
color='GREEN'
prmpt='[Y/n]: '

echo "Next $(tput setaf 1)sudo$(tput sgr0) check for /root/.pathvariables.env' "

if ! test -z $1; then
    pathvars=$!
    if test -f ~/.pathvariables.env && sudo test -f /root/.pathvariables.env; then
        pre='n' 
        othr='y'
        color='YELLOW'
        prmpt='[N/y]: '
    fi
else
    reade -Q "$color" -i "$pre" -p "Check existence/create .pathvariables.env and link it to .bashrc in $HOME/ and /root/? $prmpt" "$othr" pathvars
fi

if [ "$pathvars" == "y" ] || [ -z "$pathvars" ]; then
    #Comment out every export in .pathvariables
    sed -i -e '/export/ s/^#*/#/' $pathvr
        
    # Allow if checks
    sed -i 's/^#\[\[/\[\[/' $pathvr
    sed -i 's/^#type/type/' $pathvr
    
    # Comment out FZF stuff
    sed -i 's/  --bind/ #--bind/' $pathvr
    sed -i 's/  --preview-window/ #--preview-window/' $pathvr
    sed -i 's/  --color/ #--color/' $pathvr

    # Set tmpdir
    sed 's|#export TMPDIR|export TMPDIR|' -i $pathvr

    # Package Managers
    #reade -Q "YELLOW" -i "y" -p "Check and create DIST,DIST_BASE,ARCH,PM and WRAPPER? (distro, distro base, architecture, package manager and pm wrapper) [Y/n]:" "y n" Dists
    #if [ "$Dists" == "y" ]; then
    #   printf "NOT YET IMPLEMENTED\n"
    #fi
    
    # TODO: non ugly values
    reade -Q "YELLOW" -i "n" -p "Set LS_COLORS with some predefined values? (WARNING: ugly values) [N/y]: " "y" lsclrs
    if [ "$lsclrs" == "y" ] || [ -z "$lsclrs" ]; then
        sed 's/^#export LS_COLORS/export LS_COLORS/' -i $pathvr
    fi
    
    
    reade -Q "GREEN" -i "y" -p "Set PAGER? (Page reader) [Y/n]: " "n" pgr
    if [ "$pgr" == "y" ] || [ -z "$pgr" ]; then
        # Uncomment export PAGER=
        sed 's/^#export PAGER=/export PAGER=/' -i $pathvr
        
        pagers="less more"
        prmpt="${green} \tless = Default pager - Basic, archaic but very customizable\n\tmore = Preinstalled other pager - leaves text by default, less customizable (ironically)\n"
        if type most &> /dev/null; then
            pagers="$pagers most"
            prmpt="$prmpt \tmost = Installed pager that is very customizable\n"
        fi
        if type bat &> /dev/null; then
            pagers="$pagers bat"
            prmpt="$prmpt \tbat = Cat clone / pager wrapper with syntax highlighting\n"
            sed -i 's/#export BAT=/export BAT=/' $pathvr
        fi
        if type moar &> /dev/null; then
            pagers="$pagers moar"
            prmpt="$prmpt \tmoar = Installed pager with an awesome default configuration\n"
            sed -i 's/#export MOAR=/export MOAR=/' $pathvr
        fi
        if type nvimpager &> /dev/null; then
            pagers="$pagers nvimpager"
            prmpt="$prmpt \tnvimpager = The pager that acts and feels like Neovim. Did you guess?\n"
        fi
        printf "$prmpt${normal}"
        
        reade -Q "GREEN" -i "less" -p "PAGER=" "$pagers" pgr2
        pgr2=$(whereis "$pgr2" | awk '{print $2}')
        sed -i 's|export PAGER=.*|export PAGER='$pgr2'|' $pathvr

        # Set less options that system supports 
        sed -i 's|#export LESS=|export LESS="*"|g' $pathvr
        lss=$(cat $pathvr | grep 'export LESS="*"' | sed 's|export LESS="\(.*\)"|\1|g')
        lss_n=""
        for opt in ${lss}; do
            opt1=$(echo "$opt" | sed 's|--\(\)|\1|g' | sed 's|\(\)\=.*|\1|g')
            if (man less | grep -Fq "${opt1}") 2> /dev/null; then
                lss_n="$lss_n $opt"
            fi
        done
        sed -i "s|export LESS=.*|export LESS=\" $lss_n\"|g" $pathvr
        #sed -i 's/#export LESSEDIT=/export LESSEDIT=/' .pathvariables.env
        unset lss lss_n opt opt1

        # Set moar options
        sed -i 's/#export MOAR=/export MOAR=/' $pathvr
        
        if test "$(basename $pgr2)" == "bat" && type moar &> /dev/null || test "$(basename $pgr2)" == "bat" && type nvimpager &> /dev/null ; then
            pagers=""
            prmpt="${cyan}Bat is a pager wrapper that defaults to less except if BAT_PAGER is set\n\t${green}less = Default pager - Basic, archaic but very customizable\n"
            if type moar &> /dev/null; then
                pagers="$pagers moar"
                prmpt="$prmpt \tmoar = Custom pager with an awesome default configuration\n"
            fi
            if type nvimpager &> /dev/null; then
                pagers="$pagers nvimpager"
                prmpt="$prmpt \tnvimpager = The pager that acts and feels like Neovim. Did you guess?\n"
            fi
            printf "$prmpt${normal}"
            reade -Q "GREEN" -i "less" -p "BAT_PAGER=" "$pagers" pgr2
            pgr2=$(whereis "$pgr2" | awk '{print $2}')
            [[ "$pgr2" =~ "less" ]] && pgr2="$pgr2 \$LESS --line-numbers"  
            [[ "$pgr2" =~ "moar" ]] && pgr2="$pgr2 \$MOAR --no-linenumbers"  
            sed 's/^#export BAT_PAGER=/export BAT_PAGER=/' -i $pathvr
            sed -i 's|^export BAT_PAGER=.*|export BAT_PAGER='$pgr2'|' $pathvr
        fi
    fi
    unset prmpt
    
    if type nvim &> /dev/null; then
        reade -Q "GREEN" -i "y" -p "Set Neovim as MANPAGER? [Y/n]: " "y n" manvim
        if [ "$manvim" == "y" ]; then
           sed -i 's|.export MANPAGER=.*|export MANPAGER='\''nvim +Man!'\''|g' $pathvr 
        fi
    fi

    reade -Q "GREEN" -i "y" -p "Set EDITOR and VISUAL? [Y/n]: " "n" edtvsl
    if [ "$edtvsl" == "y" ] || [ -z "$edtvsl" ]; then
        editors=""
        prmpt="${green}\tnano = Default editor - Basic, but userfriendly\n" 
        if type vi &> /dev/null; then
            editors="vi $editors"
            prmpt="$prmpt \tvi = Archaic and non-userfriendly editor\n"
        fi
        if type micro &> /dev/null; then
            editors="micro $editors"
            prmpt="$prmpt \tMicro = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
        fi
        if type ne &> /dev/null; then
            editors="ne $editors"
            prmpt="$prmpt \tNice editor = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
        fi
        if type vim &> /dev/null; then
            editors="vim $editors"
            prmpt="$prmpt \tvim = The one and only true modal editor - Not userfriendly, but many features (maybe even too many) and greatly customizable\n"
            sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" $pathvr
            sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" $pathvr
        fi
        if type nvim &> /dev/null; then                                  
            editors="nvim $editors"
            prmpt="$prmpt \tnvim (neovim) = A better vim? - Faster and less buggy then regular vim, even a little userfriendlier\n"
            sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" $pathvr
            sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" $pathvr
        fi
        if type emacs &> /dev/null; then
            editors="emacs $editors"
            prmpt="$prmpt \tEmacs = One of the oldest and versatile editors - Modal and featurerich, but overwhelming as well\n"
        fi
        printf "$prmpt${normal}"
        reade -Q "GREEN" -i "nano" -p "EDITOR (Terminal)=" "$editors" edtor
        if [ "$edtor" == "emacs" ]; then
            edtor="emacs -nw"
        fi
        edtor=$(whereis "$edtor" | awk '{print $2}')
        sed -i 's|#export EDITOR=.*|export EDITOR='$edtor'|g' $pathvr
        
        # Make .txt file and output file
        touch $TMPDIR/editor-outpt
        # Redirect output to file in subshell (mimeopen gives output but also starts read. This cancels read). In tmp because that gets cleaned up
        (echo "" | mimeopen -a editor-check.sh &> $TMPDIR/editor-outpt)
        compedit="nano $(cat $TMPDIR/editor-outpt | awk 'NR > 2' | awk '{if (prev_1_line) print prev_1_line; prev_1_line=prev_line} {prev_line=$NF}' | sed 's|[()]||g' | tr -s [:space:] \\n | uniq | tr '\n' ' ') $editors"
        compedit="$(echo $compedit | tr ' ' '\n' | sort -u)"

        prmpt="Found visual editors using ${CYAN}mimeopen${normal} (non definitive list): ${GREEN}\n"
        for i in $compedit; do
            prmpt="$prmpt\t - $i\n"
        done
        prmpt="$prmpt${normal}"

        frst="$(echo $compedit | awk '{print $1}')"
        compedit="$(echo $compedit | sed "s/\<$frst\> //g")"

        printf "$prmpt"

        reade -Q "GREEN" -i "$frst" -p "VISUAL (GUI editor)=" "$compedit" vsual
        vsual="$(whereis "$vsual" | awk '{print $2}')"
        sed -i 's|#export VISUAL=|export VISUAL=|g' $pathvr
        sed -i 's|export VISUAL=.*|export VISUAL='"$vsual"'|g' $pathvr
        
        if grep -q "#export SUDO_EDITOR" $pathvr; then
            reade -Q "GREEN" -i "y" -p 'Set SUDO_EDITOR to $EDITOR? [Y/n]: ' "n" sud_edt
            if test "$sud_edt" == "y"; then
                sed -i 's|#export SUDO_EDITOR.*|export SUDO_EDITOR=$EDITOR|g' $pathvr
            fi
        fi
        
        echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for 'Defaults env_keep += \"PAGER\"' in /etc/sudoers"
        if ! sudo grep -q "Defaults env_keep += \"PAGER\"" /etc/sudoers; then
            printf "${bold}${yellow}Sudo by default does not respect the user's PAGER environment. If you were to want to keep your userdefined less options or use a custom pager (more on that later) when using sudo ${cyan}systemctl/journalctl${bold}${yellow}, you would need to always pass your environment using 'sudo -E'\n${normal}"
            reade -Q "YELLOW" -i "y" -p "Change this behaviour permanently in /etc/sudoers? [Y/n]: " "n" sudrs
            if test "$sudrs" == "y"; then
                sudo sed -i '1s/^/Defaults env_keep += "PAGER"\n/' /etc/sudoers
                echo "Added ${RED}'Defaults env_keep += \"PAGER\"'${normal} to /etc/sudoers"
            fi
        fi

        echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for 'Defaults env_keep += \"EDITOR VISUAL\"' in /etc/sudoers"
        if ! sudo grep -q "Defaults env_keep += \"EDITOR VISUAL\"" /etc/sudoers; then
            printf "${bold}${yellow}Sudo by default does not respect the user's EDITOR/VISUAL environment and SUDO_EDITOR is not always checked by programs.\nIf you were to want edit root crontabs (sudo crontab -e), you would get vi (unless using 'sudo -E' to pass your environment)\n"
            reade -Q "YELLOW" -i "y" -p "Change this behaviour permanently in /etc/sudoers? (Run 'man --pager='less -p ^security' less' if you want to see the potential security holes when using less) [Y/n]: " "n" sudrs
            if test "$sudrs" == "y"; then
                sudo sed -i '1s/^/Defaults env_keep += "EDITOR VISUAL"\n/' /etc/sudoers
                echo "Added ${RED}'Defaults env_keep += \"EDITOR VISUAL\"'${normal} to /etc/sudoers"
            fi
        fi
    fi
    unset edtvsl compedit frst editors prmpt

    # Set DISPLAY
    addr=$(nmcli device show | grep IP4.ADDR | awk 'NR==1{print $2}'| sed 's|\(.*\)/.*|\1|')
    #reade -Q "GREEN" -i "n" -p "Set DISPLAY to ':$(addr).0'? [Y/n]:" "y n" dsply
    if [[ $- =~ i ]] && [[ -n "$SSH_TTY" ]]; then
        reade -Q "YELLOW" -i "n" -p "Detected shell is SSH. For X11, it's more reliable performance to dissallow shared clipboard (to prevent constant hanging). Set DISPLAY to 'localhost:10.0'? [Y/n]:" "y n" dsply
        if [ "$dsply" == "y" ] || [ -z "$dsply" ]; then
            sed -i "s|.export DISPLAY=.*|export DISPLAY=\"localhost:10.0\"|" $pathvr
        fi
    fi
    unset dsply

    if type go &> /dev/null; then
        sed -i 's|#export GOPATH|export GOPATH|' $pathvr 
    fi
    unset snapvrs

    if type snap &> /dev/null; then
        sed -i 's|#export PATH=/bin/snap|export PATH=/bin/snap|' $pathvr 
    fi
    unset snapvrs
    
    if type flatpak &> /dev/null; then
        sed -i 's|#export FLATPAK|export FLATPAK|' $pathvr 
        sed -i 's|#\(export PATH=$PATH:$HOME/.local/bin/flatpak\)|\1|g' $pathvr
    fi
    unset snapvrs

    # TODO do something for flatpak  (XDG_DATA_DIRS)
    # Check if xdg installed
    if type xdg-open &> /dev/null ; then
        prmpt="${green}This will set XDG pathvariables to their respective defaults\n\
        XDG is related to default applications\n\
        Setting these could be usefull when installing certain programs \n\
        Defaults:\n\
        - XDG_CACHE_HOME=$HOME/.cache\n\
        - XDG_CONFIG_HOME=$HOME/.config\n\
        - XDG_CONFIG_DIRS=/etc/xdg\n\
        - XDG_DATA_HOME=$HOME/.local/share\n\
        - XDG_DATA_DIRS=/usr/local/share/:/usr/share\n\
        - XDG_STATE_HOME=$HOME/.local/state\n"
        printf "$prmpt${normal}"
        reade -Q "GREEN" -i "y" -p "Set XDG environment? [Y/n]: " "n" xdgInst
        if [ -z "$xdgInst" ] || [ "y" == "$xdgInst" ]; then
            sed 's/^#export XDG_CACHE_HOME=\(.*\)/export XDG_CACHE_HOME=\1/' -i $pathvr 
            sed 's/^#export XDG_CONFIG_HOME=\(.*\)/export XDG_CONFIG_HOME=\1/' -i $pathvr
            sed 's/^#export XDG_CONFIG_DIRS=\(.*\)/export XDG_CONFIG_DIRS=\1/' -i $pathvr
            sed 's/^#export XDG_DATA_HOME=\(.*\)/export XDG_DATA_HOME=\1/' -i $pathvr    
            sed 's/^#export XDG_DATA_DIRS=\(.*\)/export XDG_DATA_DIRS=\1/' -i $pathvr
            sed 's/^#export XDG_STATE_HOME=\(.*\)/export XDG_STATE_HOME=\1/' -i $pathvr
            sed 's/^#export XDG_RUNTIME_DIR=\(.*\)/export XDG_RUNTIME_DIR=\1/' -i $pathvr
        fi
    fi
    unset xdgInst


    # TODO: check around for other systemdvars 
    # Check if systemd installed
    if type systemctl &> /dev/null; then
        pageSec=1
        printf "${cyan}Systemd comes preinstalled with ${GREEN}SYSTEMD_PAGERSECURE=1${normal}.\n This means any pager without a 'secure mode' cant be used for ${CYAN}systemctl/journalctl${normal}.\n(Features that are fairly obscure and mostly less-specific in the first place -\n No editing (v), no examining (:e), no pipeing (|)...)\n It's an understandable concern to be better safe and sound, but this does constrain the user to ${CYAN}only using less.${normal}\n"
        reade -Q "YELLOW" -i "y" -p "${yellow}Set SYSTEMD_PAGERSECURE to 0? [Y/n]: " "n" page_sec
        if test "$page_sec" == "y"; then
           pageSec=0 
        fi
        prmpt="${yellow}This will set SYSTEMD pathvariables\n\
        When setting a new pager for systemd or changing logging specifics\n\
        Defaults:\n\
        - SYSTEMD_PAGER=\$PAGER\n\
        - SYSTEMD_COLORS=256\n\
        - SYSTEMD_PAGERSECURE=$pageSec\n\
        - SYSTEMD_LESS=\"FRXMK\"\n\
        - SYSTEMD_LOG_LEVEL=\"warning\"\n\
        - SYSTEMD_LOG_COLOR=\"true\"\n\
        - SYSTEMD_LOG_TIME=\"true\"\n\
        - SYSTEMD_LOG_LOCATION=\"true\"\n\
        - SYSTEMD_LOG_TID=\"true\"\n\
        - SYSTEMD_LOG_TARGET=\"auto\"\n"
        printf "$prmpt${normal}"
        reade -Q "YELLOW" -i "y" -p "Set systemd environment? [Y/n]: " "n" xdgInst
        if [ -z "$xdgInst" ] || [ "y" == "$xdgInst" ]; then
            sed 's/^#export SYSTEMD_PAGER=\(.*\)/export SYSTEMD_PAGER=\1/' -i $pathvr 
            if test "$pageSec" == 0; then
                sed 's/^#export SYSTEMD_PAGERSECURE=\(.*\)/export SYSTEMD_PAGERSECURE=0/' -i $pathvr
            else
                sed 's/^#export SYSTEMD_PAGERSECURE=\(.*\)/export SYSTEMD_PAGERSECURE=1/' -i $pathvr
            fi
            sed 's/^#export SYSTEMD_COLORS=\(.*\)/export SYSTEMD_COLORS=\1/' -i $pathvr
            sed 's/^#export SYSTEMD_LESS=\(.*\)/export SYSTEMD_LESS=\1/' -i $pathvr    
            sed 's/^#export SYSTEMD_LOG_LEVEL=\(.*\)/export SYSTEMD_LOG_LEVEL=\1/' -i $pathvr
            sed 's/^#export SYSTEMD_LOG_TIME=\(.*\)/export SYSTEMD_LOG_TIME=\1/' -i $pathvr
            sed 's/^#export SYSTEMD_LOG_LOCATION=\(.*\)/export SYSTEMD_LOG_LOCATION=\1/' -i $pathvr
            sed 's/^#export SYSTEMD_LOG_TID=\(.*\)/export SYSTEMD_LOG_TID=\1/' -i $pathvr
            sed 's/^#export SYSTEMD_LOG_TARGET=\(.*\)/export SYSTEMD_LOG_TARGET=\1/' -i $pathvr
        fi
    fi

    if type libvirtd &> /dev/null; then
        sed -i 's/^#export LIBVIRT_DEFAULT_URI/export LIBVIRT_DEFAULT_URI/' $pathvr
    fi

    pathvariables_r(){ 
        if ! sudo grep -q "~/.pathvariables.env" /root/.bashrc; then
            printf "\n[ -f ~/.pathvariables.env ] && source ~/.pathvariables.env\n\n" | sudo tee -a /root/.bashrc
        fi
        sudo cp -fv $pathvr /root/.pathvariables.env;
    }                                            
    pathvariables(){
        if ! grep -q "~/.pathvariables.env" ~/.bashrc; then
            printf "\n[ -f ~/.pathvariables.env ] && source ~/.pathvariables.env\n\n" >> ~/.bashrc
        fi
        cp -fv $pathvr ~/.pathvariables.env
        yes_edit_no pathvariables_r "$pathvr" "Install .pathvariables.env at /root/?" "edit" "YELLOW"; 
    }
    yes_edit_no pathvariables "$pathvr" "Install .pathvariables.env at ~/? " "edit" "GREEN"
fi

if ! test -f checks/check_pathvar.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi
#unset prmpt pathvr xdgInst
