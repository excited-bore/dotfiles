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
binds0=$SCRIPT_DIR/keybinds/.keybinds.d/00-bind-empty.bash
binds1=$SCRIPT_DIR/keybinds/.keybinds.d/01-cdw.bash
binds2=$SCRIPT_DIR/keybinds/.keybinds.d/02-keybinds.bash
binds3=$SCRIPT_DIR/keybinds/.keybinds
if ! [[ -f $binds ]]; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.inputrc
    tmp0=$(mktemp) && curl -o $tmp0 https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds.d/00-binds-empty.bash
    tmp1=$(mktemp) && curl -o $tmp1 https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds.d/01-cdw.bash
    tmp2=$(mktemp) && curl -o $tmp2 https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds.d/02-keybinds.bash
    tmp3=$(mktemp) && curl -o $tmp3 https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds
    binds=$tmp
    binds0=$tmp0
    binds1=$tmp1
    binds2=$tmp2
    binds3=$tmp3
fi

if ! [[ -f /etc/inputrc ]]; then
    sed -i 's/^$include \/etc\/inputrc/#$include \/etc\/inputrc/g' $binds
fi

shell-keybinds_r() {
    if [[ -f /root/.environment.env ]]; then
        sudo sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' /root/.environment.env
    fi
   
    sudo cp $binds0 /root/.keybinds.d/
    sudo cp $binds1 /root/.keybinds.d/
    sudo cp $binds2 /root/.keybinds.d/
    sudo cp $binds3 /root/.keybinds
    sudo cp $binds /root/
    
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether '~/.keybinds' is sourced in /root/.bashrc"
    if [[ -f /root/.bashrc ]] && ! grep -q '[ -f /root/.keybinds ]' /root/.bashrc; then
        if sudo grep -q '[ -f /root/.bash_aliases ]' /root/.bashrc; then
            sudo sed -i 's|\(\[ -f \/root/.bash_aliases \] \&\& source \/root/.bash_aliases\)|\1\n\[ -f \/root/.keybinds \] \&\& source \/root/.keybinds\n|g' /root/.bashrc
        else
            printf '[ -f ~/.keybinds ] && source ~/.keybinds' | sudo tee -a /root/.bashrc &>/dev/null
        fi
    fi

    # X based settings is generally not for root and will throw errors
    echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether 'setxkbmap *' is part of /root/.keybinds.d/keybinds.bash and comment this line out to prevent errors"
    if sudo grep -q '^setxkbmap' /root/.keybinds.d/02-keybinds.bash; then
        sudo sed -i 's|^setxkbmap|#setxkbmap|g' /root/.keybinds.d/02-keybinds.bash
    fi
}

