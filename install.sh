INSTALL=1
unalias curl &>/dev/null
unalias wget &>/dev/null

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

if ! (hash zip &>/dev/null || hash unzip &>/dev/null) && test -n "$pac_ins"; then
    printf "${CYAN}zip${normal} and/or ${CYAN}unzip${normal} are not installed \n"
    readyn -p "Install zip and unzip?" nzp_ins
    if [[ $nzp_ins == 'y' ]]; then
        eval "$pac_ins_y zip unzip"
    fi
    unset nzp_ins
fi

if ! hash curl &>/dev/null && test -n "$pac_ins"; then
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
        if ! test -f $SCRIPT_DIR/install_less.sh; then
            source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_less.sh)
        else 
            . $SCRIPT_DIR/install_less.sh 
        fi
    fi
    unset ins_less
fi


# Jq - Javascript query tool
if ! hash jq &>/dev/null && test -n "$pac_ins"; then
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
        if ! test -f install_fzf.sh; then
            if hash curl &>/dev/null; then
                source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fzf.sh) "simple"
            else
                source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fzf.sh) "simple"
            fi
        else
            . ./install_fzf.sh "simple"
        fi
    fi
    unset ins_fzf
fi

if ! hash aria2c &>/dev/null && test -n "$pac_ins"; then
    printf "${CYAN}aria2c${normal} is not installed \n"
    readyn -p "Install aria2c (for fetching files from internet - multithreaded versus singlethreaded wget -> faster downloads)?" ins_ar
    if [[ $ins_ar == 'y' ]]; then
        eval "${pac_ins} aria2"
    fi
    unset ins_aria2c
fi

if ! hash rlwrap &>/dev/null; then
    if ! test -f $SCRIPT_DIR/checks/check_rlwrap.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_rlwrap.sh)
    else
        . $SCRIPT_DIR/checks/check_rlwrap.sh
    fi
fi


printf "${green}If all necessary files are sourced correctly, this text looks green.\nIf not, something went wrong.\n"
if hash gio &>/dev/null; then
    printf "\n${green}Files that get overwritten get backed up and trashed (to prevent clutter).\nRecover using ${cyan}'gio trash --list'${green} and ${cyan}'gio trash --restore' ${normal}\n"
fi

if ! test -e ~/config && test -d ~/.config; then
    readyn -Y "BLUE" -p "Create ~/.config to ~/config symlink? " sym1
    if [[ "y" == $sym1 ]]; then
        ln -s ~/.config ~/config
    fi
fi

if ! test -e ~/lib_systemd && test -d ~/lib/systemd/system; then
    readyn -Y "BLUE" -p "Create /lib/systemd/system/ to user directory symlink?" sym2
    if [[ "y" == $sym2 ]]; then
        ln -s /lib/systemd/system/ ~/lib_systemd
    fi
fi

if ! test -e ~/etc_systemd && test -d ~/etc/systemd/system; then
    readyn -Y "BLUE" -p "Create /etc/systemd/system/ to user directory symlink?" sym3
    if [[ "y" == $sym3 ]]; then
        ln -s /etc/systemd/system/ ~/etc_systemd
    fi
fi

if test -d /etc/modprobe.d && ! test -f /etc/modprobe.d/nobeep.conf; then
    readyn -p "Remove terminal beep? (blacklist pcspkr)" beep
    if [[ "$beep" == "y" ]]; then
        echo "blacklist pcspkr" | sudo tee /etc/modprobe.d/nobeep.conf 1>/dev/null
    fi
fi
unset sym1 sym2 sym3 beep

SCRIPT_DIR=$(get-script-dir)

# Environment variables

if ! test -f $HOME/.environment; then
    if ! test -f $SCRIPT_DIR/install_envvars.sh; then
        tmp=$(mktemp -d) &&
            wget-aria-dir $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_envvars.sh
        . ./$tmp/install_envvars.sh 'n'
    else
        . $SCRIPT_DIR/install_envvars.sh 'n'
    fi
fi

if [[ $machine == 'Linux' ]]; then
    if ! hash xclip &>/dev/null || ! hash xsel &>/dev/null; then
        printf "${CYAN}xclip${normal} and/or ${CYAN}xsel${normal} are not installed (clipboard tools for X11 based systems)\n"
        readyn -p "Install xclip and xsel?" nzp_ins
        if [[ $nzp_ins == 'y' ]]; then
            eval "$pac_ins_y xclip xsel"
        fi
        unset nzp_ins
    fi
