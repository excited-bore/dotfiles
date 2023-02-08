alias systemctl_list_unit_services="sudo systemctl list-units --type=service"
alias systemctl_list_unit_sockets="sudo systemctl list-units --type=socket"
alias systemctl_list_unit_files="sudo systemctl list-unit-files"
alias systemctl_daemon_start="sudo systemctl start"
alias systemctl_daemon_restart="sudo systemctl restart"
alias systemctl_daemon_stop="sudo systemctl stop"
alias systemctl_daemon_enable="sudo systemctl enable"
alias systemctl_daemon_enable_now="sudo systemctl enable --now"
alias systemctl_daemon_disable="sudo systemctl disable"
alias systemctl_daemon_disable_now="sudo systmctl disable --now"
alias systemctl_daemon_status="sudo systemctl status"
alias systemctl_daemon_reload="sudo systemctl daemon-reload"
alias systemctl_bios="sudo systemctl reboot --firmware-setup"
alias systemctl_bluetooth_start="sudo systemctl start bluetooth.service && blueman-manager"
alias systemctl_bluetooth_down="sudo systemctl stop bluetooth.service"

alias journalctl_daemon_logs="sudo journalctl -f -u"
alias journalctl_boot="sudo journalctl -xb"
alias journalctl_boot_reverse="sudo journalctl -xrb"
alias journalctl_live="sudo journalctl -xf"
alias journalctl_live_reverse="sudo journalctl -xr"

function systemctl_create_daemon(){
    read -p "Give up a '*.service' name: " inpt;
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
