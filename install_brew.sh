#!/usr/bin/env bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f checks/check_envvar.sh.sh; then
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

if ! type reade &> /dev/null; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi


if type brew &> /dev/null; then
    if test $machine == 'Mac'; then
        echo "This next $(tput setaf 1)sudo$(tput sgr0) will make $USER the owner of the folder '/usr/local' and '/Library/Caches/Homebrew' to mitigate permission errors when installing apps";
        sudo chown -R "$USER":admin /usr/local
        sudo mkdir -p /Library/Caches/Homebrew
        sudo chown -R "$USER":admin /Library/Caches/Homebrew
    fi
    if ! grep -q -- '--no-quarantine' $ENVVAR || grep -q '#export HOMEBREW_CASK_OPTS="--no-quarantine"' $ENVVAR; then
        reade -Q 'GREEN' -i 'y' -p "Unblock Homebrew apps from Gatekeeper (No more popups each time when you install from homebrew) by setting HOMEBREW_CASK_OPTS=\"--no-quarantine\" in $ENVVAR? [Y/n]: " 'n' unblock_hb
        if test $unblock_hb == 'y' ;then
           if [[ $ENVVAR =~ '.environment.env' ]]; then
                sed -i='s/^#export HOMEBREW_CASK_OPTS/export HOMEBREW_CASK_OPTS/g' $ENVVAR
           else
                echo 'export HOMEBREW_CASK_OPTS=" --no-quarantine"' >> $ENVVAR
           fi
           source $ENVVAR
        fi
        unset unblock_hb
    fi
    if ! test -z "$(brew list applite)"; then
        reade -Q 'GREEN' -i 'y' -p 'Install Applite? (Opensource brew store GUI) [Y/n]: ' 'n' ins_appl
        if test "$ins_appl" == 'y'; then
            brew install applite
        fi
    fi
    unset ins_appl
fi


