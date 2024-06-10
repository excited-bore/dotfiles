#!/bin/bash

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

if ! test -f update_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
else
    . ./update_system.sh
fi

if ! test -f checks/check_rlwrap.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_rlwrap.sh)" 
else
    . ./checks/check_rlwrap.sh
fi

if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi


printf "${green}If all necessary files are sourced correctly, this text looks green.\nIf not, something went wrong.\n"
printf "\n${green}Files that get overwritten get backed up and trashed (to prevent clutter).\nRecover using ${cyan}'gio trash --list'${green} and ${cyan}'gio trash --restore' ${normal}\n"
printf "${green} Will now start with updating system ${normal}\n"

update_system

if [ ! -e ~/config ] && test -d ~/.config; then
    reade -Q "BLUE" -i "y" -p "Create ~/.config to ~/config symlink? [Y(es)/n(o)]:" "y n" sym1
    if [ -z $sym1 ] || [ "y" == $sym1 ]; then
        ln -s ~/.config ~/config
    fi
fi

if [ ! -e ~/lib_systemd ] && test -d ~/lib/systemd/system; then
    reade -Q "BLUE" -i "y" -p "Create /lib/systemd/system/ to user directory symlink? [Y/n]:" "y n" sym2
    if [ -z $sym2 ] || [ "y" == $sym2 ]; then
        ln -s /lib/systemd/system/ ~/lib_systemd
    fi
fi

if [ ! -e ~/etc_systemd ] && test -d ~/etc/systemd/system; then
    reade -Q "BLUE" -i "y" -p "Create /etc/systemd/system/ to user directory symlink? [Y/n]:" "y n" sym3
    if [ -z $sym3 ] || [ "y" == $sym3 ]; then
        ln -s /etc/systemd/system/ ~/etc_systemd
    fi
fi

if [ ! -f /etc/modprobe.d/nobeep.conf ]; then
    reade -Q "GREEN" -i "y" -p "Remove terminal beep? (blacklist pcspkr) [Y/n]:" "y n" beep
    if [ "$beep" == "y" ] || [ -z "$beep" ]; then
        echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf
    fi
fi

unset sym1 sym2 sym3 beep


if ! type flatpak &> /dev/null; then
    printf "%s\n" "${blue}No flatpak detected. (Independent package manager from Red Hat)${normal}"
    reade -Q "GREEN" -i "y" -p "Install? [Y/n]:" "y n" insflpk 
    if [ "y" == "$insflpk" ]; then
        if ! test -f install_flatpak.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)" 
        else
            ./install_flatpak.sh 
        fi 
    fi
fi
unset insflpk

if ! type snap &> /dev/null; then
    printf "%s\n" "${blue}No snap detected. (Independent package manager from Canonical)${normal}"
    reade -Q "GREEN" -i "n" -p "Install? [Y/n]:" "y n" inssnap 
    if [ "y" == "$inssnap" ]; then
        if ! test -f install_snapd.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_snapd.sh)" 
        else
            ./install_snapd.sh 
        fi 
    fi
fi
unset inssnap

if ! sudo test -f /etc/polkit/49-nopasswd_global.pkla && ! sudo test -f /etc/polkit-1/rules.d/90-nopasswd_global.rules; then
    reade -Q "YELLOW" -i "n" -p "Install polkit files for automatic authentication for passwords? [Y/n]:" "y n" plkit
    if [ "y" == "$plkit" ]; then
        if ! test -f install_polkit_wheel.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_polkit_wheel.sh)" 
        else
            ./install_polkit_wheel.sh
        fi 
    fi
    unset plkit
fi


#  Pathvariables