fi

if test -z "$(eval "$pac_ls_ins groff 2> /dev/null")"; then
    printf "${CYAN}groff${normal} is not installed (Necessary for 'man' (manual) command)\n"
    readyn -p "Install groff?" groff_ins
    if [[ $groff_ins == 'y' ]]; then
        eval "${pac_ins}" groff
        printf "Logout and login (or reboot) to take effect\n"
    fi
    unset groff_ins
fi

if [[ $distro_base == 'Debian' ]]; then
    
    if [[ "$distro" == 'Ubuntu' ]]; then
        if test -z "$(${pac_ls_ins} manpages-posix 2>/dev/null)"; then
            printf "${CYAN}manpages-posix${normal} is not installed (Manpages for posix-compliant (f.ex. bash) commands (f.ex. alias, test, type, etc...))\n"
            readyn -p "Install manpages-posix?" posixman_ins
            if [[ $posixman_ins == 'y' ]]; then
                eval "$pac_ins_y manpages-posix"
            fi
            unset posixman_ins
        fi
    fi

    if test -z "$(apt list --installed software-properties-common 2>/dev/null | awk 'NR>1{print;}')" || test -z "$(apt list --installed python3-launchpadlib 2>/dev/null | awk 'NR>1{print;}')"; then
        if test -z "$(apt list --installed software-properties-common 2>/dev/null | awk 'NR>1{print;}')"; then
            printf "${CYAN}add-apt-repository${normal} is not installed (cmd tool for installing extra repositories/ppas on debian systems)\n"
            readyn -p "Install add-apt-repository?" add_apt_ins
            if [[ $add_apt_ins == 'y' ]]; then
                eval "$pac_ins_y software-properties-common python3-launchpadlib"
            fi
            unset add_apt_ins
        fi

        if test -z "$(apt list --installed python3-launchpadlib 2>/dev/null | awk 'NR>1{print;}')"; then
            printf "${CYAN}python3-launchpadlib${normal} is not installed (python3 library that adds support for ppas from Ubuntu's 'https://launchpad.net' to add-apt-repository)\n"
            readyn -p "Install python3-launchpadlib?" lpdlb_ins
            if [[ $lpdlb_ins == 'y' ]]; then
                eval "$pac_ins_y python3-launchpadlib"
            fi
            unset lpdlb_ins

        fi
    fi

    if hash add-apt-repository &>/dev/null; then

        if ! hash xmllint &>/dev/null && test -n "$(apt search libxml2-utils 2>/dev/null | awk 'NR>2{print;}')"; then
            printf "${CYAN}xmllint${normal} is not installed (cmd tool for lint xml/html - used in helper script for installing PPA's)\n"
            readyn -p "Install xmllint?" xml_ins
            if [[ $xml_ins == 'y' ]]; then
                eval "$pac_ins_y libxml2-utils"
            fi
            unset xml_ins
        fi

        if ! hash mainline &>/dev/null; then
            printf "${CYAN}mainline${normal} is not installed (GUI and cmd tool for managing installation of (newer) kernel versions)\n"
            readyn -p "Install mainline?" mainl_ins
            if [[ $mainl_ins == 'y' ]]; then
                if [[ "$distro" == 'Ubuntu' ]]; then
                    sudo add-apt-repository ppa:cappelikan/ppa 
                    eval "${pac_up}" 
                    eval "$pac_ins_y mainline"
                else
                    eval "$pac_ins_y libgee-0.8-dev git libjson-glib-dev libvte-2.91-dev valac aria2 lsb-release" 
                    git clone https://github.com/bkw777/mainline.git $TMPDIR 
                    (cd $TMPDIR/mainline
                    make
                    sudo make install) 
                fi
            fi
            unset mainl_ins
        fi 

        if ! hash ppa-purge &>/dev/null && test -n "$(apt search ppa-purge 2>/dev/null | awk 'NR>2{print;}')"; then
            printf "${CYAN}ppa-purge${normal} is not installed (cmd tool for disabling installed PPA's)\n"
            readyn -p "Install ppa-purge?" ppa_ins
            if [[ $ppa_ins == 'y' ]]; then
                eval "$pac_ins_y ppa-purge"
            fi
            unset ppa_ins
        fi
    fi

    if ! hash nala &>/dev/null && test -n "$(apt search nala 2>/dev/null | awk 'NR>2{print;}')"; then
        printf "${CYAN}nala${normal} is not installed (A TUI wrapper for apt install, update, upgrade, search, etc..)\n"
        readyn -p "Install nala?" nala_ins
        if [[ $nala_ins == 'y' ]]; then
            eval "$pac_ins_y nala"
            pac="nala"
            pac_ins="sudo nala install"
            pac_up="sudo nala update"
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

    if test -z "$(pacman -Q pacman-contrib 2>/dev/null)"; then
        printf "${CYAN}pacman-contrib${normal} is not installed (Includes tools like pactree, pacsearch, pacdiff..)\n"
        readyn -p 'Install pacman-contrib package?' -c '! hash pactree &> /dev/null' pacmn_cntr
        if [[ "$pacmn_cntr" == 'y' ]]; then
            sudo pacman -Su pacman-contrib
        fi
    fi
    unset pacmn_cntr

    if ! hash yay &>/dev/null; then
        printf "${CYAN}yay${normal} is not installed (Pacman wrapper for installing AUR packages, needed for yay-fzf-install)\n"
        readyn -p "Install yay?" insyay
        if [[ "y" == "$insyay" ]]; then
            if hash curl &>/dev/null && ! test -f $SCRIPT_DIR/AUR_installers/install_yay.sh; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_yay.sh)
            else
                . $SCRIPT_DIR/AUR_installers/install_yay.sh
            fi
            if hash yay &>/dev/null; then
                AUR_pac="yay"
                AUR_up="yay -Syu"
                AUR_ins="yay -S"
                AUR_search="yay -Ss"
                AUR_ls_ins="yay -Q"
            fi
        fi
        unset insyay
    fi

    if hash pamac &>/dev/null; then
        if ! test -f $SCRIPT_DIR/checks/check_pamac.sh; then
            source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_pamac.sh)
        else
            . $SCRIPT_DIR/checks/check_pamac.sh
        fi
    fi

    if ! test -z "$AUR_ls_ins" && test -z "$(eval ${AUR_ls_ins} | grep pacseek 2>/dev/null)"; then
        printf "${CYAN}pacseek${normal} (A TUI for managing packages from pacman and AUR) is not installed\n"
        readyn -p "Install pacseek? " pacs_ins
        if [[ "$pacs_ins" == 'y' ]]; then
            eval "yes | ${AUR_ins} pacseek"
        fi
        unset pacs_ins
    fi
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check for polkit related files in '/etc/polkit', '/etc/polkit-1/rules.d/' and '/etc/polkit-1/localauthority.conf.d/'"

