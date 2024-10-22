#source /usr/share/bash-completion/completions/systemctl 
alias service-system-list-units="sudo systemctl list-units --all"
alias service-user-list-units="systemctl --user list-units --all"
alias service-system-list-services="sudo systemctl list-units --type=service"
alias service-user-list-services="systemctl --user list-units --type=service"
alias service-system-list-sockets="sudo systemctl list-units --type=socket"
alias service-user-list-sockets="systemctl --user list-units --type=socket"
alias service-system-list-files="sudo systemctl list-unit-files"
alias service-user-list-files="systemctl --user list-unit-files"
alias service-systemd-restart="sudo systemctl restart"

alias bios="systemctl reboot --firmware-setup"

alias restart-network="systemctl restart NetworkManager"  
alias status-network="systemctl status NetworkManager"  

alias restart-bluetooth="systemctl restart bluetooth.target"
alias status-bluetooth="systemctl status bluetooth.target"

alias restart-display="sudo systemctl restart display-manager"  
alias status-display="sudo systemctl status display-manager"  

if type samba &> /dev/null; then
    servs="smbd nmbd" 
    alias stop-samba="sudo systemctl stop $servs"
    alias start-samba="sudo systemctl start $servs"
    alias enable-samba="sudo systemctl enable $servs"
    alias disable-samba="sudo systemctl disable $servs"
    alias enable-now-samba="sudo systemctl enable --now $servs"
    alias disable-now-samba="sudo systemctl disable --now $servs"
    alias restart-samba="sudo systemctl restart $servs"
    alias status-samba-service="sudo systemctl status $servs"
    unset servs 
fi

if type tor &> /dev/null; then
    servs="tor" 
    alias stop-tor="sudo systemctl stop  $servs"
    alias start-tor="sudo systemctl start  $servs"
    alias enable-tor="sudo systemctl enable  $servs"
    alias disable-tor="sudo systemctl disable  $servs"
    alias enable-now-tor="sudo systemctl enable --now $servs"
    alias disable-now-tor="sudo systemctl disable --now  $servs"
    alias restart-tor="sudo systemctl restart  $servs"
    alias status-tor-service="sudo systemctl status $servs"
    unset servs 
fi

if type docker &> /dev/null; then
    servs="docker" 
    alias stop-docker="sudo systemctl stop  $servs"
    alias start-docker="sudo systemctl start  $servs"
    alias restart-docker="sudo systemctl restart  $servs"
    alias disable-docker="sudo systemctl disable  $servs"
    alias enable-docker="sudo systemctl enable  $servs"
    alias enable-now-docker="sudo systemctl enable --now $servs"
    alias disable-now-docker="sudo systemctl disable --now  $servs"
    alias status-docker-service="sudo systemctl status $servs"
    unset servs 
fi


if type pipewire &> /dev/null; then
    servs="pipewire" 
    if type wireplumber &> /dev/null; then
        servs=$servs" wireplumber" 
    fi
    if type pipewire-pulse &> /dev/null; then
        servs=$servs" pipewire-pulse" 
    fi
    alias stop-pipewire="systemctl stop --user $servs"
    alias start-pipewire="systemctl start --user $servs"
    alias restart-pipewire="systemctl restart --user $servs"
    alias status-pipewire="systemctl status --user $servs"
    alias disable-pipewire="systemctl disable --user  $servs"
    alias enable-pipewire="systemctl enable --user  $servs"
    alias enable-now-pipewire="systemctl enable --user --now $servs"
    alias disable-now-pipewire="systemctl disable --user --now  $servs"

    unset servs 
fi

if type fzf &> /dev/null; then
    alias systemctl-fzf-running-units='systemctl --no-pager --state running | head -n -6 |  fzf --ansi'
fi

system-service-start(){
    sudo systemctl start $@; 
     systemctl status $@;
}