#if [ ! -f ~/.pathvariables.env ]; then
pathvr=$(pwd)/.pathvariables.env
    if ! test -f .pathvariables.env; then
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/.pathvariables.env
        pathvr=$TMPDIR/.pathvariables.env
    fi
    reade -Q "GREEN" -i "y" -p "Check existence (and create) ~/.pathvariables.env and link it to .bashrc? [Y/n]:" "y n" pathvars
    if [ "$pathvars" == "y" ] || [ -z "$pathvars" ]; then
        
        #Comment out every export in .pathvariables
        sed -i -e '/export/ s/^#*/#/' $pathvr

        # Set tmpdir
        sed 's|#export TMPDIR|export TMPDIR|' -i $pathvr

        ## Package Managers
        #reade -Q "YELLOW" -i "y" -p "Check and create DIST,DIST_BASE,ARCH,PM and WRAPPER? (distro, distro base, architecture, package manager and pm wrapper) [Y/n]:" "y n" Dists
        #if [ "$Dists" == "y" ]; then
        #   printf "NOT YET IMPLEMENTED\n"
        #fi
        
        # TODO: non ugly values
        reade -Q "YELLOW" -i "n" -p "Set LS_COLORS with some predefined values? (WARNING: ugly values) [N/y]:" "y n" lsclrs
        if [ "$lsclrs" == "y" ] || [ -z "$lsclrs" ]; then
            sed 's/^#export LS_COLORS/export LS_COLORS/' -i $pathvr
        fi
        
        if type nvim &> /dev/null; then
            reade -Q "GREEN" -i "y" -p "Set Neovim as MANPAGER? [Y/n]: " "y n" manvim
            if [ "$manvim" == "y" ]; then
               sed -i 's|.export MANPAGER=.*|export MANPAGER='\''nvim +Man!'\''|g' $pathvr 
            fi
        fi
        
        reade -Q "GREEN" -i "y" -p "Set PAGER? (Page reader) [Y/n]:" "y n" pgr
        if [ "$pgr" == "y" ] || [ -z "$pgr" ]; then
            # Uncomment export PAGER=
            sed 's/^#export PAGER=/export PAGER=/' -i $pathvr
            
            pagers="less more"
            prmpt="${green} \tless = Default pager - Basic, archaic but very customizable\n\tmore = Preinstalled other pager - leaves text by default, less customizable (ironically)\n"
            if type most &> /dev/null; then
                pagers="$pagers most"
                prmpt="$prmpt \tmost = Installed pager that is very customizable\n"
            fi
            if type moar &> /dev/null; then
                pagers="$pagers moar"
                prmpt="$prmpt \tmoar = Installed pager with an awesome default configuration\n"
            fi
            printf "$prmpt"
            reade -Q "GREEN" -i "less" -p "PAGER=" "$pagers" pgr2
            pgr2=$(whereis "$pgr2" | awk '{print $2}')
            sed -i 's|export PAGER=.*|export PAGER='$pgr2'|' $pathvr
            if grep -q "less" "$pgr2"; then
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
                unset lss lss_n opt opt1
                #sed -i 's/#export LESSEDIT=/export LESSEDIT=/' .pathvariables.env
            fi
            if grep -q "moar" "$pgr2"; then
                sed -i 's/#export MOAR=/export MOAR=/' $pathvr
            fi

        fi
        unset prmpt

        reade -Q "GREEN" -i "y" -p "Set EDITOR and VISUAL? [Y/n]:" "y n" edtvsl
        if [ "$edtvsl" == "y" ] || [ -z "$edtvsl" ]; then
            editors="nano vi"
            prmpt="${green}\tnano = Default editor - Basic, but userfriendly\n\tvi = Other preinstalled editor - Archaic and non-userfriendly editor\n" 
            if type micro &> /dev/null; then
                editors="$editors micro"
                prmpt="$prmpt \tMicro = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
            fi
            if type ne &> /dev/null; then
                editors="$editors ne"
                prmpt="$prmpt \tNice editor = Relatively good out-of-the-box editor - Decent keybindings, yet no customizations\n"
            fi
            if type vim &> /dev/null; then
                editors="$editors vim"
                prmpt="$prmpt \tvim = The one and only true modal editor - Not userfriendly, but many features (maybe even too many) and greatly customizable\n"
                sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" $pathvr
                sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" $pathvr
            fi
            if type nvim &> /dev/null; then                                  
                editors="$editors nvim"
                prmpt="$prmpt \tnvim (neovim) = A better vim? - Faster and less buggy then regular vim, even a little userfriendlier\n"
                sed -i "s|#export MYVIMRC=|export MYVIMRC=|g" $pathvr
                sed -i "s|#export MYGVIMRC=|export MYGVIMRC=|g" $pathvr
            fi
            if type emacs &> /dev/null; then
                editors="$editors emacs"
                prmpt="$prmpt \tEmacs = One of the oldest and versatile editors - Modal and featurerich, but overwhelming as well\n"
            fi
            printf "$prmpt"
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
            compedit=$(cat $TMPDIR/editor-outpt | awk 'NR > 2' | awk '{if (prev_1_line) print prev_1_line; prev_1_line=prev_line} {prev_line=$NF}' | sed 's|[()]||g' | tr -s [:space:] \\n | uniq | tr '\n' ' ')
            frst="$(echo $compedit | awk '{print $1}')"
            reade -Q "GREEN" -i "$frst" -p "VISUAL (GUI editor)=" "$compedit" vsual
            vsual="$editors $(whereis "$vsual" | awk '{print $2}')"
            vsual="$(echo $vsual | uniq)"
            sed -i 's|#export VISUAL=|export VISUAL=|g' $pathvr
            sed -i 's|export VISUAL=.*|export VISUAL='"$vsual"'|g' $pathvr
            
            if grep -q "#export SUDO_EDITOR" $pathvr; then
                reade -Q "GREEN" -i "y" -p "Set SUDO_EDITOR to \$EDITOR? [Y/n]: " "y n" sud_edt
                if test "$sud_edt" == "y"; then
                    sed -i 's|#export SUDO_EDITOR.*|export SUDO_EDITOR=$EDITOR|g' $pathvr
                fi
            fi
            
            echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for  'Defaults env_keep += \"VISUAL EDITOR\"' in /etc/sudoers"
            if ! sudo grep -q "Defaults env_keep += \"VISUAL EDITOR\"" /etc/sudoers; then
                reade -Q "YELLOW" -i "y" -p "Sudo by default does not respect the user's EDITOR/VISUAL and not every program supports the SUDO_EDITOR environment variables (f.ex. sudo crontab -e ).\n Change this behaviour permanently in /etc/sudoers? [Y/n]: " "y n" sudrs
                if test "$sudrs" == "y"; then
                    sudo sed -i '1s/^/Defaults env_keep += "VISUAL EDITOR"\n/' /etc/sudoers
                    echo "Added 'Defaults env_keep += \"VISUAL EDITOR\"' to /etc/sudoers"
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
            printf "$prmpt"
            reade -Q "GREEN" -i "y" -p "Set XDG environment? [Y/n]: " "y n" xdgInst
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
            printf "${green} Systemd comes preinstalled with SYSTEMD_PAGERSECURE=1.\n This means any pager without a 'secure mode' (reduced features - only less does this afaik) cant be used for systemctl/journalctl.\n It's a relatively good to be on the safe side, but this does constrain the user.\n"
            reade -Q "YELLOW" -i "y" -p "${yellow}Set SYSTEMD_PAGERSECURE to 0? [Y/n]: " "y n" page_sec
            if test "$page_sec" == "y"; then
               pageSec=0 
            fi
            prmpt="${yellow}This will set SYSTEMD pathvariables\n\
            When setting a new pager for systemd or changing logging specifics\n\
            \tDefaults:\n\
            - SYSTEMD_PAGER=$PAGER\n\
            - SYSTEMD_COLORS=256\n\
            - SYSTEMD_PAGERSECURE=$pageSec\n\
            - SYSTEMD_LESS=\"FRXMK\"\n\
            - SYSTEMD_LOG_LEVEL=\"warning\"\n\
            - SYSTEMD_LOG_COLOR=\"true\"\n\
            - SYSTEMD_LOG_TIME=\"true\"\n\
            - SYSTEMD_LOG_LOCATION=\"true\"\n\
            - SYSTEMD_LOG_TID=\"true\"\n\
            - SYSTEMD_LOG_TARGET=\"auto\"\n"
            printf "$prmpt"
            reade -Q "YELLOW" -i "y" -p "Set systemd environment? [Y/n]: " "y n" xdgInst
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

        pathvariables_r(){ 
             if ! sudo grep -q "~/.pathvariables.env" /root/.bashrc; then
                printf "if [[ -f ~/.pathvariables.env ]]; then\n" | sudo tee -a /root/.bashrc
                printf "  . ~/.pathvariables.env\n" | sudo tee -a /root/.bashrc
                printf "fi\n" | sudo tee -a /root/.bashrc
            fi
            sudo cp -fv $pathvr /root/.pathvariables.env;
        }                                            
        pathvariables(){
            if ! grep -q "~/.pathvariables.env" ~/.bashrc; then
                echo "[ -f ~/.pathvariables.env ] && source ~/.pathvariables.env" >> ~/.bashrc
            fi
            cp -fv $pathvr ~/.pathvariables.env
            yes_edit_no pathvariables_r "$pathvr" "Install .pathvariables.env at /root/?" "edit" "YELLOW"; 
        }
        yes_edit_no pathvariables "$pathvr" "Install .pathvariables.env at ~/? " "edit" "GREEN"
    fi
