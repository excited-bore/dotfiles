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

    function list-installed-kernels(){
     
        if [[ "$distro_base" == 'Arch' ]]; then
         
            local insk
             
            if test -n "$AUR_search_ins"; then
                insk=$(eval "$AUR_search_ins linux | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv 'headers|docs|tool|kernel module' | sed 's|local/||g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V")
            else
                insk=$(eval "$pac_search_ins linux | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv 'headers|docs|tool|kernel module' | sed 's|local/||g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V")
            fi

            local prmpth="${green}%-15s %-20s %-25s %-25s\n" 
            local prmpth1="${cyan}%s\n\n" 
             
            # pamac list --files linux54 | grep /usr/lib/modules/ | sed 's|/usr/lib/modules/\([^/]*\)/.*|\1|g' | uniq
            printf "${GREEN}Installed Kernels:\n${normal}"
            printf "${GREEN}%-15s %-20s %-25s %-25s\n" "Name" "Version" "Headers" "Headers-Version-Same"
             
            local kv kh khv 
            while IFS= read -r k; do
                
                kv=$(pacman -Qi "$k" | grep Version | awk '{$1="";$2=""; print}' | xargs) 
               
                if [[ $k == "linux-meta" ]]; then
                    kh="linux-headers-meta" 
                elif [[ $k == "linux-lts-meta" ]]; then
                    kh="linux-lts-headers-meta" 
                else
                    kh="$k-headers" 
                fi
                
                if test -n "$(pacman -Qi "$kh" 2> /dev/null)"; then
                    [[ "$kv" == "$(pacman -Qi "$kh" | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&  
                        khv="${GREEN}o" ||
                        khv="${RED}x"
                else
                    kh="${red}Not installed" 
                    khv=""
                fi
                printf "$prmpth" "$k" "$kv" "$kh" "$khv"  
            done <<< $insk
        fi
    } 

    function update-kernel(){
        local latest_lts latest_lts1 choices
        
        if [[ "$distro_base" == 'Debian' ]]; then
            choices="lts liquorix" 
        elif [[ "$distro_base" == "Arch" ]]; then

            if test -z "$AUR_pac"; then
                local insyay
                printf "${GREEN}If you want to install the custom kernels ${CYAN}'Liquorix (zen-based)', 'xanmod', 'libre', 'clear' or '-ck'${GREEN}, an AUR installer needs to be available${normal}\n" 
                printf "${CYAN}yay${GREEN} is a popular, go-to AUR installer/pacman wrapper${normal}\n"
                readyn -p "Install ${CYAN}yay${GREEN}?" insyay
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
            elif test -n "$AUR_pac" && [[ "$AUR_pac" == 'pamac' ]] && grep -q "#EnableAUR" /etc/pamac.conf; then
                
                local nable_aur
                if [[ "$distro" == 'Manjaro' ]]; then
                    printf "${GREEN}If you want to install the ${CYAN}latest longterm support kernel on Manjaro${GREEN} (or a custom kernel like ${CYAN}'Liquorix (zen-based)', 'xanmod', 'libre', 'clear' or '-ck'${GREEN}, the AUR needs to be available${normal}\n" 
                else 
                    printf "${GREEN}If you want to install the custom kernels ${CYAN}'Liquorix (zen-based)', 'xanmod', 'libre', 'clear' or '-ck'${GREEN}, the AUR needs to be available${normal}\n" 
                fi
                printf "${CYAN}pamac${GREEN} is installed but is not configured to allow for installing AUR packages${normal}\n" 
                readyn -p "Enable installing AUR packages for pamac?" nable_aur
                if [[ "$nable_aur" == 'y' ]]; then
                    sudo sed -i 's|#EnableAUR|EnableAUR|g' /etc/pamac.conf 
                elif [[ "$distro" == 'Manjaro' ]]; then  
                    local nstall_arch
                    printf "${green}Another way to install the latest kernel for ${GREEN}$distro${green} is to basically 'change distribution to ${CYAN}Arch${green}' by configuring Arch-specific repositories (also called mirrors) for pacman to allow the installation of 'linux-lts' (and other kernels)\n${YELLOW}(Warning - this process is ${RED}highly risky when done incorrectly${YELLOW} and could lead to f.ex. pacman becoming unusable if not allowing packages to downgrade while updating after configuring said repositories, also certain $distro-specific packages (like mhwd or pacman-mirrors) will become impossible to install/update/maintain\!\!)\n" 
                    readyn -n -p "Install Arch specific repositories in ${CYAN}/etc/pacman.d/mirrorlist${YELLOW}, then update?\n" nstall_arch 
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
                fi
            fi
             
            list-installed-kernels

            echo 

            if [[ "$distro_base" == 'Arch' ]]; then
               
                local prmpth="${green}%-15s %-20s %-25s %-25s\n" 
                local prmpth1="${cyan}%s\n\n" 
                
                printf "${GREEN}Available Kernels:\n"
                printf "${GREEN}%-15s %-20s %-25s %-25s\n" "Name" "Version" "Headers" "Headers-Version-Same"
                
                
                local available stablev stablehv ltsv ltshv harnenedv hardenedhv rtv rthv rtltsv rtltshv zenv zenhv 
                if test -n "$(pacman -Si 'linux' 2> /dev/null)"; then
                    available="linux" 
                    stablev=$(pacman -Si 'linux' | grep Version | awk '{$1="";$2=""; print}' | xargs) 
                    [[ "$stablev" == "$(pacman -Si 'linux-headers' | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&
                        stablehv="${GREEN}o" ||
                        stablehv="${RED}x"
                    printf "$prmpth" "linux" "$stablev" "linux-headers" "$stablehv" 
                    printf "$prmpth1" "'Vanilla Linux kernel and modules, with a few patches applied'"
                fi
               
                # Manjaro kernels 
                if test -n "$(pacman -Si 'linux-meta' 2> /dev/null)"; then
                    available="$available linux-meta" 
                    local lhv lv=$(pacman -Si 'linux-meta' | grep Version | awk '{$1="";$2=""; print}' | xargs) 
                    [[ "$lv" == "$(pacman -Si 'linux-headers-meta' | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&
                        lhv="${GREEN}o" ||
                        lhv="${RED}x"
                    printf "$prmpth" "linux-meta" "$lv" "linux-headers-meta" "$lhv" 
                    printf "$prmpth1" "'Manjaro stable kernel'"
                fi
               
                # Manjaro kernels 
                if test -n "$(pacman -Ss '^linux[0-9]+$' 2> /dev/null)"; then
                    local ks=$(eval "$pac_search '^linux[0-9]+$' | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv 'headers|docs|tool|kernel module|installed' | sed -E 's,core/|extra/|multilib/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sed 's/\(x[0-9]\)/\1./' | sort -rV | sed 's/\.//g'")                     available="$available $ks"
                    while IFS= read -r k; do
                        kv=$(pacman -Si "$k" | grep Version | awk '{$1="";$2=""; print}' | xargs) 
                        [[ "$kv" == "$(pacman -Si "$k-headers" | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&  
                            khv="${GREEN}o" ||
                            khv="${RED}x"
                        printf "$prmpth" "$k" "$kv" "$k-headers" "$khv" 
                    done <<< $ks
                    printf "$prmpth1" "'Vanilla Linux kernels and modules, indicated by version number (f.ex. linux612 is linux v6.12)'"
                fi
                 
                if test -n "$(pacman -Si 'linux-lts' 2> /dev/null)"; then
                    available="$available linux-lts" 
                    ltsv=$(pacman -Si 'linux-lts' | grep Version | awk '{$1="";$2=""; print}' | xargs) 
                    [[ "$ltsv" == "$(pacman -Si 'linux-lts-headers' | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&
                        ltshv="${GREEN}o" ||
                        ltshv="${RED}x"
                    printf "$prmpth" "linux-lts" "$ltsv" "linux-lts-headers" "$ltshv" 
                    printf "$prmpth1" "'Long-term support (LTS) Linux kernel and modules with configuration options targeting usage in servers.'"
                fi
              
                # Manjaro kernels 
                if test -n "$(pacman -Si 'linux-lts-meta' 2> /dev/null)"; then
                    available="$available linux-lts-meta" 
                    local lthv ltv 
                    ltv=$(pacman -Si 'linux-lts-meta' | grep Version | awk '{$1="";$2=""; print}' | xargs) 
                    [[ "$ltv" == "$(pacman -Si 'linux-lts-headers-meta' | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&
                        lthv="${GREEN}o" ||
                        lthv="${RED}x"
                    printf "$prmpth" "linux-lts-meta" "$ltv" "linux-lts-headers-meta" "$lthv" 
                    printf "$prmpth1" "'Manjaro LTS kernel'"
                fi
                 

                if test -n "$(pacman -Si 'linux-hardened' 2> /dev/null)"; then
                    available="$available linux-hardened" 
                    hardenedv=$(pacman -Si 'linux-hardened' | grep Version | awk '{$1="";$2=""; print}' | xargs) 
                    [[ "$hardenedv" == "$(pacman -Si 'linux-hardened-headers' | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&
                        hardenedhv="${GREEN}o" ||
                        hardenedhv="${RED}x"
                    printf "$prmpth" "linux-hardened" "$hardenedv" "linux-hardened-headers" "$hardenedhv" 
                    printf "$prmpth1" "'A security-focused Linux kernel applying a set of hardening patches to mitigate kernel and userspace exploits. It also enables more upstream kernel hardening features than \"linux\".'"
                fi
                
                if test -n "$(pacman -Si 'linux-rt' 2> /dev/null)"; then
                    available="$available linux-rt" 
                    rtv=$(pacman -Si 'linux-rt' | grep Version | awk '{$1="";$2=""; print}' | xargs) 
                    [[ "$rtv" == "$(pacman -Si 'linux-rt-headers' | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&
                        rthv="${GREEN}o" ||
                        rthv="${RED}x"
                    printf "$prmpth" "linux-rt" "$rtv" "linux-rt-headers" "$rthv" 
                    test -z "$(pacman -Si 'linux-rt-lts' 2> /dev/null)" && test -z "$(pacman -Ss '^linux[0-9]+$' 2> /dev/null)" &&
                        printf "$prmpth1" "'Maintained by a small group of core developers led by Ingo Molnar. This patch allows nearly all of the kernel to be preempted, with the exception of a few very small regions of code (\"raw_spinlock critical regions\"). This is done by replacing most kernel spinlocks with mutexes that support priority inheritance, as well as moving all interrupt and software interrupts to kernel threads.'"
                fi 
               
                # Manjaro kernels 
                if test -n "$(pacman -Ss '^linux[0-9]+-rt$' 2> /dev/null)"; then
                    local ks=$(eval "$pac_search '^linux[0-9]+-rt$' | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv 'headers|docs|tool|kernel module' | grep '^[^[:space:]]' | grep -iv 'installed' | sed -E 's,core/|extra/|multilib/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sed 's/\(x[0-9]\)/\1./' | sort -rV | sed 's/\.//g'")                     available="$available $ks"
                    while IFS= read -r k; do
                        local kv=$(pacman -Si "$k" | grep Version | awk '{$1="";$2=""; print}' | xargs) 
                        [[ "$kv" == "$(pacman -Si "$k-headers" | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&  
                            khv="${GREEN}o" ||
                            khv="${RED}x"
                        printf "$prmpth" "$k" "$kv" "$k-headers" "$khv" 
                    done <<< $ks
                    test -z "$(pacman -Si 'linux-rt-lts' 2> /dev/null)" &&
                        printf "$prmpth1" "'Maintained by a small group of core developers led by Ingo Molnar. This patch allows nearly all of the kernel to be preempted, with the exception of a few very small regions of code (\"raw_spinlock critical regions\"). This is done by replacing most kernel spinlocks with mutexes that support priority inheritance, as well as moving all interrupt and software interrupts to kernel threads.'" 
                fi
                 
               
                if test -n "$(pacman -Si 'linux-rt-lts' 2> /dev/null)"; then
                    available="$available linux-rt-lts" 
                    rtltsv=$(pacman -Si 'linux-rt-lts' | grep Version | awk '{$1="";$2=""; print}' | xargs) 
                    [[ "$rtltsv" == "$(pacman -Si 'linux-rt-lts-headers' | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&
                        rtltshv="${GREEN}o" ||
                        rtltshv="${RED}x"
                    printf "$prmpth" "linux-rt-lts" "$rtltsv" "linux-rt-lts-headers" "$rtltshv" 
                    printf "$prmpth1" "'Maintained by a small group of core developers led by Ingo Molnar. This patch allows nearly all of the kernel to be preempted, with the exception of a few very small regions of code (\"raw_spinlock critical regions\"). This is done by replacing most kernel spinlocks with mutexes that support priority inheritance, as well as moving all interrupt and software interrupts to kernel threads.'"
                fi
                
                if test -n "$(pacman -Si 'linux-zen' 2> /dev/null)"; then
                    available="$available linux-zen" 
                    zenv=$(pacman -Si 'linux-zen' | grep Version | awk '{$1="";$2=""; print}' | xargs) 
                    [[ "$zenv" == "$(pacman -Si 'linux-zen-headers' | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&
                        zenhv="${GREEN}o" ||
                        zenhv="${RED}x"
                    printf "$prmpth" "linux-zen" "$zenv" "linux-zen-headers" "$zenhv" 
                    printf "$prmpth1" "'Result of a collaborative effort of kernel hackers to provide the best Linux kernel possible for everyday systems.'"
                fi 
               

                if test -n "$AUR_search_q" && test -n "$AUR_info"; then
                    
                    readyn -p "These kernel packages were only from official repositories. Also list unofficial (AUR) kernel packages?" kern_AUR 
                    # local ltss=$(eval "$AUR_search_q linux-lts | grep 'linux-lts[[:digit:]+]' | cut -d- -f-2 | awk '{print \$1}' | uniq | tr '\n' ' ' | xargs")
                    # No header : linux-drm-tip-git linux-drm-next-git  
                    if hash fzf &> /dev/null; then
                        local kernel=$(eval "$AUR_search linux | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv 'headers|docs|tool|kernel module|installed' | sed -E 's,core/|extra/|multilib/|aur/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V | fzf --reverse --preview 'cat <(yay -Si {1})'")
                    fi
                     
                    #local b=$(pacman -Qs linux | grep -i -B 1 -E 'kernel [^module]|kernel,' --no-group-separator | grep -E -v 'headers|docs|tools' | grep '^[^[:space:]]' | sed 's|local/||g' | grep '^linux' | uniq | awk '{print $1}')
                         
                    #available="$available $ltss linux-lqx linux-git linux-mainline linux-next-git linux-drm-tip-git linux-drm-next-git linux-ck linux-clear linux-libre linux-pf linux-prjc linux-nitrous linux-vfio linux-vfio-lts linux-xanmod linux-xanmod-linux-bin-x64v1 linux-xanmod-linux-bin-x64v2 linux-xanmod-linux-bin-x64v3 linux-xanmod-lts linux-xanmod-lts-linux-bin-x64v1 linux-xanmod-lts-linux-bin-x64v2 linux-xanmod-lts-linux-bin-x64v3 linux-xanmod-edge linux-xanmod-edge-linux-bin-x64v2 linux-xanmod-edge-linux-bin-x64v3 linux-xanmod-edge-linux-bin-x64v4 linux-xanmod-rt linux-xanmod-bore linux-xanmod-anbox linux-cachyos" 
                else
                    if hash fzf &> /dev/null; then
                        local kernel=$(eval "$pac_search linux | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv 'headers|docs|tool|kernel module|installed' | sed -E 's,core/|extra/|multilib/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V | fzf --reverse --preview 'cat <(yay -Si {1})'")
                    fi
                fi
    
                if test -n "$kernel"; then
                    local kernelh="$kernel-headers" 
                    if [[ $kernel == "linux-meta" ]]; then
                        kernelh="linux-headers-meta" 
                    elif [[ $kernel == "linux-lts-meta" ]]; then
                        kernelh="linux-lts-headers-meta" 
                    fi
                     
                    local nstall_kh='n'
                    if test -n "$AUR_search_q" && test -n "$AUR_info"; then
                        if test -n "$(eval "$AUR_search_q $kernelh")" && test -z "$(pacman -Q $kernelh 2> /dev/null)"; then
                            readyn -p "Kernel header ${CYAN}'$kernelh'${GREEN} available and not installed (C header files that allow external kernel modules to function with the kernel).\nAlso install ${CYAN}$kernelh${GREEN}?" nstall_kh
                        else
                            printf "${YELLOW}No header packages found for $kernel${normal}\n"
                        fi
                    else  
                        if test -n "$(eval "$pac_search_q $kernelh")" && test -z "$(pacman -Q $kernelh 2> /dev/null)"; then
                            readyn -p "Kernel header ${CYAN}'$kernelh'${GREEN} available and not installed (C header files that allow external kernel modules to function with the kernel).\nAlso install ${CYAN}$kernelh${GREEN}?" nstall_kh
                        else
                           printf "${YELLOW}No header packages found for $kernel${normal}\n"
                        fi
                    fi
                     
                    if [[ $nstall_kh == 'y' ]]; then
                       if test -n "$AUR_ins"; then
                           eval "$AUR_ins $kernel $kernelh" 
                       else
                           eval "$pac_ins $kernel $kernelh" 
                       fi
                    else    
                       if test -n "$AUR_ins"; then
                           eval "$AUR_ins $kernel" 
                       else
                           eval "$pac_ins $kernel" 
                       fi
                    fi
                fi
            fi
        fi
    }

fi 
