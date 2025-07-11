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

function list-binds-xfce4(){
    local usedkeysp="$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | sed 's|/xfwm4/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' | sort -V)"
    local usedkeysp1="$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' | sort -V)" 
    
    (printf "${GREEN}Known ${CYAN}xfce4${GREEN} keybinds: \n${normal}"
    local var1; 
    for j in $(seq 2); do
        if [[ $j == 1 ]]; then
            var1=($(echo "$usedkeysp" | awk '{print $1}'))
            printf "\n${GREEN}Window Manager shortcuts: \n\n${normal}"
        else 
            usedkeysp=$usedkeysp1 
            var1=($(echo "$usedkeysp1" | awk '{print $1}' )) 
            printf "\n${GREEN}Application Shortcuts: \n\n${normal}"
        fi
        if test -n "$BASH_VERSION"; then
            for i in ${!var1[@]}; do
                printf "%-35s %-35s\n" "${green}${var1[$i]}" "${cyan}$(awk 'NR=='$((i+1))'{$1="";print;}' <<< $usedkeysp | sed 's/^ //')${normal}"; 
            done
        elif test -n "$ZSH_VERSION"; then
            local i=0
            for k in ${var1[@]}; do
                printf "%-35s %-35s\n" "${green}${var1[$i]}" "${cyan}$(awk 'NR=='$((i+1))'{$1="";print;}' <<< $usedkeysp | sed 's/^ //')${normal}"; 
                i=$((i+1))
            done
        fi
    done) | eval "$PAGER"
}

if [[ $DESKTOP_SESSION == 'xfce' ]]; then

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
        #    usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | sed 's|/xfwm4/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
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
                    
                    usedkeys=$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | awk '{print $1;}' | sed 's|/xfwm4/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' )
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
                    #        xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/$newk -t boolean -s "$usedkey" 
                    #    else
                    #        xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/$newk -t string -s "$usedkey" 
                    #    fi
                    #    xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom/$newk -l -v 
                    #fi
                fi

            elif [[ $whatdo == 'remove-existing-keybind' ]]; then
                keyb=$(echo "$keyb" | sed 's|-||g; s|Control|<Primary>|g; s|Shift|<Shift>|g; s|Alt|<Alt>|g; s|Windowkey|<Super>|g;' )
                #if [[ $firstbatch == 1 ]]; then
                    xfconf-query -c xfce4-keyboard-shortcuts -r -p /commands/custom/$keyb    
                #else
                #    xfconf-query -c xfce4-keyboard-shortcuts -r -p /xfwm4/custom/$keyb    
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
            #        xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/$keyb -t boolean -s "kitty" 
            #    else
            #        xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/$keyb -t string -s "kitty" 
            #    fi
            #    xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom/$keyb -l -v 
            #fi

        elif [[ $whatdo == 'different-keybind' ]]; then
            return 3 
        fi
        return 0
    }

    # Solution to 'accidently' resetting application shortcuts to custom
    # https://forum.xfce.org/viewtopic.php?pid=76178#p76178

    if [[ "$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v)" =~ /commands/custom/\<Alt\>F1.*xfce4-popup-applicationsmenu ]]; then
        echo "${CYAN}Altf-F1${normal}${green}, which translates to the same keycode as the ${CYAN}Windowskey/Commandkey${normal}${green}, is bound to the action that opens the right-click menu - ${MAGENTA}xfce4-popup-applicationsmenu${normal}"
        readyn -p "Would you like to change this to the menu that opens the popup 'whiskermenu' ${normal}${cyan}(the menu that opens from clicking the distro icon down left) ${CYAN}- xfce4-popup-whiskermenu${GREEN}" wiskermen
        if [[ $wiskermen == 'y' ]]; then
            xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom/\<Alt\>F1 -r 
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /commands/custom/\<Alt\>F1 -t string -s 'xfce4-popup-whiskermenu' 
        fi
    fi
   
    # Control-Alt to Superkey? 

    if [[ "$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v)" =~ /xfwm4/custom/\<Alt\>\<Control\> ]] || [[ "$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v)" =~ /xfwm4/custom/\<Shift\>\<Control\>\<Alt\> ]]; then
        printf "${CYAN}Control-Alt${normal}${green} used for ${CYAN}xfce4's window management${normal}
