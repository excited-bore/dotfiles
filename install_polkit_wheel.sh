read -p "Add polkit rules? (rules at /etc/polkit-1/rules.d/) [Y/n]: " resp1
if [ -z $resp1 ]; then
    sudo mkdir -p /etc/polkit-1/rules.d/ 
    sudo cp -f polkit/49-nopasswd_global.rules /etc/polkit-1/rules.d/49-nopasswd_global.rules
fi