#fi

# Shell-keybinds

#if grep -q 'bind -x '\''"\\C-s": ctrl-s'\''' ~/keybinds.bash && ! grep -q '#bind -x '\''"\\C-s": ctrl-s'\''' ~/keybinds.bash; then
#    sed -i 's|bind -x '\''"\\C-s": ctrl-s'\''|#bind -x '\''"\\C-s": ctrl-s'\''|g' ~/keybinds.bash
#    sed -i 's|bind -x '\''"\\eOR": ctrl-s'\''|#bind -x '\''"\\eOR": ctrl-s'\''|g' ~/keybinds.bash
#fi

binds=keybinds/.inputrc
binds1=keybinds/.keybinds.d/keybinds.bash
if ! test -f keybinds/.inputrc; then
    wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.inputrc
    wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds.d/keybinds.bash 
    
    binds=$TMPDIR/.inputrc
    binds1=$TMPDIR/.keybinds.d/keybinds.bash
fi

shell-keybinds_r(){ 
    if [ -f /root/.pathvariables.env ]; then
       sudo sed -i 's|#export INPUTRC|export INPUTRC|g' /root/.pathvariables.env
    fi
    sudo cp -fv $binds1 /root/.keybinds.d/;
    sudo cp -fv $binds /root/;

    # X based settings is generally not for root and will throw errors 
    if sudo grep -q '^setxkbmap' /root/.keybinds.d/keybinds.bash; then
        sudo sed -i 's|setxkbmap|#setxkbmap|g' /root/.keybinds.d/keybinds.bash
    fi
}
shell-keybinds() {
    
    if ! test -f ./checks/check_keybinds.sh; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_keybinds.sh)" 
    else
        . ./checks/check_keybinds.sh
    fi
    
    reade -Q "GREEN" -i "y" -p "Enable vi-mode instead of emacs mode (might cause issues with pasteing - revert with 'Ctrl-z')? [Y/n]: " "y n" vimde
    if [ "$vimde" == "y" ]; then
        sed -i "s|.set editing-mode .*|set editing-mode vi|g" $binds
    fi
    reade -Q "GREEN" -i "y" -p "Enable visual que for vi/emacs toggle? (Displayed as '(ins)/(cmd) - (emacs)') [Y/n]: " "y n" vivisual
    if [ "$vivisual" == "y" ]; then
        sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
    fi
    reade -Q "GREEN" -i "y" -p "Set caps to escape? (Might cause X11 errors with SSH) [Y/n]: " "y n" xtrm
    if [ "$xtrm" != "y" ] && ! [ -z "$xtrm" ]; then
        sed -i "s|setxkbmap |#setxkbmap |g" $binds
    fi
    cp -fv $binds1 ~/.keybinds.d/
    cp -fv $binds ~/
    if [ -f ~/.pathvariables.env ]; then
       sed -i 's|#export INPUTRC|export INPUTRC|g' ~/.pathvariables.env
    fi
    unset vimde vivisual xterm
    yes_edit_no shell-keybinds_r "$binds $binds1" "Install .inputrc and keybinds.bash at /root/ and /root/.keybinds.d/?" "edit" "YELLOW"; 
}
yes_edit_no shell-keybinds "$binds $binds1" "Install .inputrc and keybinds.bash at ~/ and ~/.keybinds.d/? (keybinds configuration)" "edit" "YELLOW"

