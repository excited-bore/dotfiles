if sudo test -d /etc/polkit-1/localauthority/50-local.d/; then
    sudo cp -f polkit/49-nopasswd_global.pkla /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla
    echo "Rules added at /etc/polkit/49-nopasswd_global.pkla"
fi
if sudo test -d /etc/polkit-1/localauthority.conf.d/; then
    sudo cp -f polkit/49-nopasswd_global.pkla /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf
    echo "Rules added at /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf"
fi
if sudo test -d /etc/polkit-1/rules.d/; then
    sudo cp -f polkit/49-nopasswd_global.rules /etc/polkit-1/rules.d/90-nopasswd_global.rules
    echo "Rules added at /etc/polkit-1/rules.d/90-nopasswd_global.rules"
fi
