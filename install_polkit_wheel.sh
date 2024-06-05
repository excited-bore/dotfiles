# !/bin/bash

if sudo test -d /etc/polkit-1/localauthority/50-local.d/; then
    if ! test -f polkit/49-nopasswd_global.pkla; then
        wget -O polkit/49-nopasswd_global.pkla https://raw.githubusercontent.com/excited-bore/dotfiles/main/polkit/49-nopasswd_global.pkla
    else
        sudo cp -bfv polkit/49-nopasswd_global.pkla /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla
    fi
    #gio trash /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla~
fi
if sudo test -d /etc/polkit-1/localauthority.conf.d/; then
    if ! test -f polkit/49-nopasswd_global.pkla; then
        wget -O polkit/49-nopasswd_global.pkla https://raw.githubusercontent.com/excited-bore/dotfiles/main/polkit/49-nopasswd_global.pkla
    else 
        sudo cp -fv polkit/49-nopasswd_global.pkla /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf
    fi
    #gio trash /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla~
fi
if sudo test -d /etc/polkit-1/rules.d/; then
    if ! test -f polkit/49-nopasswd_global.rules; then
        wget -O polkit/49-nopasswd_global.pkla https://raw.githubusercontent.com/excited-bore/dotfiles/main/polkit/49-nopasswd_global.pkla
    else 
        sudo cp -fv polkit/49-nopasswd_global.rules /etc/polkit-1/rules.d/90-nopasswd_global.rules
    fi
    #gio trash /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla~
fi
