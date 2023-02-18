read -p "Add polkit rules? (rules at /etc/polkit-1/rules.d/) [Y/n]: " resp1
if [ -z $resp1 ]; then
    if sudo test -d /etc/polkit-1/localauthority.conf.d/; then
        sudo cp -f polkit/49-nopasswd_global.pkla /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf
    fi
    if sudo test -d /etc/polkit-1/rules.d/; then
        sudo cp -f polkit/49-nopasswd_global.rules /etc/polkit-1/rules.d/49-nopasswd_global.rules
    fi
fi
