alias service_list_unit_services="sudo systemctl list-units --type=service"
alias service_list_unit_sockets="sudo systemctl list-units --type=socket"
alias service_list_unit_files="sudo systemctl list-unit-files"
alias services_restart_systemctl="sudo systemctl restart"
alias service_start="sudo systemctl start "
alias service_stop="sudo systemctl stop "
alias service_enable="sudo systemctl enable "
alias service_enable_now="sudo systemctl enable --now "
alias service_disable="sudo systemctl disable "
alias service_disable_now="sudo systmctl disable --now "
alias service_status="sudo systemctl status "
alias services_reload="sudo systemctl daemon-reload"
alias bios="sudo systemctl reboot --firmware-setup"
alias bluetooth_start="sudo systemctl start bluetooth.service && blueman-manager"
alias bluetooth_down="sudo systemctl stop bluetooth.service"

alias services_logs="sudo journalctl -f -u"
alias services_logs_boot="sudo journalctl -xb"
alias services_logs_boot_reverse="sudo journalctl -xrb"
alias services_logs_live="sudo journalctl -xf"
alias services_logs_live_reverse="sudo journalctl -xr"

function systemd_create_multi_user_daemon(){
    read -p "Give up a '*.service' name (script adds file extension .service): " inpt;
    if [ -z "$inpt" ]; then
        echo "Give up a viable filename please";
        return;
    else
        serv="/etc/systemd/system/$inpt.service"
        touch $serv;
        echo "[Unit]" >> $serv;
        echo "Description=$serv service." >> $serv;

        echo "[Service]" >> $serv;
        echo "ExecStart=/bin/bash /usr/bin/test_service.sh" >> $serv;

        echo "[Install]" >> $serv;
        echo "WantedBy=multi-user.target" >> $serv;
    fi
    sudo chmod 644 $serv;
    sudoedit $serv;
    systemctl_start $serv;
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