if ! sudo test -f /etc/polkit/49-nopasswd_global.pkla && ! sudo test -f /etc/polkit-1/localauthority.conf.d/90-nopasswd_global.conf && ! sudo test -f /etc/polkit-1/rules.d/90-nopasswd_global.rules; then
    readyn -Y "YELLOW" -p "Install polkit files for automatic authentication for passwords?" plkit
    if [[ "y" == "$plkit" ]]; then
        if ! test -f $SCRIPT_DIR/install_polkit_wheel.sh; then
            source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_polkit_wheel.sh)
        else
            . $SCRIPT_DIR/install_polkit_wheel.sh
        fi
    fi
    unset plkit
fi

SCRIPT_DIR=$(get-script-dir)

if ! test -f $SCRIPT_DIR/checks/check_envvar.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh)
else
    . $SCRIPT_DIR/checks/check_envvar.sh
fi

if ! test -f $SCRIPT_DIR/checks/checkn_completions_dir.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)
else
    . $SCRIPT_DIR/checks/check_completions_dir.sh
fi

# Appimagelauncher

if ! hash AppImageLauncher &>/dev/null; then
    printf "${GREEN}If you want to install applications using appimages, there is a helper called 'appimagelauncher'\n"
    readyn -p "Check if appimage ready and install appimagelauncher?" appimage_install
    if [[ "$appimage_install" == 'y' ]]; then
        if ! test -f $SCRIPT_DIR/install_appimagelauncher.sh; then
            source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_appimagelauncher.sh)
        else
            . $SCRIPT_DIR/install_appimagelauncher.sh
        fi
    fi
