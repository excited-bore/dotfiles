# !/bin/bash
#
# Kdocker is a system tray app
# thunderbird does not support trays on linux, which why we do this
alias thunderbird="kdocker thunderbird"

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
 
### VIM ###

alias vim="nvim -u ~/.config/nvim/init.vim" 
alias vim_check_health="vim +checkhealth"
alias vim_install_plugin="vim +PluginInstall +qall"

function vlcFolder(){
    if [ -d $1 ]; then
        vlc --recursive expand "./$1";
    else
        pwd | vlc --recursive expand ;
    fi;
}


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
alias systemctl_devolo_startup="doas systemctl start devolonetsvc.service && bash /opt/devolo/dlancockpit/bin/dlancockpit-run.sh"
alias systemctl_devolo_down="doas systemctl stop devolonetsvc.service"


#alias vmOn="sudo virsh net-autostart default && sudo virsh net-start default && sudo mv /etc/modprobe.d/vfio.conf.orig /etc/modprobe.d/vfio.conf && sudo mkinitcpio -p linux515 && reboot"
#alias vmOff="sudo virsh net-destroy default && sudo mv /etc/modprobe.d/vfio.conf /etc/modprobe.d/vfio.conf.orig && sudo mkinitcpio -p linux515 && reboot"