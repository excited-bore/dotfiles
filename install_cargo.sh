#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        continue
    fi
else
    . ./checks/check_all.sh
fi

DIR=$(get-script-dir)

#if ! type cargo &> /dev/null; then
#    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
#fi

if [[ "$distro_base" == "Debian" ]]; then
    if ! hash cargo &> /dev/null || version-higher "0.7" "$(apt-cache madison cargo | awk 'NR==1 {print $3}')"; then
        eval "${pac_rm} cargo rustc"
        eval "${pac_ins} curl build-essential gcc make"
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        ! grep -q 'source ~/.cargo/env' $ENV &&
            printf "# CARGO\n[ -f ~/.cargo/env ] && source ~/.cargo/env\n" >> $ENV ||
            sed -i 's,#source ~/.cargo/env,source ~/.cargo/env,g' $ENNVAR &&
            sed -i 's,#[ -f ~/.cargo/env ] && source ~/.cargo/env,[ -f ~/.cargo/env ] && source ~/.cargo/env,g' $ENV
        source $ENV 
        rustc -V
    fi
elif [[ "$distro_base" == "Arch" ]]; then
    eval "${pac_ins_y} rust"
elif [[ "$distro" == 'Fedora' ]]; then
    eval "${pac_ins_y} rust"
fi

if ! grep -q "# RUST" "$ENV"; then
    printf "# RUST\ntest -d ~/.cargo/bin && export CARGO_INSTALL_ROOT=\$HOME/.cargo &&\nexport PATH=\$PATH:\$HOME/.cargo/bin\n" >>"$ENV"
else
    sed -i 's,#export CARGO_INSTALL_ROOT,export CARGO_INSTALL_ROOT,g' $ENV
    sed -i 's,#export PATH=\$PATH:\$HOME/.cargo,export PATH=\$PATH:\$HOME/.cargo,g' $ENV
fi

echo "This next $(tput setaf 1)sudo$(tput sgr0) will set envvar for cargo in $ENV_R"

if ! sudo grep -q "# RUST" "$ENV_R"; then
    printf "# RUST\ntest -d \$HOME/.cargo/bin && export CARGO_INSTALL_ROOT=\$HOME/.cargo &&\nexport PATH=\$PATH:\$HOME/.cargo/bin\n" | sudo tee -a "$ENV_R" &>/dev/null
else
    sudo sed -i 's,#export CARGO_INSTALL_ROOT,export CARGO_INSTALL_ROOT,g' $ENV_R
    sudo sed -i 's,#export PATH=\$PATH:\$HOME/.cargo,export PATH=\$PATH:\$HOME/.cargo,g' $ENV_R
fi
    
echo "This next $(tput setaf 1)sudo$(tput sgr0) will check if something along the lines of 'Defaults secure_path=\"$HOME/.cargo/bin\"' is being kept in /etc/sudoers";

if test -f /etc/sudoers && ! sudo grep -q "$HOME/.cargo/bin" /etc/sudoers; then
    readyn -p "Add ${RED}$HOME/.cargo/bin${GREEN} to /etc/sudoers? (so rust applications installed with cargo can be executed using sudo)?" ansr
    if [[ "$ansr" == 'y' ]]; then
        sudo sed -i 's,^\(Defaults[[:space:]+]secure_path=".*\)",\1:'"$HOME"'/.cargo/bin/",g' /etc/sudoers
        echo "Added ${GREEN}'/home/$USER/.cargo/bin'${normal} to ${RED}secure_path${normal} in /etc/sudoers!"
    fi
fi

export CARGO_INSTALL_ROOT=$HOME/.cargo
export PATH=$PATH:$HOME/.cargo/bin
