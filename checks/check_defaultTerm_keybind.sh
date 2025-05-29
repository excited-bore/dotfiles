SYSTEM_UPDATED='TRUE'

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

function xfce-listkeybinds(){
    local usedkeysp=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' ) 
#    usedkeysp="$usedkeysp
#$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/default -l -v | sed 's|/xfwm4/default/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;')"
    
    usedkeysp=$(echo "$usedkeysp" | sort -V)

    local var1=($(echo "$usedkeysp" | awk '{print $1}')); 
    
    (printf "${GREEN}Known ${CYAN}xfce4${GREEN} keybinds: \n\n${normal}"
    for i in ${!var1[@]}; do
        printf "%-35s %-35s\n" "${green}${var1[$i]}" "${cyan}$(awk 'NR=='$((i+1))'{$1="";print;}' <<< $usedkeysp | sed 's/^ //')${normal}"; 
    done) | $PAGER
}


function xfce-keybinds-handle-error(){
    local err=$1
    if [[ "$err" == 1 ]]; then 
        printf "${GREEN}Opening graphical program ${CYAN}xfce4-keyboard-settings${normal}.${GREEN} Go to the second tab: '${MAGENTA}Applications Shortcuts${normal}'\n"
        echo
        sleep 1
        printf "${GREEN}.."
        sleep 2
        printf ".\n${normal}"
        xfce4-keyboard-settings 
    elif [[ "$err" == 2 ]]; then
        printf "${GREEN}Opening graphical program ${CYAN}xfwm4-settings${normal}.${GREEN} Go to the second tab: '${MAGENTA}Applications Shortcuts${normal}'\n"
        echo
        sleep 1
        printf "${GREEN}.."
        sleep 2
        printf ".\n${normal}"
        xfwm4-settings 
    fi
}

