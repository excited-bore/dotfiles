# https://pipewire.org/

hash pipewire &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! [[ -f $TOP/checks/check_all.sh ]]; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if [[ "$distro" == "Manjaro" ]]; then
    # Manjaro keeps complaining about this so yeh
    if pamac list --installed jack | grep -q 'jack2'; then
        eval "$pac_rm_y jack2"
    fi
    eval "$pac_ins_y pipewire pipewire-jack wireplumber pipewire-pulse manjaro-pipewire"
elif [[ "$distro_base" == "Arch" ]]; then
    eval "$pac_ins_y pipewire pipewire-jack wireplumber pipewire-pulse"
elif [[ "$distro_base" == "Debian" ]]; then
    eval "$pac_ins_y pipewire pipewire-jack wireplumber pipewire-pulse"
fi 

if ! [[ -f ~/.bash_completion.d/pipewire.bash ]]; then
    readyn -p "Install pipewire completions (pw-cli, wpctl)?" comps
    if [[ $comps == 'y' ]]; then

        if ! [[ -f $TOP/checks/check_completions_dir.sh ]]; then
             source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh) 
        else
            . $TOP/checks/check_completions_dir.sh
        fi
         
        pipewire_cmp=$TOP/cli-tools/pipewire/.bash_completion.d/pipewire.bash
        if ! [[ -f $TOP/pipewire/.bash_completion.d/pipewire.bash ]]; then
            wget-aria-dir $TMPDIR https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pipewire/.bash_completion.d/pipewire.bash 
            pipewire_cmp=$TMPDIR/pipewire.bash
        fi
        cp $pipewire_cmp ~/.bash_completion.d/ 
   
        pipewire_cmpz=$TOP/pipewire/.zsh_completion.d/pipewire.zsh
        if ! [[ -f $TOP/pipewire/.zsh_completion.d/pipewire.zsh ]]; then
            wget-aria-dir $TMPDIR https://raw.githubusercontent.com/excited-bore/dotfiles/main/$TOP/pipewire/.zsh_completion.d/pipewire.zsh 
            pipewire_cmp=$TMPDIR/pipewire.zsh
        fi
        cp $pipewire_cmp ~/.zsh_completion.d/ 
         
    fi
fi

mkdir -p $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/

if wpctl status | grep -q 'HMDI'; then
    readyn -p "Unlist all HDMI audio devices from pipewire?" unlst_hdmi
    if [[ "$unlst_hdmi" == 'y' ]]; then
        hdmi_f="$XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/51-HDMI-disable.conf"  
        touch hdmi_f 
        printf "monitor.alsa.rules = [
  {
    matches = [
    ] 
    actions = {
      update-props = {
         device.disabled = true
      }
    }
  }
]" > $hdmi_f 
        hmis=$(pw-cli info all 2> /dev/null | grep --color=never hdmi | grep node.name | sed 's|.*"alsa_output\(.*\)|alsa_card\1|g' | sed 's|\(.*\)\.hdmi.*|\1|')         
        for i in $hmis; do 
            sed -i 's|\(matches = \[\)|\1\n\t{\n\t  device.name = "'"$i"'"\n\t}|g' $hdmi_f ;         
        done
    fi
fi

#https://bbs.archlinux.org/viewtopic.php?id=271850
# https://wiki.archlinux.org/title/PipeWire#Sound_does_not_automatically_switch_when_connecting_a_new_device
if hash systemctl &> /dev/null && ! [[ -f /etc/systemd/user/pipewire-load-switch-on-connect.service ]]; then
    #printf "${CYAN}You should test first whether sounds autoswitches when connected${normal}\n"
    readyn -p "Create 'USB-audiodevice-autoswitch-on-connect' configuration file?" auto_s
    if [[ $auto_s == 'y' ]]; then
        mkdir -p $XDG_CONFIG_HOME/pipewire/pipewire-pulse.conf.d/
        conf=$XDG_CONFIG_HOME/pipewire/pipewire-pulse.conf.d/switch-on-connect.conf
        if ! [ -e $conf ] || ! grep -q "# override for pipewire-pulse.conf file" $conf; then
            echo "# override for pipewire-pulse.conf file" >> $conf
            echo "pulse.cmd = [" >> $conf
            echo "  { cmd = \"load-module\" args = \"module-always-sink\" flags = [ ] }" >> $conf
            echo "  { cmd = \"load-module\" args = \"module-switch-on-connect\" }" >> $conf
            echo "]" >> $conf
        fi
        systemctl restart --user pipewire-pulse.service 
        if systemctl status --user --no-pager -l pipewire-pulse.service | grep -q 'File exists'; then
            sed -i '/module-always-sink/d' $conf 
            systemctl restart --user pipewire-pulse.service 
        fi
        printf "${GREEN}Added pipewire conf for $USER at:\n${CYAN}$XDG_CONFIG_HOME/pipewire/pipewire-pulse.conf.d\n${normal}" 

    #    reade -Q 'GREEN' -i 'y' -p "Install USB-audio autoswitch on connect for pipewire system-wide? (at /etc/pipewire/pipewire-pulse.conf.d/) [Y/n]: " 'n' auto_s_sys
    #    if test $auto_s_sys == 'y'; then
    #        if ! test -d /etc/pipewire/pipewire-pulse.conf.d/; then
    #            echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for and create /etc/pipewire/pipewire-pulse.conf.d/"
    #            sudo mkdir -p /etc/pipewire/pipewire-pulse.conf.d/
    #        fi
    #        echo "Next $(tput setaf 1)sudo$(tput sgr0) will move $conf to /etc/pipewire/pipewire-pulse.conf.d/"
    #        sudo cp $conf /etc/pipewire/pipewire-pulse.conf.d
    #        printf "${GREEN}Added pipewire conf for all users at:\n${CYAN}/etc/pipewire/pipewire-pulse.conf.d\n${normal}" 
    #    fi

    #    echo "${green}Installing systemd service${normal}" 
    #    mkdir -p $XDG_CONFIG_HOME/systemd/user/
    #    serv="pipewire-load-switch-on-connect"
    #    servF="$serv.service"
    #    myuser="$USER"
    #    servFile=/etc/systemd/user/$serv.service;
    #    touch $servF
    #    echo "[Unit]" >> $servF;
    #    echo "Description=$serv service." >> $servF;

    #    echo "[Service]" >> $servF;
    #    echo "ExecStart=sudo -u $myuser env XDG_RUNTIME_DIR=/run/user/$(id -u $myuser) /usr/bin/pactl load-module module-switch-on-connect" >> $servF;

    #    echo "[Install]" >> $servF;
    #    echo "WantedBy=default.target" >> $servF;

    #    sudo mv -f $servF $servFile
    #    systemctl --user enable --now $servFile

    #    #if ! sudo grep -q "load-module module-switch-on-connect" /etc/pulse/default.pa; then
    #    #    sudo sed -i "s,\(load-module module-switch-on-port-available\),\1\nload-module module-switch-on-connect,g" /etc/pulse/default.pa
    #    #fi
    #    #printf "Added pipewire conf at:\n$XDG_CONFIG_HOME/pipewire/pipewire-pulse.conf.d\n/etc/pipewire/pipewire.conf.d/\n$servFile\n"
    #    #printf "Added pipewire conf at: \n$XDG_CONFIG_HOME/pipewire/pipewire-pulse.conf.d\n /etc/pipewire/pipewire.conf.d/\n $servFile\n /etc/pulse/default.pa\n"
    fi 