# Xresources

xterm=xterm/.Xresources
if ! test -f xterm/.Xresources; then
    wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/xterm/.Xresources
    xterm=$TMPDIR/.Xresources
fi

xresources_r(){
    sudo cp -fv $xterm /root/.Xresources;
    }
xresources() {
    cp -fv $xterm ~/.Xresources;
    yes_edit_no xresources_r "$xterm" "Install .Xresources at /root/?" "edit" "RED"; }
yes_edit_no xresources "$xterm" "Install .Xresources at ~/? (Xterm configuration)" "edit" "YELLOW"
    

if ! test -f checks/check_completions_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
    . ./checks/check_completions_dir.sh
fi


# Bash alias completions
reade -Q "GREEN" -i "y" -p "Install bash completions for aliases in ~/.bash_completion.d? [Y/n]:" "y n" compl
if [ -z "$compl" ] || [ "y" == "$compl" ]; then
    if ! test -f install_bashalias_completions.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashalias_completions.sh)" 
    else
        ./install_bashalias_completions.sh
    fi 
fi
unset compl

# Python completions
reade -Q "GREEN" -i "y" -p "Install python completions in ~/.bash_completion.d? [Y/n]:" "y n" pycomp
if [ -z $pycomp ] || [ "y" == $pycomp ]; then
    if ! test -f install_python_completions.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_python_completions.sh)" 
    else
        ./install_python_completions.sh
    fi