fi

# Flatpak

#if ! hash flatpak &> /dev/null; then
#printf "%s\n" "${blue}No flatpak detected. (Independent package manager from Red Hat)${normal}"
readyn -p "Install (or just configure) Flatpak?" -c "test -z \"$FLATPAK\"" insflpk
if [[ "y" == "$insflpk" ]]; then
    if ! test -f $SCRIPT_DIR/install_flatpak.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_flatpak.sh)
    else
        . $SCRIPT_DIR/install_flatpak.sh
    fi
fi

if ! hash snap &>/dev/null; then
    printf "%s\n" "${blue}No snap detected. (Independent package manager from Canonical)${normal}"
    readyn -Y "MAGENTA" -p "Install snap?" -n inssnap
    if [[ "y" == "$inssnap" ]]; then
        if ! test -f $SCRIPT_DIR/install_snapd.sh; then
            source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_snapd.sh)
        else
            . $SCRIPT_DIR/install_snapd.sh
        fi
    fi
fi
unset inssnap

# Eza prompt

readyn -p "Install eza? (A modern replacement for ls)" -c "! hash eza &> /dev/null" rmp

if [[ "y" == "$rmp" ]]; then
    if ! test -f $SCRIPT_DIR/install_eza.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_eza.sh)
    else
        . $SCRIPT_DIR/install_eza.sh
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
    cpgi="all advcpmv xcp none"
    cpgp="[All/advcpmv/xcp/none]: "
    color="GREEN"
fi

reade -Q "$color" -i "$cpgi" -p "Install advcpmv, xcp, all or none? $cpgp" cpg
if [[ "all" == "$cpg" ]] || [[ "advcpmv" == "$cpg" ]]; then
    if ! test -f $SCRIPT_DIR/install_advcpmv.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_advcpmv.sh)
    else
        . $SCRIPT_DIR/install_advcpmv.sh
    fi
fi
if [[ "all" == "$cpg" ]] || [[ "xcp" == "$cpg" ]]; then
    if ! test -f $SCRIPT_DIR/install_xcp.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_xcp.sh)
    else
        . $SCRIPT_DIR/install_xcp.sh
    fi
fi
unset cpg cpgi cpgp color

# Rm prompt

readyn -p "Install rm-prompt? (Rm but lists files/directories before deletion)" -c "! hash rm-prompt &> /dev/null" rmp

if [[ "y" == "$rmp" ]]; then
    if ! test -f $SCRIPT_DIR/install_rmprompt.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_rmprompt.sh)
    else
        $SCRIPT_DIR/install_rmprompt.sh
    fi
fi
unset rmp

# Fzf (Fuzzy Finder)

readyn -p "Install fzf? (Fuzzy file/folder finder - replaces Ctrl-R/reverse-search, binds fzf search files on Ctrl+T and fuzzy search directories on Alt-C + Custom script: Ctrl-f becomes system-wide file opener)" -c "! hash fzf &> /dev/null" findr

if [[ "y" == "$findr" ]]; then
    if ! test -f $SCRIPT_DIR/install_fzf.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_fzf.sh)
    else
        . $SCRIPT_DIR/install_fzf.sh
    fi
fi
unset findr

# Ack prompt

readyn -c "! hash ack &> /dev/null" -p "Install ack? (A modern replacement for grep - finds lines in shell output)" ack

if [[ "y" == "$ack" ]]; then
    if ! test -f $SCRIPT_DIR/install_ack.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ack.sh)
    else
        . $SCRIPT_DIR/install_ack.sh
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
if [[ "all" == "$dua_dust_ncdu" ]] || [[ "dua" == "$dua_dust_ncdu" ]]; then
    if ! test -f $SCRIPT_DIR/install_dua_cli.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_dua_cli.sh)
    else
        . $SCRIPT_DIR/install_dua_cli.sh
    fi
fi
if [[ "all" == "$dua_dust_ncdu" ]] || [[ "dust" == "$dua_dust_ncdu" ]]; then
    if ! test -f $SCRIPT_DIR/install_dust.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_dust.sh)
    else
        . $SCRIPT_DIR/install_dust.sh
    fi