fi

if ! [[ -f $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/51-dualshock4-disable.conf ]]; then
    mkdir -p $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/
    readyn -p "Unlist dualshock 4 audio sources from pipewire? (prevents usb-autoconnect from triggering)" ds4
    if [[ "y" == $ds4 || "Y" == $ds4 ]]; then
        touch $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/51-dualshock4-disable.conf   
        printf "monitor.alsa.rules = [
  {
    matches = [
      { 
        device.name = \"~alsa_card.usb-Sony_Interactive_Entertainment_Wireless_Controller-*\" 
      }
    ] 
    actions = {
      update-props = {
         device.disabled = true
      }
    }
  }
]" > $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/51-dualshock4-disable.conf
    fi
fi

if ! [[ -f $XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/51-disable-suspension.conf ]]; then
    printf "${yellow}Noticeable audio delay or audible pop/crack when starting playback can be caused by ${YELLOW}'node suspension when inactive'\n${normal}"
    printf "${RED}This might also break more then it helps\n${normal}"
    readyn -n -p "Disable node suspension when inactive?" dis_node
    if [[ "$dis_node" == 'y' ]]; then
        dis_node_f="$XDG_CONFIG_HOME/wireplumber/wireplumber.conf.d/51-disable-suspension.conf"  
        touch dis_node_f 
        printf "monitor.alsa.rules = [
  {
    matches = [
      {
        # Matches all sources
        node.name = \"~alsa_input.*\"
      },
      {
        # Matches all sinks
        node.name = \"~alsa_output.*\"
      }
    ]
    actions = {
      update-props = {
        session.suspend-timeout-seconds = 0
      }
    }
  }
]
# bluetooth devices
monitor.bluez.rules = [
  {
    matches = [
      {
        # Matches all sources
        node.name = \"~bluez_input.*\"
      },
      {
        # Matches all sinks
        node.name = \"~bluez_output.*\"
      }
    ]
    actions = {
      update-props = {
        session.suspend-timeout-seconds = 0
      }
    }
  }
]" > $dis_node_f 
    fi 
fi


if ! hash qwpgraph &> /dev/null; then
    readyn -p "Install patchbay interface 'qpwgraph'? (create and manage audiostreams)" -c "! hash patchbay &> /dev/null" patchb
    if [[ "$patchb" == 'y' ]]; then
        if [[ "$distro_base" == 'Arch' ]] || [[ "$distro_base" == 'Debian' ]]; then
            eval "${pac_ins_y} qpwgraph"
        fi
    fi
    unset patchb 
fi

if ! hash easyeffects &> /dev/null; then
    readyn -p "Install sound effect configurator 'easyeffects'? (Enable/disable audio effects on audiostreams)" ezff
    if [[ "$ezff" == 'y' ]]; then
        if [[ "$distro_base" == 'Arch' || "$distro_base" == 'Debian' ]]; then
            eval "${pac_ins_y} easyeffects"
        fi
    fi
    unset ezff 
fi

file=$TOP/cli-tools/pipewire/.aliases.d/pipewire.sh
if ! [[ -f $file ]]; then
    tmpd=$(mktemp -d)
    wget-aria-dir $tmpd https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pipewire/.aliases.d/pipewire.sh
    file=$tmpd/pipewire.sh
fi

pipewire_r(){ 
    sudo cp $file /root/.aliases.d/; 
}

pipewiresh(){
    cp $file ~/.aliases.d/;
    yes-edit-no -Y 'YELLOW' -f pipewire_r -g "$file" -p "Install pipewire aliases at /root/.aliases.d/?"
}
yes-edit-no -f pipewiresh -g "$file" -p "Install pipewire aliases at ~/.aliases.d/?"


if hash systemctl &> /dev/null; then
    readyn -p 'Restart pipewire user service(s)?' rs_pwr
    if [[ "$rs_pwr" == 'y' ]]; then
       systemctl restart --user wireplumber pipewire pipewire-pulse 
       systemctl status --user wireplumber pipewire pipewire-pulse 
    fi
fi
