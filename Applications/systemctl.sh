alias systemd_list_rootunits="sudo systemctl list-units --all"
alias systemd_list_userunits="systemctl --user list-units --all"
alias systemd_list_rootservices="sudo systemctl list-units --type=service"
alias systemd_list_userservices="systemctl --user list-units --type=service"
alias systemd_list_rootsockets="sudo systemctl list-units --type=socket"
alias systemd_list_usersockets="systemctl --user list-units --type=socket"
alias systemd_list_rootfiles="sudo systemctl list-unit-files"
alias systemd_list_userfiles="systemctl --user list-unit-files"
alias systemd_restart="sudo systemctl restart"
systemd_start_rootservice(){
    sudo systemctl start $@;
    sudo systemctl status $@;
}
systemd_start_userservice(){
    systemctl --user start $@;
    systemctl --user status $@;
}
alias systemd_stop_rootservice="sudo systemctl stop "
alias systemd_stop_userservice="systemctl --user stop "
systemd_restart_rootservice(){
    sudo systemctl stop $@;
    sudo systemctl start $@;
    sudo systemctl status $@;
}
systemd_restart_userservice(){
    systemctl --user stop $@;
    systemctl --user start $@;
    systemctl --user status $@;
}
alias systemd_enable_rootservice="sudo systemctl enable "
alias systemd_enable_userservice="systemctl --user enable "
systemd_enable_now_rootservice(){
    sudo systemctl enable --now $@;
    sudo systemctl status $@;
}
systemd_enable_now_userservice(){
    systemctl --user enable --now $@;
    systemctl --user status $@;
}
alias systemd_disable_rootservice="sudo systemctl disable "
alias systemd_disable_userservice="systemctl --user disable "
alias systemd_disable_now_rootservice="sudo systemctl disable --now "
alias systemd_disable_now_userservice="systemctl --user disable --now "
alias systemd_status_service="systemctl status "
alias systemd_reload_rootservices="sudo systemctl daemon-reload"
alias systemd_reload_userservices="systemctl --user daemon-reload"
alias bios="sudo systemctl reboot --firmware-setup"
alias bluetooth_start="sudo systemctl start bluetooth.service && blueman-manager"
alias bluetooth_down="sudo systemctl stop bluetooth.service"

alias systemd_logs_rootservice="sudo journalctl -x -u "
alias systemd_logs_userservice="journalctl -x --user-unit="
alias systemd_logs_boot="sudo journalctl -xb"
alias systemd_logs_boot_reverse="sudo journalctl -xrb"
alias systemd_logs_live="sudo journalctl -xf"
alias systemd_logs_live_reverse="sudo journalctl -xr"

function systemd_create_rootservice(){
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
        systemd_start_rootservice $serv;
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

#function systemctl_create_multi_user_root_daemon(){
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
