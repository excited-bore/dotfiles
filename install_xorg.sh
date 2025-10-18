hash Xorg &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! [[ -f checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if [[ $distro_base == "Arch" ]] || [[ $distro_base == "Debian" ]]; then
    eval "$pac_ins xorg"
fi 

#This should create a xorg.conf.new file in /root/ that you can copy over to /etc/X11/xorg.conf
Xorg :0 -configure
# If already running an X server
#Xorg :2 -configure
#cp /root/xorg.conf.new /etc/X11/xorg.conf
