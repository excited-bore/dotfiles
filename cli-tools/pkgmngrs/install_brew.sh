hash brew &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../../checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! hash brew &> /dev/null; then
    source <(wget-curl https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
fi

if [[ $machine == 'Mac' ]] && ! grep -q 'eval "$(brew shellenv)"' $ZSH_ENV; then
    printf '\neval "$(brew shellenv)"\n' >> $ZSH_ENV 
fi

if hash brew &> /dev/null; then
    if [[ $machine == 'Mac' ]]; then
        echo "This next $(tput setaf 1)sudo$(tput sgr0) will make $USER the owner of the folder '/usr/local' and '/Library/Caches/Homebrew' to mitigate permission errors when installing apps";
        sudo chown -R "$USER":admin /usr/local
        sudo mkdir -p /Library/Caches/Homebrew
        sudo chown -R "$USER":admin /Library/Caches/Homebrew
    fi
    if ! grep -q -- '--no-quarantine' $ENV || grep -q '#export HOMEBREW_CASK_OPTS="--no-quarantine"' $ENV; then
        readyn -p "Unblock Homebrew apps from Gatekeeper (No more popups each time when you install from homebrew) by setting HOMEBREW_CASK_OPTS=\"--no-quarantine\" in $ENV?" unblock_hb
        if [[ $unblock_hb == 'y' ]]; then
           if [[ $ENV =~ '.environment.env' ]]; then
                sed -i 's/^#export HOMEBREW_CASK_OPTS/export HOMEBREW_CASK_OPTS/g' $ENV
           else
                echo 'export HOMEBREW_CASK_OPTS=" --no-quarantine"' >> $ENV
           fi
           source $ENV
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
