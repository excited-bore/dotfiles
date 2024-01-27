if sudo test -d /etc/polkit-1/localauthority/50-local.d/; then
    sudo cp -bfv polkit/49-nopasswd_global.pkla /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla
    gio trash /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla~
fi
if sudo test -d /etc/polkit-1/localauthority.conf.d/; then
    sudo cp -bfv polkit/49-nopasswd_global.pkla /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf
    gio trash /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla~
    
fi
if sudo test -d /etc/polkit-1/rules.d/; then
    sudo cp -bfv polkit/49-nopasswd_global.rules /etc/polkit-1/rules.d/90-nopasswd_global.rules
    gio trash /etc/polkit-1/localauthority/50-local.d/90-nopasswd_global.pkla~
fi
