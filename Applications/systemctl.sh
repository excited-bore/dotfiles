source /usr/share/bash-completion/completions/systemctl 
alias service_system_list_units="sudo systemctl list-units --all"
alias service_user_list_units="systemctl --user list-units --all"
alias service_system_list_services="sudo systemctl list-units --type=service"
alias service_user_list_services="systemctl --user list-units --type=service"
alias service_system_list_sockets="sudo systemctl list-units --type=socket"
alias service_user_list_sockets="systemctl --user list-units --type=socket"
alias service_system_list_files="sudo systemctl list-unit-files"
alias service_user_list_files="systemctl --user list-unit-files"
alias service_systemd_restart="sudo systemctl restart"

service_system_start(){
    sudo systemctl start $@; 
    sudo systemctl status $@;
}

_service_system_start(){
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

complete -F _service_system_start service_system_start

service_user_start(){
    systemctl --user start $@;
    systemctl --user status $@;
}

_service_user_start(){
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

complete -F _service_user_start service_user_start

alias service_system_stop="sudo systemctl stop "
alias service_user_stop="systemctl --user stop "

service_system_restart(){
    sudo systemctl stop $@;
    sudo systemctl start $@;
    sudo systemctl status $@;
}

_service_system_restart(){
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

complete -F _service_system_restart service_system_restart

service_user_restart(){
    systemctl --user stop $@;
    systemctl --user start $@;
    systemctl --user status $@;
}

_service_user_restart(){
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

complete -F _service_user_restart service_user_restart

alias systemd_enable_systemservice="sudo systemctl enable "
alias systemd_enable_userservice="systemctl --user enable "

service_system_enable_now(){
    sudo systemctl enable --now $@;
    sudo systemctl status $@;
}

_service_system_enable_now(){
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

complete -F _service_system_enable_now service_system_enable_now

service_user_enable_now(){
    systemctl --user enable --now $@;
    systemctl --user status $@;
}

_service_user_enable_now(){
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

complete -F _service_user_enable_now service_user_enable_now

alias service_system_disable="sudo systemctl disable "
alias service_user_disable="systemctl --user disable "
alias service_system_disable_now="sudo systemctl disable --now "
alias service_user_disable_now="systemctl --user disable --now "
alias service_status="systemctl status"
alias service_system_reloadall="sudo systemctl daemon-reload"
alias service_user_reloadall="systemctl --user daemon-reload"
alias bios="systemctl reboot --firmware-setup"
alias bluetooth_start="sudo systemctl start bluetooth.service && blueman-manager"
alias bluetooth_down="sudo systemctl stop bluetooth.service"

alias service_system_logs="sudo journalctl -x"
alias service_system_log_unit="sudo journalctl -x -u"
alias service_user_logs="journalctl -x"
alias service_user_log_unit="journalctl -x -u"
alias service_system_logs_boot="sudo journalctl -xb"
alias service_user_logs_boot="journalctl -xb"
alias service_system_logs_boot_reverse="sudo journalctl -xrb"
alias service_user_logs_boot_reverse="journalctl -xrb"
alias service_system_logs_live="sudo journalctl -xf"
alias service_user_logs_live="journalctl -xf"
alias service_system_logs_reverse="sudo journalctl -xr"
alias service_user_logs_reverse="journalctl -xr"

function service_system_create(){
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
        systemd_start_systemservice $serv;
    fi
}

function service_user_create(){
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
        systemd_start_userservice $serv;
    fi
}

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
