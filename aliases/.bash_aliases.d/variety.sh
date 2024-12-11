# !/bin/bash
if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

if ! type ble &> /dev/null; then
    alias ble-load="sed 's/#\(.*ble.sh --noattach\)/\1/g' ~/.bashrc && source ~/.bashrc"
else  
    alias ble-unload="sed 's/^\(.*ble.sh --noattach\)/#\1/g' ~/.bashrc && source ~/.bashrc"
fi

# Kdocker is a system tray app
# thunderbird does not support trays on linux, which why we do this

if type kdocker &> /dev/null && type thunderbird &> /dev/null; then
    alias thunderbird="kdocker thunderbird"
fi

if type lowfi &> /dev/null; then
    alias lowfi-play="lowfi play"
fi

if type nyx &> /dev/null; then
    alias status-tor="nyx"
fi

if type java &> /dev/null; then
    alias java-jar="java -jar"
fi


if type torsocks &> /dev/null; then
    alias tor-shell-on="source torsocks on"
    alias tor-shell-off="source torsocks off"
fi

if test -f /opt/anaconda/bin/activate; then
    alias conda-activate='CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 source /opt/anaconda/bin/activate root'
    alias conda-deactivate='CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 conda deactivate'
    #CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1 source /opt/anaconda/bin/activate root 
fi

if type nmap &> /dev/null; then
    function net-open-ports-outgoing(){
        if test -z $@; then
            printf "No arguments. This could take a while.\n" 
            time nmap -p- portquiz.net | grep -i open 
        else 
            time nmap -p "$@" portquiz.net 
        fi
    }
    complete -W "$(seq 1 10000)" net-open-ports-outgoing 
fi

if type ss &> /dev/null; then
    alias ports-listen-tcp="ss -nlt"
  #alias net-list-active-ports="ss -tulpn | awk '{print \$5;}' | grep --color=never '[^\:][0-9]$' | cut -d: -f2 | xargs | tr ' ' '\n' | sort -u"  
fi


if type netstat &> /dev/null; then
    # Netstat deprecated 
    # https://blog.pcarleton.com/post/netstat-vs-ss/
    if type ss &> /dev/null; then
        alias netstat-is-installed-but-use-ss='ss'
    fi
    alias netstat-list-all-ports="netstat -a"
    alias netstat-list-all-ports-tcp="netstat -at"
    alias netstat-list-all-ports-udp="netstat -au"
    #alias netstat-list-ports-in-use="netstat -latu | awk 'NR>2{print \$4}' | cut -d: -f2 | grep --color=never [0-9]" 
    #alias netstat-open-ports-incoming='netstat -nalpeec --inet | $PAGER'
    alias netstat-open-ports-listening-no-unix='netstat -ntulpeec | $PAGER' 
    alias netstat-open-ports-listening-tcp='netstat -ntlpeec | $PAGER' 
    alias netstat-open-ports-listening-udp='netstat -nulpeec | $PAGER' 
    alias netstat-open-ports-listening-unix='netstat -nxlpeec | $PAGER' 
    alias netstat-open-ports-listening-all='netstat -nalpeec | $PAGER' 
    alias netstat-stats='netstat -s | $PAGER' 
    alias netstat-stats-tcp='netstat -st | $PAGER' 
    alias netstat-stats-udp='netstat -su | $PAGER' 
    alias netstat-kernel-interface='netstat -iee | $PAGER' 
    alias netstat-masquerades='netstat -M | $PAGER' 
    alias netstat-routing-table-kernel='netstat -r | $PAGER' 
    alias netstat-ip4v6-group-membership='netstat -g | $PAGER' 
    
    function netstat-search-program-port(){
        if ! test -z "$@"; then
            for i in "$@"; do
                printf "${CYAN}Port $i ${normal}\n" 
                netstat -an | grep ":$i" 
            done
        fi
    }
    #if ! type ss &> /dev/null; then
        complete -W "$(seq 1 10000)" netstat-search-program-port 
    #else
    #    complete -W "$(net-list-all-active-ports)" netstat-search-program-port 
    #fi
fi


if type exiftool &> /dev/null; then
    alias exiftool-folder="exiftool -r -all= $(pwd)"
    function exiftool-add-cron-wipe-all-metadata-rec-dir(){
        reade -Q 'GREEN' -i '0,5,10,15,25,30,35,40,45,5,55 0 5 10 15 25 30 35 40 45 50 55' -p 'Minutes? (0-59): '  min
        reade -Q 'GREEN' -p "Dir?: " -e dir
        (crontab -l; echo "$min * * * * exiftool -r -all= $dir") | sort -u | crontab -; crontab -l 
        unset min dir 
    } 
    alias exiftool-add-cron-wipe-all-metadata-rec-picture-dir="(crontab -l; echo '0,5,10,15,25,30,35,40,45,5,55 * * * * exiftool -r -all= $HOME/Pictures') | sort -u | crontab -; crontab -l"
fi

#if type lazygit &> /dev/null && type copy-to &> /dev/null; then
    #alias lazygit="copy-to run && lazygit"
#fi

# Discord and discord overlay
if type discord &> /dev/null && type discover-overlay &> /dev/null; then
    alias discord="discover-overlay && discord"
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
        frst=$(echo $1 | sed 's|"|\\"|g' | sed 's|\[|\\[|g' | sed 's|\]|\\]|g') 
        scnd=$(echo $2 | sed 's|"|\\"|g' | sed 's|\[|\\[|g' | sed 's|\]|\\]|g') 
        printf 'Replacing '"${CYAN}$frst${normal}"' with '"${YELLOW}$scnd${normal}""\n" 
        #echo $frst'|'$scnd 
        rg "$(echo $frst | sed 's|?|\\\?|g')" --multiline --files-with-matches 
        rg "$(echo $frst | sed 's|?|\\?|g')" --multiline --color=never --files-with-matches | xargs sed -i "s|${frst}|${scnd}|g"
        unset $frst $scnd 
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
