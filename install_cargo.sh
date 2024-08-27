if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_pathvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pathvar.sh)" 
else
    . ./checks/check_pathvar.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "n" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type cargo &> /dev/null; then
    if test $distro_base == "Debian"; then
       sudo apt install cargo
    elif test $distro == "Arch" || test $distro == "Manjaro"; then
       sudo pacman -S cargo
    fi
fi

if grep -q "cargo" $PATHVAR; then
    sed -i 's|.export PATH=$PATH:~/.cargo/bin|export PATH=$PATH:~/.cargo/bin|g' $PATHVAR  
else
    printf "# RUST\nexport PATH=$PATH:~/.cargo/bin\n" >> $PATHVAR 
fi

echo "This next $(tput setaf 1)sudo$(tput sgr0) will set pathvariable for cargo in $PATHVAR_R";

if sudo grep -q "cargo" $PATHVAR_R; then
    sudo sed -i 's|.export PATH=$PATH:~/.cargo/bin|export PATH=$PATH:~/.cargo/bin|g' $PATHVAR_R  
else
   printf "# RUST\nexport PATH=$PATH:~/.cargo/bin\n" | sudo tee -a $PATHVAR_R &> /dev/null 
fi



