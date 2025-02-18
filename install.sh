#!/bin/bash

export INSTALL=1 

if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
    if type curl &> /dev/null; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
    else 
        continue 
    fi
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! test -f rlwrap-scripts/reade; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/reade)" &> /dev/null 
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/rlwrap-scripts/readyn)" &> /dev/null 
else
    . ./rlwrap-scripts/reade &> /dev/null
    . ./rlwrap-scripts/readyn &> /dev/null
fi


if ! test -f checks/check_system.sh; then
    if type curl &> /dev/null; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
    else 
        continue 
    fi
else
    . ./checks/check_system.sh
fi


if ! test -f checks/check_envvar.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    else
        export SYSTEM_UPDATED="TRUE"
    fi
fi

if ! type rlwrap &>/dev/null; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_rlwrap.sh)" 
else
    . ./checks/check_rlwrap.sh
fi

#readyn -p "Install reade and readyn?" -c 'test -f /usr/bin/reade' insrde
#if test $insrde == 'y'; then
#    if ! test -f install_reade_readyn.sh; then
#         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_reade_readyn.sh)" 
#    else
#        ./install_reade_readyn.sh
#    fi
#fi
#unset insrde



printf "${green}If all necessary files are sourced correctly, this text looks green.\nIf not, something went wrong.\n"
if type gio &> /dev/null; then
    printf "\n${green}Files that get overwritten get backed up and trashed (to prevent clutter).\nRecover using ${cyan}'gio trash --list'${green} and ${cyan}'gio trash --restore' ${normal}\n"
fi
printf "${green} Will now start with updating system ${normal}\n"


if [ ! -e ~/config ] && test -d ~/.config; then
    readyn -Y "BLUE" -p "Create ~/.config to ~/config symlink? " sym1
    if [ -z $sym1 ] || [ "y" == $sym1 ]; then
        ln -s ~/.config ~/config
    fi
fi

if [ ! -e ~/lib_systemd ] && test -d ~/lib/systemd/system; then
    readyn -Y "BLUE" -p "Create /lib/systemd/system/ to user directory symlink? " sym2
    if [ -z $sym2 ] || [ "y" == $sym2 ]; then
        ln -s /lib/systemd/system/ ~/lib_systemd
    fi
fi

if [ ! -e ~/etc_systemd ] && test -d ~/etc/systemd/system; then
    readyn -Y "BLUE" -p "Create /etc/systemd/system/ to user directory symlink? " sym3
    if [ -z $sym3 ] || [ "y" == $sym3 ]; then
        ln -s /etc/systemd/system/ ~/etc_systemd
    fi
fi

if test -d /etc/modprobe.d && [ ! -f /etc/modprobe.d/nobeep.conf ]; then
    readyn -p "Remove terminal beep? (blacklist pcspkr)" beep
    if [ "$beep" == "y" ] || [ -z "$beep" ]; then
        echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf
    fi
fi

unset sym1 sym2 sym3 beep

# Environment variables

if ! test -f $HOME/.environment.env; then
    if ! test -f install_envvars.sh; then
        tmp=$(mktemp) && wget -O $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_envvars.sh
        ./$tmp 'n' 
    else
        ./install_envvars.sh 'n'  
    fi 
fi

# Appimagelauncher

if ! type AppImageLauncher &> /dev/null; then
    printf "${GREEN}If you want to install applications using appimages, there is a helper called 'appimagelauncher'\n"
     readyn -p "Check if appimage ready and install appimagelauncher?" appimage_install
     if test $appimage_install == 'y'; then
         if ! test -f ./install_appimagelauncher.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_appimagelauncher.sh)" 
         else
            ./install_appimagelauncher.sh
         fi
     fi
fi


# Flatpak

#if ! type flatpak &> /dev/null; then
   #printf "%s\n" "${blue}No flatpak detected. (Independent package manager from Red Hat)${normal}"
   readyn -p "Install (or just configure) Flatpak?" insflpk 
   if [ "y" == "$insflpk" ]; then
       if ! test -f install_flatpak.sh; then
           eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)" 
       else
           ./install_flatpak.sh 
       fi 
   fi
