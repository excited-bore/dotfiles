SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi


if sudo test -d /etc/polkit-1/localauthority/50-local.d/ && ! sudo test -f /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla; then
    file=$TOP/polkit/49-nopasswd_global.pkla 
    if ! test -f $TOP/polkit/49-nopasswd_global.pkla; then
        mktemp=$(mktemp -d) 
        wget-aria-dir $tmp/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/polkit/49-nopasswd_global.pkla
        file=$tmp/49-nopasswd_global.pkla 
    fi
    function localauth_conf(){
        sudo cp $file /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla
    } 
    yes-edit-no -f localauth_conf -g "$file" -p "Install $file at /etc/polkit-1/localauthority/50-local.d/?"  
    unset file 
fi

if sudo test -d /etc/polkit-1/localauthority.conf.d/ && ! sudo test -f /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf; then
    file=$TOP/polkit/49-nopasswd_global.conf 
    if ! test -f $TOP/polkit/49-nopasswd_global.conf; then
        mktemp=$(mktemp -d) 
        wget-aria-dir $tmp/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/polkit/49-nopasswd_global.conf
        file=$tmp/49-nopasswd_global.conf 
    fi 
    function localauth_conf_d(){
        sudo cp $file /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf
    } 
    yes-edit-no -f localauth_conf_d -g "$file" -p "Install $file at /etc/polkit-1/localauthority.conf.d?" 
    unset file 
fi

if sudo test -d /etc/polkit-1/rules.d/ && ! sudo test -f /etc/polkit-1/rules.d/90-nopasswd_global.rules; then
    file=$TOP/polkit/49-nopasswd_global.rules 
    if ! test -f $TOP/polkit/49-nopasswd_global.rules; then
        mktemp=$(mktemp -d) 
        wget-aria-dir $tmp/ https://raw.githubusercontent.com/excited-bore/dotfiles/main/polkit/49-nopasswd_global.rules
        file=$tmp/49-nopasswd_global.rules
    fi 
    function rules_conf(){
        sudo cp $file /etc/polkit-1/rules.d/90-nopasswd_global.rules
    } 
    yes-edit-no -f rules_conf -g "$file" -p "Install $file at/etc/polkit-1/rules.d/?"  
    unset file 
fi
