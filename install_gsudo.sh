#!/bin/bash

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

if ! type sudo &> /dev/null; then
    winget install gerardog.gsudo 
fi

reade -Q 'GREEN' -i 'y' -p 'Set "gsudo config Cachemode Auto"? This enables credentials cache (less UAC popups) which is kind of security risk but still recommended because there are over 50+ windows [Yes/no] popups otherwise [Y/n]: ' 'n' gsudn
if test $gsdun == 'y'; then
    gsudo config CacheMode Auto  
fi
