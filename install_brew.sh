#!/usr/bin/env bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! type brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
fi

if [[ $machine == 'Mac' ]] && ! grep -q 'eval "$(brew shellenv)"' ~/.zprofile; then
    printf '\neval "$(brew shellenv)"\n' >> ~/.zprofile 
fi

if type brew &> /dev/null; then
    if [[ $machine == 'Mac' ]]; then
        echo "This next $(tput setaf 1)sudo$(tput sgr0) will make $USER the owner of the folder '/usr/local' and '/Library/Caches/Homebrew' to mitigate permission errors when installing apps";
        sudo chown -R "$USER":admin /usr/local
        sudo mkdir -p /Library/Caches/Homebrew
        sudo chown -R "$USER":admin /Library/Caches/Homebrew
    fi
    if ! grep -q -- '--no-quarantine' $ENVVAR || grep -q '#export HOMEBREW_CASK_OPTS="--no-quarantine"' $ENVVAR; then
        readyn -p "Unblock Homebrew apps from Gatekeeper (No more popups each time when you install from homebrew) by setting HOMEBREW_CASK_OPTS=\"--no-quarantine\" in $ENVVAR?" unblock_hb
        if [[ $unblock_hb == 'y' ]]; then
           if [[ $ENVVAR =~ '.environment.env' ]]; then
                sed -i 's/^#export HOMEBREW_CASK_OPTS/export HOMEBREW_CASK_OPTS/g' $ENVVAR
           else
                echo 'export HOMEBREW_CASK_OPTS=" --no-quarantine"' >> $ENVVAR
           fi
           source $ENVVAR
        fi
    fi
    if test -z "$(brew list applite)" &> /dev/null; then
        readyn -p 'Install Applite? (Opensource brew store GUI)' ins_appl
        if [[ "$ins_appl" == 'y' ]]; then
            brew install applite
        fi
    fi
fi
unset ins_appl unblock_hb