fi
unset pycomp

# Git
reade -Q "GREEN" -i "y" -p "Install Git and configure? (Project managing tool) [Y/n]:" "y n" nvm
if [ "y" == "$nvm" ]; then
    if ! test -f install_git.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_git.sh)" 
    else
        ./install_git.sh
    fi
fi


# Osc
#reade -Q "GREEN" -i "y" -p "Install Osc52 clipboard? (Universal clipboard tool / works natively over ssh) [Y/n]: " "y n" osc
#if [ -z $osc ] || [ "Y" == $osc ] || [ $osc == "y" ]; then
#    ./install_osc.sh 
#fi
#unset osc

# Bat
reade -Q "GREEN" -i "y" -p "Install Bat? (Cat clone with syntax highlighting) [Y/n]: " "y n" bat
if [ -z $bat ] || [ "Y" == $bat ] || [ $bat == "y" ]; then
    if ! test -f install_bat.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)" 
    else
        ./install_bat.sh 
    fi
fi
unset bat

# Fzf (Fuzzy Finder)
reade -Q "GREEN" -i "y" -p "Install fzf? (Fuzzy file/folder finder - keybinding yes for upgraded Ctrl-R/reverse-search, fzf filenames on Ctrl+T and fzf-version of 'cd' on Alt-C + Custom script: Ctrl-f becomes system-wide file opener) [Y/n]: " "y n" findr
if [ "y" == "$findr" ]; then
    if ! test -f install_fzf.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fzf.sh)" 
    else
        ./install_fzf.sh
    fi
fi
unset findr

# Neofetch
if ! type neofetch &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install neofetch/fastfetch/screenFetch)? (Terminal taskmanager - system information tool) [Y/n]:" "y n" tojump
    if [ "$tojump" == "y" ]; then
        if ! test -f install_neofetch.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_neofetch.sh)" 
        else
            ./install_neofetch.sh
        fi
    fi
    unset tojump
fi

