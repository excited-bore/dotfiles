if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

#if ! test -f checks/check_envvar.sh; then
#     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
#else
#    . ./checks/check_envvar.sh
#fi

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


if ! type cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 
fi

#if ! type cargo &> /dev/null; then
#    if test $distro_base == "Debian"; then
#       eval "$pac_ins cargo"
#    elif test $distro_base == "Arch"; then
#       eval "$pac_ins cargo"
#    elif test $distro == 'Fedora'; then
#       eval "$pac_ins cargo" 
#    fi
#fi

if ! grep -q "# RUST" $ENVVAR; then
    printf "# RUST\ntest -d ~/.cargo/bin && export PATH=\$PATH:~/.cargo/bin\n" >> $ENVVAR 
fi

echo "This next $(tput setaf 1)sudo$(tput sgr0) will set envvar for cargo in $ENVVAR_R";

if ! sudo grep -q "# RUST" $ENVVAR_R; then
    printf "# RUST\ntest -d ~/.cargo/bin && export PATH=\$PATH:~/.cargo/bin\n" | sudo tee -a $ENVVAR_R &> /dev/null 
fi

source ~/.cargo/bin
