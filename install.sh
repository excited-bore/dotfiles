INSTALL=1

if ! [[ -f checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

DIR=$(get-script-dir)

if ! (hash zip &>/dev/null || hash unzip &>/dev/null) && [[ -n $pac_ins ]]; then
    printf "${CYAN}zip${normal} and/or ${CYAN}unzip${normal} are not installed \n"
    readyn -p "Install zip and unzip?" nzp_ins
    if [[ $nzp_ins == 'y' ]]; then
        eval "$pac_ins_y zip unzip"
    fi
    unset nzp_ins
fi

if ! hash curl &>/dev/null && [ -n "$pac_ins" ]; then
    printf "${CYAN}curl${normal} is not installed \n"
    readyn -p "Install curl (for querying URLS)?" ins_curl
    if [[ $ins_curl == 'y' ]]; then
        eval "$pac_ins_y curl"
    fi
    unset ins_curl
fi

# We at minimum need the 630 version for the '--no-vbell' option for people with epilepsy
if ! hash less &> /dev/null || (hash less &> /dev/null && version-higher '633' "$(command less -V | awk 'NR==1{print $2}')"); then
    printf "${CYAN}less${normal} is not installed or is under version 633, which is the version that has a flag that allowas disabling the 'virtual bell', which automatically activates when disabling the audible bell feature for a white screen flash for whenever the audible bell normally would sound, which can be triggering for people with epilespy\n"
    readyn -p "Install latest version of less?" ins_less
    if [[ $ins_less == 'y' ]]; then
        if ! [[ -f $DIR/install_less.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_less.sh)
        else 
            . $DIR/install_less.sh 
        fi
    fi
    unset ins_less
fi


# Jq - Javascript query tool
if ! hash jq &>/dev/null && [[ -n "$pac_ins" ]]; then
    printf "${CYAN}jq${normal} is not installed \n"
    readyn -p "Install jq (for querying javascript - used to get latest release(s) from github)?" ins_jq
    if [[ $ins_jq == 'y' ]]; then
        eval "${pac_ins_y} jq"
    fi
    unset ins_jq
fi

# Fzf version 0.6+ needed
if ! hash fzf &>/dev/null || (hash fzf &> /dev/null && version-higher '0.6' "$(fzf --version | awk '{print $1}')"); then
    printf "${CYAN}fzf${normal} is not installed \n"
    readyn -p "Install fzf (a fuzzy finder / TUI to make a selection - used in a multitude of functions/tools)?" ins_fzf
    if [[ $ins_fzf == 'y' ]]; then
        if ! [[ -f cli-tools/install_fzf.sh ]]; then
           source <(wget-curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_fzf.sh) "simple"
        else
            . cli-tools/install_fzf.sh "simple"
        fi
    fi
    unset ins_fzf
fi

if ! hash aria2c &>/dev/null && [ -n "$pac_ins" ]; then
    printf "${CYAN}aria2c${normal} is not installed \n"
    readyn -p "Install aria2c (for fetching files from internet - multithreaded versus singlethreaded wget -> faster downloads)?" ins_ar
    if [[ $ins_ar == 'y' ]]; then
        eval "${pac_ins_y} aria2"
    fi
    unset ins_aria2c
fi

if ! hash rlwrap &>/dev/null; then
    if ! [[ -f $DIR/cli-tools/install_rlwrap.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_rlwrap.sh)
    else
        . $DIR/cli-tools/install_rlwrap.sh
    fi
fi


printf "${green}If all necessary files are sourced correctly, this text looks green.\nIf not, something went wrong.\n"
if hash gio &>/dev/null; then
    printf "\n${green}Files that get overwritten get backed up and trashed (to prevent clutter).\nRecover using ${cyan}'gio trash --list'${green} and ${cyan}'gio trash --restore' ${normal}\n"
fi

if ! [[ -L ~/config ]] && [[ -d $XDG_CONFIG_HOME ]]; then
    readyn -Y "BLUE" -p "Create $XDG_CONFIG_HOME to ~/config symlink? " sym1
    if [[ "y" == $sym1 ]]; then
        ln -s ~/.config ~/config
    fi
fi

#if ! [[ -L ~/lib_systemd ]] && [ -d ~/lib/systemd/system ]; then
#    readyn -Y "BLUE" -p "Create /lib/systemd/system/ to user directory symlink?" sym2
#    if [[ "y" == $sym2 ]]; then
#        ln -s /lib/systemd/system/ ~/lib_systemd
#    fi
#fi

#if ! [ -e ~/etc_systemd ] && [ -d ~/etc/systemd/system ]; then
#    readyn -Y "BLUE" -p "Create /etc/systemd/system/ to user directory symlink?" sym3
#    if [[ "y" == $sym3 ]]; then
#        ln -s /etc/systemd/system/ ~/etc_systemd
#    fi
#fi

if [[ -d /etc/modprobe.d ]] && ! [[ -f /etc/modprobe.d/nobeep.conf ]]; then
    readyn -p "Remove terminal beep? (blacklist pcspkr)" beep
    if [[ "$beep" == "y" ]]; then
        echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf 1>/dev/null
    fi
fi

unset sym1 sym2 sym3 beep

if [[ "$XDG_CURRENT_DESKTOP" == 'GNOME' && "$(gsettings get org.gnome.desktop.peripherals.keyboard remember-numlock-state)" == "false"  ]] || [[ "$XDG_CURRENT_DESKTOP" == 'XFCE' && $(xfconf-query -c keyboards -lv | grep -i numlock | awk '{print $2}') == 'false' ]] || ([[ "$XDG_CURRENT_DESKTOP" == 'labwc:wlroots' ]] && ! hash numlockw &> /dev/null) ; then
    if ! [[ -f checsk/check_numlock.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_numlock.sh) 
    else
        . ./checks/check_numlock.sh 
    fi
fi
 
#if ! hash numlockx &> /dev/null || ! (([ -f ~/.xinitrc ] && grep -q 'numlockx on' ~/.xinitrc) || ([ -f ~/.bash_profile ] && ! grep -q 'numlockx on' ~/.bash_profile) || ([ -f ~/.zprofile ] && ! grep -q 'numlockx on' ~/.zprofile) || ([ -f ~/.profile ] && ! grep -q 'numlockx on' ~/.profile)); then
#    readyn -p "Right now if you were to have a keyboard with a numberpad and reboot, ${YELLOW}numlock would reset\n${GREEN}Disable this by installing and configuring ${CYAN}numlockx${GREEN}?" nmlcx
#    if [[ "$nmlcx" == "y" ]]; then
#        if ! [ -f install_numlockx.sh ]; then
#            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_numlockx.sh) 
#        else
#            . ./install_numlockx.sh 
#        fi
#    fi
#fi



DIR=$(get-script-dir)

# Environment variables

if ! [[ -f $HOME/.environment.env ]]; then
    if ! [[ -f $DIR/install_envvars.sh ]]; then
        tmp=$(mktemp -d) &&
            wget-aria-dir $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_envvars.sh
        . ./$tmp/install_envvars.sh 'n'
    else
        . $DIR/install_envvars.sh 'n'
    fi
fi

if [[ $machine == 'Linux' ]]; then
    if ([[ "$XDG_SESSION_TYPE" == 'x11' ]] && (! hash xclip &> /dev/null || ! hash xsel &> /dev/null)) || ([[ "$XDG_SESSION_TYPE" == 'wayland' ]] && (! hash wl-copy &> /dev/null || ! hash wl-paste &> /dev/null)); then
        readyn -p "Install commandline clipboard? (xsel/xclip on x11, wl-copy/wl-paste on wayland)" clip
        if [[ "y" == "$clip" ]]; then
            if ! [[ -f $DIR/install_linux_clipboard.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_linux_clipboard.sh)
            else
                . $DIR/install_linux_clipboard.sh
            fi
        fi
        unset clip
    fi
fi

if [[ -z "$(eval "$pac_ls_ins groff 2> /dev/null")" ]]; then
    printf "${CYAN}groff${normal} is not installed (Necessary for 'man' (manual) command)\n"
    readyn -p "Install groff?" groff_ins
    if [[ $groff_ins == 'y' ]]; then
        eval "${pac_ins_y}" groff
        printf "Logout and login (or reboot) to take effect\n"
    fi
    unset groff_ins
fi

if [[ $distro_base == 'Debian' ]]; then
    
    if [[ "$distro" == 'Ubuntu' ]]; then
        if [[ -z "$(${pac_ls_ins} manpages-posix 2>/dev/null)" ]]; then
            printf "${CYAN}manpages-posix${normal} is not installed (Manpages for posix-compliant (f.ex. bash) commands (f.ex. alias, test, type, etc...))\n"
            readyn -p "Install manpages-posix?" posixman_ins
            if [[ $posixman_ins == 'y' ]]; then
                eval "$pac_ins_y manpages-posix"
            fi
            unset posixman_ins
        fi
    fi

    if [[ -z "$(apt list --installed software-properties-common 2>/dev/null | awk 'NR>1{print;}')" ]] ||  [[ -z "$(apt list --installed python3-launchpadlib 2>/dev/null | awk 'NR>1{print;}')" ]]; then
        if [[ -z "$(apt list --installed software-properties-common 2>/dev/null | awk 'NR>1{print;}')" ]]; then
            printf "${CYAN}add-apt-repository${normal} is not installed (cmd tool for installing extra repositories/ppas on debian systems)\n"
            readyn -p "Install add-apt-repository?" add_apt_ins
            if [[ $add_apt_ins == 'y' ]]; then
                eval "$pac_ins_y software-properties-common python3-launchpadlib"
            fi
            unset add_apt_ins
        fi

        if [[ -z "$(apt list --installed python3-launchpadlib 2>/dev/null | awk 'NR>1{print;}')" ]]; then
            printf "${CYAN}python3-launchpadlib${normal} is not installed (python3 library that adds support for ppas from Ubuntu's 'https://launchpad.net' to add-apt-repository)\n"
            readyn -p "Install python3-launchpadlib?" lpdlb_ins
            if [[ $lpdlb_ins == 'y' ]]; then
                eval "$pac_ins_y python3-launchpadlib"
            fi
            unset lpdlb_ins

        fi
    fi

    if ! hash mainline &> /dev/null; then
        printf "${CYAN}mainline${normal} is not installed (GUI and cmd tool for managing installation of (newer) kernel versions)\n"
        readyn -p "Install mainline?" mainl_ins
        if [[ $mainl_ins == 'y' ]]; then
            if ! [[ -f cli-tools/install_mainline.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_mainline.sh)
            else
                . cli-tools/install_mainline.sh
            fi
        fi
        unset mainl_ins
    fi
    
    if hash add-apt-repository &>/dev/null; then

        if ! hash xmllint &>/dev/null && [[ -n "$(apt search libxml2-utils 2>/dev/null | awk 'NR>2{print;}')" ]]; then
            printf "${CYAN}xmllint${normal} is not installed (cmd tool for lint xml/html - used in helper script for installing PPA's)\n"
            readyn -p "Install xmllint?" xml_ins
            if [[ $xml_ins == 'y' ]]; then
                eval "$pac_ins_y libxml2-utils"
            fi
            unset xml_ins
        fi

        if ! hash ppa-purge &>/dev/null && [[ -n "$(apt search ppa-purge 2>/dev/null | awk 'NR>2{print;}')" ]]; then
            printf "${CYAN}ppa-purge${normal} is not installed (cmd tool for disabling installed PPA's)\n"
            readyn -p "Install ppa-purge?" ppa_ins
            if [[ $ppa_ins == 'y' ]]; then
                eval "$pac_ins_y ppa-purge"
            fi
            unset ppa_ins
        fi
    fi

    if ! hash nala &>/dev/null && [[ -n "$(apt search nala 2>/dev/null | awk 'NR>2{print;}')" ]]; then
        printf "${CYAN}nala${normal} is not installed (A TUI wrapper for apt install, update, upgrade, search, etc..)\n"
        readyn -p "Install nala?" nala_ins
        if [[ $nala_ins == 'y' ]]; then
            eval "$pac_ins_y nala"
            if ! [[ -f checks/check_system.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)
            else 
                . ./checks/check_system.sh 
            fi
        fi
        unset nala_ins
    fi

    if [[ $distro == "Ubuntu" ]]; then
        if ! hash synaptic &>/dev/null; then
            printf "${CYAN}synaptic${normal} is not installed (Better GUI for package management)\n"
            readyn -p "Install synaptic? " ins_curl
            if [[ $ins_curl == 'y' ]]; then
                eval "$pac_ins_y synaptic"
            fi
            unset ins_curl
        fi
    fi

elif [[ $distro_base == 'Arch' ]]; then

    if [[ -z "$(pacman -Q pacman-contrib 2>/dev/null)" ]]; then
        printf "${CYAN}pacman-contrib${normal} is not installed (Includes tools like pactree, pacsearch, pacdiff..)\n"
        readyn -p 'Install pacman-contrib package?' -c '! hash pactree &> /dev/null' pacmn_cntr
        if [[ "$pacmn_cntr" == 'y' ]]; then
            sudo pacman -Su --noconfirm pacman-contrib
        fi
    fi
    unset pacmn_cntr

    if [[ -z "$AUR_pac" &>/dev/null ]]; then
        printf "${CYAN}yay${normal} is not installed (Pacman wrapper for installing AUR packages, needed for yay-fzf-install)\n"
        readyn -p "Install yay?" insyay
        if [[ "y" == "$insyay" ]]; then
            if ! [[ -f $DIR/AUR_installers/install_yay.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_yay.sh)
            else
                . $DIR/AUR_installers/install_yay.sh
            fi
            if hash yay &>/dev/null; then
                if ! [[ -f checks/check_system.sh ]]; then
                    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)
                else 
                    . ./checks/check_system.sh 
                fi
            fi
        fi
        unset insyay
    fi

    if hash pamac &>/dev/null; then
        if ! [[ -f $DIR/checks/check_pamac.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh)
        else
            . $DIR/checks/check_pamac.sh
        fi
    fi

    if ! [[ -z "$AUR_ls_ins" ]] && [[ -z "$(eval ${AUR_ls_ins} | grep pacseek 2>/dev/null)" ]]; then
        printf "${CYAN}pacseek${normal} (A TUI for managing packages from pacman and AUR) is not installed\n"
        readyn -p "Install pacseek? " pacs_ins
        if [[ "$pacs_ins" == 'y' ]]; then
            eval "${AUR_ins_y} pacseek"
        fi
        unset pacs_ins
    fi
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for polkit related files in '/etc/polkit', '/etc/polkit-1/rules.d/' and '/etc/polkit-1/localauthority.conf.d/'"

if ! sudo [[ -f /etc/polkit/49-nopasswd_global.pkla ]] && ! sudo [[ -f /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf ]] && ! sudo [[ -f /etc/polkit-1/rules.d/90-nopasswd_global.rules ]]; then
    readyn -Y "YELLOW" -p "Configure polkit for automatic authentication without passwords (sudo still requires passwords)?" plkit
    if [[ "y" == "$plkit" ]]; then
        if ! [[ -f $DIR/conf_polkit_no_pwd.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/conf_polkit_no_pwd.sh)
        else
            . $DIR/conf_polkit_no_pwd.sh
        fi
    fi
    unset plkit
fi

DIR=$(get-script-dir)

if ! [[ -f $DIR/checks/check_envvar.sh ]]; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)
else
    . $DIR/checks/check_envvar.sh
fi

if ! [[ -f $DIR/checks/check_completions_dir.sh ]]; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)
else
    . $DIR/checks/check_completions_dir.sh
fi

# Appimagelauncher

if ! hash AppImageLauncher &>/dev/null; then
    printf "${GREEN}If you want to install applications using appimages, there is a helper called 'appimagelauncher'\n"
    readyn -p "Check if appimage ready and install appimagelauncher?" appimage_install
    if [[ "$appimage_install" == 'y' ]]; then
        if ! [[ -f $DIR/install_appimagelauncher.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_appimagelauncher.sh)
        else
            . $DIR/install_appimagelauncher.sh
        fi
    fi
fi

# Flatpak

#if ! hash flatpak &> /dev/null; then
#printf "%s\n" "${blue}No flatpak detected. (Independent package manager from Red Hat)${normal}"
readyn -p "Install (or just configure) Flatpak?" -c "[ -z \"$FLATPAK\" ]" insflpk
if [[ "y" == "$insflpk" ]]; then
    if ! [[ -f $DIR/cli-tools/pkgmngrs/install_flatpak.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_flatpak.sh)
    else
        . $DIR/cli-tools/pkgmngrsinstall_flatpak.sh
    fi
fi

if ! hash snap &>/dev/null; then
    printf "%s\n" "${blue}No snap detected. (Independent package manager from Canonical)${normal}"
    readyn -Y "MAGENTA" -p "Install snap?" -n inssnap
    if [[ "y" == "$inssnap" ]]; then
        if ! [[ -f $DIR/cli-tools/pkgmngrs/install_snapd.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_snapd.sh)
        else
            . $DIR/cli-tools/pkgmngrs/install_snapd.sh
        fi
    fi
fi
unset inssnap

# Eza prompt

readyn -p "Install eza? (A modern replacement for ls)" -c "! hash eza &> /dev/null" rmp

if [[ "y" == "$rmp" ]]; then
    if ! [[ -f $DIR/cli-tools/install_eza.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_eza.sh)
    else
        . $DIR/cli-tools/install_eza.sh
    fi
fi
unset rmp

# Xcp

if (hash cpg &>/dev/null || cp --help | grep -qF -- '-g') && hash xcp &>/dev/null; then
    cpgi="none all advcpmv xcp"
    cpgp="[None/all/advcpmv/xcp]: "
    color="YELLOW"
elif hash xcp &>/dev/null; then
    printf "${CYAN}cpg/mvg${GREEN} are patches for the default coreutils 'cp (copy) / mv (move)' which gives an added flag to both for a progress bar with '-g/--progress-bar'\n${normal}" 
    cpgi="advcpmv xcp all none"
    cpgp="[Advcpmv/xcp/all/none]: "
    color="GREEN"
elif (hash cpg &>/dev/null || cp --help | grep -qF -- '-g'); then 
    printf "${CYAN}xcp${GREEN} is an 'extended', rust-written cp that copies faster and also comes with a progress bar${normal}\n"
    cpgi="xcp advcpmv all none"
    cpgp="[Xcp/advcpmv/all/none]: "
    color="GREEN"
else
    printf "${CYAN}cpg/mvg${GREEN} are patches for the default coreutils 'cp (copy) / mv (move)' which gives an added flag to both for a progress bar with '-g/--progress-bar'\n${CYAN}xcp${GREEN} is an 'extended', rust-written cp that copies faster and also comes with a progress bar${normal}\n"
    cpgi="advcpmv xcp all none"
    cpgp="[Advcpmv/xcp/all/none]: "
    color="GREEN"
fi

reade -Q "$color" -i "$cpgi" -p "Install advcpmv, xcp, all or none? $cpgp" cpg
if [[ "all" == "$cpg" || "advcpmv" == "$cpg" ]]; then
    if ! [ -f $DIR/cli-tools/install_advcpmv.sh ]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_advcpmv.sh)
    else
        . $DIR/cli-tools/install_advcpmv.sh
    fi
fi
if [[ "all" == "$cpg" || "xcp" == "$cpg" ]]; then
    if ! [[ -f $DIR/cli-tools/install_xcp.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_xcp.sh)
    else
        . $DIR/cli-tools/install_xcp.sh
    fi
fi
unset cpg cpgi cpgp color

# Rm prompt

readyn -p "Install rm-prompt? (Rm but lists files/directories before deletion)" -c "! hash rm-prompt &> /dev/null" rmp

if [[ "y" == "$rmp" ]]; then
    if ! [[ -f $DIR/cli-tools/install_rmprompt.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_rmprompt.sh)
    else
        $DIR/cli-tools/install_rmprompt.sh
    fi
fi
unset rmp

# Fzf (Fuzzy Finder)

readyn -p "Install fzf? (Fuzzy file/folder finder - replaces Ctrl-R/reverse-search, binds fzf search files on Ctrl+T and fuzzy search directories on Alt-C + Custom script: Ctrl-f becomes system-wide file opener)" -c "! [[ -f $HOME/.keybinds.d/fzf-bindings.bash ]]" findr

if [[ "y" == "$findr" ]]; then
    if ! [[ -f $DIR/cli-tools/install_fzf.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_fzf.sh)
    else
        . $DIR/cli-tools/install_fzf.sh
    fi
fi
unset findr

# Ack prompt

readyn -c "! hash ack &> /dev/null" -p "Install ack? (A modern replacement for grep - finds lines in shell output)" ack

if [[ "y" == "$ack" ]]; then
    if ! [[ -f $DIR/cli-tools/install_ack.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_ack.sh)
    else
        . $DIR/cli-tools/install_ack.sh
    fi
fi
unset ack

# Dust, dua and ncdu - Du replacement(s)

if ! (hash dua &>/dev/null || hash dust &>/dev/null || hash ncdu &>/dev/null); then
    if ! hash dua &>/dev/null && ! hash dust &>/dev/null && ! hash ncdu &>/dev/null; then 
        printf "${CYAN}'Dua'${GREEN} and ${CYAN}'dust'${GREEN} are modern cli replacements of du\n${CYAN}'Dua interactive'${GREEN} and ${CYAN}'ncdu'${GREEN} are interactive TUI replacements that also help remove unnecessary files${normal}\n"
        color='GREEN'
        pre="dua dust ncdu all none"
        prmpt="[Dua/dust/ncdu/all/none]: "
    elif ! hash dust &>/dev/null && hash dua &>/dev/null; then
        printf "${CYAN}'Dust'${GREEN} is a modern cli replacements of du\n${CYAN}'Ncdu'${GREEN} is an interactive TUI replacements that also help remove unnecessary files${normal}\n"
        color='GREEN'
        pre="dust dua ncdu all none"
        prmpt="[Dust/dua/ncdu/all/none]: "
    elif hash dua &>/dev/null && hash dust &>/dev/null && ! hash ncdu &>/dev/null; then
        printf "${CYAN}'Ncdu'${GREEN} is an interactive TUI replacements that also help remove unnecessary files${normal}\n"
        color='GREEN'
        pre="ncdu dust dua none"
        prmpt="[Ncdu/dust/dua/none]: "
    fi
else
    color='YELLOW'
    pre="none dua dust ncdu all"
    prmpt="[None/dua/dust/ncdu/all]: "
fi

reade -Q "$color" -i "$pre" -p "Install dua, dust, ncdu or all? $prmpt" dua_dust_ncdu
if [[ "all" == "$dua_dust_ncdu" || "dua" == "$dua_dust_ncdu" ]]; then
    if ! [[ -f $DIR/cli-tools/install_dua_cli.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_dua_cli.sh)
    else
        . $DIR/cli-tools/install_dua_cli.sh
    fi
fi
if [[ "all" == "$dua_dust_ncdu" || "dust" == "$dua_dust_ncdu" ]]; then
    if ! [[ -f $DIR/cli-tools/install_dust.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_dust.sh)
    else
        . $DIR/cli-tools/install_dust.sh
    fi
fi
if [[ "all" == "$dua_dust_ncdu" || "ncdu" == "$dua_dust_ncdu" ]]; then
    if ! [[ -f $DIR/cli-tools/install_ncdu.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_ncdu.sh)
    else
        . $DIR/cli-tools/install_ncdu.sh
    fi
fi
unset dua_dust_ncdu color pre prmpt

# Duf and Dysk - Df replacement

color='GREEN'
color1="${GREEN}"
pre="duf dysk both none"
prmpt=" [Duf/dysk/both/none]: "
if ! hash dysk &>/dev/null && hash duf &>/dev/null; then
    color='YELLOW'
    color1="${YELLOW}"
    pre="none dysk duf both"
    prmpt=" [None/dysk/duf/both]: "
elif hash dysk &>/dev/null || hash duf &>/dev/null; then
    color='YELLOW'
    color1="${YELLOW}"
    pre="none duf dysk both"
    prmpt=" [None/duf/dysk/both]: "
fi

reade -Q "$color" -i "$pre" -p "Install ${CYAN}duf${color1}, ${CYAN}dysk${color1} or both? (Both are modern replacements for df - tools list hard drive disk space)$prmpt" duf_dysk
if [[ "both" == "$duf_dysk" ]] || [[ "duf" == "$duf_dysk" ]]; then
    if ! [[ -f $DIR/install_duf.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_duf.sh)
    else
        . $DIR/install_duf.sh
    fi
fi
if [[ "both" == "$duf_dysk" ]] || [[ "dysk" == "$duf_dysk" ]]; then
    if ! [[ -f $DIR/cli-tools/install_dysk.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_dysk.sh)
    else
        . $DIR/cli-tools/install_dysk.sh
    fi
fi
unset duf_dysk color color1 pre prmpt

# Bash alias completions

readyn -p "Install bash completions for aliases in ~/.bash_completion.d?" -c "! [ -f ~/.bash_completion.d/complete_alias ]" compl
if [[ "y" == "$compl" ]]; then
    if ! [[ -f $DIR/cli-tools/install_bashalias_completions.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_bashalias_completions.sh)
    else
        . $DIR/cli-tools/install_bashalias_completions.sh
    fi
fi
unset compl

# Python completions

readyn -p "Install python completions in ~/.bash_completion.d?" -c "! hash activate-global-python-argcomplete &> /dev/null" pycomp
if [[ "y" == "$pycomp" ]]; then
    if ! [[ -f $DIR/cli-tools/install_python_completions.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_python_completions.sh)
    else
        . $DIR/cli-tools/install_python_completions.sh
    fi
fi
unset pycomp

DIR=$(get-script-dir)

# Xresources

xterm=$DIR/xterm/.Xresources

if ! [[ -f $xterm ]]; then
    tmp=$(mktemp) && 
        wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/xterm/.Xresources > $tmp
    xterm=$tmp
fi

xresources_r() {
    sudo cp $xterm /root/.Xresources
}
xresources() {
    cp $xterm ~/.Xresources
    yes-edit-no -f xresources_r -g "$xterm" -p "Install .Xresources at /root/?" -e -n -Q "RED"
}
yes-edit-no -f xresources -g "$xterm" -p "Install .Xresources at ~/? (Xterm configuration)" -e -Q "YELLOW"

# Rlwrap scripts

#readyn -p "Install reade, readyn and yes-edit-no?" -c '[ -f ~/.aliases.d/reade ]' insrde
#if [ "$insrde" == 'y' ]; then
#    if ! [ -f install_reade_readyn.sh ]; then
#         source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_reade_readyn.sh)
#    else
#        ./install_reade_readyn.sh
#    fi
#fi
#unset insrde

# Starship

readyn -p "Install Starship? (Snazzy looking prompt)" -c "! hash starship &> /dev/null" strshp
if [[ "$strshp" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_starship.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_starship.sh)
    else
        . $DIR/cli-tools/install_starship.sh
    fi
fi
unset strshp

DIR=$(get-script-dir)

# Aliases

readyn -p "Install bash aliases and other config?" scripts
if [[ "y" == "$scripts" ]]; then

    if ! [[ -f $DIR/checks/check_aliases_dir.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)
    else
        . $DIR/checks/check_aliases_dir.sh
    fi
    
    if ! [[ -f $DIR/install_aliases.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/install_aliases.sh)
    else
        . $DIR/install_aliases.sh
    fi
fi

# Hhighlighter (or just h)

readyn -c "! hash h &> /dev/null" -p "Install hhighlighter (or just h)? (A tiny utility to highlight multiple keywords with different colors in a textoutput)" h
if [[ "y" == "$h" ]]; then
    if ! hash ack &>/dev/null; then
        printf "For ${CYAN}hhighlighter${normal} to work, ${CYAN}ack${normal} needs to be installed beforehand.\n"
        readyn -p "Install ack and then hhighlighter?" ansr
        if [[ "$ansr" == 'y' ]]; then
            if ! [[ -f $DIR/cli-tools/install_ack.sh ]]; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_ack.sh)
            else
                . $DIR/cli-tools/install_ack.sh
            fi
        fi
        unset ansr
    fi
    if hash ack &> /dev/null; then
        if ! [[ -f $DIR/cli-tools/install_hhighlighter.sh ]]; then
            source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_hhighlighter.sh)
        else
            . $DIR/cli-tools/install_hhighlighter.sh
        fi
    fi
fi
unset h

[[ -n "$BASH_VERSION" ]] && source ~/.bashrc &>/dev/null
[[ -n "$ZSH_VERSION" ]] && source ~/.zshrc &>/dev/null

if ! [[ -f checks/check_all.sh ]]; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

DIR=$(get-script-dir)

# Nerdfonts

readyn -p "Install a Nerdfont? (Type of font with icons to distinguish filetypes in the terminal + other types of icons)" nstll_nerdfont

if [[ "y" == "$nstll_nerdfont" ]]; then
    if ! [[ -f $DIR/install_nerdfonts.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nerdfonts.sh)
    else
        . $DIR/install_nerdfonts.sh
    fi
fi
unset nstll_nerdfont

# Kitty (Terminal emulator)

readyn -p "Install Kitty? (Terminal emulator)" -c "! hash kitty &> /dev/null" kittn

if [[ "y" == "$kittn" ]]; then
    if ! [[ -f $DIR/install_kitty.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_kitty.sh)
    else
        . $DIR/install_kitty.sh
    fi
fi
unset kittn

# Keybinds

if ! [[ -f install_keybinds.sh ]]; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_keybinds.sh)
else
    . ./install_keybinds.sh
fi

# Bash Preexec

readyn -p "Install pre-execution hooks for bash in ~/.bash_preexec?" -c "! [ -f ~/.bash_preexec.sh ] || ! [ -f /root/.bash_preexec.sh ]" bash_preexec
if [[ "y" == "$bash_preexec" ]]; then
    if ! [[ -f $DIR/install_bash_preexec.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bash_preexec.sh)
    else
        . $DIR/install_bash_preexec.sh
    fi
fi
unset bash_preexec

# Pipewire (better sound)

readyn -p "Install and configure pipewire? (sound system - pulseaudio replacement)" -c '! hash wireplumber &> /dev/null || ! [ -f ~/.config/pipewire/pipewire-pulse.conf.d/switch-on-connect.conf ];' pipew
if [[ "$pipew" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_pipewire.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_pipewire.sh)
    else
        . $DIR/cli-tools/install_pipewire.sh
    fi
fi
unset pipew

# Moor (Custom pager instead of less)

readyn -p "Install moor? (Custom pager/less replacement - awesome default options)" -c '! hash moor &> /dev/null;' moor

if [[ "$moor" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_moor.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_moor.sh)
    else
        . $DIR/cli-tools/install_moor.sh
    fi
fi
unset moor

# Nano (Editor)

readyn -p "Install nano + config? (Simple terminal editor)" -c "! hash nano &> /dev/null || ! [ -f ~/.nanorc ]" nno

if [[ "y" == "$nno" ]]; then
    if ! [[ -f $DIR/cli-tools/install_nano.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_nano.sh)
    else
        . $DIR/cli-tools/install_nano.sh
    fi
fi
unset nno

# Nvim (Editor)

readyn -p "Install neovim + config? (Complex terminal editor)" -c "! hash nvim &> /dev/null" nvm

if [[ "y" == "$nvm" ]]; then
    if ! [[ -f $DIR/cli-tools/install_nvim.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_nvim.sh)
    else
        . $DIR/cli-tools/install_nvim.sh
    fi
fi
unset nvm

# Rg (ripgrep)

readyn -p "Install ripgrep? (recursively searches the current directory for lines matching a regex pattern)" -c "! hash rg &> /dev/null" rgrp
if [[ "y" == "$rgrp" ]]; then
    if ! [[ -f $DIR/cli-tools/install_ripgrep.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_ripgrep.sh)
    else
        . $DIR/cli-tools/install_ripgrep.sh
    fi
fi
unset rgrp

# Ast-grep (ast-grep)

readyn -p "Install ast-grep? (Search and Rewrite code at large scale using precise AST pattern)" -c "! hash ast-grep &> /dev/null" rgrp
if [[ "y" == "$rgrp" ]]; then
    if ! [[ -f $DIR/install_ast-grep.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_ast-grep.sh)
    else
        . $DIR/cli-tools/install_ast-grep.sh
    fi
fi
unset rgrp

# Git

readyn -p "Install Git and configure? (Project managing tool)" -n -c "! hash git &> /dev/null && [ -f ~/.gitconfig ]" git_ins

if [[ "y" == "$git_ins" ]]; then
    if ! [[ -f $DIR/cli-tools/install_git.sh ]]; then
        ins_git=$(mktemp)
        wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_git.sh > $ins_git
        chmod u+x "$ins_git"
        eval "$ins_git 'global'"
    else
        . $DIR/cli-tools/install_git.sh 'global'
    fi
fi
unset git_ins

# Lazygit

readyn -p "Install Lazygit?" -c "! hash lazygit &> /dev/null" git_ins
if [[ "y" == "$git_ins" ]]; then

    if ! [[ -f $DIR/install_lazygit.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_lazygit.sh)
    else
        . $DIR/cli-tools/install_lazygit.sh
    fi

fi
unset git_ins

# Osc
#readyn -p "Install Osc52 clipboard? (Universal clipboard tool / works natively over ssh)" osc
#if [[ -z $osc ] || [[ "Y" == $osc ] || [[ $osc == "y" ]]; then
#    ./install_osc.sh
#fi
#unset osc

# Ranger (File explorer)

readyn -p "Install Ranger? (Terminal file explorer)" -c "! hash ranger &> /dev/null" rngr
if [[ "y" == "$rngr" ]]; then
    if ! [[ -f $DIR/cli-tools/install_ranger.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_ranger.sh)
    else
        . $DIR/cli-tools/install_ranger.sh
    fi
fi
unset rngr

# Tmux (File explorer)

readyn -p "Install Tmux? (Terminal multiplexer)" -c "! hash tmux &> /dev/null" tmx
if [[ "y" == "$tmx" ]]; then
    if ! [[ -f $DIR/cli-tools/install_tmux.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_tmux.sh)
    else
        . $DIR/cli-tools/install_tmux.sh
    fi
fi
unset tmx

# Bat

readyn -p "Install Bat? (Cat clone with syntax highlighting)" -c "! hash bat &> /dev/null && ! hash batcat &> /dev/null" bat

if [[ $bat == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_bat.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_bat.sh)
    else
        . $DIR/cli-tools/install_bat.sh
    fi
fi
unset bat

# Neofetch

readyn -p "Install neofetch/fastfetch/screenFetch)? (Terminal taskmanager - system information tool)" -c "! hash fastfetch &> /dev/null && ! hash screenfetch &> /dev/null" tojump

if [[ "$tojump" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_neofetch_onefetch.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_neofetch_onefetch.sh)
    else
        . $DIR/cli-tools/install_neofetch_onefetch.sh
    fi
fi
unset tojump

# Btop

readyn -p "Install Btop? (A processmanager with a fastly improved TUI relative to top/htop written in C++)" -c "! hash btop &> /dev/null" tojump
if [[ "$tojump" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_btop.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_btop.sh)
    else
        . $DIR/cli-tools/install_btop.sh
    fi
fi
unset tojump

# Autojump
# -c "! hash autojump &> /dev/null"

readyn -n -p "Install autojump? (jump to folders using 'bookmarks' - j_ )" tojump
if [[ "$tojump" == "y" ]]; then
    if ! [[ -f $DIR/install_autojump.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_autojump.sh)
    else
        . $DIR/cli-tools/install_autojump.sh
    fi
fi
unset tojump

# Zoxide

readyn -p "Install zoxide? (A cd that guesses the right path based on a history)" -c "! hash zoxide &> /dev/null" zoxs
if [[ "$zoxs" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_zoxide.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_zoxide.sh)
    else
        . $DIR/cli-tools/install_zoxide.sh
    fi
fi
unset zoxs

# Thefuck
# i mean pay-respects

readyn -p "Install 'pay-respects'? (Correct last command that ended with an error - 'thefuck' successor)" -c "! hash pay-respects &> /dev/null" tf
if [[ "$tf" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_f.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_f.sh)
    else
        . $DIR/cli-tools/install_f.sh
    fi
fi
unset tf

# Nmap

readyn -p "Install nmap? (Network port scanning tool)" -c '! hash nmap &> /dev/null' nmap
if [[ "$nmap" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_nmap.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_nmap.sh)
    else
        . $DIR/cli-tools/install_nmap.sh
    fi
fi
unset nmap

# Ufw / Gufw

readyn -p "Install ufw? (Uncomplicated firewall - Iptables wrapper)" -c "! hash ufw &> /dev/null" ins_ufw
if [[ "$ins_ufw" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_ufw.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_ufw.sh)
    else
        . $DIR/cli-tools/install_ufw.sh
    fi
fi
unset ins_ufw

# Netstat - deprecated
#pre='y'
#othr='n'
#color='GREEN'
#prmpt='[Y/n]: '
#if hash netstat &> /dev/null || hash netstat-nat &> /dev/null; then
#    pre='n'
#    othr='y'
#    color='YELLOW'
#    prmpt='[N/y]: '
#fi
#
#reade -Q "$color" -i "$pre" -p "Install netstat? (Also port scanning tool) $prmpt" "$othr" tojump
#if [[ "$tojump" == "y" ]]; then
#    if ! [[ -f cli-tools/install_netstat.sh ]]; then
#        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_netstat.sh)
#    else
#        ./cli-tools/install_netstat.sh
#    fi
#fi
#unset tojump
#unset pre color othr prmpt

# Lazydocker

readyn -p "Install lazydocker?" -c "! hash lazydocker &> /dev/null" git_ins
if [[ "y" == "$git_ins" ]]; then
    if ! [[ -f $DIR/cli-tools/install_lazydocker.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_lazydocker.sh)
    else
        . $DIR/cli-tools/install_lazydocker.sh
    fi
fi
unset git_ins

# Exiftool (Metadata wiper)

readyn -p "Install exiftool? (Metadata wiper for files)" -c "! hash exiftool &> /dev/null" exif_t
if [[ "$exif_t" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_exiftool.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_exiftool.sh)
    else
        . $DIR/cli-tools/install_exiftool.sh
    fi
fi
unset exif_t

# Testdisk (File recovery tool)

readyn -p "Install testdisk? (File recovery tool)" -c "! hash testdisk &> /dev/null" kittn
if [[ "y" == "$kittn" ]]; then
    if ! [[ -f $DIR/cli-tools/install_testdisk.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_testdisk.sh)
    else
        . $DIR/cli-tools/install_testdisk.sh
    fi
fi
unset kittn

# Ffmpeg

readyn -p "Install ffmpeg? (video/audio/image file converter)" -c "! hash ffmpeg &> /dev/null || ! [ -f $HOME/.aliases.d/ffmpeg.sh ]" ffmpg
if [[ "$ffmpg" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_ffmpeg.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_ffmpeg.sh)
    else
        . $DIR/cli-tools/install_ffmpeg.sh
    fi
fi
unset ffmpg

# Yt-dlp

readyn -p "Install yt-dlp? (youtube video downloader)" -c "! hash yt-dlp &> /dev/null" yt_dlp
if [[ "$yt_dlp" == "y" ]]; then
    if ! [[ -f $DIR/cli-tools/install_yt-dlp.sh ]]; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_yt-dlp.sh)
    else
        . $DIR/cli-tools/install_yt-dlp.sh
    fi
fi
unset yt_dlp

# Environment.env

#pre='y'
#othr='n'
#color='GREEN'
#prmpt='[Y/n]: '
#echo "Next $(tput setaf 1)sudo$(tput sgr0) check for /root/.environment.env' "
#if [ -f ~/.environment.env ] && sudo [ -f /root/.environment.env ]; then
#    pre='n'
#    othr='y'
#    color='YELLOW'
#    prmpt='[N/y]: '
#fi

#reade -Q "$color" -i "$pre" -p "Check existence/create .environment.env and link it to .bashrc in $HOME/ and /root/? $prmpt" "$othr" envvars
#if [[ "$envvars" == "y" ]] || [[ -z "$envvars" ]]  then
if ! [[ -f $DIR/install_envvars.sh ]]; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_envvars.sh)
else
    . $DIR/install_envvars.sh
fi
#fi

# Check one last time if ~/.bash_preexec - for both $USER and root - is the last line in their ~/.bash_profile and ~/.bashrc

#if ! [ -f ./checks/check_bash_source_order.sh ]; then
#    if hash curl &>/dev/null; then
#        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
#    else
#        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
#        return 1 || exit 1
#    fi
#else
#    . ./checks/check_bash_source_order.sh
#fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether root account is enabled"
if ! [[ "$(sudo passwd -S | awk '{print $2}')" == 'L' ]]; then
    printf "${CYAN}One more thing before finishing off${normal}: the ${RED}root${normal} account is still enabled.\n${RED1}This can be considered a security risk!!${normal}\n"
    readyn -n -p 'Disable root account? (Enable again by giving up a password with \\"sudo passwd root\\")' root_dis
    if [[ "$root_dis" == 'y' ]]; then
        sudo passwd -l root
    fi
    unset root_dis
fi

echo "${cyan}${bold}Source .bashrc 'source ~/.bashrc' and you can check all aliases with 'alias'"
echo "${green}${bold}Done!${normal}"
readyn -p 'List all aliases?' allis
if [[ "$allis" == 'y' ]]; then
    [[ -n "$BASH_VERSION" ]] && set -o posix
    [[ -n "$ZSH_VERSION" ]] && set -o posixaliases
    eval "alias | $PAGER"
fi

readyn -p 'List all functions?' fncts
if [[ "$fncts" == 'y' ]]; then
    [[ -n "$BASH_VERSION" ]] && set -o posix
    [[ -n "$ZSH_VERSION" ]] && set -o posixaliases
    eval "declare -f | $PAGER"
fi

unset fncts allis
