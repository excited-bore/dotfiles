# global bashrc -> /etc/bash.bashrc
# global shell profiles -> /etc/profile
. .exports
. ~/Applications/general.sh
. ~/Applications/systemctl.sh
. ~/Applications/tmux.sh
. ~/Applications/package_managers.sh
. ~/Applications/manjaro.sh
. ~/Applications/git.sh
. ~/Applications/youtube.sh
. ~/Applications/doas.sh

if [ ! -e ~/lib_systemd ]; then
    lnSoft /lib/systemd/system/ ~/lib_systemd
fi

if [ ! -e ~/etc_systemd ]; then
    lnSoft /etc/systemd/system/ ~/etc_systemd
fi

if [ ! -e ~/.vimrc ]; then
    lnSoft .config/nvim/init.vim ~/.vimrc
fi




# Set caps to escape
setxkbmap -option "lv3:caps_switch" 
# Set Shift delete to backspace
xmodmap -e "keycode 119 = Delete BackSpace"

function ptrace_toggle() {
    echo "Has ptrace currently elevated priviliges: $PTRACE_ELEVATED_PRIVILIGE";
    echo "Change? y/n: ";
    if [[ ! $(read) = "y" ]];then
        return;
    fi
    if [ $PTRACE_ELEVATED_PRIVILIGE == 1 ]; then
        export PTRACE_ELEVATED_PRIVILIGE="0";
    else
        export PTRACE_ELEVATED_PRIVILIGE="1";
    fi
    doas echo $PTRACE_ELEVATED_PRIVILIGE > /proc/sys/kernel/yama/ptrace_scope;   
}
# python virtual env
#python3 -m venv python3
#source venv/bin/activate

# Jump to bottom of screen
# https://stackoverflow.com/questions/49733211/bash-jump-to-bottom-of-terminal



## stty settings
# see with 'stty -a'
# unbinds ctrl-c and bind the function to ctrl-x
stty intr '^x'
stty start 'undef' 
stty stop 'undef' 
#stty 'eol' 'home'

# Kdocker is a system tray app
# thunderbird does not support trays on linux, which why we do this
alias thunderbird="kdocker thunderbird"


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
alias pihole_update="cd ~/Applications/docker-pi-hole && docker_update"

alias ds4LOn="ds4drv --led ff0000"
alias ds4LOff="ds4drv --led 000000"
alias ds4="python3 -m ds4drv --hidraw --udp --udp-port 26760"

alias udev_reload="sudo udevadm control --reload-rules && sudo udevadm trigger"

#Devolo PLC Stuff

alias wick="sudo wickrme --no-sandbox"


#alias vmOn="sudo virsh net-autostart default && sudo virsh net-start default && sudo mv /etc/modprobe.d/vfio.conf.orig /etc/modprobe.d/vfio.conf && sudo mkinitcpio -p linux515 && reboot"
#alias vmOff="sudo virsh net-destroy default && sudo mv /etc/modprobe.d/vfio.conf /etc/modprobe.d/vfio.conf.orig && sudo mkinitcpio -p linux515 && reboot"
