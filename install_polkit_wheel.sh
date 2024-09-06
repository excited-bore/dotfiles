# !/bin/bash

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if sudo test -d /etc/polkit-1/localauthority/50-local.d/ && ! sudo test -f /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla; then
    file=polkit/49-nopasswd_global.pkla 
    if ! test -f polkit/49-nopasswd_global.pkla; then
        mktemp=$(mktemp -d) 
        wget -q -O $tmp/49-nopasswd_global.pkla https://raw.githubusercontent.com/excited-bore/dotfiles/main/polkit/49-nopasswd_global.pkla
        file=$tmp/49-nopasswd_global.pkla 
    fi
    function localauth_conf(){
        sudo cp -bfv $file /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla
    } 
    yes_edit_no localauth_conf "$file" "Install $file at /etc/polkit-1/localauthority/50-local.d/?" "yes" "GREEN"; 
    unset file 
fi

if sudo test -d /etc/polkit-1/localauthority.conf.d/ && ! sudo test -f /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf; then
    file=polkit/49-nopasswd_global.conf 
    if ! test -f polkit/49-nopasswd_global.conf; then
        mktemp=$(mktemp -d) 
        wget -q -O $tmp/49-nopasswd_global.conf https://raw.githubusercontent.com/excited-bore/dotfiles/main/polkit/49-nopasswd_global.conf
        file=$tmp/49-nopasswd_global.conf 
    fi 
    function localauth_conf_d(){
        sudo cp -fbv $file /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf
    } 
    yes_edit_no localauth_conf_d "$file" "Install $file at /etc/polkit-1/localauthority.conf.d?" "yes" "GREEN"; 
    unset file 
fi

if sudo test -d /etc/polkit-1/rules.d/ && ! sudo test -f /etc/polkit-1/rules.d//90-nopasswd_global.rules; then
    file=polkit/49-nopasswd_global.rules 
    if ! test -f polkit/49-nopasswd_global.rules; then
        mktemp=$(mktemp -d) 
        wget -q -O $tmp/49-nopasswd_global.rules https://raw.githubusercontent.com/excited-bore/dotfiles/main/polkit/49-nopasswd_global.rules
        file=$tmp/49-nopasswd_global.rules
    fi 
    function rules_conf(){
        sudo cp -fbv $file /etc/polkit-1/rules.d/90-nopasswd_global.rules
    } 
    yes_edit_no rules_conf "$file" "Install $file at/etc/polkit-1/rules.d/?" "yes" "GREEN"; 
    unset file 
fi