#fi
unset insflpk

if ! type snap &> /dev/null; then
    printf "%s\n" "${blue}No snap detected. (Independent package manager from Canonical)${normal}"
    readyn -Y "MAGENTA" -p "Install snap?" -n inssnap 
    if [ "y" == "$inssnap" ]; then
        if ! test -f install_snapd.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_snapd.sh)" 
        else
            ./install_snapd.sh 
        fi 
    fi
fi
unset inssnap

if test -z "$(eval "$pac_ls_ins groff 2> /dev/null")"; then
    printf "${CYAN}groff${normal} is not installed (Necessary for 'man' (manual) command)\n"
    readyn -p "Install groff? " groff_ins
    if test $groff_ins == 'y'; then
        eval "yes | $pac_ins groff"
        printf "Logout and login (or reboot) to take effect\n" 
    fi
    unset groff_ins 
fi


if test $distro_base == 'Debian'; then

     if test -z "$(${pac_ls_ins} manpages-posix 2> /dev/null)"; then
        printf "${CYAN}manpages-posix${normal} is not installed (Manpages for posix-compliant (f.ex. bash) commands (f.ex. alias, test, type, etc...))\n"
        readyn -p "Install manpages-posix? " posixman_ins
        if test $posixman_ins == 'y'; then
            eval "yes | $pac_ins manpages-posix -y"
        fi
        unset posixman_ins 
     fi

     if test -z "$(apt list --installed software-properties-common 2> /dev/null | awk 'NR>1{print;}')"|| test -z "$(apt list --installed python3-launchpadlib 2> /dev/null | awk 'NR>1{print;}')"; then
        if test -z "$(apt list --installed software-properties-common 2> /dev/null | awk 'NR>1{print;}')"; then 
            printf "${CYAN}add-apt-repository${normal} is not installed (cmd tool for installing extra repositories/ppas on debian systems)\n"
            readyn -p "Install add-apt-repository? " add_apt_ins
            if test $add_apt_ins == 'y'; then
                eval "yes | $pac_ins software-properties-common"
            fi
            unset add_apt_ins 
        fi 

        if test -z "$(apt list --installed python3-launchpadlib 2> /dev/null | awk 'NR>1{print;}')"; then
            printf "${CYAN}python3-launchpadlib${normal} is not installed (python3 library that adds support for ppas from Ubuntu's 'https://launchpad.net' to add-apt-repository)\n"
            readyn -p "Install python3-launchpadlib? " lpdlb_ins
            if test $lpdlb_ins == 'y'; then
                eval "yes | $pac_ins python3-launchpadlib"
            fi
            unset lpdlb_ins 
             
        fi 
    fi

    if type add-apt-repository &> /dev/null; then
        if ! test -f install_list-ppa.sh; then
                eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_list-ppa.sh)" 
        else
            ./install_list-ppa.sh
        fi

        if ! type ppa-purge &> /dev/null && ! test -z "$(apt search ppa-purge 2> /dev/null | awk 'NR>2{print;}')"; then
            printf "${CYAN}ppa-purge${normal} is not installed (cmd tool for disabling installed PPA's)\n"
            readyn -p "Install ppa-purge? " ppa_ins
            if test $ppa_ins == 'y'; then
                eval "yes | $pac_ins ppa-purge"
            fi
            unset ppa_ins 
        fi
    fi 

    if ! type nala &> /dev/null && ! test -z "$(apt search nala 2> /dev/null | awk 'NR>2{print;}')"; then
        printf "${CYAN}nala${normal} is not installed (A TUI wrapper for apt install, update, upgrade, search, etc..)\n"
        readyn -p "Install nala? " nala_ins
        if test $nala_ins == 'y'; then
            eval "$pac_ins nala"
            pac="nala"
            pac_ins="sudo nala install"
            pac_up="sudo nala update" 
        fi
        unset nala_ins 
    fi
         
    if test $distro == "Ubuntu"; then 
        if ! type synaptic &> /dev/null; then
            printf "${CYAN}synaptic${normal} is not installed (Better GUI for package management)\n"
            readyn -p "Install synaptic? " ins_curl
            if test $ins_curl == 'y'; then
                ${pac_ins} synaptic -y
            fi
            unset ins_curl
        fi
    fi 

