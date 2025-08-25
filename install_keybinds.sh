if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! test -f $SCRIPT_DIR/checks/check_defaultTerm_keybind.sh; then
   source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_defaultTerm_keybind.sh)
else
   source $SCRIPT_DIR/checks/check_defaultTerm_keybind.sh 
fi


if ! hash pcregrep &> /dev/null; then
    eval "${pac_ins_y} pcregrep" 
fi


# Shell-keybinds

binds=$SCRIPT_DIR/keybinds/.inputrc
binds1=$SCRIPT_DIR/keybinds/.keybinds.d/keybinds.bash
binds2=$SCRIPT_DIR/keybinds/.keybinds
if ! test -f $binds; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.inputrc
    tmp1=$(mktemp) && curl -o $tmp1 https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds.d/keybinds.bash
    tmp2=$(mktemp) && curl -o $tmp2 https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds
    binds=$tmp
    binds1=$tmp1
    binds2=$tmp2
fi

if ! test -f /etc/inputrc; then
    sed -i 's/^$include \/etc\/inputrc/#$include \/etc\/inputrc/g' $binds
fi

shell-keybinds_r() {
    if test -f /root/.environment.env; then
        sudo sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' /root/.environment.env
    fi
    sudo cp $binds1 /root/.keybinds.d/
    sudo cp $binds2 /root/.keybinds
    sudo cp $binds /root/
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether '~/.keybinds' is sourced in /root/.bashrc"
    if test -f /root/.bashrc && ! grep -q '[ -f /root/.keybinds ]' /root/.bashrc; then
        if sudo grep -q '[ -f /root/.bash_aliases ]' /root/.bashrc; then
            sudo sed -i 's|\(\[ -f \/root/.bash_aliases \] \&\& source \/root/.bash_aliases\)|\1\n\[ -f \/root/.keybinds \] \&\& source \/root/.keybinds\n|g' /root/.bashrc
        else
            printf '[ -f ~/.keybinds ] && source ~/.keybinds' | sudo tee -a /root/.bashrc &>/dev/null
        fi
    fi

    # X based settings is generally not for root and will throw errors
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether 'setxkbmap *' is part of /root/.keybinds.d/keybinds.bash and comment this line out to prevent errors"
    if sudo grep -q '^setxkbmap' /root/.keybinds.d/keybinds.bash; then
        sudo sed -i 's|^setxkbmap|#setxkbmap|g' /root/.keybinds.d/keybinds.bash
    fi
}

shell-keybinds() {
    if ! test -f $SCRIPT_DIR/checks/check_keybinds.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_keybinds.sh)
    else
        . $SCRIPT_DIR/checks/check_keybinds.sh
    fi

    printf "${cyan}You can always switch between vi/emacs mode with ${CYAN}Ctrl-o${normal}\n"

    readyn -Y "CYAN" -p "Startup in ${MAGENTA}vi-mode${CYAN} instead of ${GREEN}emacs${CYAN} mode? (might cause issues with pasteing)" vimde

    sed -i "s|^set editing-mode .*|#set editing-mode vi|g" $binds
    sed -i "s|^bind 'set editing-mode vi'|# bind 'set editing-mode vi'|g" $binds1

    if [[ "$vimde" == "y" ]]; then
        sed -i "s|# bind 'set editing-mode vi'|bind 'set editing-mode vi'|g" $binds1
    fi

    sed -i "s|^set show-mode-in-prompt .*|#set show-mode-in-prompt on|g" $binds

    readyn -p "Enable visual que for vi/emacs toggle? (Displayed as '(ins)/(cmd) - (emacs)')" vivisual
    if [[ "$vivisual" == "y" ]]; then
        sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
    fi

    sed -i "s|^setxkbmap |#setxkbmap |g" $binds

    if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then
        readyn -p "Set caps to escape? (Might cause X11 errors with SSH)" xtrm
        if [[ "$xtrm" = "y" ]]; then
            sed -i "s|#setxkbmap |setxkbmap |g" $binds
        fi
    fi

    cp $binds1 ~/.keybinds.d/
    cp $binds2 ~/.keybinds
    cp $binds ~/

    if test -f ~/.bashrc && ! grep -q '~/.keybinds' ~/.bashrc; then
        if grep -q '\[ -f ~/.bash_aliases \]' ~/.bashrc; then
            sed -i 's|\(\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\1\n\n\[ -f \~/.keybinds \] \&\& source \~/.keybinds\n|g' ~/.bashrc
        else
            echo '[ -f ~/.keybinds ] && source ~/.keybinds' >>~/.bashrc
        fi
    fi

    if [ -f ~/.environment.env ]; then
        sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' ~/.environment.env
    fi
    unset vimde vivisual xterm
    yes-edit-no -Y "YELLOW" -f shell-keybinds_r -g "$binds $binds2 $binds1" -p "Install .inputrc and keybinds.bash at /root/ and /root/.keybinds.d/?"
}

