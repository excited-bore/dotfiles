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
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
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


if ! type kitty &> /dev/null; then
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

if ! test -d kitty/.config/kitty; then
    tmpdir=$(mktemp -d -t kitty-XXXXXXXXXX)
    tmpfile=$(mktemp)
    curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/download_git_directory.sh | tee "$tmpfile" &> /dev/null
    chmod u+x "$tmpfile"
    eval $tmpfile https://github.com/excited-bore/dotfiles/tree/main/kitty/.config/kitty $tmpdir
    wget https://raw.githubusercontent.com/excited-bore/dotfiles/main/kitty/.bash_aliases.d/kitty.sh -P $tmpdir
    dir=$tmpdir/kitty/.config/kitty
    file=$tmpdir/kitty.sh
else
    dir=kitty/.config/kitty
    file=kitty/.bash_aliases.d/kitty.sh
fi

reade -Q "GREEN" -i "y" -p "Install kitty conf? (at ~/.config/kitty/kitty.conf\|ssh.conf) [Y/n]:" "n" kittn
if [ "y" == "$kittn" ]; then
    mkdir -p ~/.config/kitty
    cp -bvf $dir/kitty.conf $dir/kitty.conf
    if [ -f ~/.config/kitty/kitty.conf~ ]; then
        gio trash $dir/kitty.conf~
    fi
    cp -vf $dir/ssh.conf $dir/ssh.conf
    if [ -f ~/.config/kitty/ssh.conf~ ]; then
        gio trash ~/.config/kitty/ssh.conf~
    fi
fi
unset kittn

reade -Q "GREEN" -i "y" -p "Install kitty aliases? (at ~/.bash_aliases.d/kitty.sh) [Y/n]:" "n" kittn
if [ "y" == "$kittn" ]; then
    if ! test -f checks/check_aliases_dir.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)" 
    else
        ./checks/check_aliases_dir.sh
    fi
    cp -bvf $file ~/.bash_aliases.d/kitty.sh
    if [ -f ~/.bash_aliases.d/kitty.sh~ ]; then
        gio trash ~/.bash_aliases.d/kitty.sh~
    fi 
fi
unset kittn


# TODO: Get sed warnings gone
if [ -f ~/.pathvariables.env ]; then
    sed -i 's|^.\(export KITTY_PATH=~/.local/bin/:~/.local/kitty.app/bin/\)|\1|g' ~/.pathvariables.env;
    sed -i 's|^.\(export PATH=$KITTY_PATH:$PATH\)|\1|g' ~/.pathvariables.env;
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