elif test $distro_base == 'Arch'; then

    if test -z "$(pacman -Q pacman-contrib)"; then
        printf "${CYAN}pacman-contrib${normal} is not installed (Includes tools like pactree, pacsearch, pacdiff..)\n" 
        readyn -p 'Install pacman-contrib package?' -n 'type pactree &> /dev/null' pacmn_cntr
        if test $pacmn_cntr == 'y'; then
            sudo pacman -Su pacman-contrib
        fi
    fi
    unset pacmn_cntr
   
    if ! type yay &> /dev/null; then
        printf "${CYAN}yay${normal} is not installed (Pacman wrapper for installing AUR packages, needed for yay-fzf-install)\n"
        readyn -p "Install yay?" insyay
        if [ "y" == "$insyay" ]; then 
            if type curl &> /dev/null && ! test -f ../AUR_installers/install_yay.sh; then
                eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_yay.sh)" 
            else
                eval ../AUR_installers/install_yay.sh
            fi
            AUR_pac="yay"
            AUR_up="yay -Syu"
            AUR_ins="yay -S"
            AUR_search="yay -Ss"
            AUR_ls_ins="yay -Q"
        fi
        unset insyay
    fi


    if ! test -z "$AUR_ls_ins" && test -z "$(${AUR_ls_ins} pacseek 2> /dev/null)"; then
        printf "${CYAN}pacseek${normal} (A TUI for managing packages from pacman and AUR) is not installed\n"
        readyn -p "Install pacseek? " pacs_ins
        if test $pacs_ins == 'y'; then
            yes | ${AUR_ins} pacseek
        fi
        unset pacs_ins 
    fi 
fi


if ! sudo test -f /etc/polkit/49-nopasswd_global.pkla && ! sudo test -f /etc/polkit-1/rules.d/90-nopasswd_global.rules; then
    readyn -Y "YELLOW" -p "Install polkit files for automatic authentication for passwords? " plkit
    if [ "y" == "$plkit" ]; then
        if ! test -f install_polkit_wheel.sh; then
            eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_polkit_wheel.sh)" 
        else
            ./install_polkit_wheel.sh
        fi 
    fi
    unset plkit
fi

if ! test -f checks/check_envvar.sh; then
    eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)" 
else
    . ./checks/check_envvar.sh
fi

if ! test -f checks/check_completions_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
    . ./checks/check_completions_dir.sh
fi

# Ack prompt

readyn -p "Install Ack? (A modern replacement for grep - finds lines in shell output)" -n -c "type ack &> /dev/null" ack

if [ "y" == "$ack" ]; then
    if ! test -f install_ack.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ack.sh)" 
    else
        ./install_ack.sh
    fi 
fi
unset ack

# Hhighlighter (or just h)

readyn -n -c "type h &> /dev/null" -p "Install Hhighlighter (or just h)? (A tiny utility to highlight multiple keywords with different colors in a textoutput)" h
if [ "y" == "$h" ]; then
    if ! type ack &> /dev/null; then
        printf "For ${CYAN}Hhighlighter${normal} to work, ${CYAN}ack${normal} needs to be installed first." 
        readyn -p "Install Ack and then hhighlighter?" ansr 
        if test "$ansr" == 'y'; then
            continue 
        else
            break
        fi
        unset ansr 
    fi
    if ! test -f install_hhighlighter.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_hhighlighter.sh)" 
    else
        ./install_hhighlighter.sh
    fi 
fi
unset h




# Eza prompt

readyn -p "Install Eza? (A modern replacement for ls)" -n -c "type eza &> /dev/null" rmp

if [ -z "$rmp" ] || [ "y" == "$rmp" ]; then
    if ! test -f install_eza.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_eza.sh)" 
    else
        ./install_eza.sh
    fi 
