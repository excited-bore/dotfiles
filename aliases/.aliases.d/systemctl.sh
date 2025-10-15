### SYSTEMCTL ###

if ! type reade &> /dev/null && test -f ~/.aliases.d/00-rlwrap_scripts.sh; then
    . ~/.aliases.d/00-rlwrap_scripts.sh
fi

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

alias restart-bluetooth="systemctl restart bluetooth.service"
alias status-bluetooth="systemctl status bluetooth.service"

alias restart-display="sudo systemctl restart display-manager"  
alias status-display="sudo systemctl status display-manager"  

alias systemctl-find-service-file="systemctl show -P FragmentPath "

if systemctl list-units --full -all | grep -Fq "ssh.service"; then
    servs="ssh sshd" 
    alias stop-sshd="sudo systemctl stop $servs"
    alias start-sshd="sudo systemctl start $servs"
    alias enable-sshd="sudo systemctl enable $servs"
    alias disable-sshd="sudo systemctl disable $servs"
    alias enable-now-sshd="sudo systemctl enable --now $servs"
    alias disable-now-sshd="sudo systemctl disable --now $servs"
    alias restart-sshd="sudo systemctl restart $servs"  
    alias status-sshd="sudo systemctl status $servs"  
    alias logs-ssh="sudo journalctl -u ssh"  
    unset servs 
fi

if systemctl list-units --full -all | grep -Fq "smb.service"; then
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

if systemctl list-units --full -all | grep -Fq "tor.service"; then
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

if hash docker &> /dev/null; then
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


if hash pipewire &> /dev/null; then
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

if hash fzf &> /dev/null; then
    function systemctl-running-units-fzf() {
        local unit actn now 
        if test -z $1; then
            unit=$(systemctl --no-pager --state running | head -n -6 | tail -n +2 | fzf --multi --ansi| awk '{print $1;}')
        else
            unit=$(systemctl --no-pager --state running | head -n -6 | tail -n +2 | fzf --multi --ansi -q "$@" | awk '{print $1;}')
        fi
        echo $unit 
        reade -Q "GREEN" -i "status stop restart enable disable edit print" -p "What to do? [Status/stop/restart/enable/disable/edit/print]: " actn 
        if ! test -z $actn; then
            if [[ $actn == 'status' ]]; then
                systemctl status $unit 
            elif [[ $actn == 'stop' ]]; then
                systemctl status $unit 
                systemctl stop $unit 
            elif [[ $actn == 'restart' ]]; then
                systemctl restart $unit 
                systemctl status $unit 
            elif [[ $actn == 'enable' ]]; then
                readyn -p "Also start $unit?" now
                if [[ $now == 'y' ]]; then
                    systemctl enable --now $unit 
                    systemctl status $unit 
                else
                    systemctl enable $unit 
                    systemctl status $unit 
                fi
            elif [[ $actn == 'disable' ]]; then
                readyn -n -p "Also stop $unit? " now
                if [[ $now == 'y' ]]; then
                    systemctl disable --now $unit 
                    systemctl status $unit 
                else
                    systemctl disable $unit 
                    systemctl status $unit 
                fi
            elif [[ $actn == 'edit' ]]; then
                 files='' 
                 for un in $unit; do
                     files=$files"/lib/systemd/system/$un " 
                 done
                 $EDITOR $files 
            elif [[ $actn == 'print' ]]; then
                echo "$unit"         
            fi
        fi
    }
fi

system-service-start(){
    sudo systemctl start $@; 
    systemctl status $@;
}


service-start(){
    systemctl --user start $@;
    systemctl --user status $@;
}


alias system-service-stop="sudo systemctl stop "
alias service-stop="systemctl --user stop "

system-service-restart(){
    sudo systemctl restart $@;
    sudo systemctl status $@;
}

service-restart(){
    systemctl --user restart $@;
    systemctl --user status $@;
}


system-service-enable-now(){
    sudo systemctl enable --now $@;
    sudo systemctl status $@;
}


service-enable-now(){
    systemctl --user enable --now $@;
    systemctl --user status $@;
}

alias systemctl-failed='systemctl --failed'
alias systemctl-failed-root='sudo systemctl --failed'
alias service-failed='systemctl --failed'
alias service-failed-system='sudo systemctl --failed'

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

function systemctl-create-systemwide-service(){
    local inpt serv start exec="/bin/bash /home/$USER/my_script.sh"
    reade -Q 'GREEN' -p "Give up a name for the service file: " inpt;
    if [ -z "$inpt" ]; then
        echo "Give up a viable filename please";
        return 1;
    else
        printf "${CYAN}For example: ${GREEN}/bin/bash /home/$USER/my_script.sh\n${normal}" 
        reade -Q 'GREEN' -p "Give up command or (shell)script file: " exec;
        if [ -f $TMPDIR/$inpt ]; then
            command rm $TMPDIR/$inpt  
        fi
        touch $TMPDIR/$inpt;
        echo "[Unit]" >> $TMPDIR/$inpt;
        echo "Description=$inpt service" >> $TMPDIR/$inpt;

        echo "[Service]" >> $TMPDIR/$inpt;
        echo "ExecStart=$exec" >> $TMPDIR/$inpt;

        echo "[Install]" >> $TMPDIR/$inpt;
        echo "WantedBy=multi-user.target" >> $TMPDIR/$inpt;
        
        sudo mv $TMPDIR/$inpt /etc/systemd/system/$inpt.service
        serv="/etc/systemd/system/$inpt.service";
        sudo chmod 644 $serv;
        sudoedit $serv;
        reade -Q 'GREEN' -i 'start enable neither' -p "Start or enable ${CYAN}$serv${GREEN}? [Start/enable/none]: " start
        if [[ "$start" == 'start' ]]; then
            sudo systemctl start $serv;
        elif [[ "$start" == 'enable' ]]; then  
            sudo systemctl enable $serv;
        fi
        sudo systemctl status $serv 
    fi
}

function systemctl-create-user-service(){
    local inpt serv start exec="/bin/bash /home/$USER/my_script.sh"
    reade -Q 'GREEN' -p "Give up a name for the service file: " inpt;
    if [ -z "$inpt" ]; then
        echo "Give up a viable filename please";
        return 1;
    else
        printf "${CYAN}For example: ${GREEN}/bin/bash /home/$USER/my_script.sh\n${normal}" 
        reade -Q 'GREEN' -p "Give up command or (shell)script file: " exec;
        if [ -f $TMPDIR/$inpt ]; then
            command rm $TMPDIR/$inpt  
        fi
        touch $TMPDIR/$inpt;
        echo "[Unit]" >> $TMPDIR/$inpt;
        echo "Description=$inpt service" >> $TMPDIR/$inpt;

        echo "[Service]" >> $TMPDIR/$inpt;
        echo "ExecStart=$exec" >> $TMPDIR/$inpt;

        echo "[Install]" >> $TMPDIR/$inpt;
        echo "WantedBy=default.target" >> $TMPDIR/$inpt;
        
        mv $TMPDIR/$inpt $XDG_DATA_HOME/systemd/system/$inpt.service
        serv="$XDG_DATA_HOME/systemd/system/$inpt.service";
        chmod 644 $serv;
        $EDITOR $serv
        reade -Q 'GREEN' -i 'start enable neither' -p "Start or enable ${CYAN}$serv${GREEN}? [Start/enable/none]: " start
        if [[ "$start" == 'start' ]]; then
            systemctl --user start $serv;
        elif [[ "$start" == 'enable' ]]; then  
            systemctl --user enable $serv;
        fi
        systemctl --user status $serv
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
