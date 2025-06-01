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
    local usedkeysp="$(xfconf-query -c xfce4-keyboard-shortcuts -p /xfwm4/default -l -v | sed 's|/xfwm4/default/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' | sort -V)"
    local usedkeysp1="$(xfconf-query -c xfce4-keyboard-shortcuts -p /commands/custom -l -v | sed 's|/commands/custom/||g; s|<Primary>|<Control>|g; s|<Super>|<Windowkey>|g; s|><|-|g; s|<||g; s|>|-|g;' | sort -V)" 
    
    (printf "${GREEN}Known ${CYAN}xfce4${GREEN} keybinds: \n${normal}"
    for i in $(seq 2); do
        local var1; 
        if [[ $i == 1 ]]; then
            var1=($(echo "$usedkeysp" | awk '{print $1}'))
            printf "\n${GREEN}Window Manager shortcuts: \n\n${normal}"
        else 
            usedkeysp=$usedkeysp1 
            var1=($(echo "$usedkeysp1" | awk '{print $1}'))
            printf "\n${GREEN}Application Shortcuts: \n\n${normal}"
        fi
        for i in ${!var1[@]}; do
            printf "%-35s %-35s\n" "${green}${var1[$i]}" "${cyan}$(awk 'NR=='$((i+1))'{$1="";print;}' <<< $usedkeysp | sed 's/^ //')${normal}"; 
        done
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

