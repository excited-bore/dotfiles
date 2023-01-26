alias systemctl_list_unit_services="doas systemctl list-units --type=service"
alias systemctl_list_unit_sockets="doas systemctl list-units --type=socket"
alias systemctl_list_unit_files="doas systemctl list-unit-files"
alias systemctl_start="doas systemctl start"
alias systemctl_restart="doas systemctl restart"
alias systemctl_stop="doas systemctl stop"
alias systemctl_enable="doas systemctl enable"
alias systemctl_enable_now="doas systemctl enable --now"
alias systemctl_disable="doas systemctl disable"
alias systemctl_disable_now="doas systmctl disable --now"
alias systemctl_status_daemon="doas systemctl status"
alias systemctl_bios="doas systemctl reboot --firmware-setup"
alias systemctl_bluetooth_startup="doas systemctl start bluetooth.service && blueman-manager"
alias systemctl_bluetooth_down="doas systemctl stop bluetooth.service"
alias systemctl_devolo_startup="doas systemctl start devolonetsvc.service && bash /opt/devolo/dlancockpit/bin/dlancockpit-run.sh"
alias systemctl_devolo_down="doas systemctl stop devolonetsvc.service"

alias journalctl_boot="doas journalctl -xb"
alias journalctl_live="doas journalctl -xf"
alias journalctl_live_reverse="doas journalctl -xr"

function create_systemd_daemon(){
    read -p "Give up a '*.service' name: " inpt;
    if [ -z "$inpt" ]; then
        echo "Give up a viable filename please";
        return;
    else
        serv=/etc/systemd/system/"$inpt.service";
        echo "File will be at '$serv'";
        sleep 2;
        if [ -e ~/systemd_example.service ]; then
            doas cp ~/systemd_example.service $serv;
        else
            doas touch $serv;
            doas echo "[Unit]" >> $serv;
            doas echo "Description=Example systemd service." >> $serv;

            doas echo "[Service]" >> $serv;
            doas echo "Type=simple" >> $serv;
            doas echo "ExecStart=/bin/bash /usr/bin/test_service.sh" >> $serv;

            doas echo "[Install]" >> $serv;
            doas echo "WantedBy=multi-user.target" >> $serv;
        fi
    fi
    doas chmod 644 $serv;
    doasedit $serv;
    systemctl_start $serv;
}
