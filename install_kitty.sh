#!/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f aliases/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/rlwrap_scripts.sh)" 
else
    . ./aliases/rlwrap_scripts.sh
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

if ! [ -x "$(command -v kitty)" ]; then
    if [ "$distro" == "Arch" ] || [ "$distro_base" == "Arch" ]; then
        yes | sudo pacman -Su kitty 
    elif [ "$distro" == "Debian" ] || [ "$distro_base" == "Debian" ]; then    
        yes | sudo apt install kitty
        if [ ! -x "$(command -v kitten)" ]; then
            sudo ln -s ~/.local/share/kitty-ssh-kitten/kitty/bin/kitten    
        fi
        kitten update-self 
    fi
fi

reade -Q "GREEN" -i "y" -p "Install kitty conf? (at ~/.config/kitty/kitty.conf\|ssh.conf) [Y/n]:" "y n" kittn
if [ "y" == "$kittn" ]; then
    mkdir -p ~/.config/kitty
    cp -vf kitty/kitty.conf ~/.config/kitty/kitty.conf
    cp -vf kitty/ssh.conf ~/.config/kitty/ssh.conf
fi
unset kittn

# TODO: Get sed warnings gone
if [ -f ~/.pathvariables.env ]; then
    sed -i 's|^.\(export KITTY_PATH=~/.local/bin/:~/.local/kitty.app/bin/\)|\1|g' ~/.pathvariables.env 2> /dev/null;
    sed -i 's|^.\(export PATH=$KITTY_PATH:$PATH\)|\1|g' ~/.pathvariables.env 2> /dev/null;
    #sed -i 's|^.\(if \[\[ \$SSH_TTY \]\] .*\)|\1|g' $PATHVAR
    #sed -i 's|^.\(export KITTY_PORT=.*\)|\1|g' $PATHVAR
    #sed -i 's|^.\(fi\)|\1|g' $PATHVAR
fi              

#if [ -x "$(command -v xdg-open)" ]; then
#    reade -Q "GREEN" -p -i "y" "Set kitty as default terminal? [Y/n]:" "y n" kittn
#    if [ "y" == "$kittn" ]; then
#        
#    fi
#fi
