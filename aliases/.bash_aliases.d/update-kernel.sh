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
    
        printf "${GREEN}Currently used kernel:\n${normal}"
        printf "${GREEN}%-20s %-20s\n" "Name/Version" "Headers"

        local prmptc="${green}%-20s %-20s\n" 
        local ch 
        test -d /lib/modules/$(uname -r)/build && test -n "$(ls /lib/modules/$(uname -r)/build/*)" &&
            ch="${GREEN}o" ||
            ch="${RED}x"

        printf "$prmptc" "$(uname -r)" "$ch" 
        echo 

        if [[ "$distro_base" == 'Arch' ]]; then
         
            local insk
             
            if test -n "$AUR_search_ins"; then
                insk=$(eval "$AUR_search_ins linux | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module' | sed 's|local/||g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V")
            else
                insk=$(eval "$pac_search_ins linux | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module' | sed 's|local/||g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V")
            fi

            local prmpth="${green}%-20s %-20s %-25s %-25s\n" 
             
            # pamac list --files linux54 | grep /usr/lib/modules/ | sed 's|/usr/lib/modules/\([^/]*\)/.*|\1|g' | uniq
            if test -n "$AUR_pac"; then
                printf "${GREEN}Installed kernels using pacman/$AUR_pac:\n${normal}"
            else
                printf "${GREEN}Installed kernels using pacman:\n${normal}"
            fi
            printf "${GREEN}%-20s %-20s %-25s %-25s\n" "Name" "Version" "Headers" "Headers-Version-Same"
             
            local kv kh khv 
            local known='n'
            local knownk=($(ls /lib/modules/)) knownk2=()
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
                    if pacman -Qi $k | grep 'Description' | grep -qi 'and headers'; then
                        kh="${green}Part of main kernel package" 
                    else 
                        kh="${red}Not installed" 
                    fi
                    khv=""
                fi
               
                known='n' 
                for i in ${knownk[@]}; do 
                    if [[ $known == 'n' ]] && pacman -Ql $k | grep -q $i; then
                        known='y'
                    else
                        knownk2+=("$i") 
                    fi
                done
                knownk=("${knownk2[@]}")
                knownk2=()
                printf "$prmpth" "$k" "$kv" "$kh" "$khv"  
                 
            done <<< $insk
          
            if (( ${#knownk[@]} != 0 )); then
                printf "${GREEN}Installed Custom Compiled Kernels:\n${normal}"
                printf "${GREEN}%-20s %-20s\n" "Name/Version" "Headers"
                local prmptc="${green}%-20s %-20s\n" 
                for i in "${knownk[@]}"; do
                    if test -n "$i"; then
                        test -d /lib/modules/$i/build && test -n "$(ls /lib/modules/$i/build/*)" &&
                            kh="${GREEN}o" ||
                            kh="${RED}x"
                        printf "$prmptc" "$i" "$kh"
                    fi
                done
            fi
        fi
    } 

    function update-kernel(){
        local latest_lts latest_lts1 choices
        
        if [[ "$distro_base" == 'Debian' ]]; then
            choices="lts liquorix" 
        elif [[ "$distro_base" == "Arch" ]]; then

            if ! hash fzf &> /dev/null; then
                printf "${CYAN}fzf${GREEN} not installed and needed for for listing possible kernels packages. Installing..${normal}\n" 
                sudo pacman -Su fzf --noconfirm 
            fi

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
                    local ks=$(eval "$pac_search '^linux[0-9]+$' | sed -n '1p; /^[^[:space:]]/ {N;/[\^n]*\n\t/!p;}' | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module|installed' | sed -E 's,core/|extra/|multilib/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sed 's/\(x[0-9]\)/\1./' | sort -rV | sed 's/\.//g'")                     available="$available $ks"
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
                    local ks=$(eval "$pac_search '^linux[0-9]+-rt$' | sed -n '1p; /^[^[:space:]]/ {N;/[\^n]*\n\t/!p;}' | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module' | grep '^[^[:space:]]' | grep -iv 'installed' | sed -E 's,core/|extra/|multilib/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sed 's/\(x[0-9]\)/\1./' | sort -rV | sed 's/\.//g'")                     available="$available $ks"
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
              
                local pre='newkernel keepcurrent' prmpt='What to do? [Newkernel/keepcurrent]: ' ansr
                 
                if ! test -d /lib/modules/$(uname -r)/build || test -z "$(ls /lib/modules/$(uname -r)/build/*)"; then
                    pre='headers newkernel keepcurrent'
                    prmpt="${YELLOW}No headers found of current kernel!${GREEN}\nWhat to do? [Headers/newkernel/keepcurrent]: "
                fi
                reade -Q 'GREEN' -i "$pre" -p "$prmpt" ansr 
                
                if [[ $ansr == 'newkernel' ]]; then
                    local kernel 
                    if test -n "$AUR_search_q" && test -n "$AUR_info"; then
                        
                        readyn -p "These kernel packages were only from official repositories. Also list unofficial (AUR) kernel packages?" kern_AUR 
                        # local ltss=$(eval "$AUR_search_q linux-lts | grep 'linux-lts[[:digit:]+]' | cut -d- -f-2 | awk '{print \$1}' | uniq | tr '\n' ' ' | xargs")
                        # No header : linux-drm-tip-git linux-drm-next-git  
                        if [[ $kern_AUR == 'y' ]]; then
                            if hash fzf &> /dev/null; then
                                kernel=$(eval "$AUR_search linux | sed -n '1p; /^[^[:space:]]/ {N;/[\^n]*\n\t/!p;}' | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module|installed' | sed -E 's,core/|extra/|multilib/|aur/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V | fzf --reverse --height 50% --preview 'cat <(yay -Si {1})'")
                            fi
                        else
                            if hash fzf &> /dev/null; then
                                kernel=$(eval "$pac_search linux | sed -n '1p; /^[^[:space:]]/ {N;/[\^n]*\n\t/!p;}' | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module|installed' | sed -E 's,core/|extra/|multilib/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V | tac | fzf --reverse --height 50% --preview 'cat <(yay -Si {1})'")
                            fi 
                        fi
                    else
                        if hash fzf &> /dev/null; then
                            kernel=$(eval "$pac_search linux | sed -n '1p; /^[^[:space:]]/ {N;/[\^n]*\n\t/!p;}' | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module|installed' | sed -E 's,core/|extra/|multilib/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V | tac | fzf --reverse --height 50% --preview 'cat <(yay -Si {1})'")
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
                                readyn -p "Kernel header ${CYAN}'$kernelh'${GREEN} available and not installed (C header files that allow external kernel modules to function using the kernel).\nAlso install ${CYAN}$kernelh${GREEN}?" nstall_kh
                            else
                                printf "${YELLOW}No header packages found for $kernel${normal}\n"
                            fi
                        else  
                            if test -n "$(eval "$pac_search_q $kernelh")" && test -z "$(pacman -Q $kernelh 2> /dev/null)"; then
                                readyn -p "Kernel header ${CYAN}'$kernelh'${GREEN} available and not installed (C header files that allow external kernel modules to function using the kernel).\nAlso install ${CYAN}$kernelh${GREEN}?" nstall_kh
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
                elif [[ "$ansr" == 'headers' ]]; then
                    local current=$(uname -r) 
                    local upprdist=$(echo $distro | tr '[:lower:]' '[:upper:]')
                    if [[ $current =~ $upprdist ]]; then
                        current=$(echo $current | sed "s/-$upprdist//g") 
                    fi
                    
                    if test -n "$AUR_search_ins"; then
                        kernel=$(eval "$AUR_search_ins linux | sed -E '/headers|docs|tool/d' | sed 's|local/||g' | grep $current | awk 'NR==1{print \$1;}'")
                    else
                        kernel=$(eval "$pac_search_ins linux | sed -E '/headers|docs|tool/d'| sed 's|local/||g' | grep $current | awk 'NR==1{print \$1;}'")
                    fi
                    
                    if test -n "$kernel"; then
                        if [[ "$distro" == 'Manjaro' ]] && ( (test -n "$(pamac search --installed linux-meta)" && pamac info linux-meta | grep 'Depends On' | grep -q "$kernel") || (test -n "$(pamac search --installed linux-lts-meta)" && pamac info linux-lts-meta | grep 'Depends On' | grep -q "$kernel")); then
                            if test -n "$(pamac search --installed linux-meta)" && pamac info 'linux-meta' | grep 'Depends On' | grep -q "$kernel"; then 
                                printf "${GREEN}Installing ${CYAN}linux-headers-meta${normal}\n" 
                                pamac install --no-confirm linux-headers-meta
                            elif test -n "$(pamac search --installed linux-lts-meta)" && pamac info 'linux-lts-meta' | grep 'Depends On' | grep -q "$kernel"; then 
                                printf "${GREEN}Installing ${CYAN}linux-lts-headers-meta${normal}\n" 
                                pamac install --no-confirm linux-lts-headers-meta
                            fi
                        elif test -n "$AUR_info" && test -n "$(eval "$AUR_info $kernel-headers")"; then
                                printf "${GREEN}Installing ${CYAN}$kernel-headers${normal}\n" 
                                eval "$AUR_ins_y $kernel-headers"
                        elif test -n "$(eval "$pac_info $kernel-headers")"; then
                                printf "${GREEN}Installing ${CYAN}$kernel-headers${normal}\n" 
                                eval "$pac_ins_y $kernel-headers"         
                        fi
                    else
                        printf "${YELLOW}Uncertain which kernel package relevant for current kernel\nTry looking for yourself using your packagemanager (f.ex. pacman)\n"
                    fi
                fi
            fi
        fi
    }

fi 
