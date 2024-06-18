# !/bin/bash
#
# Kdocker is a system tray app
# thunderbird does not support trays on linux, which why we do this

if type kdocker &> /dev/null && type thunderbird &> /dev/null; then
    alias thunderbird="kdocker thunderbird"
fi

if type lazygit &> /dev/null && type copy-to &> /dev/null; then
    alias lazygit="copy-to run && lazygit"
fi

alias mullvad-sessions="mullvad-exclude thunderbird; mullvad-exclude ferdium; mullvad connect"

function rg-search-and-replace() {
    if test -z "$1" || test -z "$2"; then
        echo "rg-search-and-replace needs 2 arguments: "
        echo "  - the pattern to search for"
        echo "  - the replacement"
        return 1
    fi
    rg "$1" --color=never --files-with-matches | xargs sed -i "s/$1/$2/g"
}

#function ptrace_toggle() {
#    echo "Has ptrace currently elevated priviliges: $PTRACE_ELEVATED_PRIVILIGE";
#    echo "Change? y/n: ";
#    if [[ ! $(read) = "y" ]];then
#        return;
#    fi
#    if [ $PTRACE_ELEVATED_PRIVILIGE == 1 ]; then
#        export PTRACE_ELEVATED_PRIVILIGE="0";
#    else
#        export PTRACE_ELEVATED_PRIVILIGE="1";
#    fi
#    doas echo $PTRACE_ELEVATED_PRIVILIGE > /proc/sys/kernel/yama/ptrace_scope;   
#}

alias mp4tomp3="ffmpeg -i \".mp4\" -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 \".mp3\""

vlc_folder(){
    if [ -d $1 ]; then
        vlc --recursive expand "./$1";
    else
        pwd | vlc --recursive expand ;
    fi;
}

#if [ ! -e "`python -m site --user-site`" ];then
#    mkdir -p "`python -m site --user-site`"
#    ln -s $(python -m site --user-site) ~/python_user_site  
#fi

# Docker
alias docker_update="docker-compose down && docker-compose pull && docker-compose up &"

# Pihole
alias pihole_update="cd ~/Applications/docker-pi-hole && docker_update"

alias ds4LOn="ds4drv --led ff0000"
alias ds4LOff="ds4drv --led 000000"
alias ds4="python3 -m ds4drv --hidraw --udp --udp-port 26760"


alias udev_reload="sudo udevadm control --reload-rules && sudo udevadm trigger"

# Wickr
alias wick="sudo wickrme --no-sandbox"

#Devolo PLC Stuff
alias devolo_start="sudo systemctl start devolonetsvc.service && bash /opt/devolo/dlancockpit/bin/dlancockpit-run.sh"
alias devolo_down="sudo systemctl stop devolonetsvc.service"


#alias vmOn="sudo virsh net-autostart default && sudo virsh net-start default && sudo mv /etc/modprobe.d/vfio.conf.orig /etc/modprobe.d/vfio.conf && sudo mkinitcpio -p linux515 && reboot"
#alias vmOff="sudo virsh net-destroy default && sudo mv /etc/modprobe.d/vfio.conf /etc/modprobe.d/vfio.conf.orig && sudo mkinitcpio -p linux515 && reboot"
