if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! type reade &> /dev/null; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi 
if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi 

if ! type nano &> /dev/null; then
    if test "$distro" == "Arch"; then
        eval "$pac_ins nano"
    elif [ $distro_base == "Debian" ]; then
        eval "$pac_ins nano"
    fi
fi

if ! test -f ~/.nanorc; then
    reade -Q 'GREEN' -i 'y' -p "Install nanorc (config) at $HOME? [Y/n]: " 'n' nsrc
    if test $nsrc == 'y'; then
        if ls -A /usr/share/nano/* &> /dev/null && ! grep -q '/usr/share/nano/' nano/.nanorc; then
           sed -i 's|include "/.*|include "/usr/share/nano/\*\.nanorc"|g' nano/.nanorc   
        elif ls -A /usr/local/share/nano/* &> /dev/null && ! grep -q '/usr/local/share/nano/' nano/.nanorc; then  
           sed -i 's|include "/.*|include "/usr/local/share/nano/\*\.nanorc"|g' nano/.nanorc   
        fi
        cp -fv nano/.nanorc ~/.nanorc
    fi
fi

echo "This next $(tput setaf 1)sudo$(tput sgr0) will check for /root/.nanorc";
if ! sudo test -f /root/.nanorc; then
    reade -Q 'GREEN' -i 'y' -p 'Install nanorc (config) at /root? [Y/n]: ' 'n' nsrc
    if test $nsrc == 'y'; then
        if ls -A /usr/share/nano/* &> /dev/null && ! grep -q '/usr/share/nano/' nano/.nanorc; then
           sed -i 's|include "/.*|include "/usr/share/nano/\*\.nanorc"|g' nano/.nanorc   
        elif ls -A /usr/local/share/nano/* &> /dev/null && ! grep -q '/usr/local/share/nano/' nano/.nanorc; then  
           sed -i 's|include "/.*|include "/usr/local/share/nano/\*\.nanorc"|g' nano/.nanorc   
        fi
        sudo cp -fv nano/.nanorc /root/.nanorc
    fi
fi
