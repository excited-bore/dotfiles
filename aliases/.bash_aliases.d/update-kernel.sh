if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

DIR=$(get-script-dir)

if test -f ~/.bash_aliases.d/package_managers.sh; then
    . ~/.bash_aliases.d/package_managers.sh
fi
if test -f $DIR/aliases/.bash_aliases.d/package_managers.sh; then
    . $DIR/aliases/.bash_aliases.d/package_managers.sh
fi

if test -f ~/.bash_aliases.d/package_managers.sh || test -f $DIR/aliases/.bash_aliases.d/package_managers.sh; then

    function update-kernel(){
        local latest_lts latest_lts1 choices
        
        if [[ "$distro_base" == 'Debian' ]]; then
            choices="lts liquorix" 
        elif [[ "$distro_base" == "Arch" ]]; then
                
            if ! [[ "$distro" == 'Arch' ]] && test -z $(pacman -Ss linux-lts); then
                local nstall_arch
                printf "${CYAN}$distro${GREEN} needs to have ${CYAN}Arch-specific${GREEN} packages available (and therefor Arch-specific repositories configured) in order to install up-to-date even just the ${CYAN}long-term support kernel${normal}\n" 
                readyn -p "Install Arch specific repositories in ${CYAN}/etc/pacman.d/mirrorlist${GREEN}, then update?" nstall_arch 
                if [[ "$nstall_arch" == 'y' ]]; then
                    if ! hash fzf &> /dev/null; then
                        printf "${CYAN}fzf${GREEN} not installed and needed for 'pacman-fzf-add-arch-repositories'. Installing..${normal}\n" 
                        sudo pacman -Su fzf --noconfirm 
                    fi
                    if test -f ~/.bash_aliases.d/package_managers.sh; then
                        . ~/.bash_aliases.d/package_managers.sh
                    fi
                    if test -f $DIR/aliases/.bash_aliases.d/package_managers.sh; then
                        . $DIR/aliases/.bash_aliases.d/package_managers.sh
                    fi
                    pacman-fzf-add-arch-repositories
                fi
                
                if test -n "$(pacman -Ss linux-lts)"; then
                    if test -z "$AUR"; then
                        local insyay
                        printf "${GREEN}If you want to install the custom kernels ${CYAN}'Liquorix (zen-based)', 'xanmod', 'libre', 'clear' or '-ck'${GREEN}, an AUR installer needs to be available${normal}\n" 
                        printf "${CYAN}yay${GREEN} is a popular, go-to AUR installer/pacman wrapper${normal}\n"
                        readyn -p "Install yay?" insyay
                        if [[ "y" == "$insyay" ]]; then
                            if hash curl &>/dev/null && ! test -f $SCRIPT_DIR/AUR_installers/install_yay.sh; then
                                source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/AUR_installers/install_yay.sh)
                            else
                                . $DIR/AUR_installers/install_yay.sh
                            fi
                            if hash yay &>/dev/null; then
                                AUR_pac="yay"
                                AUR_up="yay -Syu"
                                AUR_ins="yay -S"
                                AUR_search="yay -Ss"
                                AUR_ls_ins="yay -Q"
                            fi
                        fi
                    elif test -n "$AUR" && [[ "$AUR" == 'pamac' ]] && grep -q "#EnableAUR" /etc/pamac.conf; then
                        local nable_aur
                        printf "${GREEN}If you want to install the custom kernels ${CYAN}'Liquorix (zen-based)', 'xanmod', 'libre', 'clear' or '-ck'${GREEN}, an AUR installer needs to be available${normal}\n" 
                        printf "${CYAN}pamac${GREEN} is installed but is not configured to install AUR packages${normal}\n" 
                        readyn -p "Enable AUR for pamac?" nable_aur
                        if [[ "$nable_aur" == 'y' ]]; then
                            sudo sed -i 's|#EnableAUR|EnableAUR|g' /etc/pamac.conf 
                        fi
                    fi
                     
                    if test -n "$AUR" && ! ([[ "$AUR" == 'pamac' ]] && grep -q "#EnableAUR" /etc/pamac.conf); then
                        choices="long-term-support hardened realtime zen" 
                    else
                        choices="long-term-support hardened realtime zen liquorix xanmod libre clear -ck"
                    fi
                fi
            fi
        fi
    }

fi 