fi
if [[ "all" == "$dua_dust_ncdu" ]] || [[ "ncdu" == "$dua_dust_ncdu" ]]; then
    if ! test -f $SCRIPT_DIR/install_ncdu.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ncdu.sh)
    else
        . $SCRIPT_DIR/install_ncdu.sh
    fi
fi
unset dua_dust_ncdu color pre prmpt

# Duf and Dysk - Df replacement

color='GREEN'
color1="${GREEN}"
pre="duf dysk both none"
prmpt=" [Duf/dysk/both/none]: "
if ! hash dysk &>/dev/null && hash duf &>/dev/null; then
    pre="dysk duf both none"
    prmpt=" [Dysk/duf/both/none]: "
elif hash dysk &>/dev/null && hash duf &>/dev/null; then
    color='YELLOW'
    color1="${YELLOW}"
    pre="none duf dysk both"
    prmpt=" [None/duf/dysk/both]: "
fi

reade -Q "$color" -i "$pre" -p "Install ${CYAN}duf${color1}, ${CYAN}dysk${color1} or both? (Both are modern replacements for df - tools list hard drive disk space)$prmpt" duf_dysk
if [[ "both" == "$duf_dysk" ]] || [[ "duf" == "$duf_dysk" ]]; then
    if ! test -f $SCRIPT_DIR/install_duf.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_duf.sh)
    else
        . $SCRIPT_DIR/install_duf.sh
    fi
fi
if [[ "both" == "$duf_dysk" ]] || [[ "dysk" == "$duf_dysk" ]]; then
    if ! test -f $SCRIPT_DIR/install_dysk.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_dysk.sh)
    else
        . $SCRIPT_DIR/install_dysk.sh
    fi
fi
unset duf_dysk color pre prmpt

# Bash alias completions

readyn -p "Install bash completions for aliases in ~/.bash_completion.d?" -c "! test -f ~/.bash_completion.d/complete_alias" compl
if [[ "y" == "$compl" ]]; then
    if ! test -f $SCRIPT_DIR/install_bashalias_completions.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bashalias_completions.sh)
    else
        . $SCRIPT_DIR/install_bashalias_completions.sh
    fi
fi
unset compl

# Python completions

readyn -p "Install python completions in ~/.bash_completion.d?" -c "! hash activate-global-python-argcomplete &> /dev/null" pycomp
if [[ "y" == "$pycomp" ]]; then
    if ! test -f $SCRIPT_DIR/install_python_completions.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_python_completions.sh)
    else
        . $SCRIPT_DIR/install_python_completions.sh
    fi
fi
unset pycomp

SCRIPT_DIR=$(get-script-dir)

# Xresources

xterm=$SCRIPT_DIR/xterm/.Xresources

if ! test -f $xterm; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/xterm/.Xresources
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

#readyn -p "Install reade, readyn and yes-edit-no?" -c 'test -f ~/.bash_aliases.d/reade' insrde
#if test "$insrde" == 'y'; then
#    if ! test -f install_reade_readyn.sh; then
#         source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_reade_readyn.sh)
#    else
#        ./install_reade_readyn.sh
#    fi
#fi
#unset insrde

# Aliases

readyn -p "Install bash aliases and other config?" scripts
if [[ "y" == "$scripts" ]]; then

    if ! test -f $SCRIPT_DIR/checks/check_aliases_dir.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/checks/check_aliases_dir.sh)
    else
        . $SCRIPT_DIR/checks/check_aliases_dir.sh
    fi
    if ! test -f $SCRIPT_DIR/install_aliases.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/install_aliases.sh)
    else
        . $SCRIPT_DIR/install_aliases.sh
    fi
fi

# Hhighlighter (or just h)