# Bashtop
if ! type bashtop &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install bashtop? (Python based improved top/htop) [Y/n]:" "y n" tojump
    if [ "$tojump" == "y" ]; then
        if ! test -f install_bashtop.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashtop.sh)" 
        else
            ./install_bashtop.sh
        fi
    fi
    unset tojump
fi

# Autojump
if ! type autojump &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install autojump? (jump to folders using 'bookmarks' - j_ ) [Y/n]:" "y n" tojump
    if [ "$tojump" == "y" ]; then
        if ! test -f install_autojump.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_autojump.sh)" 
        else
            ./install_autojump.sh
        fi
    fi
    unset tojump
fi

# Starship
if ! type starship &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install Starship? (Snazzy looking prompt) [Y/n]: " "y n" strshp
    if [ $strshp == "y" ]; then
        if ! test -f install_starship.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_starship.sh)" 
        else
            ./install_starship.sh 
        fi
    fi
    unset strshp
fi



# Moar (Custom pager instead of less)
reade -Q "GREEN" -i "y" -p "Install moar? (Custom pager instead of less with linenumbers) [Y/n]: " "y n" moar
if [ -z $moar ] || [ "Y" == $moar ] || [ $moar == "y" ]; then
    if ! test -f install_moar.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_moar.sh)" 
    else
        ./install_moar.sh 
    fi
fi
unset moar

# Nvim (Editor)
reade -Q "GREEN" -i "y" -p "Install Neovim? (Terminal editor) [Y/n]: " "y n" nvm
if [ "y" == "$nvm" ]; then
    if ! test -f install_nvim.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nvim.sh)" 
    else
        ./install_nvim.sh
    fi
fi
unset nvm



# Ranger (File explorer)
reade -Q "GREEN" -i "y" -p "Install Ranger? (Terminal file explorer) [Y/n]: " "y n" rngr
if [ "y" == "$rngr" ]; then
    if ! test -f install_ranger.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ranger.sh)" 
    else
        ./install_ranger.sh
    fi
fi
unset rngr

# Tmux (File explorer)
reade -Q "GREEN" -i "y" -p "Install Tmux? (Terminal multiplexer) [Y/n]: " "y n" tmx
if [ "y" == "$tmx" ]; then
    if ! test -f install_tmux.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_tmux.sh)" 
    else
        ./install_tmux.sh
    fi
fi
unset tmx

# Kitty (Terminal emulator)
reade -Q "GREEN" -i "y" -p "Install Kitty? (Terminal emulator) [Y/n]: " "y n" kittn
if [ "y" == "$kittn" ]; then
    if ! test -f install_kitty.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_kitty.sh)" 
    else
        ./install_kitty.sh
    fi
fi
unset kittn

# Srm (Secure remove)
if ! type srm &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install srm? (Secure remove) [Y/n]: " "y n" kittn
    if [ "y" == "$kittn" ]; then
        if ! test -f install_srm.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_srm.sh)" 
        else
            ./install_srm.sh
        fi
    fi
    unset kittn
fi

# Testdisk (File recovery tool)
if ! type testdisk &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install testdisk? (File recovery tool) [Y/n]: " "y n" kittn
    if [ "y" == "$kittn" ]; then
        if ! test -f install_testdisk.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_testdisk.sh)" 
        else
            ./install_testdisk.sh
        fi
    fi
    unset kittn
fi

# Nmap
if ! type nmap &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Install nmap? (Network port scanning tool) [Y/n]:" "y n" tojump
    if [ "$tojump" == "y" ]; then
        if ! test -f install_nmap.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nmap.sh)" 
        else
            ./install_nmap.sh
        fi
    fi
    unset tojump
fi