fi
unset rmp

# Xcp

readyn -p "Install xcp? (cp but faster and with progress bar)" -n -c "type xcp &> /dev/null" rmp

if [ -z "$rmp" ] || [ "y" == "$rmp" ]; then
    if ! test -f install_xcp.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_xcp.sh)" 
    else
        ./install_xcp.sh
    fi 
fi
unset rmp



# Rm prompt

readyn -p "Install rm-prompt? (Rm but lists files/directories before deletion)" -n -c "type rm-prompt &> /dev/null" rmp

if [ -z "$rmp" ] || [ "y" == "$rmp" ]; then
    if ! test -f install_rmprompt.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_rmprompt.sh)" 
    else
        ./install_rmprompt.sh
    fi 
fi

unset rmp

# Bash alias completions
# v

readyn -p "Install bash completions for aliases in ~/.bash_completion.d?" -n "! test -f ~/.bash_completion.d/complete_alias || ! test -f /root/.bash_completion.d/complete_alias" compl
if [ -z "$compl" ] || [ "y" == "$compl" ]; then
    if ! test -f install_bashalias_completions.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashalias_completions.sh)" 
    else
        ./install_bashalias_completions.sh
    fi 
fi
unset compl

# Python completions

readyn -p "Install python completions in ~/.bash_completion.d?" -n "! type activate-global-python-argcomplete &> /dev/null" pycomp
if [ -z $pycomp ] || [ "y" == $pycomp ]; then
    if ! test -f install_python_completions.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_python_completions.sh)" 
    else
        ./install_python_completions.sh
    fi
fi
unset pycomp

readyn -p "Install bash aliases and other config?" scripts
if [ -z $scripts ] || [ "y" == $scripts ]; then

    if ! test -f checks/check_aliases_dir.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)" 
    else
        ./checks/check_aliases_dir.sh
    fi
    if ! test -f install_aliases.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/install_aliases.sh)" 
    els
        ./install_aliases.sh
    fi
fi
source ~/.bashrc



# Shell-keybinds

binds=keybinds/.inputrc
binds1=keybinds/.keybinds.d/keybinds.bash
binds2=keybinds/.keybinds
if ! test -f $binds; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.inputrc
    tmp1=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds.d/keybinds.bash 
    tmp2=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/keybinds/.keybinds 
    binds=$tmp
    binds1=$tmp1
    binds2=$tmp2
fi

if ! test -f /etc/inputrc; then
    sed -i 's/^$include \/etc\/inputrc/#$include \/etc\/inputrc/g' $binds
fi

shell-keybinds_r(){ 
    if [ -f /root/.environment.env ]; then
       sudo sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' /root/.environment.env
    fi
    sudo cp -fv $binds1 /root/.keybinds.d/;
    sudo cp -fv $binds2 /root/.keybinds
    sudo cp -fv $binds /root/;
    if sudo test -f /root/.bashrc && ! sudo grep -q '[ -f /root/.keybinds ]' /root/.bashrc; then
         if grep -q '[ -f /root/.bash_aliases ]' /root/.bashrc; then
               sed -i 's|\(\[ -f \/root/.bash_aliases \] \&\& source \/root/.bash_aliases\)|\1\n\[ -f \/root/.keybinds \] \&\& source \/root/.keybinds\n|g' /root/.bashrc
         else
               printf '[ -f ~/.keybinds ] && source ~/.keybinds' | sudo tee -a /root/.bashrc &> /dev/null
         fi
    fi
    # X based settings is generally not for root and will throw errors 
    if sudo grep -q '^setxkbmap' /root/.keybinds.d/keybinds.bash; then
        sudo sed -i 's|setxkbmap|#setxkbmap|g' /root/.keybinds.d/keybinds.bash
    fi
}