readyn -c "! hash h &> /dev/null" -p "Install hhighlighter (or just h)? (A tiny utility to highlight multiple keywords with different colors in a textoutput)" h
if [[ "y" == "$h" ]]; then
    if ! hash ack &>/dev/null; then
        printf "For ${CYAN}hhighlighter${normal} to work, ${CYAN}ack${normal} needs to be installed beforehand.\n"
        readyn -p "Install ack and then hhighlighter?" ansr
        if [[ "$ansr" == 'y' ]]; then
            if ! test -f $SCRIPT_DIR/install_ack.sh; then
                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ack.sh)
            else
                . $SCRIPT_DIR/install_ack.sh
            fi
        else
            break
        fi
        unset ansr
    fi
    if ! test -f $SCRIPT_DIR/install_hhighlighter.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_hhighlighter.sh)
    else
        . $SCRIPT_DIR/install_hhighlighter.sh
    fi
fi
unset h

test -n "$BASH_VERSION" && source ~/.bashrc &>/dev/null
test -n "$ZSH_VERSION" && source ~/.zshrc &>/dev/null

if ! test -f checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi

SCRIPT_DIR=$(get-script-dir)

# Nerdfonts

readyn -p "Install a Nerdfont? (Type of font with icons to distinguish filetypes in the terminal + other types of icons)" nstll_nerdfont

if [[ "y" == "$nstll_nerdfont" ]]; then
    if ! test -f $SCRIPT_DIR/install_nerdfonts.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nerdfonts.sh)
    else
        . $SCRIPT_DIR/install_nerdfonts.sh
    fi
fi
unset nstll_nerdfont

# Kitty (Terminal emulator)

readyn -p "Install Kitty? (Terminal emulator)" -c "! hash kitty &> /dev/null" kittn

if [[ "y" == "$kittn" ]]; then
    if ! test -f $SCRIPT_DIR/install_kitty.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_kitty.sh)
    else
        . $SCRIPT_DIR/install_kitty.sh
    fi
fi
unset kittn

# Keybinds

if ! test -f install_keybinds.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_keybinds.sh)
else
    . ./install_keybinds.sh
fi

# Bash Preexec

readyn -p "Install pre-execution hooks for bash in ~/.bash_preexec?" -c "! test -f ~/.bash_preexec.sh || ! test -f /root/.bash_preexec.sh" bash_preexec
if [[ "y" == "$bash_preexec" ]]; then
    if ! test -f $SCRIPT_DIR/install_bash_preexec.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bash_preexec.sh)
    else
        . $SCRIPT_DIR/install_bash_preexec.sh
    fi
fi
unset bash_preexec

# Pipewire (better sound)

readyn -p "Install and configure pipewire? (sound system - pulseaudio replacement)" -c '! hash wireplumber &> /dev/null || ! test -f ~/.config/pipewire/pipewire-pulse.conf.d/switch-on-connect.conf;' pipew
if [[ "$pipew" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_pipewire.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipewire.sh)
    else
        . $SCRIPT_DIR/install_pipewire.sh
    fi
fi
unset pipew

# Moar (Custom pager instead of less)

readyn -p "Install moar? (Custom pager/less replacement - awesome default options)" -c '! hash moar &> /dev/null;' moar

if [[ "$moar" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_moar.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_moar.sh)
    else
        . $SCRIPT_DIR/install_moar.sh
    fi
fi
unset moar

# Nano (Editor)

readyn -p "Install nano + config? (Simple terminal editor)" -c "! hash nano &> /dev/null || ! test -f ~/.nanorc &> /dev/null" nno

if [[ "y" == "$nno" ]]; then
    if ! test -f $SCRIPT_DIR/install_nano.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nano.sh)
    else
        . $SCRIPT_DIR/install_nano.sh
    fi
fi
unset nno

# Nvim (Editor)

readyn -p "Install neovim + config? (Complex terminal editor)" -c "! hash nvim &> /dev/null" nvm

if [[ "y" == "$nvm" ]]; then
    if ! test -f $SCRIPT_DIR/install_nvim.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nvim.sh)
    else
        . $SCRIPT_DIR/install_nvim.sh
    fi
fi
unset nvm

# Rg (ripgrep)

readyn -p "Install ripgrep? (recursively searches the current directory for lines matching a regex pattern)" -c "! hash rg &> /dev/null" rgrp
if [[ "y" == "$rgrp" ]]; then
    if ! test -f $SCRIPT_DIR/install_ripgrep.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ripgrep.sh)
    else
        . $SCRIPT_DIR/install_ripgrep.sh
    fi
fi
unset rgrp

# Ast-grep (ast-grep)

