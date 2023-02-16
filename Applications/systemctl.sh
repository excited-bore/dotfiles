source /usr/share/bash-completion/completions/systemctl
alias systemd_list_system_units="sudo systemctl list-units --all"
alias systemd_list_user_units="systemctl --user list-units --all"
alias systemd_list_system_services="sudo systemctl list-units --type=service"
alias systemd_list_user_services="systemctl --user list-units --type=service"
alias systemd_list_system_sockets="sudo systemctl list-units --type=socket"
alias systemd_list_user_sockets="systemctl --user list-units --type=socket"
alias systemd_list_system_files="sudo systemctl list-unit-files"
alias systemd_list_user_files="systemctl --user list-unit-files"
alias systemd_restart="sudo systemctl restart"

#alias systemd_start_systemservice='function __systemd_start_systemservice() { sudo systemctl start "$@"; sudo systemctl status "$@"; unset -f __systemd_start_systemservice; }; __systemd_start_systemservice'
systemd_start_system_service(){
    sudo systemctl start $@; 
    sudo systemctl status $@;
}

_systemd_start_system(){
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

complete -F _systemd_start_system systemd_start_systemservice

systemd_start_user_service(){
    systemctl --user start $@;
    systemctl --user status $@;
}

_systemd_start_user(){
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

complete -F _systemd_start_user systemd_start_user

alias systemd_stop_systemservice="sudo systemctl stop "
alias systemd_stop_userservice="systemctl --user stop "

systemd_restart_systemservice(){
    sudo systemctl stop $@;
    sudo systemctl start $@;
    sudo systemctl status $@;
}

_systemd_restart_system(){
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

complete -F _systemd_restart_system systemd_restart_system

systemd_restart_userservice(){
    systemctl --user stop $@;
    systemctl --user start $@;
    systemctl --user status $@;
}

_systemd_restart_user(){
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

complete -F _systemd_restart_user systemd_restart_user

alias systemd_enable_systemservice="sudo systemctl enable "
alias systemd_enable_userservice="systemctl --user enable "

systemd_enable_now_system_service(){
    sudo systemctl enable --now $@;
    sudo systemctl status $@;
}

_systemd_enable_system_service(){
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

complete -F _systemd_enable_system_service systemd_enable_system_service

systemd_enable_now_userservice(){
    systemctl --user enable --now $@;
    systemctl --user status $@;
}

_systemd_enable_user_service(){
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

complete -F _systemd_enable_user_service systemd_enable_user_service

alias systemd_disable_systemservice="sudo systemctl disable "
alias systemd_disable_userservice="systemctl --user disable "
alias systemd_disable_now_systemservice="sudo systemctl disable --now "
alias systemd_disable_now_userservice="systemctl --user disable --now "
alias systemd_status_service="systemctl status "
alias systemd_reload_systemservices="sudo systemctl daemon-reload"
alias systemd_reload_userservices="systemctl --user daemon-reload"
alias bios="sudo systemctl reboot --firmware-setup"
alias bluetooth_start="sudo systemctl start bluetooth.service && blueman-manager"
alias bluetooth_down="sudo systemctl stop bluetooth.service"

alias systemd_logs_systemservice="sudo journalctl -x -u "
alias systemd_logs_userservice="journalctl -x --user-unit="
alias systemd_logs_boot="sudo journalctl -xb"
alias systemd_logs_boot_reverse="sudo journalctl -xrb"
alias systemd_logs_live="sudo journalctl -xf"
alias systemd_logs_live_reverse="sudo journalctl -xr"

function systemd_create_systemservice(){
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

function systemd_create_userservice(){
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
