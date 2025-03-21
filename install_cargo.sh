#!/bin/bash
 
[[ $0 != $BASH_SOURCE ]] && SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )" || SCRIPT_DIR="$( cd "$( dirname "$-1" )" && pwd )" 
 
if ! test -f $SCRIPT_DIR/checks/check_all.sh; then 
    if type curl &> /dev/null; then 
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"  
    else  
        continue  
    fi 
else 
    . $SCRIPT_DIR/checks/check_all.sh 
fi


#if ! type cargo &> /dev/null; then
#    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh 
#fi

if ! type cargo &> /dev/null; then
    if test $distro_base == "Debian"; then
        ${pac_ins} rust
    elif test $distro_base == "Arch"; then
        ${pac_ins} rust
    elif test $distro == 'Fedora'; then
        ${pac_ins} rust 
    fi
fi

#if ! grep -q "# RUST" $ENVVAR; then
#    printf "# RUST\ntest -d ~/.cargo/bin && export CARGO_INSTALL_ROOT=\$HOME/.cargo &&\nexport PATH=\$PATH:~/.cargo/bin\n" >> $ENVVAR 
#fi

#echo "This next $(tput setaf 1)sudo$(tput sgr0) will set envvar for cargo in $ENVVAR_R";

#if ! sudo grep -q "# RUST" $ENVVAR_R; then
#    printf "# RUST\ntest -d \$HOME/.cargo/bin && export CARGO_INSTALL_ROOT=\$HOME/.cargo &&\nexport PATH=\$PATH:\$HOME/.cargo/bin\n" | sudo tee -a $ENVVAR_R &> /dev/null 
#fi

#echo "This next $(tput setaf 1)sudo$(tput sgr0) will check if the variable CARGO_INSTALL_ROOT is being kept from the user's environment in /etc/sudoers";

#if test -f /etc/sudoers && ! sudo grep -q "Defaults env_keep += \"CARGO_INSTALL_ROOT\"" /etc/sudoers; then
#    readyn -Y 'GREEN' -p "Keep the environment variable ${RED}CARGO_INSTALL_ROOT${GREEN} when using sudo (so cargo installed binaries stay available)?" ansr
#    if test "$ansr" == 'y'; then
#    	sudo sed -i '1s/^/Defaults env_keep += "CARGO_INSTALL_ROOT"\n/' /etc/sudoers
#        echo "Added ${RED}'Defaults env_keep += \"CARGO_INSTALL_ROOT\"'${normal} to /etc/sudoers"
#    fi
#fi
#unset ansr

#export CARGO_INSTALL_ROOT=$HOME/.cargo
#export PATH=$PATH:$HOME/.cargo/bin

#. "$HOME/.cargo/env"
