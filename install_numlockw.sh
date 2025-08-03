# https://github.com/xz-dev/numlockw
 
! hash pipx &> /dev/null && SYSTEM_UPDATED='true'

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

DIR=$(get-script-dir)

if [[ $XDG_SESSION_TYPE == 'wayland' ]]; then
    if ! hash pipx &> /dev/null; then
        if ! test -f $DIR/install_pipx.sh; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)
        else
            . $DIR/install_pipx.sh
        fi
    fi

    if hash pipx &> /dev/null && ! hash numlockw &> /dev/null; then
        # For Arch users: Refer to https://wiki.archlinux.org/title/Udev#Allowing_regular_users_to_use_devices
        sudo usermod -a -G plugdev $USER  
        # or pipx install git+https://github.com/xz-dev/numlockw.git 
        pipx install numlockw 
        if [[ "$distro_base" == 'Arch' || "$distro_base" == 'Debian' ]]; then
            echo 'KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/10-evdevremapkeys.rules &> /dev/null  
        fi
    fi
    
    if hash numlockw &> /dev/null; then 
        if ! test -f ~/.bash_profile && ! test -f ~/.zprofile && ! test -f ~/.profile; then
           touch ~/.profile 
        fi
    
        if test -f ~/.bash_profile && ! grep -q 'numlockw on' ~/.bash_profile; then
            echo "numlockw on" >> ~/.bash_profile
        elif test -f ~/.zprofile && ! grep -q 'numlockw on' ~/.zprofile; then
            echo "numlockw on" >> ~/.zprofile
        elif test -f ~/.profile && ! grep -q 'numlockw on' ~/.profile; then
            echo "numlockw on" >> ~/.profile
        fi
    
        if [[ "$XDG_CURRENT_DESKTOP" == 'labwc:wlroots' ]] && ! grep -q 'numlockw on' ~/.config/labwc/autostart; then
            echo "numlockw on" >> ~/.config/labwc/autostart 
        fi
    fi     
fi