yes-edit-no -f shell-keybinds -g "$binds $binds2 $binds1" -p "Install .inputrc and keybinds.bash at ~/ and ~/.keybinds.d/? (keybinds configuration)"


if [[ "$DESKTOP_SESSION" == 'xfce' ]]; then
    if ! test -f $XDG_CONFIG_HOME/xfce4/helpers.rc; then
         touch $XDG_CONFIG_HOME/xfce4/helpers.rc 
    fi
    if ! grep -q "TerminalEmulator" $XDG_CONFIG_HOME/xfce4/helpers.rc; then
        readyn -p "Set default terminal emulator for ${CYAN}xfce4${GREEN}?" deftermemyn
        if [[ $deftermemyn == 'y' ]]; then
            termems="xfce4-terminal" 
            if type kitty &> /dev/null; then
                termems="kitty $termems" 
            fi
             
            reade -Q 'GREEN' -i "$termems" -p 'Which emulator?: ' emulatr
            if test -n "$emulatr"; then
                echo "TerminalEmulator=$emulatr" >> $XDG_CONFIG_HOME/xfce4/helpers.rc 
            fi
        fi
    fi

   
     nobind=0
     while read -r i; do
        if [[ "$i" == 'xfce4-terminal' ]] || [[ "$i" == 'exo-open --launch TerminalEmulator' ]] || (hash kitty &> /dev/null && [[ "$i" == 'kitty' ]]); then
            unset nobind 
        fi
    done <<< "$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{$1=""; print}' | sed 's/^ //g')" 
    
    if [[ $nobind ]]; then 
        value='exo-open --launch TerminalEmulator' 
        if grep -q "TerminalEmulator" $XDG_CONFIG_HOME/xfce4/helpers.rc; then
            emulatr=$(grep --color=never 'TerminalEmulator' $XDG_CONFIG_HOME/xfce4/helpers.rc | cut -d= -f2)
            readyn -p "Set keybind for the default terminal emulator set for xfce4 - ${CYAN}$emulatr${GREEN}?" setermemkeybind
        else
            if test -n "$emulatr"; then
                value="$emulatr"
            else
                termems="xfce4-terminal" 
                if hash kitty &> /dev/null; then
                    termems="kitty $termems" 
                fi
                 
                reade -Q 'GREEN' -i "$termems" -p 'Which emulator?: ' emulatr
                value="$emulatr" 
            fi
            readyn -p "Set keybind for ${CYAN}$emulatr${GREEN}?" setermemkeybind
        fi
        
        if [[ "y" == "$setermemkeybind" ]]; then
            printf "Format: ${CYAN}[Control/Shift/Alt/Windowkey]-[Control/Shift/Alt/Windowkey]-[Control/Shift/Alt/Windowkey]${GREEN}-Key\n${normal}"

            list-binds-xfce4
            reade -Q 'GREEN' -i 'Control-Alt-t Windowkey-t' -p 'What keybind?: ' keyb
                
            while test -n "$keyb"; do 
                usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{print $1;}' | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
                
                for i in ${usedkeys[@]}; do
                    if [[ $i == $keyb ]]; then
                        xfce-check-binds "$keyb" "$value"
                        if [[ $? == 1 ]]; then 
                            xfce-keybinds-handle-error 1
                        elif [[ $? == 2 ]]; then 
                            xfce-keybinds-handle-error 2
                        elif [[ $? == 3 ]]; then
                            binds='Control-Alt-t Windowkey-t'
                            if [[ $keyb == 'Control-Alt-t' ]]; then
                               binds="Windowkey-t" 
                            elif [[ $keyb == 'Windowkey-t' ]]; then 
                               binds='Control-Alt-t'
                            fi
                            reade -Q 'GREEN' -i "$binds" -p 'What keybind?: ' keyb
                            unset binds

                            list-binds-xfce4
                            usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{print $1;}' | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
                            for j in ${usedkeys[@]}; do
                                if [[ $j == $keyb ]]; then
                                    xfce-check-binds "$keyb" "$value"
                                    if [[ $? == 3 ]]; then
                                       xfce-keybinds-handle-error 1
                                       xfce-keybinds-handle-error 2
                                    fi
                                fi
                            done

                            #usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | awk '{print $1;}' | sed 's|/xfwm4/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
                            #for j in ${usedkeys[@]}; do
                            #    if [[ $j == $keyb ]]; then
                            #        xfce-check-binds "$keyb" "$value"
                            #        if [[ $? == 3 ]]; then
                            #           xfce-keybinds-handle-error 1
                            #           xfce-keybinds-handle-error 2
                            #        fi
                            #    fi
                            #done
                        fi
                    fi
                done
                
                #usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | awk '{print $1;}' | sed 's|/xfwm4/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )

                #for i in ${usedkeys[@]}; do
                #    if [[ $i == $keyb ]]; then
                #        xfce-check-binds "$keyb" "$value"
                #        if [[ $? == 1 ]]; then 
                #            xfce-keybinds-handle-error 1
                #        elif [[ $? == 2 ]]; then 
                #            xfce-keybinds-handle-error 2
                #        elif [[ $? == 3 ]]; then
                #            binds='Control-Alt-t Windowkey-t'
                #            if [[ $keyb == 'Control-Alt-t' ]]; then
                #               binds="Windowkey-t" 
                #            elif [[ $keyb == 'Windowkey-t' ]]; then 
                #               binds='Control-Alt-t'
                #            fi
                #            reade -Q 'GREEN' -i "$binds" -p 'What keybind?: ' keyb
                #            unset binds

                #            list-binds-xfce4 
                #            usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{print $1;}' | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g;' )
                #            for j in ${usedkeys[@]}; do
                #                if [[ $j == $keyb ]]; then
                #                    xfce-check-binds "$keyb" "$value"
                #                    if [[ $res1 == 3 ]]; then
                #                       xfce-keybinds-handle-error 1
                #                       xfce-keybinds-handle-error 2
                #                    fi
                #                fi
                #            done

                #            usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{print $1;}' | sed 's|/xfwm4/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;')
                #            for j in ${usedkeys[@]}; do
                #                if [[ $j == $keyb ]]; then
                #                    xfce-check-binds "$keyb" "$value"
                #                    if [[ $? == 3 ]]; then
                #                       xfce-keybinds-handle-error 1
                #                       xfce-keybinds-handle-error 2
                #                    fi
                #                fi
                #            done
                #        fi
                #    fi
                #done 
                keyb=$(echo "$keyb" | sed 's|-||g; s|Control|<Primary>|g; s|Shift|<Shift>|g; s|Alt|<Alt>|g; s|Windowkey|<Super>|g;' )
            
                xfconf-query -c xfce4-keyboard-shortcuts -n -p /commands/custom/$keyb -t string -s "$value" 
                #xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/$keyb -l -v 
                unset keyb 
            done
        fi
        unset keyb nobind kittn usedkeys i j
    fi
fi