${ORANGE}This can conflict with different applications' (custom) keybinds\n${normal}"
        readyn -p "Set ${CYAN}Control-Alt${GREEN} to ${CYAN}Control-Windows/Commandkey${GREEN}?" ctrl_alt_super
        if [[ $ctrl_alt_super == 'y' ]]; then
            vars=$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | grep --color=never '<Primary><Alt>' | awk '{print $1}') 
            vars="$vars\n$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | grep --color=never '<Shift><Control><Alt>' | awk '{print $1}')"

            for i in $(echo "$vars"); do
                value="$(xfconf-query -c xfce4-keyboard-shortcuts -p $i -l -v | awk '{$1=""; print}')"
                key=$(echo "$i" | sed 's/Alt/Super/g') 
                xfconf-query -c xfce4-keyboard-shortcuts -p $i -r
                xfconf-query -c xfce4-keyboard-shortcuts -n -p $key -t string -s "$value"
            done 
        fi
        unset ctrl_alt_super vars i value key
    fi   

    # Set KP_Up/down/left/right to regular arrow keys? 

    if test -z "$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | grep --color=never 'tile')" || [[ "$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | grep --color=never 'tile')" =~ /xfwm4/custom/\<Super\>KP ]]; then
        printf "${CYAN}xfce4${green} has tiling shortcuts ${YELLOW}aren't bound/are set to keypad arrowkeys${green} for tiling programs Up/down/left/right${normal}\n"
        readyn -p "Bind ${CYAN}Windows/Commandkey-Arrowkey${GREEN} to tile programs?" super_arr
        
        if [[ "$super_arr" == 'y' ]]; then
            xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom/\<Super\>KP_Down  -r 
            xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom/\<Super\>KP_Up    -r 
            xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom/\<Super\>KP_Right -r 
            xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom/\<Super\>KP_Left  -r 
            xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom/\<Super\>KP_End   -r 
            xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom/\<Super\>KP_Home  -r 
            # Next instead of KP_Page_Down ?
            xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom/\<Super\>KP_Next  -r 
            xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom/\<Super\>KP_Page_Up -r 
           
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Super\>Down  -t string -s tile_down_key 
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Super\>Up    -t string -s tile_up_key 
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Super\>Right -t string -s tile_right_key
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Super\>Left  -t string -s tile_left_key 
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Super\>End   -t string -s tile_down_left_key 
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Super\>Home  -t string -s tile_up_left_key 
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Super\>Page_Down  -t string -s tile_down_right_key 
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Super\>Page_Up -t string -s tile_up_right_key 


        fi
        unset super_arr
    fi
     

    # No key bound to moving programs accross monitors? 

    if test -z "$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/custom -l -v | grep --color=never 'monitor')"; then
        printf "${CYAN}xfce4${green} has ${YELLOW}no shortcuts${yellow} for moving programs accross monitors${normal}\n"
        readyn -p "Bind ${CYAN}Alt-Windows/Commandkey-Arrowkey${GREEN} to move program from monitor to monitor?" alt_super_arr
        if [[ $alt_super_arr == 'y' ]]; then
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Alt\>\<Super\>Down -t string -s move_window_to_monitor_down_key 
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Alt\>\<Super\>Up -t string -s move_window_to_monitor_up_key 
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Alt\>\<Super\>Left -t string -s move_window_to_monitor_left_key 
            xfconf-query -c xfce4-keyboard-shortcuts -n -p /xfwm4/custom/\<Alt\>\<Super\>Right -t string -s move_window_to_monitor_right_key 

        fi
        unset alt_super_arr
    fi

fi
