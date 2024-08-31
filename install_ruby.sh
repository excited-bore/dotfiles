if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi 
if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi
if ! test -f checks/check_keybinds.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_keybinds.sh)" 
else
    . ./checks/check_keybinds.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi 

if ! type ruby &> /dev/null; then
    if test $machine == 'Mac'; then
        brew install ruby 
    elif [ "$distro" == "Manjaro" ]; then
        pamac install ruby
    elif test "$distro" == "Arch"; then
        sudo pacman -S ruby 
    elif [ $distro_base == "Debian" ]; then
        sudo apt install ruby ruby-dev                 
    fi
fi

rver=$(echo $(ruby --version) | awk '{print $2}' | cut -d. -f-2)'.0'
paths=$(gem environment | awk '/- GEM PATH/{flag=1;next}/- GEM CONFIGURATION/{flag=0}flag' | sed 's|     - ||g' | paste -s -d ':')
if grep -q "GEM" $ENVVAR; then
    sed -i "s|.export GEM_HOME=.*|export GEM_HOME=$HOME/.gem/ruby/$rver|g" $ENVVAR
    sed -i "s|.export GEM_PATH=.*|export GEM_PATH=/usr/lib/ruby/gems/$rver:$HOME/.local/share/gem/ruby/$rver/bin|g" $ENVVAR
    sed -i 's|.export PATH=$PATH:$GEM_PATH.*|export PATH=$PATH:$GEM_PATH:$GEM_HOME|g' $ENVVAR
else
    printf "export GEM_HOME=$HOME/.gem/ruby/$rver\n" >> $ENVVAR
    printf "export GEM_PATH=/usr/lib/ruby/gems/$rver:$HOME/.local/share/gem/ruby/$rver/bin\n" >> $ENVVAR
    printf "export PATH=\$PATH:\$GEM_PATH:\$GEM_HOME\n" >> $ENVVAR
fi

source $ENVVAR