shell-keybinds() {
    if ! test -f ./checks/check_keybinds.sh; then
         eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_keybinds.sh)" 
    else
        . ./checks/check_keybinds.sh
    fi
   
    printf "${cyan}You can always switch between vi/emacs mode with ${CYAN}Ctrl-o${normal}\n"
     
    readyn -Y "YELLOW" -p "Startup in vi-mode instead of emacs mode? (might cause issues with pasteing)" vimde

    sed -i "s|^set editing-mode .*|#set editing-mode vi|g" $binds

    if [ "$vimde" == "y" ]; then
        sed -i "s|.set editing-mode .*|set editing-mode vi|g" $binds
    fi
   
    sed -i "s|^set show-mode-in-prompt .*|#set show-mode-in-prompt on|g" $binds
     
    readyn -p "Enable visual que for vi/emacs toggle? (Displayed as '(ins)/(cmd) - (emacs)')" vivisual
    if [ "$vivisual" == "y" ]; then
        sed -i "s|.set show-mode-in-prompt .*|set show-mode-in-prompt on|g" $binds
    fi

    sed -i "s|^setxkbmap |#setxkbmap |g" $binds
     
    if test $X11_WAY == 'x11'; then 
        readyn -p "Set caps to escape? (Might cause X11 errors with SSH)" xtrm
        if [ "$xtrm" = "y" ]; then
            sed -i "s|#setxkbmap |setxkbmap |g" $binds
        fi
    fi 

    cp -fv $binds1 ~/.keybinds.d/
    cp -fv $binds2 ~/.keybinds 
    cp -fv $binds ~/

    if test -f ~/.bashrc && ! grep -q '\[ -f ~/.keybinds \]' ~/.bashrc; then
         if grep -q '\[ -f ~/.bash_aliases \]' ~/.bashrc; then
                sed -i 's|\(\[ -f \~/.bash_aliases \] \&\& source \~/.bash_aliases\)|\1\n\n\[ -f \~/.keybinds \] \&\& source \~/.keybinds\n|g' ~/.bashrc
         else
                echo '[ -f ~/.keybinds ] && source ~/.keybinds' >> ~/.bashrc
         fi
    fi
    
    if [ -f ~/.environment.env ]; then
       sed -i 's|#export INPUTRC.*|export INPUTRC=~/.inputrc|g' ~/.environment.env
    fi
    unset vimde vivisual xterm
    yes_edit_no shell-keybinds_r "$binds $binds2 $binds1" "Install .inputrc and keybinds.bash at /root/ and /root/.keybinds.d/?" "yes" "YELLOW"; 
}
yes_edit_no shell-keybinds "$binds $binds2 $binds1" "Install .inputrc and keybinds.bash at ~/ and ~/.keybinds.d/? (keybinds configuration)" "yes" "GREEN"

# Xresources

xterm=xterm/.Xresources
if ! test -f xterm/.Xresources; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/xterm/.Xresources
    xterm=$tmp
fi

xresources_r(){
    sudo cp -fv $xterm /root/.Xresources;
    }
xresources() {
    cp -fv $xterm ~/.Xresources;
    yes_edit_no xresources_r "$xterm" "Install .Xresources at /root/?" "edit" "RED"; }
yes_edit_no xresources "$xterm" "Install .Xresources at ~/? (Xterm configuration)" "edit" "YELLOW"

# Bash Preexec
readyn -p "Install pre-execution hooks for bash in ~/.bash_preexec?" -n "! test -f ~/.bash_preexec || ! test -f /root/.bash_preexec" bash_preexec
if [ -z "$bash_preexec" ] || [ "y" == "$bash_preexec" ]; then
    if ! test -f install_bash_preexec.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bash_preexec.sh)" 
    else
        ./install_bash_preexec.sh
    fi 
fi
unset bash_preexec

# Bash Preexec
readyn -p "Install pre-execution hooks for bash in ~/.bash_preexec?" -n "! test -f ~/.bash_preexec || ! test -f /root/.bash_preexec" bash_preexec
if [ -z "$bash_preexec" ] || [ "y" == "$bash_preexec" ]; then
    if ! test -f install_bash_preexec.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bash_preexec.sh)" 
    else
        ./install_bash_preexec.sh
    fi 
fi
unset bash_preexec

