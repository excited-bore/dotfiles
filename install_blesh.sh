#!/bin/bash

if ! test -f ~/.local/share/blesh; then
    tmpd=$(mktemp -d) 
    wget -P $tmpd https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz 
    
    # INSTALL (robust)
    mkdir ~/.local/share/blesh 
    tar xJf $tmpd/ble-0.4.0-devel3.tar.xz -C ~/.local/share/blesh
    if ! grep -q 'source ~/.local/share/blesh/ble.sh' ~/.bashrc; then
        { printf "# BLESH-source\n[[ \$- == *i* ]] && source ~/.local/share/blesh/ble.sh --attach=none\n"; command cat ~/.bashrc; } > ~/.bashrc.new
        command mv ~/.bashrc{.new,}
    fi
    if ! grep -q '\[\[ ${BLE_VERSION-} ]] && ble-attach' ~/.bashrc; then
         printf "# BLESH-attach\n [[ \${BLE_VERSION-} ]] && ble-attach\n" >> ~/.bashrc
    fi
fi