readyn -p "Install ast-grep? (Search and Rewrite code at large scale using precise AST pattern)" -c "! hash ast-grep &> /dev/null" rgrp
if [[ "y" == "$rgrp" ]]; then
    if ! test -f $SCRIPT_DIR/install_ast-grep.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ast-grep.sh)
    else
        . $SCRIPT_DIR/install_ast-grep.sh
    fi
fi
unset rgrp

# Git

readyn -p "Install Git and configure? (Project managing tool)" -n -c "! hash git &> /dev/null && test -f ~/.gitconfig" git_ins

if [[ "y" == "$git_ins" ]]; then
    if ! test -f $SCRIPT_DIR/install_git.sh; then
        ins_git=$(mktemp)
        curl -o $ins_git https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_git.sh
        chmod u+x "$ins_git"
        eval "$ins_git 'global'"
    else
        . $SCRIPT_DIR/install_git.sh 'global'
    fi
fi
unset git_ins

# Lazygit

readyn -p "Install Lazygit?" -c "! hash lazygit &> /dev/null" git_ins
if [[ "y" == "$git_ins" ]]; then

    if ! test -f $SCRIPT_DIR/install_lazygit.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_lazygit.sh)
    else
        . $SCRIPT_DIR/install_lazygit.sh
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
    if ! test -f $SCRIPT_DIR/install_ranger.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ranger.sh)
    else
        . $SCRIPT_DIR/install_ranger.sh
    fi
fi
unset rngr

# Tmux (File explorer)

readyn -p "Install Tmux? (Terminal multiplexer)" -c "! hash tmux &> /dev/null" tmx
if [[ "y" == "$tmx" ]]; then
    if ! test -f $SCRIPT_DIR/install_tmux.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_tmux.sh)
    else
        . $SCRIPT_DIR/install_tmux.sh
    fi
fi
unset tmx

# Bat

readyn -p "Install Bat? (Cat clone with syntax highlighting)" -c "! hash bat &> /dev/null && ! hash batcat &> /dev/null" bat

