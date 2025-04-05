#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"
    else
        continue
    fi
else
    . ./checks/check_all.sh
fi

get-script-dir SCRIPT_DIR

#if ! type cargo &> /dev/null; then
#    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
#fi

if ! type cargo &>/dev/null; then
    if [[ "$distro_base" == "Debian" ]]; then
        eval "${pac_ins}" rust
    elif [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins}" rust
    elif [[ "$distro" == 'Fedora' ]]; then
        eval "${pac_ins}" rust
    fi
fi

if ! grep -q "# RUST" "$ENVVAR"; then
    printf "# RUST\ntest -d ~/.cargo/bin && export CARGO_INSTALL_ROOT=\$HOME/.cargo &&\nexport PATH=\$PATH:~/.cargo/bin\n" >>"$ENVVAR"
fi

echo "This next $(tput setaf 1)sudo$(tput sgr0) will set envvar for cargo in $ENVVAR_R"

if ! sudo grep -q "# RUST" "$ENVVAR_R"; then
    printf "# RUST\ntest -d \$HOME/.cargo/bin && export CARGO_INSTALL_ROOT=\$HOME/.cargo &&\nexport PATH=\$PATH:\$HOME/.cargo/bin\n" | sudo tee -a "$ENVVAR_R" &>/dev/null
fi

echo "This next $(tput setaf 1)sudo$(tput sgr0) will check if something along the lines of 'Defaults secure_path=\".*/\.cargo/bin\"' is being kept in /etc/sudoers";

if test -f /etc/sudoers && ! sudo grep -q "/bin:$HOME/.cargo/bin" /etc/sudoers; then
    readyn -Y 'GREEN' -p "Add ${RED}$HOME/.cargo/bin${GREEN} to /etc/sudoers? (so rust applications installed with cargo can be executed using sudo)?" ansr
    if [[ "$ansr" == 'y' ]]; then
        sudo sed -i 's,Defaults secure_path="\(.*\)",Defaults secure_path="\1:'"$HOME"'/.cargo/bin/",g' /etc/sudoers
        echo "Added ${GREEN}'/home/$USER/.cargo/bin'${normal} to ${RED}secure_path${normal} in /etc/sudoers!"
    fi
fi

export CARGO_INSTALL_ROOT=$HOME/.cargo
export PATH=$PATH:$HOME/.cargo/bin