# Pipewire (better sound)
readyn -p "Install and configure pipewire? (sound system - pulseaudio replacement)" -n 'type wireplumber &> /dev/null && test -f ~/.config/pipewire/pipewire-pulse.conf.d/switch-on-connect.conf;' pipew
if [ $pipew == "y" ]; then
    if ! test -f install_pipewire.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipewire.sh)" 
    else
        ./install_pipewire.sh 
    fi
fi
unset pipew

# Moar (Custom pager instead of less)

readyn -p "Install moar? (Custom pager/less replacement - awesome default options)" -n 'type moar &> /dev/null;' moar

if [ -z $moar ] || [ "Y" == $moar ] || [ $moar == "y" ]; then
    if ! test -f install_moar.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_moar.sh)" 
    else
        ./install_moar.sh 
    fi
fi
unset moar



# Nano (Editor)

readyn -p "Install nano + config? (Simple terminal editor)" -n -c "type nano &> /dev/null && test -f ~/.nanorc &> /dev/null" nno

if [ "y" == "$nno" ]; then
    if ! test -f install_nano.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nano.sh)" 
    else
        ./install_nano.sh
    fi
fi
unset nno


# Nvim (Editor)

readyn -p "Install neovim + config? (Complex terminal editor)" -n -c "type nvim &> /dev/null" nvm

if [ "y" == "$nvm" ]; then
    if ! test -f install_nvim.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nvim.sh)" 
    else
        ./install_nvim.sh
    fi
fi
unset nvm


# Kitty (Terminal emulator)

readyn -p "Install Kitty? (Terminal emulator)" -n -c "type kitty &> /dev/null" kittn

if [ "y" == "$kittn" ]; then
    if ! test -f install_kitty.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_kitty.sh)" 
    else
        ./install_kitty.sh
    fi
fi
unset kittn


# Fzf (Fuzzy Finder)
 
readyn -p "Install fzf? (Fuzzy file/folder finder - keybinding yes for upgraded Ctrl-R/reverse-search, fzf filenames on Ctrl+T and fzf-version of 'cd' on Alt-C + Custom script: Ctrl-f becomes system-wide file opener)" -n -c "type fzf &> /dev/null" findr

if [ "y" == "$findr" ]; then
    if ! test -f install_fzf.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fzf.sh)" 
    else
        ./install_fzf.sh
    fi
fi
unset findr



# Rg (ripgrep)

readyn -p "Install ripgrep? (recursively searches the current directory for lines matching a regex pattern)" -c "type rg &> /dev/null" rgrp
if [ "y" == "$rgrp" ]; then
    if ! test -f install_ripgrep.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ripgrep.sh)" 
    else
        ./install_ripgrep.sh
    fi
fi
unset rgrp


# Ast-grep (ast-grep)

readyn -p "Install ast-grep? (Search and Rewrite code at large scale using precise AST pattern)" -c "type ast-grep &> /dev/null" rgrp
if [ "y" == "$rgrp" ]; then
    if ! test -f install_ast-grep.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ast-grep.sh)" 
    else
        ./install_ast-grep.sh
    fi
fi
unset rgrp


# Git

readyn -p "Install Git and configure? (Project managing tool)" -n -c "type git &> /dev/null && test -f ~/.gitconfig" git_ins

if [ "y" == "$git_ins" ]; then
    if ! test -f install_git.sh; then
        ins_git=$(mktemp)
        curl -o $ins_git https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_git.sh   
        chmod u+x "$ins_git"
        eval "$ins_git" 'global'
    else
        ./install_git.sh 'global'
    fi
fi
unset git_ins

# Lazygit

readyn -p "Install lazygit?" -n -c "type lazygit &> /dev/null" git_ins

if [ "y" == "$git_ins" ]; then
    if ! test -f install_lazygit.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_lazygit.sh)" 
    else
        ./install_lazygit.sh
    fi
fi
unset git_ins

# Osc
#readyn -p "Install Osc52 clipboard? (Universal clipboard tool / works natively over ssh)" osc
#if [ -z $osc ] || [ "Y" == $osc ] || [ $osc == "y" ]; then
#    ./install_osc.sh 
#fi
#unset osc