if [[ $bat == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_bat.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_bat.sh)
    else
        . $SCRIPT_DIR/install_bat.sh
    fi
fi
unset bat

# Neofetch

readyn -p "Install neofetch/fastfetch/screenFetch)? (Terminal taskmanager - system information tool)" -c "! hash fastfetch &> /dev/null && ! hash screenfetch &> /dev/null" tojump

if [[ "$tojump" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_neofetch_onefetch.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_neofetch_onefetch.sh)
    else
        . $SCRIPT_DIR/install_neofetch_onefetch.sh
    fi
fi
unset tojump

# Btop

readyn -p "Install Btop? (A processmanager with a fastly improved TUI relative to top/htop written in C++)" -c "! hash btop &> /dev/null" tojump
if [[ "$tojump" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_btop.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_btop.sh)
    else
        . $SCRIPT_DIR/install_btop.sh
    fi
fi
unset tojump

# Autojump
# -c "! hash autojump &> /dev/null"

readyn -n -p "Install autojump? (jump to folders using 'bookmarks' - j_ )" tojump
if [[ "$tojump" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_autojump.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_autojump.sh)
    else
        . $SCRIPT_DIR/install_autojump.sh
    fi
fi
unset tojump

# Zoxide

readyn -p "Install zoxide? (A cd that guesses the right path based on a history)" -c "! hash zoxide &> /dev/null" zoxs
if [[ "$zoxs" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_zoxide.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_zoxide.sh)
    else
        . $SCRIPT_DIR/install_zoxide.sh
    fi
fi
unset zoxs

# Starship

readyn -p "Install Starship? (Snazzy looking prompt)" -c "! hash starship &> /dev/null" strshp
if [[ "$strshp" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_starship.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_starship.sh)
    else
        . $SCRIPT_DIR/install_starship.sh
    fi
fi
unset strshp

# Thefuck
# i mean pay-respects

readyn -p "Install 'pay-respects'? (Correct last command that ended with an error - 'thefuck' successor)" -c "! hash pay-respects &> /dev/null" tf
if [[ "$tf" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_f.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_f.sh)
    else
        . $SCRIPT_DIR/install_f.sh
    fi
fi
unset tf

# Nmap

readyn -p "Install nmap? (Network port scanning tool)" -c '! hash nmap &> /dev/null' nmap
if [[ "$nmap" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_nmap.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_nmap.sh)
    else
        . $SCRIPT_DIR/install_nmap.sh
    fi
fi
unset nmap

# Ufw / Gufw

readyn -p "Install ufw? (Uncomplicated firewall - Iptables wrapper)" -c "! hash ufw &> /dev/null" ins_ufw
if [[ "$ins_ufw" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_ufw.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ufw.sh)
    else
        . $SCRIPT_DIR/install_ufw.sh
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
#    if ! test -f install_netstat.sh; then
#        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_netstat.sh)
#    else
#        ./install_netstat.sh
#    fi
#fi
#unset tojump
#unset pre color othr prmpt

# Lazydocker

readyn -p "Install lazydocker?" -c "! hash lazydocker &> /dev/null" git_ins
if [[ "y" == "$git_ins" ]]; then
    if ! test -f $SCRIPT_DIR/install_lazydocker.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_lazydocker.sh)
    else
        . $SCRIPT_DIR/install_lazydocker.sh
    fi
fi
unset git_ins

# Exiftool (Metadata wiper)

readyn -p "Install exiftool? (Metadata wiper for files)" -c "! hash exiftool &> /dev/null" exif_t
if [[ "$exif_t" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_exiftool.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_exiftool.sh)
    else
        . $SCRIPT_DIR/install_exiftool.sh
    fi
fi
unset exif_t

# Testdisk (File recovery tool)

readyn -p "Install testdisk? (File recovery tool)" -c "! hash testdisk &> /dev/null" kittn
if [[ "y" == "$kittn" ]]; then
    if ! test -f $SCRIPT_DIR/install_testdisk.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_testdisk.sh)
    else
        . $SCRIPT_DIR/install_testdisk.sh
    fi
fi
unset kittn

# Ffmpeg

readyn -p "Install ffmpeg? (video/audio/image file converter)" -c "! hash ffmpeg &> /dev/null" ffmpg
if [[ "$ffmpg" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_ffmpeg.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ffmpeg.sh)
    else
        . $SCRIPT_DIR/install_ffmpeg.sh
    fi
fi
unset ffmpg

# Yt-dlp

readyn -p "Install yt-dlp? (youtube video downloader)" -c "! hash yt-dlp &> /dev/null" yt_dlp
if [[ "$yt_dlp" == "y" ]]; then
    if ! test -f $SCRIPT_DIR/install_yt-dlp.sh; then
        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_yt-dlp.sh)
    else
        . $SCRIPT_DIR/install_yt-dlp.sh
    fi
fi
unset yt_dlp

# Environment.env

#pre='y'
#othr='n'
#color='GREEN'
#prmpt='[Y/n]: '
#echo "Next $(tput setaf 1)sudo$(tput sgr0) check for /root/.environment' "
#if test -f ~/.environment && sudo test -f /root/.environment; then
#    pre='n'
#    othr='y'
#    color='YELLOW'
#    prmpt='[N/y]: '
#fi

#reade -Q "$color" -i "$pre" -p "Check existence/create .environment and link it to .bashrc in $HOME/ and /root/? $prmpt" "$othr" envvars
#if [[ "$envvars" == "y" ]] || [[ -z "$envvars" ]]  then
if ! test -f $SCRIPT_DIR/install_envvars.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_envvars.sh)
else
    . $SCRIPT_DIR/install_envvars.sh
fi
#fi

# Check one last time if ~/.bash_preexec - for both $USER and root - is the last line in their ~/.bash_profile and ~/.bashrc

#if ! test -f ./checks/check_bash_source_order.sh; then
#    if hash curl &>/dev/null; then
#        source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_bash_source_order.sh)
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
    [ -n "$BASH_VERSION" ] && set -o posix
    [ -n "$ZSH_VERSION" ] && set -o posixaliases
    eval "alias | $PAGER"
fi

readyn -p 'List all functions?' fncts
if [[ "$fncts" == 'y' ]]; then
    [ -n "$BASH_VERSION" ] && set -o posix
    [ -n "$ZSH_VERSION" ] && set -o posixaliases
    eval "declare -f | $PAGER"
fi

unset fncts allis
