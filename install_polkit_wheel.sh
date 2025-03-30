# !/bin/bash


if ! test -f checks/check_all.sh; then
    if type curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh) 
    else 
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n" 
        return 1 || exit 1 
    fi
else
    . ./checks/check_all.sh
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
    yes-no-edit -f localauth_conf -g "$file" -p "Install $file at /etc/polkit-1/localauthority/50-local.d/?" -i "y" -Q "GREEN"; 
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
    yes-no-edit -f localauth_conf_d -g "$file" -p "Install $file at /etc/polkit-1/localauthority.conf.d?" -i "y" -Q "GREEN"; 
    unset file 
fi

if sudo test -d /etc/polkit-1/rules.d/ && ! sudo test -f /etc/polkit-1/rules.d/90-nopasswd_global.rules; then
    file=polkit/49-nopasswd_global.rules 
    if ! test -f polkit/49-nopasswd_global.rules; then
        mktemp=$(mktemp -d) 
        wget -q -O $tmp/49-nopasswd_global.rules https://raw.githubusercontent.com/excited-bore/dotfiles/main/polkit/49-nopasswd_global.rules
        file=$tmp/49-nopasswd_global.rules
    fi 
    function rules_conf(){
        sudo cp -fbv $file /etc/polkit-1/rules.d/90-nopasswd_global.rules
    } 
    yes-no-edit -f rules_conf -g "$file" -p "Install $file at/etc/polkit-1/rules.d/?" -i "y" -Q "GREEN"; 
    unset file 
fi