# Ranger (File explorer)

readyn -p "Install Ranger? (Terminal file explorer)" -n -c "type ranger &> /dev/null" rngr

if [ "y" == "$rngr" ]; then
    if ! test -f install_ranger.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ranger.sh)" 
    else
        ./install_ranger.sh
    fi
fi
unset rngr

# Tmux (File explorer)

readyn -p "Install Tmux? (Terminal multiplexer)" -n -c "type tmux &> /dev/null" tmx

if [ "y" == "$tmx" ]; then
    if ! test -f install_tmux.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_tmux.sh)" 
    else
        ./install_tmux.sh
    fi
fi
unset tmx

# Bat

readyn -p "Install Bat? (Cat clone with syntax highlighting)" -n -c "type bat &> /dev/null || type batcat &> /dev/null" bat

if [ -z $bat ] || [ "Y" == $bat ] || [ $bat == "y" ]; then
    if ! test -f install_bat.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)" 
    else
        ./install_bat.sh 
    fi
fi
unset bat 


# Neofetch 

readyn -p "Install neofetch/fastfetch/screenFetch)? (Terminal taskmanager - system information tool)" -n -c "type neofetch &> /dev/null || type fastfetch &> /dev/null || type screenfetch &> /dev/null" tojump

if [ "$tojump" == "y" ]; then
    if ! test -f install_neofetch_onefetch.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_neofetch_onefetch.sh)" 
    else
        ./install_neofetch_onefetch.sh
    fi
fi
unset tojump  


# Btop

readyn -p "Install Btop? (A processmanager with a fastly improved TUI relative to top/htop written in C++)" -n -c "type btop &> /dev/null" tojump
if [ "$tojump" == "y" ]; then
    if ! test -f install_btop.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_btop.sh)" 
    else
        ./install_btop.sh
    fi
fi
unset tojump


# Autojump

readyn -p "Install autojump? (jump to folders using 'bookmarks' - j_ )" -n -c "type autojump &> /dev/null" tojump
if [ "$tojump" == "y" ]; then
    if ! test -f install_autojump.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_autojump.sh)" 
    else
        ./install_autojump.sh
    fi
fi
unset tojump

# Zoxide 

readyn -p "Install zoxide? (A cd that guesses the right path based on a history)" -n -c "type zoxide &> /dev/null" zoxs
if [ "$zoxs" == "y" ]; then
    if ! test -f install_zoxide.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_zoxide.sh)" 
    else
        ./install_zoxide.sh
    fi
fi
unset zoxs


# Starship

readyn -p "Install Starship? (Snazzy looking prompt)" -n -c "type starship &> /dev/null" strshp
if [ $strshp == "y" ]; then
    if ! test -f install_starship.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_starship.sh)" 
    else
        ./install_starship.sh 
    fi
fi
unset strshp

# Thefuck

readyn -p "Install 'thefuck'? (Correct last command that ended with an error)" -n -c "type thefuck &> /dev/null" tf
if [ "$tf" == "y" ]; then
    if ! test -f install_thefuck.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_thefuck.sh)" 
    else
        ./install_thefuck.sh
    fi
fi
unset tf


# Nmap

readyn -p "Install nmap? (Network port scanning tool)" -n 'type nmap &> /dev/null' nmap

if [ "$nmap" == "y" ]; then
    if ! test -f install_nmap.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nmap.sh)" 
    else
        ./install_nmap.sh
    fi
fi
unset nmap


# Ufw / Gufw

readyn -p "Install ufw? (Uncomplicated firewall - Iptables wrapper)" -n -c "type ufw &> /dev/null" ins_ufw
if [ $ins_ufw == "y" ]; then
    if ! test -f install_ufw.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ufw.sh)" 
    else
        ./install_ufw.sh 
    fi
fi
unset ins_ufw


