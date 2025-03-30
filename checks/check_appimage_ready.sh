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

if [[ $distro_base == "Debian" ]]; then
    # Libfuse2 has a lot of CVE errors so not all systems have it installed by default
    if test -z "$(dpkg -l | grep libfuse2)"; then
        printf "A package called 'libfuse2' is necessary for Appimages, but it has been removed because it is outdated and vulnerable to a bunch of CVE's\n" 
        readyn -n -p "Still install libfuse2?" inslibfuse
        if [[ "$inslibfuse" == "y" ]]; then
            eval "$pac_ins libfuse2t64"
        fi
    fi
fi
