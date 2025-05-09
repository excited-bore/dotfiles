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


if test -n $pac_ins; then
    eval "$pac_ins snapd"
fi

if grep -q "SNAP" $ENV; then
    sed -i 's|#export PATH=$PATH:/bin/snap|export PATH=$PATH:/bin/snap|g' "$ENV"
else
    echo "export PATH=:\$PATH/bin/snap:/var/lib/snapd/snap/bin" >> "$ENV"
fi

sudo systemctl daemon-reload
sudo snap install core
