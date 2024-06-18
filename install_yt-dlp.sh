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
if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update_system                     
    fi
fi

if ! test -f checks/check_aliases_dir.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)" 
else
    ./checks/check_aliases_dir.sh
fi 

if ! type yt-dlp &> /dev/null; then
    if ! test pipx &> /dev/null; then
        if test $distro == "Arch" || $distro == "Manjaro"; then
            sudo pacman -S python-pipx
        elif test $distro_base == "Debian"; then
            sudo apt install pipx
        fi
    fi
    python2 -m pipx install yt-dlp
fi

ytbe=aliases/.bash_aliases.d/youtube.sh
if ! test -d aliases/.bash_aliases.d/; then 
    wget -P $TMPDIR/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/youtube.sh 
    ytbe=$TMPDIR/youtube.sh
fi

ytbe(){
    cp -fv "$ytbe" ~/.bash_aliases.d/
}
yes_edit_no ytbe "$ytbe" "Install yt-dlp (youtube cli download) and youtube.sh at ~/.bash_aliases.d/ (yt-dlp aliases)?" "yes" "GREEN"