reade -Q "GREEN" -i "y" -p "Install bash aliases and other config? [Y/n]:" "y n" scripts
if [ -z $scripts ] || [ "y" == $scripts ]; then

    if ! test -f checks/check_aliases_dir.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)" 
    else
        ./checks/check_aliases_dir.sh
    fi
    
    genr=aliases/.bash_aliases.d/general.sh
    if ! test -f aliases/.bash_aliases.d/general.sh; then
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/general.sh 
        genr=$TMPDIR/general.sh
    fi

    general_r(){ 
        if ! test -f checks/check_aliases_dir.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)" 
        else
            ./checks/check_aliases_dir.sh
        fi
        sudo cp -fv $genr /root/.bash_aliases.d/;
    }
    general(){
        if test -f ~/.pathvariables.env; then
            sed -i 's|^export TRASH_BIN_LIMIT=|export TRASH_BIN_LIMIT=|g' ~/.pathvariables.env
        fi
        local ansr
        reade -Q "GREEN" -i "y" -p "Set cp/mv (when overwriting) to backup files? (will also trash backups) [Y/n]:" "y n" ansr         
        if [ "$ansr" != "y" ]; then
            sed -i 's|alias cp="cp-trash -rv"|#alias cp="cp-trash -rv"|g' $genr
            sed -i 's|alias mv="mv-trash -v"|#alias mv="mv-trash -v"|g' $genr
        fi
        unset ansr
        reade -Q "YELLOW" -i "n" -p "Set 'gio trash' alias for rm? [N/y]:" "y n" ansr 
        if [ "$ansr" != "y" ]; then
            sed -i 's|alias rm="trash"|#alias rm="trash"|g' $genr
        fi
        if type bat &> /dev/null; then
            reade -Q "YELLOW" -i "n" -p "Set 'cat' as alias for 'bat'? [N/y]:" "y n" cat
            if [ "$cat" != "y" ]; then
                sed -i 's|^alias cat="bat"|#alias cat="bat"|g' $genr
            fi
        fi
        unset cat
        cp -fv $genr ~/.bash_aliases.d/
        yes_edit_no general_r "$genr" "Install general.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no general "$genr" "Install general.sh at ~/? (aliases related to general actions - cd/mv/cp/rm + completion script replacement for 'read -e') " "yes" "YELLOW"
    
    update_sysm=update_system.sh
    systemd=aliases/.bash_aliases.d/systemctl.sh
    dosu=aliases/.bash_aliases.d/sudo.sh
    pacmn=aliases/.bash_aliases.d/package_managers.sh
    sshs=aliases/.bash_aliases.d/ssh.sh
    ps1=aliases/.bash_aliases.d/PS1_colours.sh
    manjaro=aliases/.bash_aliases.d/manjaro.sh
    variti=aliases/.bash_aliases.d/variety.sh
    pthon=aliases/.bash_aliases.d/python.sh
    ytbe=aliases/.bash_aliases.d/youtube.sh
    if ! test -d aliases/.bash_aliases.d/; then
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh 
        update_sysm=$TMPDIR/update_system.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/systemctl.sh 
        systemd=$TMPDIR/systemctl.sh
        wget -P $TMPDIR/  https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/sudo.sh 
        dosu=$TMPDIR/sudo.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/package_managers.sh 
        pacmn=$TMPDIR/package_managers.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ssh.sh 
        sshs=$TMPDIR/ssh.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/ps1.sh 
        ps1=$TMPDIR/ps1.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/manjaro.sh 
        manjaro=$TMPDIR/manjaro.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/variety.sh 
        variti=$TMPDIR/variety.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/python.sh 
        pthon=$TMPDIR/python.sh
        wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/youtube.sh 
        ytbe=$TMPDIR/youtube.sh
    fi 

    sed -i 'd/SYSTEM_UPDATED="TRUE"' $update_sysm
    update_sysm_r(){ 
        sudo cp -fv $update_sysm /root/.bash_aliases.d/;
    }
    update_sysm(){
        cp -fv $update_sysm ~/.bash_aliases.d/
        yes_edit_no update_sysm_r "$update_sysm" "Install update_system.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no update_sysm "$update_sysm" "Install update_system.sh at ~/.bash_aliases.d/? (Global system update function)?" "edit" "GREEN"

    systemd_r(){ 
        sudo cp -fv $systemd /root/.bash_aliases.d/;
    }
    systemd(){
        cp -fv $systemd ~/.bash_aliases.d/
        yes_edit_no systemd_r "$systemd" "Install systemctl.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no systemd "$systemd" "Install systemctl.sh at ~/.bash_aliases.d/? (systemctl aliases/functions)?" "edit" "GREEN"
        

    dosu_r(){ 
        sudo cp -fv $dosu /root/.bash_aliases.d/ ;
    }    

    dosu(){ 
        cp -fv $dosu ~/.bash_aliases.d/;
        yes_edit_no dosu_r "$dosu" "Install sudo.sh at /root/?" "yes" "GREEN"; }
    yes_edit_no dosu "$dosu" "Install sudo.sh at ~/.bash_aliases.d/ (sudo aliases)?" "edit" "GREEN"


    packman_r(){ 
        sudo cp -fv $pacmn /root/.bash_aliases.d/
    }
    packman(){
        cp -fv $pacmn ~/.bash_aliases.d/
        yes_edit_no packman_r "$pacmn" "Install package_managers.sh at /root/?" "edit" "YELLOW" 
    }
    yes_edit_no packman "$pacmn" "Install package_managers.sh at ~/.bash_aliases.d/ (package manager aliases)? " "edit" "GREEN"
    
    ssh_r(){ 
        sudo cp -fv $sshs /root/.bash_aliases.d/; 
    }
    sshh(){
        cp -fv $sshs ~/.bash_aliases.d/
        yes_edit_no ssh_r "$sshs" "Install ssh.sh at /root/?" "edit" "YELLOW" 
    }
    yes_edit_no sshh "$sshs" "Install ssh.sh at ~/.bash_aliases.d/ (ssh aliases)? " "edit" "GREEN"


    ps1_r(){ 
        sudo cp -fv $ps1 /root/.bash_aliases.d/; 
    }
    ps11(){
        cp -fv $ps1 ~/.bash_aliases.d/
        yes_edit_no ps1_r "$ps1" "Install PS1_colours.sh at /root/?" "yes" "GREEN" 
    }
    yes_edit_no ps11 "$ps1" "Install PS1_colours.sh at ~/.bash_aliases.d/ (Coloured command prompt)? " "yes" "GREEN"
    
    if [ $distro == "Manjaro" ] ; then
        manj_r(){ 
            sudo cp -fv $manjaro /root/.bash_aliases.d/; 
        }
        manj(){
            cp -fv $manjaro ~/.bash_aliases.d/
            yes_edit_no manj_r "$manjaro" "Install manjaro.sh at /root/?" "yes" "GREEN" 
        }
        yes_edit_no manj "$manjaro" "Install manjaro.sh at ~/.bash_aliases.d/ (manjaro specific aliases)? " "yes" "GREEN"
    fi
    
    # Variety aliases 
    # 
    variti_r(){ 
        sudo cp -fv $variti /root/.bash_aliases.d/; 
    }
    variti(){
        cp -fv $variti ~/.bash_aliases.d/
        yes_edit_no variti_r "$variti" "Install variety.sh at /root/?" "no" "YELLOW" 
    }
    yes_edit_no variti "$variti" "Install variety.sh at ~/.bash_aliases.d/ (aliases for a variety of tools)? " "edit" "GREEN" 
    
    pthon(){
        cp -fv $pthon ~/.bash_aliases.d/
    }
    yes_edit_no variti "$pthon" "Install python.sh at ~/.bash_aliases.d/ (aliases for a python development)? " "edit" "GREEN" 


    # Youtube
    #

    ytbe(){
        if ! test -f checks/check_youtube.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_youtube.sh)" 
        else
            . ./checks/check_youtube.sh
        fi
        cp -fv $ytbe ~/.bash_aliases.d/
    }
    yes_edit_no ytbe "$ytbe" "Install yt-dlp (youtube cli download) and youtube.sh at ~/.bash_aliases.d/ (yt-dlp aliases)?" "yes" "GREEN"
fi

source ~/.bashrc

echo "${cyan}${bold}You can check all aliases with 'alias'";
alias -p;
echo "${green}${bold}Done!"