function xfce-check-binds(){
    local keyb=$1 
    #local firstbatch=$2
    local value=$2
    local usedkeys

    
    #if [[ $firstbatch == 1 ]]; then
        usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;;' )
    #else
    #    usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/default -l -v | sed 's|/xfwm4/default/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
    #fi

    local usedkey=$(echo "$usedkeys" | grep --color=never $keyb | awk '{$1=""; print;}' | xargs)

    local whatdo 
    printf "${GREEN}$keyb${normal}${green} is already bound to '${CYAN}$usedkey${GREEN}'${normal}\n"
    reade -Q 'GREEN' -i "replace-existing-keybind remove-existing-keybind different-keybind nevermind" -p "What to do? [Replace-existing-keybind/remove-existing-keybind/different-keybind/nevermind]: " whatdo
    if [[ $whatdo == 'replace-existing-keybind' ]] || [[ $whatdo == 'remove-existing-keybind' ]]; then
        if [[ $whatdo == 'replace-existing-keybind' ]]; then
            if [[ $usedkey == 'xfce4-terminal --drop-down' ]]; then
                newkeys='F9' 
            fi
            local newk 
            reade -Q 'GREEN' -i "$newkeys" -p "What to set ${CYAN}$usedkey${GREEN} to?: " newk
            if test -n "$newk"; then
                
                usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{print $1;}' | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
                
                for i in "${usedkeys[@]}"; do 
                    if [[ $i == $newk ]]; then 
                        local usedkey1=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' | grep --color=never "$newk" | awk '{$1=""; print}')
                         
                        printf "${YELLOW}$newk${normal}${green} is already used for ${CYAN}$usedkey1${normal}\n"
                        return 1 

                    fi
                done
                
                usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/default -l -v | awk '{print $1;}' | sed 's|/xfwm4/default/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
                 for i in "${usedkeys[@]}"; do 
                    if [[ $i == $newk ]]; then 
                        local usedkey1=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' | grep --color=never "$newk" | awk '{$1=""; print}')
                         
                        printf "${YELLOW}$newk${normal}${green} is already used for ${CYAN}$usedkey1${normal}\n"
                        return 2 
                    fi
                done
                
                newk=$(echo "$newk" | sed 's|-||g; s|Control|<Primary>|g; s|Shift|<Shift>|g; s|Alt|<Alt>|g; s|Windowkey|<Super>|g;' )
                #if [[ $firstbatch == 1 ]]; then
                    if [[ "$usedkey1" == 'true' ]] || [[ "$usedkey1" == 'false' ]]; then
                        xfconf-query -c xfce4-keyboard-shortcuts -n -p /commands/custom/$newk -t boolean -s "$usedkey" 
                    else
                        xfconf-query -c xfce4-keyboard-shortcuts -n -p /commands/custom/$newk -t string -s "$usedkey" 
                    fi
                    xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/$newk -l -v 

                #else
                #    if [[ "$usedkey1" == 'true' ]] || [[ "$usedkey1" == 'false' ]]; then
                #        xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/default/$newk -t boolean -s "$usedkey" 
                #    else
                #        xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/default/$newk -t string -s "$usedkey" 
                #    fi
                #    xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/default/$newk -l -v 
                #fi
            fi

        elif [[ $whatdo == 'remove-existing-keybind' ]]; then
            keyb=$(echo "$keyb" | sed 's|-||g; s|Control|<Primary>|g; s|Shift|<Shift>|g; s|Alt|<Alt>|g; s|Windowkey|<Super>|g;' )
            #if [[ $firstbatch == 1 ]]; then
                xfconf-query -c xfce4-keyboard-shortcuts -r -p /commands/custom/$keyb    
            #else
            #    xfconf-query -c xfce4-keyboard-shortcuts -r -p /xfwm4/default/$keyb    
            #fi
        fi
    
        keyb=$(echo "$keyb" | sed 's|-||g; s|Control|<Primary>|g; s|Shift|<Shift>|g; s|Alt|<Alt>|g; s|Windowkey|<Super>|g;' )
        
        #if [[ $firstbatch == 1 ]]; then
            if [[ "$usedkey" == 'true' ]] || [[ "$usedkey" == 'false' ]]; then
                xfconf-query -c xfce4-keyboard-shortcuts -n -p /commands/custom/$keyb -t boolean -s "$value" 
            else
                xfconf-query -c xfce4-keyboard-shortcuts -n -p /commands/custom/$keyb -t string -s "$value" 
            fi
            xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/$keyb -l -v 
        #else
        #    if [[ "$usedkey" == 'true' ]] || [[ "$usedkey" == 'false' ]]; then
        #        xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/default/$keyb -t boolean -s "kitty" 
        #    else
        #        xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/default/$keyb -t string -s "kitty" 
        #    fi
        #    xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/default/$keyb -l -v 
        #fi

    elif [[ $whatdo == 'different-keybind' ]]; then
        return 3 
    fi
    return 0
}


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
                if type kitty &> /dev/null; then
                    termems="kitty $termems" 
                fi
                 
                reade -Q 'GREEN' -i "$termems" -p 'Which emulator?: ' emulatr
                value="$emulatr" 
            fi
            readyn -p "Set keybind for ${CYAN}$emulatr${GREEN}?" setermemkeybind
        fi
        
        if [[ "y" == "$setermemkeybind" ]]; then
            printf "Format: ${CYAN}[Control/Shift/Alt/Windowkey]-[Control/Shift/Alt/Windowkey]-[Control/Shift/Alt/Windowkey]${GREEN}-Key\n${normal}"

            xfce-listkeybinds 
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

                            xfce-listkeybinds 
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

                            #usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/default -l -v | awk '{print $1;}' | sed 's|/xfwm4/default/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
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
                
                #usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/default -l -v | awk '{print $1;}' | sed 's|/xfwm4/default/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )

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

                #            xfce-listkeybinds 
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

                #            usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | awk '{print $1;}' | sed 's|/xfwm4/default/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;')
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

    if [[ "$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v)" =~ /commands/custom/\<Alt\>F1.*xfce4-popup-applicationsmenu ]]; then
        echo "${CYAN}Altf-F1${normal}${green}, which translates to the same keycode as the ${CYAN}Windowskey/Commandkey${normal}${green}, is bound to the action that opens the right-click menu - ${MAGENTA}xfce4-popup-applicationsmenu${normal}"
        readyn -p "Would you like to change this to the menu that opens the popup 'whiskermenu' ${normal}${cyan}(the menu that opens from clicking the distro icon down left) ${CYAN}- xfce4-popup-whiskermenu${GREEN}" wiskermen
        if [[ $wiskermen == 'y' ]]; then
            xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/\<Alt\>F1 -r 
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /commands/custom/\<Alt\>F1 -t string -s 'xfce4-popup-whiskermenu' 
        fi
    fi

fi
