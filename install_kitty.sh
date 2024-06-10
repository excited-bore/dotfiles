#!/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type update_system &> /dev/null; then
    if ! test -f update_system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/update_system.sh)" 
    else
        . ./update_system.sh
    fi
    update_system
else
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y n" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi 

if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

if ! [ -x "$(command -v kitty)" ]; then
    if test "$distro" == "Arch" || test "$distro" == "Manjaro"; then
       sudo pacman -S kitty 
    elif test "$distro_base" == "Debian"; then    
        sudo apt install kitty
        if [ ! -x "$(command -v kitten)" ]; then
            sudo ln -s ~/.local/share/kitty-ssh-kitten/kitty/bin/kitten    
        fi
        kitty +kitten update-self 
    fi
fi

reade -Q "GREEN" -i "y" -p "Install kitty conf? (at ~/.config/kitty/kitty.conf\|ssh.conf) [Y/n]:" "y n" kittn
if [ "y" == "$kittn" ]; then
    mkdir -p ~/.config/kitty
    cp -bvf kitty/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf
    if [ -f ~/.config/kitty/kitty.conf~ ]; then
        gio trash ~/.config/kitty/kitty.conf~
    fi
    cp -vf kitty/.config/kitty/ssh.conf ~/.config/kitty/ssh.conf
    if [ -f ~/.config/kitty/ssh.conf~ ]; then
        gio trash ~/.config/kitty/ssh.conf~
    fi
fi
unset kittn

reade -Q "GREEN" -i "y" -p "Install kitty aliases? (at ~/.bash_aliases.d/kitty.sh) [Y/n]:" "y n" kittn
if [ "y" == "$kittn" ]; then
    if ! test -f checks/check_aliases_dir.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)" 
    else
        ./checks/check_aliases_dir.sh
    fi
    cp -bvf kitty/.bash_aliases.d/kitty.sh ~/.bash_aliases.d/kitty.sh
    if [ -f ~/.bash_aliases.d/kitty.sh~ ]; then
        gio trash ~/.bash_aliases.d/kitty.sh~
    fi 
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
