read -p "Add polkit rules? (rules at /etc/polkit-1/rules.d/) [Y/n]: " resp1
if [ -z $resp1 ]; then
    if sudo test -d /etc/polkit-1/localauthority/50-local.d/; then
        sudo cp -f polkit/49-nopasswd_global.conf /etc/polkit-1/localauthority/50-local.d/49-nopasswd_global.conf
    elif sudo test -d /etc/polkit-1/localauthority.conf.d/; then
        sudo cp -f polkit/49-nopasswd_global.conf /etc/polkit-1/localauthority.conf.d/49-nopasswd_global.conf
    fi
    sudo mkdir -p /etc/polkit-1/rules.d/ 
    sudo cp -f polkit/49-nopasswd_global.rules /etc/polkit-1/rules.d/49-nopasswd_global.rules
fi
