# !/bin/bash

if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

# Kdocker is a system tray app
# thunderbird does not support trays on linux, which why we do this

if type kdocker &> /dev/null && type thunderbird &> /dev/null; then
    alias thunderbird="kdocker thunderbird"
fi

if type exiftool &> /dev/null; then
    function exiftool-add-cron-wipe-all-metadata-rec-dir(){
        reade -Q 'GREEN' -i '0,5,10,15,25,30,35,40,45,5,55' -p 'Minutes? (0-59): ' '0 5 10 15 25 30 35 40 45 50 55' min
        reade -Q 'GREEN' -p "Dir?: " -e dir
        (crontab -l; echo "0,5,10,15,25,30,35,40,45,5,55 * * * * exiftool -r -all= $dir") | sort -u | crontab -; crontab -l 
        unset min dir 
    } 
    alias exiftool-add-cron-wipe-all-metadata-rec-picture-dir="(crontab -l; echo '0,5,10,15,25,30,35,40,45,5,55 * * * * exiftool -r -all= $HOME/Pictures') | sort -u | crontab -; crontab -l"
fi

if type lazygit &> /dev/null && type copy-to &> /dev/null; then
    alias lazygit="copy-to run && lazygit"
fi

#alias mullvad-sessions="mullvad-exclude thunderbird; mullvad-exclude ferdium; mullvad connect"

# Mullvad
if type fzf &> /dev/null && type mullvad &> /dev/null; then
    function mullvad-sessions(){
        mullvad disconnect
        ssns="$(printf "mullvad-exclude firefox &\nmullvad-exclude thunderbird &\nmullvad-exclude ferdium &\nmullvad-exclude steam &\n" | fzf --multi)"
        if ! test -z "$(echo "$ssns" | grep -q 'firefox')" && ! test -z "$(ps -aux | grep firefox | awk '{print $2}')"; then
            pkill -f firefox
        fi
        mullvad connect && (eval "$ssns" &> /dev/null) 
    }
fi

# rg stuff
if type rg &> /dev/null; then
    function rg-search-and-replace() {
        if test -z "$1" || test -z "$2"; then
            echo "rg-search-and-replace needs 2 arguments: "
            echo "  - the pattern to search for"
            echo "  - the replacement"
            return 1
        fi
        rg "$1" --color=never --files-with-matches | xargs sed -i "s/$1/$2/g"
    }
fi

# Stow
alias stow-adopt="stow ./ -t ~/ --adopt"

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


if type ffmpeg &> /dev/null; then
    function videotomp3(){
        reade -Q "GREEN" -i "n" -p "Delete after conversion? [N/y]: " "y" del
        for var in "$@"
        do
            ffmpeg -i "$var" -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 "${var%.*}.mp3" && test "$del" == 'y' && test -f "$var" && rm -v "$var" 
        done
    }
fi

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