_system-service-start(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_startable_units --system "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _service-system-start service-system-start

service-start(){
    systemctl --user start $@;
    systemctl --user status $@;
}

_service-start(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_startable_units --user "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _service-start service-start

alias system-service-stop="sudo systemctl stop "
alias service-stop="systemctl --user stop "

system-service-restart(){
    sudo systemctl restart $@;
    sudo systemctl status $@;
}

_system-service-restart(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_stoppable_units --system "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _system-service-restart system-service-restart

service-restart(){
    systemctl --user restart $@;
    systemctl --user status $@;
}

_service-restart(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_stoppable_units --system "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _service-restart service-restart


system-service-enable-now(){
    sudo systemctl enable --now $@;
    sudo systemctl status $@;
}

_system-service-enable-now(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_stoppable_units --system "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _system-service-enable-now system-service-enable-now

service-enable-now(){
    systemctl --user enable --now $@;
    systemctl --user status $@;
}

_service-enable-now(){
    local cur=${COMP_WORDS[COMP_CWORD]} prev=${COMP_WORDS[COMP_CWORD-1]}
    cur_orig=$cur
    if [[ $cur =~ '\\' ]]; then
        cur="$(echo $cur | xargs echo)"
    else
        cur_orig="$(printf '%q' $cur)"
    fi
    comps=$( __get_stoppable_units --system "$cur" )
    compopt -o filenames
    COMPREPLY=( $(compgen -o filenames -W '$comps' -- "$cur_orig") )
    return 0
}

complete -F _service-enable-now service-enable-now

alias service-system-disable="sudo systemctl disable "
alias service-user-disable="systemctl --user disable "
alias service-system-disable-now="sudo systemctl disable --now "
alias service-user-disable-now="systemctl --user disable --now "
alias service-status="systemctl status"
alias service-system-reloadall="sudo systemctl daemon-reload"
alias service-user-reloadall="systemctl --user daemon-reload"
alias bluetooth-start="sudo systemctl start bluetooth.service && blueman-manager"
alias bluetooth-down="sudo systemctl stop bluetooth.service"

alias service-system-logs="sudo journalctl -x"
alias service-system-log-unit="sudo journalctl -x -u"
alias service-user-logs="journalctl -x"
alias service-user-log-unit="journalctl -x -u"
alias service-system-logs-boot="sudo journalctl -xb"
alias service-user-logs-boot="journalctl -xb"
alias service-system-logs-boot-reverse="sudo journalctl -xrb"
alias service-user-logs-boot-reverse="journalctl -xrb"
alias service-system-logs-live="sudo journalctl -xf"
alias service-user-logs-live="journalctl -xf"
alias service-system-logs-reverse="sudo journalctl -xr"
alias service-user-logs-reverse="journalctl -xr"

function service-system-create(){
    read -p "Give up a '*.service' name (script adds file extension .service): " inpt;
    if [ -z "$inpt" ]; then
        echo "Give up a viable filename please";
        return;
    else
        servF="$inpt.service";
        touch $servF;
        echo "[Unit]" >> $servF;
        echo "Description=$inpt service." >> $servF;

        echo "[Service]" >> $servF;
        echo "ExecStart=/bin/bash /usr/bin/test_service.sh" >> $servF;

        echo "[Install]" >> $servF;
        echo "WantedBy=multi-user.target" >> $servF;
        sudo chmod 644 $servF;
        sudoedit $servF;
        serv="/etc/systemd/system/$inpt.service";
        sudo mv -f $servF $serv;
        systemd-start-systemservice $serv;
    fi
}

function service-user-create(){
    read -p "Give up a '*.service' name (script adds file extension .service): " inpt;
    if [ -z "$inpt" ]; then
        echo "Give up a viable filename please";
        return;
    else
        serv="~/.config/systemd/system/$inpt.service";
        touch $serv;
        echo "[Unit]" >> $serv;
        echo "Description=$serv service." >> $serv;

        echo "[Service]" >> $serv;
        echo "ExecStart=/bin/bash /usr/bin/test_service.sh" >> $serv;

        echo "[Install]" >> $serv;
        echo "WantedBy=default.target" >> $serv;
        $EDITOR $serv;
        systemd-start-userservice $serv;
    fi
}

#if test $XDG_SESSION_TYPE == 'x11'; then
#fi

#function systemctl_create_multi_user_system_daemon(){
#    read -p "Give up a '*.conf' name (script adds file extension .conf): " inpt;
#    if [ -z "$inpt" ]; then
#        echo "Give up a viable filename please";
#        return;
#    else
#        serv="/etc/$inpt.conf"
#        touch $serv;
#        echo "#    Path                  Mode UID  GID  Age Argument" > $serv
#            
#    sudo chmod 644 $serv;
#    sudoedit $serv;
#    systemctl_start $serv;
#}                                                     
