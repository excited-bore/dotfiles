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

# Ranger 
alias ranger='source ranger ranger'
if [ -n "$RANGER_LEVEL" ]; then 
    export PS1="[ranger]$PS1"; 
fi

# Docker
alias docker_update="docker-compose down && docker-compose pull && docker-compose up &"

# Pihole
alias pihole_update="cd ~/Applications/docker-pi-hole && docker_update"

alias ds4LOn="ds4drv --led ff0000"
alias ds4LOff="ds4drv --led 000000"
alias ds4="python3 -m ds4drv --hidraw --udp --udp-port 26760"

python_install_user(){
    python $@ install --user;
}
alias python_twine_install="python3 -m pip install --upgrade twine"
alias python_twine_upload_test="python3 -m pip install --upgrade build && python3 -m build && python3 -m twine check dist/* && python3 -m twine upload --repository testpypi dist/* && rm dist/* && echo 'Uploaded to https://test.pypi.org/'"
alias python_twine_upload="python3 -m pip install --upgrade build && python3 -m build && python3 -m twine check dist/* && python3 -m twine upload dist/* && rm dist/* && echo 'Uploaded to https://pypi.org/' "


alias udev_reload="sudo udevadm control --reload-rules && sudo udevadm trigger"

# Wickr
alias wick="sudo wickrme --no-sandbox"

#Devolo PLC Stuff
alias devolo_start="sudo systemctl start devolonetsvc.service && bash /opt/devolo/dlancockpit/bin/dlancockpit-run.sh"
alias devolo_down="sudo systemctl stop devolonetsvc.service"


#alias vmOn="sudo virsh net-autostart default && sudo virsh net-start default && sudo mv /etc/modprobe.d/vfio.conf.orig /etc/modprobe.d/vfio.conf && sudo mkinitcpio -p linux515 && reboot"
#alias vmOff="sudo virsh net-destroy default && sudo mv /etc/modprobe.d/vfio.conf /etc/modprobe.d/vfio.conf.orig && sudo mkinitcpio -p linux515 && reboot"