shell-keybinds() {
    if ! [[ -f $SCRIPT_DIR/checks/check_keybinds.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_keybinds.sh)
    else
        . $SCRIPT_DIR/checks/check_keybinds.sh
    fi

    sed -i "s|^set show-mode-in-prompt .*|#set show-mode-in-prompt on|g" $binds

    sed -i "s|\([[:space:]+]\)set vi-ins-mode-string|\1#set set-vi-ins-mode-prompt|g" $binds
    sed -i "s|\([[:space:]+]\)set vi-cmd-mode-string|\1#set set-vi-cmd-mode-prompt|g" $binds
    sed -i "s|\([[:space:]+]\)set emacs-mode-string|\1#set set-emacs-mode-prompt|g" $binds

    printf "${GREEN}%s${normal}\n" "The readline options for your prompt are: "
    printf "${green}%s${normal}\n" " - Show a different cursor for emacs and vi-insert mode ('|' instead of '█')"
    printf "${green} - Show a different cursor for emacs/vi-insert mode ${GREEN}and${green}\n   Show a visual indicator for which mode is currently active '(emacs)/(vi)/(cmd)'\n${normal}"
    printf "${green} - Do both of these but with a colored mode indicator (magenta for (emacs), blue for (vi)/(cmd))'\n${normal}"
     
    reade -Q 'GREEN' -i "cursor-mode cursor cursor-colored-mode none" -p "Which do you prefer?: [Cursor-mode/cursor/cursor-colored-mode/none]: " vivisual
    if [[ "$vivisual" == "cursor" ]]; then
        sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
        
        sed -i 's|#\(set vi-ins-mode-string \\1\\e\[?0c.*\)|\1|g' $binds
        sed -i 's|#\(set vi-cmd-mode-string \\1\\e\[?8c.*\)|\1|g' $binds
        sed -i 's|#\(set emacs-mode-string  \\1\\e\[?0c.*\)|\1|g' $binds

        sed -i 's|#\(set vi-ins-mode-string \\1\\e\[5 q.*\)|\1|g' $binds
        sed -i 's|#\(set vi-cmd-mode-string \\1\\e\[2 q.*\)|\1|g' $binds
        sed -i 's|#\(set emacs-mode-string  \\1\\e\[5 q.*\)|\1|g' $binds
    
    elif [[ "$vivisual" == "cursor-mode" ]]; then
        sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
        
        sed -i 's|#\(set vi-ins-mode-string (ins)\\1\\e\[?0c.*\)|\1|g' $binds
        sed -i 's|#\(set vi-cmd-mode-string (cmd)\\1\\e\[?8c.*\)|\1|g' $binds
        sed -i 's|#\(set emacs-mode-string  (emacs)\\1\\e\[?0c.*\)|\1|g' $binds

        sed -i 's|#\(set vi-ins-mode-string (ins)\\1\\e\[5 q.*\)|\1|g' $binds
        sed -i 's|#\(set vi-cmd-mode-string (cmd)\\1\\e\[2 q.*\)|\1|g' $binds
        sed -i 's|#\(set emacs-mode-string  (emacs)\\1\\e\[5 q.*\)|\1|g' $binds
    
    elif [[ "$vivisual" == "cursor-colored-mode" ]]; then
        sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
        
        sed -i 's|#\(set vi-ins-mode-string \\1\\e\[34;1m\\2(ins)\\1\\e\[?0c.*\)|\1|g' $binds
        sed -i 's|#\(set vi-cmd-mode-string \\1\\e\[34;1m\\2(cmd)\\1\\e\[?8c.*\)|\1|g' $binds
        sed -i 's|#\(set emacs-mode-string  \\1\\e\[35;1m\\2(emacs)\\1\\e\[?0c.*\)|\1|g' $binds

        sed -i 's|#\(set vi-ins-mode-string \\1\\e\[34;1m\\2(ins)\\1\\e\[5 q.*\)|\1|g' $binds
        sed -i 's|#\(set vi-cmd-mode-string \\1\\e\[34;1m\\2(cmd)\\1\\e\[2 q.*\)|\1|g' $binds
        sed -i 's|#\(set emacs-mode-string  \\1\\e\[35;1m\\2(emacs)\\1\\e\[5 q.*\)|\1|g' $binds
         
    fi

    printf "${cyan}You can always switch between vi/emacs mode with ${CYAN}Ctrl-o${normal}\n"

    readyn -n -N "CYAN" -p "Startup in ${MAGENTA}vi-mode${CYAN} instead of ${GREEN}emacs${CYAN} mode? (might cause issues with pasteing)" vimde

    sed -i "s|^set editing-mode .*|#set editing-mode vi|g" $binds
    sed -i "s|^bind 'set editing-mode vi'|# bind 'set editing-mode vi'|g" $binds2

    if [[ "$vimde" == "y" ]]; then
        sed -i "s|# bind 'set editing-mode vi'|bind 'set editing-mode vi'|g" $binds2
    fi

    sed -i "s|^setxkbmap |#setxkbmap |g" $binds

    if [[ "$XDG_SESSION_TYPE" == 'x11' ]]; then
        readyn -p "Set caps to escape? (Might cause X11 errors with SSH)" xtrm
        if [[ "$xtrm" = "y" ]]; then
            sed -i "s|#setxkbmap |setxkbmap |g" $binds
        fi
    fi

    cp $binds0 ~/.keybinds.d/
    cp $binds1 ~/.keybinds.d/
    cp $binds2 ~/.keybinds.d/
    cp $binds3 ~/.keybinds
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
    yes-edit-no -Y "YELLOW" -f shell-keybinds_r -g "$binds $binds3 $binds0 $binds1 $binds2" -p "Install ${CYAN}.inputrc${GREEN} at ${YELLOW}/root/${GREEN} and ${CYAN}00-bind-empty.bash${GREEN}, ${CYAN}01-cdw.bash${GREEN} and ${CYAN}02-keybinds.bash${GREEN} at ${YELLOW}/root/.keybinds.d/${GREEN}?"
}

yes-edit-no -f shell-keybinds -g "$binds $binds3 $binds0 $binds1 $binds2" -p "Install ${CYAN}.inputrc${GREEN} at ${BLUE}$HOME${GREEN} and ${CYAN}00-bind-empty.bash${GREEN}, ${CYAN}01-cdw.bash${GREEN} and ${CYAN}02-keybinds.bash${GREEN} at ${BLUE}$HOME/.keybinds.d/${GREEN}? (keybinds configuration)"


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
            if [[ -n "$emulatr" ]]; then
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
            if [[ -n "$emulatr" ]]; then
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
                
            while [[ -n "$keyb" ]]; do 
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
