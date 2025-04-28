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

if ! test -f ~/.exrc; then
    reade -Q 'GREEN' -i 'y' -p "Install exrc (ex config) at $HOME? [Y/n]: " 'n' nsrc
    if test $nsrc == 'y'; then
        cp -fv ex/.exrc ~/.exrc
    fi
fi

echo "This next $(tput setaf 1)sudo$(tput sgr0) will check for /root/.nanorc";
if ! sudo test -f /root/.nanorc; then
    reade -Q 'GREEN' -i 'y' -p 'Install exrc (ex config) at /root? [Y/n]: ' 'n' nsrc
    if test $nsrc == 'y'; then
        sudo cp -fv ex/.exrc /root/.exrc
    fi
fi