# Netstat - deprecated
#pre='y'
#othr='n'
#color='GREEN'
#prmpt='[Y/n]: '
#if type netstat &> /dev/null || type netstat-nat &> /dev/null; then
#    pre='n' 
#    othr='y'
#    color='YELLOW'
#    prmpt='[N/y]: '
#fi 
#
#reade -Q "$color" -i "$pre" -p "Install netstat? (Also port scanning tool) $prmpt" "$othr" tojump
#if [ "$tojump" == "y" ]; then
#    if ! test -f install_netstat.sh; then
#        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_netstat.sh)" 
#    else
#        ./install_netstat.sh
#    fi
#fi
#unset tojump
#unset pre color othr prmpt 




# Lazydocker

readyn -p "Install lazydocker?" -n -c "type lazydocker &> /dev/null" git_ins

if [ "y" == "$git_ins" ]; then
    if ! test -f install_lazydocker.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_lazydocker.sh)" 
    else
        ./install_lazydocker.sh
    fi
fi
unset git_ins


# Exiftool (Metadata wiper)

readyn -p "Install exiftool? (Metadata wiper for files)" -n -c "type exiftool &> /dev/null" exif_t

if [ -z $exif_t ] || [ "Y" == $exif_t ] || [ $exif_t == "y" ]; then
    if ! test -f install_exiftool.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_exiftool.sh)" 
    else
        ./install_exiftool.sh 
    fi
fi
unset exif_t

# Testdisk (File recovery tool)

readyn -p "Install testdisk? (File recovery tool)" -n -c "type testdisk &> /dev/null" kittn

if [ "y" == "$kittn" ]; then
    if ! test -f install_testdisk.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_testdisk.sh)" 
    else
        ./install_testdisk.sh
    fi
fi
unset kittn


# Ffmpeg

readyn -p "Install ffmpeg? (video/audio/image file converter)" -n -c "type ffmpeg &> /dev/null" ffmpg

if [ "$ffmpg" == "y" ]; then
    if ! test -f install_ffmpeg.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ffmpeg.sh)" 
    else
        ./install_ffmpeg.sh
    fi
fi
unset ffmpg


# Yt-dlp

readyn -p "Install yt-dlp? (youtube video downloader)" -n -c "type yt-dlp &> /dev/null" yt_dlp

if [ "$yt_dlp" == "y" ]; then
    if ! test -f install_yt-dlp.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_yt-dlp.sh)" 
    else
        ./install_yt-dlp.sh
    fi
fi
unset yt_dlp


# Environment.env

#pre='y'
#othr='n'
#color='GREEN'
#prmpt='[Y/n]: '
#echo "Next $(tput setaf 1)sudo$(tput sgr0) check for /root/.environment.env' "
#if test -f ~/.environment.env && sudo test -f /root/.environment.env; then
#    pre='n' 
#    othr='y'
#    color='YELLOW'
#    prmpt='[N/y]: '
#fi 

#reade -Q "$color" -i "$pre" -p "Check existence/create .environment.env and link it to .bashrc in $HOME/ and /root/? $prmpt" "$othr" envvars
#if [ "$envvars" == "y" ] || [ -z "$envvars" ]; then
    if ! test -f install_envvars.sh; then
        tmp=$(mktemp) 
        wget -O $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_envvars.sh
        ./$tmp  
    else
        ./install_envvars.sh  
    fi 
#fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether root account is enabled"
if ! test $(sudo passwd -S | awk '{print $2}') == 'L'; then
    printf "${CYAN}One more thing before finishing off${normal}: the ${RED}root${normal} account is still enabled.\n${RED1}This can be considered a security risk!!${normal}\n"
    readyn -Y 'YELLOW' -p 'Disable root account? (Enable again by giving up a password with \\"sudo passwd root\\")' root_dis
    if test $root_dis == 'y'; then
       sudo passwd -l root 
    fi
    unset root_dis
fi

echo "${cyan}${bold}Source .bashrc 'source ~/.bashrc' and you can check all aliases with 'alias'";
echo "${green}${bold}Done!"
readyn -p 'List all aliases?' allis
test $allis == 'y' && ( set -o posix ; alias ) | $PAGER
unset allis
