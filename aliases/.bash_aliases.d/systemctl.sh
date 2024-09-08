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

service-system-start(){
    sudo systemctl start $@; 
    sudo systemctl status $@;
}

_service-system-start(){
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

service-user-start(){
    systemctl --user start $@;
    systemctl --user status $@;
}

_service-user-start(){
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

complete -F _service-user-start service-user-start

alias service-system-stop="sudo systemctl stop "
alias service-user-stop="systemctl --user stop "

service-system-restart(){
    sudo systemctl stop $@;
    sudo systemctl start $@;
    sudo systemctl status $@;
}

_service-system-restart(){
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

complete -F _service-system-restart service-system-restart

service-user-restart(){
    systemctl --user stop $@;
    systemctl --user start $@;
    systemctl --user status $@;
}

_service-user-restart(){
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

complete -F _service-user-restart service-user-restart

alias systemd-enable-systemservice="sudo systemctl enable "
alias systemd-enable-userservice="systemctl --user enable "

service-system-enable-now(){
    sudo systemctl enable --now $@;
    sudo systemctl status $@;
}

_service-system-enable-now(){
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

complete -F _service-system-enable-now service-system-enable-now

service-user-enable-now(){
    systemctl --user enable --now $@;
    systemctl --user status $@;
}

_service-user-enable-now(){
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

complete -F _service-user-enable-now service-user-enable-now

alias service-system-disable="sudo systemctl disable "
alias service-user-disable="systemctl --user disable "
alias service-system-disable-now="sudo systemctl disable --now "
alias service-user-disable-now="systemctl --user disable --now "
alias service-status="systemctl status"
alias service-system-reloadall="sudo systemctl daemon-reload"
alias service-user-reloadall="systemctl --user daemon-reload"
alias bios="systemctl reboot --firmware-setup"
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
   alias restart-display="sudo systemctl restart display-manager"  
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
