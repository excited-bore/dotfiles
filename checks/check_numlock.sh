SYSTEM_UPDATED=TRUE

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

if [[ "$XDG_CURRENT_DESKTOP" == 'GNOME' ]]; then
    readyn -p "Set ${CYAN}GNOME${GREEN} to remember the numlock state?" rmembr
    if [[ "$rmembr" == 'y' ]]; then
        gsettings set org.gnome.desktop.peripherals.keyboard remember-numlock-state true
    fi
    unset rmembr
elif [[ "$XDG_CURRENT_DESKTOP" == 'XFCE' ]]; then
    printf "${GREEN}On ${CYAN}xfce${GREEN} you can preset the numlock state to either 'true' or 'false'\n${normal}"    state=$(xfconf-query -c keyboards -lv | grep -i numlock | awk '{print $2}') 
    test -z "$state" && state='unset' 
    printf "${GREEN}Currently, the numlock state is set to $state\n${normal}" 
    if [[ "$state" == 'false' ]]; then
        state='true'
    elif [[ "$state" == 'true' ]]; then  
        state='false'
    else
        state='true' 
    fi
    readyn -p "Change the default state to '$state'?" change
    if [[ "$change" == 'y' ]]; then
        xfconf-query -c keyboards -p /Default/Numlock -t bool -s $state --create
    fi
    unset state change
elif [[ "$XDG_CURRENT_DESKTOP" == 'labwc:wlroots' ]]; then
    if ! hash numlockw &> /dev/null; then
        printf "There's no native control for the state of numlock on ${CYAN}$XDG_CURRENT_DESKTOP${GREEN}\nHowever, there is a tool called 'numlockw' that you can install that can turn numlock on or off when your shell ($HOME.profile/$HOME/.bash_profile) has been loaded\n${normal}" 
        readyn -p 'Install and activate numlockw?' nmlckw
        if [[ "$nmlckw" == 'y' ]]; then 
            if ! test -f install_numlockw.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_numlockw.sh)
            else
                . ./install_numlockw.sh
            fi
        fi
    fi
fi
