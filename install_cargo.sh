#!/bin/bash
 
[[ $0 != $BASH_SOURCE ]] && SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )" || SCRIPT_DIR="$( cd "$( dirname "$-1" )" && pwd )" 
 
if ! test -f $SCRIPT_DIR/../checks/check_all.sh; then 
    if type curl &> /dev/null; then 
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)"  
    else  
        continue  
    fi 
else 
    . $SCRIPT_DIR/../checks/check_all.sh 
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

export PATH=$PATH:"$HOME/.cargo/bin"

. "$HOME/.cargo/env"
