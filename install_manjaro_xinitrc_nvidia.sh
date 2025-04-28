read -p "Add nvidia settings to .xinitrc? [Y/n]:" nvid
if [ -z $nvid ];then
    if ! grep -q "nvidia-settings" ~/.xinitrc ; then 
        echo "exec nvidia-settings --load-config-only" >> ~/.xinitrc 
    fi
fi
