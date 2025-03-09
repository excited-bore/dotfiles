if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    ./checks/check_system.sh
fi

if ! type reade &> /dev/null; then
    if ! type reade &> /dev/null; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
    else
        ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
    fi 
fi

if ! test -f install_cargo.sh; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_cargo.sh)"
else
   ./install_cargo.sh
fi

if ! test -f ~/.cargo/bin/zellij; then 
    if ! test -z "$pac_rm"; then
        ${pac_rm} zellij 
    fi
    cargo install --locked zellij
fi

readyn -p "Install zellij config file at ~/.config/zellij?" -n "! test -f ~/.config/zellij/config.kbl" ansr
if test "$ansr" == 'y'; then
    mkdir -p ~/.config/zellij
zellij setup --dump-config > ~/.config/zellij/config.kdl
fi
unset ansr
