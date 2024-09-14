#!/bin/bash

#https://bbs.archlinux.org/viewtopic.php?id=271850
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi 


if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    reade -Q "CYAN" -i "n" -p "Update system? [Y/n]: " "y" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if [ "$distro" == "Manjaro" ]; then
    eval "$pac_ins pipewire pipewire-jack wireplumber pipewire-pulse manjaro-pipewire"
elif [ "$distro_base" == "Arch" ]; then
    eval "$pac_ins pipewire pipewire-jack wireplumber pipewire-pulse"
elif [ "$distro_base" == "Debian" ]; then
    eval "$pac_ins pipewire pipewire-pulse pipewire-jack wireplumber"
fi 

if ! test -f ~/.bash_completion.d/pipewire; then
 
    reade -Q 'GREEN' -i 'y' -p "Install pipewire completions (pw-cli, wpctl)? [Y/n]: " 'n' comps
    if test $comps == 'y'; then

        if ! test -f checks/check_completions_dir.sh; then
             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
        else
            . ./checks/check_completions_dir.sh
        fi
         
        pipewire_cmp=pipewire/.bash_completion.d/pipewire
        if ! test -f pipewire/.bash_completion.d/pipewire; then
            tmp1=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/pipewire/.bash_completion.d/pipewire 
            pipewire_cmp=$tmp1
        fi

        cp -fv $pipewire_cmp ~/.bash_completion.d/ 

    fi
fi


if echo $(wpctl status) | grep -q 'HMDI'; then
    mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
    reade -Q 'GREEN' -i 'y' -p "Unlist all HDMI audio devices from pipewire? [Y/n]: " 'n' unlst_hdmi
    if test $unlst_hdmi == 'y'; then
        hdmi_f="$HOME/.config/wireplumber/wireplumber.conf.d/51-HDMI-disable.conf"  
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
            sed -i 's|\(matches = \[\)|\1\n\t{\n\t  device.name = '"$i"'\n\t}|g' $hdmi_f ;         
        done
    fi
fi

if type systemctl &> /dev/null && ! test -f /etc/systemd/user/pipewire-load-switch-on-connect.service; then
    reade -Q 'GREEN' -i 'y' -p "Set USB-audiodevices to autoswitch when connected? [Y/n]: " 'n' auto_s
    if test $auto_s == 'y'; then
        mkdir -p ~/.config/pipewire/pipewire-pulse.conf.d/
        conf=~/.config/pipewire/pipewire-pulse.conf.d/switch-on-connect.conf
        if [ ! -e $conf ] || ! grep -q "# override for pipewire-pulse.conf file" $conf; then
            echo "# override for pipewire-pulse.conf file" >> $conf
            echo "pulse.cmd = [" >> $conf
            echo "  { cmd = \"load-module\" args = \"module-always-sink\" flags = [ ] }" >> $conf
            echo "  { cmd = \"load-module\" args = \"module-switch-on-connect\" }" >> $conf
            echo "]" >> $conf
        fi

        printf "${GREEN}Added pipewire conf for $USER at:\n${CYAN}$HOME/.config/pipewire/pipewire-pulse.conf.d\n${normal}" 

        reade -Q 'GREEN' -i 'y' -p "Install USB-audio autoswitch on connect for pipewire system-wide? (at /etc/pipewire/pipewire-pulse.conf.d/) [Y/n]: " 'n' auto_s_sys
        if test $auto_s_sys == 'y'; then
            if ! test -d /etc/pipewire/pipewire-pulse.conf.d/; then
                echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for and create /etc/pipewire/pipewire-pulse.conf.d/"
                sudo mkdir -p /etc/pipewire/pipewire-pulse.conf.d/
            fi
            echo "Next $(tput setaf 1)sudo$(tput sgr0) will move $conf to /etc/pipewire/pipewire-pulse.conf.d/"
            sudo cp -vf $conf /etc/pipewire/pipewire-pulse.conf.d
            printf "${GREEN}Added pipewire conf for all users at:\n${CYAN}/etc/pipewire/pipewire-pulse.conf.d\n${normal}" 
        fi

        echo "${green}Installing systemd service${normal}" 
        mkdir -p ~/.config/systemd/user/
        serv="pipewire-load-switch-on-connect"
        servF="$serv.service"
        myuser="$USER"
        servFile=/etc/systemd/user/$serv.service;
        touch $servF
        echo "[Unit]" >> $servF;
        echo "Description=$serv service." >> $servF;

        echo "[Service]" >> $servF;
        echo "ExecStart=sudo -u $myuser env XDG_RUNTIME_DIR=/run/user/$(id -u $myuser) /usr/bin/pactl load-module module-switch-on-connect" >> $servF;

        echo "[Install]" >> $servF;
        echo "WantedBy=default.target" >> $servF;

        sudo mv -f $servF $servFile
        systemctl --user enable --now $servFile

        #if ! sudo grep -q "load-module module-switch-on-connect" /etc/pulse/default.pa; then
        #    sudo sed -i "s,\(load-module module-switch-on-port-available\),\1\nload-module module-switch-on-connect,g" /etc/pulse/default.pa
        #fi
        #printf "Added pipewire conf at:\n~/.config/pipewire/pipewire-pulse.conf.d\n/etc/pipewire/pipewire.conf.d/\n$servFile\n"
        #printf "Added pipewire conf at: \n~/.config/pipewire/pipewire-pulse.conf.d\n /etc/pipewire/pipewire.conf.d/\n $servFile\n /etc/pulse/default.pa\n"
    fi 
fi

if ! test -f $HOME/.config/wireplumber/wireplumber.conf.d/51-dualshock4-disable.conf; then
    mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
    reade -Q 'GREEN' -i 'y' -p "Unlist dualshock 4 audio sources from pipewire? (prevents usb-autoconnect from triggering) [Y/n]: " 'n' ds4
    if [ -z $ds4 ] || [ "y" == $ds4 ] || [ "y" == $ds4 ]; then
        touch $HOME/.config/wireplumber/wireplumber.conf.d/51-dualshock4-disable.conf   
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
]" > $HOME/.config/wireplumber/wireplumber.conf.d/51-dualshock4-disable.conf
    fi
fi

if type systemctl &> /dev/null; then
    reade -Q 'GREEN' -i 'y' -p 'Restart pipewire service? [Y/n]: ' 'n' rs_pwr
    if test $rs_pwr == 'y'; then
       systemctl restart --user pipewire 
    fi
fi
