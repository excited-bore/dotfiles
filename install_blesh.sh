

if ! test -f ~/.local/share/blesh; then
    tmpd=$(mktmp -d) 
    wget -P $tmpd https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz
    
    # INSTALL (robust)
    tar xJf $tmpd/ble-0.4.0-devel3.tar.xz -C ~/.local/share/blesh
    if ! grep -q 'source ~/.local/share/blesh/ble.sh' ~/.bashrc; then
        echo -e "# BLESH-source\n[[ \$- == *i* ]] && source ~/.local/share/blesh/ble.sh --attach=none\n$(command cat ~/.bashrc)" > ~/.bashrc
    fi
    if ! grep -q '[[ ${BLE_VERSION-} ]] && ble-attach' ~/.bashrc; then
         printf "# BLESH-attach\n [[ \${BLE_VERSION-} ]] && ble-attach\n" >> ~/.bashrc
    fi
fi

