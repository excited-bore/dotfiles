if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

if ! type reade &> /dev/null && test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi 

#if [[ "$distro_base" == 'Debian' ]] && ! hash mainline &> /dev/null; then
#    local mainins
#    readyn -p "${CYAN}'mainline'${GREEN} not installed (tool that helps with installing/managing kernels for Debian-based systems).\nInstall?" mainins
#    if [[ "$mainins" == 'y' ]]; then
#        sudo apt update -y 
#        sudo apt install mainline -y
#    fi
#fi

function list-installed-kernels(){

    printf "${GREEN}Currently used kernel:\n${normal}"
    printf "${GREEN}%-25s %-25s\n" "Name/Version" "Headers"

    local prmptc="${green}%-25s %-25s\n" 
    local ch 
    test -d /lib/modules/$(uname -r)/build && test -n "$(command ls /lib/modules/$(uname -r)/build/*)" &&
        ch="${GREEN}o" ||
        ch="${RED}x"

    printf "$prmptc" "$(uname -r)" "$ch" 
    echo 

    local insk kv kh khv known='n' knownk=($(command ls /lib/modules/)) knownk2=()

    if [[ "$distro_base" == 'Debian' ]]; then

        local prmpth="${green}%-45s %-30s %-40s %-40s\n" 

        insk=$(dpkg-query -W -f '${db:Status-Status} ${Package}\n' 'linux-image-*' | awk '$1 != "not-installed" {print $2}')
        
        if hash mainline &> /dev/null; then
            printf "${GREEN}Installed kernels using apt/mainline:\n${normal}"
        else
            printf "${GREEN}Installed kernels using apt:\n${normal}"
        fi

        printf "${GREEN}%-45s %-30s %-40s %-40s\n" "Name" "Version" "Headers" "Headers-Version-Same"

        while IFS= read -r k; do
            kv="$(dpkg-query -W -f '${Version}\n' "$k")"     
            if test -z "$kv"; then
                kv="${YELLOW}Version not available!${normal}"
            fi
            kh=$(echo $k | sed -e 's/image/headers/' -e 's/unsigned-//')
            if echo "$(apt show $k 2> /dev/null)" | grep -q 'Depends:.*linux-headers'; then
                kh="${green}Headers dependency of main package${normal}"
                khv=""
            elif test -n "$(dpkg-query -W "$kh" 2> /dev/null)" ; then
                [[ "$kv" == "$(dpkg-query -f '${Version}' -W "$kh")" ]] &&  
                    khv="${GREEN}o" ||
                    khv="${RED}x"
            else 
                kh="${YELLOW}Headers package not installed${normal}"
                khv=""
            fi

            known='n' 
            for i in ${knownk[@]}; do
                if [[ $known == 'n' ]] && dpkg -L "$k" | grep -q $i; then
                    known='y'
                else
                    knownk2+=("$i") 
                fi
            done
            knownk=("${knownk2[@]}")
            knownk2=()
            printf "$prmpth" "$k" "$kv" "$kh" "$khv"  

        done <<< $insk

    elif [[ "$distro_base" == 'Arch' ]]; then
    
        local prmpth="${green}%-25s %-25s %-25s %-25s\n" 
         
        if test -n "$AUR_search_ins"; then
            insk=$(eval "$AUR_search_ins linux | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module' | sed 's|local/||g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V")
            printf "${GREEN}Installed kernels using pacman/$AUR_pac:\n${normal}"
        else
            insk=$(eval "$pac_search_ins linux | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module' | sed 's|local/||g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V")
            printf "${GREEN}Installed kernels using pacman:\n${normal}"
        fi
         
         
        printf "${GREEN}%-25s %-25s %-25s %-25s\n" "Name" "Version" "Headers" "Headers-Version-Same"
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
                    kh="${green}Part of main package" 
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
    fi
   
    echo 

    if (( ${#knownk[@]} != 0 )); then
        printf "${GREEN}Installed Custom Compiled Kernels:\n${normal}"
        printf "${GREEN}%-25s %-25s\n" "Name/Version" "Headers"
        local prmptc="${green}%-25s %-25s\n" 
        for i in "${knownk[@]}"; do
            if test -n "$i"; then
                test -d /lib/modules/$i/build && test -n "$(ls /lib/modules/$i/build/*)" &&
                    kh="${GREEN}o" ||
                    kh="${RED}x"
                printf "$prmptc" "$i" "$kh"
            fi
        done
    fi
    
    echo 
    
} 

function remove-kernels(){
   
    local hlpstr="${bold}remove-kernels${normal} [ -h / --help ] [ -a / --auto ] [ -c / --clean [ KERNEL ]]${normal}

    remove-kernels either manually or all but the supplied kernel using -c / --clean. If no kernel is supplied, removes all kernels but the one currently running.
    Best to supply the 'vmlinuz-..' kernel file. 
    Otherwise, remove-kernels will try to check /boot/grub/grub.cfg for the right vmlinuz file
    Pass -a/--auto to never prompt the user for with a question\n" 

    while :; do
        case $1 in
        -h | -\? | --help)
            printf "$hlpstr"
            return 0
            ;;
        # Otherwise
        *)
            break
            ;;
        esac
    done && OPTIND=1

    #https://stackoverflow.com/questions/12022592/how-can-i-use-long-options-with-the-bash-getopts-builtin

    if [[ $(command ls /boot/vmlinuz* | wc -w) == 1 ]]; then 
        printf "${RED}Only 1 kernel left in /boot/. Aborting...${normal}\n"
        return 1
    else
      
        for arg in "$@"; do
            shift
            case "$arg" in
                '--auto')    set -- "$@" '-a'   ;;
                '--clean')   set -- "$@" '-c'   ;;
                *)           set -- "$@" "$arg" ;;
            esac
        done
      
        local auto allbutone
        while getopts 'acc:' flag; do
            case $flag in 
                a) auto='--auto' 
                   ;;
                c) if test -n "${OPTARG}"; then
                       allbutone="${OPTARG}"
                   else
                       allbutone="$(uname -r)"                
                   fi
                   ;;
           esac
        done && OPTIND=1

        local remove kernels packages=() non_packages=()
        
        if ! [[ "$allbutone" =~ 'vmlinuz' ]]; then
            printf "Next ${red}sudo${normal} will check /boot/grub/grub.cfg for right ${cyan}'vmlinuz'${normal} file.\n" 
            if sudo grep -q "$allbutone" /boot/grub/grub.cfg; then
                allbutone="$(sudo awk '/'$allbutone'/,0 { if ($0 ~ /vmlinuz/) {print $2; exit}}' /boot/grub/grub.cfg | sed 's,.*\(vmlinuz.*\).*,\1,g')" 
            else 
                printf "${YELLOW}Couldn't find kernel specified! Try giving \"\$(uname -r)\" as argument or check /boot/ for the name of the right 'vmlinuz' file.${normal}\n"
                return 1 
            fi
        fi
     
        kernels=( $(command ls /boot/vmlinuz* | sed 's|/boot/||g' ) )

        if test -n "$allbutone"; then
            remove=( ${kernels[@]/$allbutone} ) 
        else
            remove=$(echo ${kernels[@]} | tr ' ' '\n' | fzf --reverse --height 50% --multi | tr '\n' ' ')
            remove=( $(echo $remove) ) 
        fi
        
        if test -n "$remove"; then
            if [[ "$distro_base" == 'Debian' ]]; then
                remove=( $(echo ${remove[@]} | sed 's,vmlinuz-,linux-image-,g' ) )
            else 
                remove=( $(echo ${remove[@]} | sed 's,vmlinuz-,,g' ) )
            fi
            
            if [[ "${remove[@]}" =~ "$(uname -r)" ]]; then
                printf "${yellow}One of the kernels marked to remove was ${YELLOW}'$(uname -r)'${yellow} - ${RED}the one currently running.\n${YELLOW}If you want to remove the currently running kernel, switch to another kernel and try again.\n${normal}"
                return 1 
            else 
                for i in ${remove[@]}; do
                    # Make sure we ignore symbolic links 'vmlinuz' or 'vmlinuz.old' here
                    if ! test -h "/boot/$i"; then 
                    
                        if [[ "$distro_base" == 'Arch' ]] && test -n "$AUR_pac" && test -n "$(eval "$AUR_search_ins $i")"; then  
                            packages+=("$i")
                        elif test -n "$(eval "$pac_search_ins $i")"; then
                            packages+=("$i")
                        elif [[ "$distro_base" == 'Debian' ]] && test -n "$(eval "$pac_search_ins '*$i*' 2> /dev/null")"; then
                            packages+=("$i")
                        elif [[ "$distro" == 'Manjaro' ]] && test -n "$(echo $i | sed 's,-x86_64,,g' | sed 's/^\([[:digit:]]\).\([[:digit:]+]\)/linux\1\2/g' | xargs pamac search --installed)"; then
                            packages+=("$(echo $i | sed 's,-x86_64,,g' | sed 's/^\([[:digit:]]\).\([[:digit:]+]\)/linux\1\2/g')") 
                        else
                            non_packages+=("$i")
                        fi
                    fi
                done
                    
                local j pamcflag
                test -n "$auto" &&
                    pamcflag='--no-confirm'
                if (( ${#packages[@]} != 0 )); then 
                    for i in ${packages[@]}; do  
                        j=$(eval "$pac_search_ins_q '$i' | awk 'NR==1{print;}'" ) 
                        
                        # Check if package name is 'linux-image-unsigned-' for debian based systems...
                        if [[ "$distro_base" == 'Debian' ]] && test -z "$(apt list $j 2> /dev/null | awk 'NR>1 {print;}')" && test -n "$(echo "$j" | sed 's/linux-image-/linux-image-unsigned-/' | xargs apt list 2> /dev/null | awk 'NR>1{print;}')"; then   
                            j="$(echo "$j" | sed 's/linux-image-/linux-image-unsigned-/')"  
                        fi
                        
                        if [[ "$distro" == 'Manjaro' ]] && test -n "$(pamac search --installed linux-meta)" && pamac info linux-meta | grep 'Depends On' | grep -q $j; then
                            if test -n "$(pamac list --installed linux-headers-meta)"; then
                                printf "${GREEN}Removing ${CYAN}linux-meta, linux-headers-meta${GREEN} and ${CYAN}$j*${GREEN} using ${CYAN}pamac${normal}\n"
                                pamac remove $pamcflag linux-meta
                                pamac remove $pamcflag linux-headers-meta
                            else
                                printf "${GREEN}Removing ${CYAN}linux-meta${GREEN} and ${CYAN}$j*${GREEN} using ${CYAN}pamac${normal}\n"
                                pamac remove $pamcflag "linux-meta"
                            fi
                            pamac remove $pamcflag "linux-meta* $j*"
                        elif [[ "$distro" == 'Manjaro' ]] && test -n "$(pamac search --installed linux-lts-meta)" && pamac info linux-lts-meta | grep 'Depends On' | grep -q $j; then
                            if test -n "$(pamac list --installed linux-lts-headers-meta)"; then
                                printf "${GREEN}Removing ${CYAN}linux-lts-meta, linux-lts-headers-meta${GREEN} and ${CYAN}$j*${GREEN} using ${CYAN}pamac${normal}\n"
                                pamac remove $pamcflag linux-lts-meta
                            else
                                pamac remove $pamcflag linux-lts-headers-meta
                                printf "${GREEN}Removing ${CYAN}linux-lts-meta${GREEN} and ${CYAN}$j*${GREEN} using ${CYAN}pamac${normal}\n"
                                pamac remove $pamcflag "linux-lts-meta"
                            fi
                            pamac remove $pamcflag "$j*"
                        else
                            if test -n "$AUR_pac"; then
                                if test -n "$auto"; then
                                    printf "${GREEN}Removing ${CYAN}$j*${GREEN} using ${CYAN}$AUR_rm_y${normal}\n"
                                    eval "$AUR_rm_y '$j*'"
                                else
                                    printf "${GREEN}Removing ${CYAN}$j*${GREEN} using ${CYAN}$AUR_rm${normal}\n"
                                    eval "$AUR_rm '$j*'" 
                                fi
                            else
                                local n prmpt="$j" 
                                if [[ "$distro_base" == 'Debian' ]]; then
                                    n=$(echo "$j" | grep -oP --color=never '\d+\.\d+\.\d+|\d+\.\d+')
                                    prmpt=$(dpkg --get-selections | grep -v deinstall | awk '{print $1}' | grep --color=never "^linux.*$n")
                                    j=$(echo $prmpt | tr '\n' ' ' | xargs)
                                else
                                    j="$j*"
                                fi
                                if test -n "$auto"; then
                                    if [[ "$distro_base" == 'Debian' ]]; then
                                        printf "${GREEN}Removing ${CYAN}$prmpt${GREEN} using ${CYAN}sudo dpkg --purge $j${normal}\n"
                                        eval "$pac_rm_purge_y $j" 
                                    else 
                                        printf "${GREEN}Removing ${CYAN}$prmpt${GREEN} using ${CYAN}$pac_rm_y${normal}\n"
                                        eval "$pac_rm_y $j" 
                                    fi
                                else
                                    if [[ "$distro_base" == 'Debian' ]]; then
                                        printf "${GREEN}Removing ${CYAN}$prmpt${GREEN} using ${CYAN}sudo dpkg --purge $j${normal}\n" 
                                        eval "$pac_rm_purge $j" 
                                    else 
                                        printf "${GREEN}Removing ${CYAN}$prmpt${GREEN} using ${CYAN}$pac_rm${normal}\n" 
                                        eval "$pac_rm $j"
                                    fi
                                fi
                                if [[ "$distro_base" == 'Debian' ]]; then
                                     if test -n "$(command ls /lib/modules/$n* 2> /dev/null)"; then                        
                                        printf "Found unremoved directories in ${CYAN}'/lib/modules/'${normal}. Removing...\n" 
                                        if [[ $(ls /lib/modules/* | grep $n | cut -d: -f1 | wc -w) == 1 ]]; then          
                                            sudo rm -r $(ls /lib/modules/* | grep $n | cut -d: -f1)                       
                                        else                                                                              
                                            local config=$(ls /lib/modules/* | grep $n | cut -d: -f1 | tr '\n' ' ')       
                                            local which                                                                   
                                            reade -Q 'GREEN' -i "$config" -p "Multiple directories found in '/lib/modules/'. Which one to delete?" which       
                                            test -n "$which" && sudo rm -r "$which"                                       
                                        fi                                                                                
                                    fi
                                fi
                            fi
                        fi
                    done
                fi
                
                local hadcustom='n' 
                if (( ${#non_packages[@]} != 0 )); then
                    local rmq 
                    for i in ${non_packages[@]}; do
                        j="$(command ls /boot/*$i*)"
                        test -d "/usr/lib/modules/$i" && 
                            j="$j /usr/lib/modules/$i"
                        j="$(echo $j | tr '\n' ' ')"
                        readyn $auto -p "Remove ${CYAN}'$j'${GREEN}?" rmq
                        if [[ "$rmq" == 'y' ]]; then
                            hadcustom='y'   
                            # No idea why 'sudo rm /boot/linux.img ..' doesn't work 
                            eval "sudo rm $j" 
                        fi
                    done
                fi
                
                [[ "$hadcustom" == 'y' ]] && 
                    sudo update-grub
            fi
        fi
    fi
} 

if hash grub-set-default &> /dev/null; then
        
    function switch-default-kernel(){
        local query=''
        if test -n "$1"; then
            query="$(echo $1 | sed -E 's/linux-|linux//g')"
        fi
        if ! grep -q "^GRUB_DEFAULT=saved" /etc/default/grub; then
            local grb_def
            printf "${YELLOW}Setting the default kernel using 'grub-set-default' (which this function uses) relies on setting GRUB_DEFAULT=saved in ${CYAN}/etc/default/grub${normal}\n" 
            readyn -p "Set 'GRUB_DEFAULT=saved' in ${CYAN}/etc/default/grub${GREEN}?" grb_def
            if [[ "$grb_def" == 'y' ]]; then
                if grep -q '^GRUB_DEFAULT=' /etc/default/grub; then
                    sudo sed -i 's/GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/g' /etc/default/grub
                elif grep -q '#GRUB_DEFAULT=' /etc/default/grub; then 
                    sudo sed -i 's/#GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/g' /etc/default/grub
                else
                    sudo sed -i '1s/^/\nGRUB_DEFAULT=saved\n/' /etc/default/grub 
                fi
            fi
        fi
        
        if grep -q "^GRUB_DEFAULT=saved" /etc/default/grub; then
         
            local lines=$(sudo grep -E '^menuentry | menuentry |submenu ' /boot/grub/grub.cfg | uniq | cut -d\' -f2 | cut -d\' -f1 | cut -d\" -f2 | sed '/UEFI/d') 
            local j=0
            while IFS= read -r i; do 
                if [[ "$i" =~ 'Advanced' ]]; then
                    break 
                fi
                j=$((j+1)) 
            done <<< "$lines"
            
            printf "${CYAN}Current kernel:\n   ${GREEN}$(uname -r)\n\n${normal}"

            local kernel grb_entry kernels=$(sudo grep -e "[[:space:]+]menuentry '" /boot/grub/grub.cfg | grep --color=never 'Linux' | cut -d\' -f2 | cut -d\' -f1) 
            if hash fzf &> /dev/null; then
                # Sed remove colors
                kernel=$(echo "$kernels" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2};?)?)?[mGK]//g" | fzf --query="$query" --reverse --height 10%)   
            else
                kernels=$(echo $kernels | sed 's/ /_/g') 
                if test -n "$query"; then
                    while IFS= read -r i; do 
                        if [[ $query =~ $i ]]; then 
                            readyn -p "Is '$i' the right entry in grub?" grb_entry 
                            if [[ $grb_entry == 'y' ]]; then
                                kernel=$i
                            fi
                        fi
                    done <<< "$kernels"
                fi
                if test -z "$kernel"; then
                    printf "${CYAN}Available kernels:\n${normal}" 
                    while IFS= read -r i; do 
                        printf "${GREEN}   $i\n${normal}" 
                    done <<< "$kernels"
                    kernels=$(echo $kernels | tr '\n' ' ') 
                    reade -Q 'GREEN' -i "$kernels" -p 'Which one?: ' kernel 
                    kernel="$(echo $kernel | sed 's/_/ /g')" 
                fi
            fi
            
            if test -n "$kernel"; then
                local h kernels=$(sudo grep -e "[[:space:]+]menuentry '" /boot/grub/grub.cfg | grep 'Linux' | cut -d\' -f2 | cut -d\' -f1)
                while IFS= read -r i; do 
                    h=$(($h+1))
                    if [[ "$i" =~ "$kernel" ]]; then
                        break
                    fi
                done <<< "$kernels" 
               
                printf "${GREEN}Setting new default kernel with ${CYAN}'sudo grub-set-default "$j>$h"'${normal}\n" 
                sudo grub-set-default "$j>$h"
                sudo update-grub
               
                echo "${YELLOW}A reboot is needed to take full effect!${normal}" 
                echo "${YELLOW}If booting into the new kernel breaks, hold ${CYAN}'Shift'${YELLOW} while booting to load into grub, then choose an older kernel.${normal}" 
                return 0 
            else
                return 1
            fi
        fi 
        #sudo grep -E 'menuentry |submenu ' /boot/grub/grub.cfg | uniq | cut -d\' -f2 | cut -d\' -f1 | cut -d\" -f2
    }
fi


function update-kernel(){
    local latest_lts latest_lts1 choices
    
    if ! hash fzf &> /dev/null; then
        printf "${CYAN}fzf${GREEN} not installed and needed for for listing possible kernels packages. Installing..${normal}\n" 
        eval "${pac_ins_y} fzf" 
    fi

    if ! hash xmllint &> /dev/null; then
        printf "${CYAN}xmllint${GREEN} not installed and needed for for listing latest kernel versions from ${CYAN}www.kernel.org${GREEN}. Installing..${normal}\n" 
        eval "${pac_ins_y} xmllint" 
    fi
   
    list-installed-kernels
    echo 
        
    local prmpth0="${CYAN}%-20s ${green}%-20s\n${normal}" 

    local mainlinev="$(curl -s https://www.kernel.org/feeds/kdist.xml | xmllint --format --xpath '//title' - | grep '<title>[[:digit:]]' | grep 'mainline' | sed -E 's,<title>|<\/title>,,g' | cut -d: -f1 | awk 'NR==1 {print;}')" 
    local stablev="$(curl -s https://www.kernel.org/feeds/kdist.xml | xmllint --format --xpath '//title' - | grep '<title>[[:digit:]]' | grep 'stable' | sed -E 's,<title>|<\/title>,,g' | cut -d: -f1 | awk 'NR==1 {print;}')" 
    
    local longtermv="$(curl -s https://www.kernel.org/feeds/kdist.xml | xmllint --format --xpath '//title' - | grep '<title>[[:digit:]]' | grep 'longterm' | sed -E 's,<title>|<\/title>,,g' | cut -d: -f1 | awk 'NR==1 {print;}')" 
    
    printf "${GREEN}Latest kernels from ${CYAN}'www.kernel.org'${GREEN}:${normal}\n"
    printf "${GREEN}%-20s %-20s\n" "Name" "Version"
   
    printf "$prmpth0" "- Mainline: " "$mainlinev"
    printf "$prmpth0" "- Stable: " "$stablev"
    printf "$prmpth0" "- Longterm: " "$longtermv"

    echo

    if [[ "$distro_base" == 'Debian' ]]; then
       
        if hash mainline &> /dev/null; then
            echo "${GREEN}Available kernels using mainline (includes headers): " 
            local mainlines='' mainlines1="$(mainline list --include-rc --include-flavors | sed -e 's/Running//g' -e 's/Installed//g')" 
            for i in $(mainline list --include-rc --include-flavors | grep --color=never -oPf <(echo '^\d\.\d+') | uniq); do
                local m=$(echo "$mainlines1" | grep --color=never -E "^$i\.|^$i[[:space:]]|^$i-" | head -1 | xargs) 
                printf "${CYAN}%s\n${normal}" "  - $m"
                test -z "$mainlines" && mainlines="$m" || mainlines="$mainlines $m"
            done
            echo
        fi 

        local prmpth="${green}%-45s %-30s %-40s %-40s\n${normal}" 
        local prmpth1="${cyan}%s\n\n${normal}" 

        printf "${GREEN}Available kernels using apt:\n"
        printf "${GREEN}%-45s %-30s %-40s %-40s\n" "Name" "Version" "Headers" "Headers-Version-Same"
        
        local available hwev hwehv hwedgv hwedghv ltsv ltshv harnenedv hardenedhv rtv rthv rtltsv rtltshv zenv zenhv 
        if test -n "$(apt search '^linux-generic' 2> /dev/null)"; then
            available="linux-generic" 
            genv=$(apt search '^linux-generic$' 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
            [[ "$genv" == "$(apt search '^linux-headers-generic$' 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                genhv="${GREEN}o" ||
                genhv="${RED}x"
            printf "$prmpth" "linux-generic" "$genv" "linux-headers-generic" "$genhv" 
            available="linux-image-generic" 
            genv=$(apt search '^linux-image-generic$' 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
            [[ "$genv" == "$(apt search '^linux-headers-generic$' 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                genhv="${GREEN}o" ||
                genhv="${RED}x"
            printf "$prmpth" "linux-image-generic" "$genv" "linux-headers-generic" "$genhv" 
            printf "$prmpth1" "'Meta package for the 'latest' generic Linux kernel image.'"
        fi
        
        if test -n "$(apt search '^linux-generic-[0-9]+' 2> /dev/null)"; then
            for i in $(apt-cache -qq search 'linux-generic-[[:digit:]+]' | sort -V | grep --color=never -oPf <(echo 'linux-generic-\d\.\d+') | uniq); do 
                #kernels+=( "$(apt-cache search "$i.*-generic" | tac | head -1)" ); 
                local k="$(echo "$i" | sed 's/linux-generic-//')" 
                available="$available linux-generic-$k" 
                kv=$(apt search "linux-generic-$k" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$kv" == "$(apt search "linux-headers-generic-$k" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&  
                    khv="${GREEN}o" ||
                    khv="${RED}x"
                printf "$prmpth" "linux-generic-$k" "$kv" "linux-headers-generic-$k" "$khv" 
            done 
        fi 

        if test -n "$(apt search '^linux-image-generic-[0-9]+' 2> /dev/null)"; then
            for i in $(apt-cache -qq search 'linux-image-[[:digit:]+].*generic' | sort -V | grep --color=never -oPf <(echo 'linux-image-\d\.\d+') | uniq); do 
                #kernels+=( "$(apt-cache search "$i.*-generic" | tac | head -1)" ); 
                local k="$(echo "$i" | sed 's/linux-image-//')" 
                available="$available linux-image-generic-$k" 
                kv=$(apt search "linux-image-generic-$k" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$kv" == "$(apt search "linux-headers-generic-$k" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&  
                    khv="${GREEN}o" ||
                    khv="${RED}x"
                printf "$prmpth" "linux-image-generic-$k" "$kv" "linux-headers-generic-$k" "$khv" 
            done 
        fi 
        printf "$prmpth1" "'Specific versions of generic Linux kernels'"


        if [[ "$distro" == 'Ubuntu' ]]; then
            
            if test -n "$(apt search "^linux-generic-hwe-$release" 2> /dev/null)"; then
                available="$available linux-generic-hwe-$release linux-generic-hwe-$release-edge" 
                hwev=$(apt search "linux-generic-hwe-$release" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$hwev" == "$(apt search "linux-headers-generic-hwe-$release" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    hwehv="${GREEN}o" ||
                    hwehv="${RED}x"
                hwedgv=$(apt search "linux-generic-hwe-$release-edge" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$hwedgv" == "$(apt search "linux-headers-generic-hwe-$release-edge" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    hwedghv="${GREEN}o" ||
                    hwedghv="${RED}x"
                printf "$prmpth" "linux-generic-hwe-$release" "$hwev" "linux-headers-generic-hwe-$release" "$hwehv" 
                printf "$prmpth" "linux-generic-hwe-$release-edge" "$hwedgv" "linux-headers-generic-hwe-$release-edge" "$hwedghv" 
            fi
             
            if test -n "$(apt search "^linux-image-generic-hwe-$release" 2> /dev/null)"; then
                available="$available linux-image-generic-hwe-$release linux-image-generic-hwe-$release-edge" 
                hwev=$(apt search "linux-image-generic-hwe-$release" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$hwev" == "$(apt search "linux-headers-generic-hwe-$release" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    hwehv="${GREEN}o" ||
                    hwehv="${RED}x"
                hwedgv=$(apt search "linux-image-generic-hwe-$release-edge" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$hwedgv" == "$(apt search "linux-headers-generic-hwe-$release-edge" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    hwedghv="${GREEN}o" ||
                    hwedghv="${RED}x"
                printf "$prmpth" "linux-image-generic-hwe-$release" "$hwev" "linux-headers-generic-hwe-$release" "$hwehv" 
                printf "$prmpth" "linux-image-generic-hwe-$release-edge" "$hwedgv" "linux-headers-generic-hwe-$release-edge" "$hwedghv" 
            fi
            printf "$prmpth1" "'Ubuntu Linux kernel images with Hardware Enablement (HWE), designed to keep up-to-date the newest hardware technologies.'"
       
            local lowv lowhv lowedgv lowedghv  
            
            if test -n "$(apt search "^linux-lowlatency$" 2> /dev/null)"; then
                available="$available linux-lowlatency" 
                lowv=$(apt search "^linux-lowlatency$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowv" == "$(apt search "^linux-headers-lowlatency$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowhv="${GREEN}o" ||
                    lowhv="${RED}x"
                printf "$prmpth" "linux-lowlatency" "$lowv" "linux-headers-lowlatency" "$lowhv" 
                available="$available linux-image-lowlatency" 
                lowv=$(apt search "^linux-image-lowlatency$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowv" == "$(apt search "^linux-headers-lowlatency$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowhv="${GREEN}o" ||
                    lowhv="${RED}x"
                printf "$prmpth" "linux-image-lowlatency" "$lowv" "linux-headers-lowlatency" "$lowhv" 
                for i in $(apt-cache -qq search 'linux-image-lowlatency-[[:digit:]+].*' | sort -V | grep --color=never -oPf <(echo 'linux-image-lowlatency-\d\.\d+') | uniq); do 
                    local k="$(echo "$i" | sed 's/linux-image-lowlatency-//')" 
                    available="$available linux-image-lowlatency-$k" 
                    lowv=$(apt search "linux-image-lowlatency-$k" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                    [[ "$lowv" == "$(apt search "linux-headers-lowlatency-$k" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                        lowhv="${GREEN}o" ||
                        lowhv="${RED}x"
                    printf "$prmpth" "linux-image-lowlatency-$k" "$lowv" "linux-headers-lowlatency-$k" "$lowhv" 
                done 
                available="$available linux-image-lowlatency-hwe-$release linux-image-lowlatency-hwe-$release-edge" 
                lowv=$(apt search "^linux-image-lowlatency-hwe-$release$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowv" == "$(apt search "^linux-headers-lowlatency-hwe-$release$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowhv="${GREEN}o" ||
                    lowhv="${RED}x"
                lowedgv=$(apt search "^linux-image-lowlatency-hwe-$release-edge$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowedgv" == "$(apt search "^linux-headers-lowlatency-hwe-$release-edge$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowedghv="${GREEN}o" ||
                    lowedghv="${RED}x"
                
                printf "$prmpth" "linux-image-lowlatency-hwe-$release" "$lowv" "linux-headers-lowlatency-hwe-$release" "$lowhv" 
                printf "$prmpth" "linux-image-lowlatency-hwe-$release-edge" "$lowedgv" "linux-headers-lowlatency-hwe-$release-edge" "$lowedghv" 
                printf "${cyan}'Linux kernel designed to improve performance for applications that require low latency, such as audio and video production.\nNote: Lowlatency performance can also be performed with the generic kernel by setting specific kernel parameters.\nFollow this guide for that:\nhttps://discourse.ubuntu.com/t/fine-tuning-the-ubuntu-24-04-kernel-for-low-latency-throughput-and-power-efficiency/44834\n\n"
            fi

            if test -n "$(apt search "^linux-nvidia$" 2> /dev/null)"; then
                available="$available linux-nvidia" 
                lowv=$(apt search "^linux-nvidia$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowv" == "$(apt search "^linux-headers-nvidia$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowhv="${GREEN}o" ||
                    lowhv="${RED}x"
                printf "$prmpth" "linux-nvidia" "$lowv" "linux-headers-nvidia" "$lowhv" 
                available="$available linux-image-nvidia" 
                lowv=$(apt search "^linux-image-nvidia$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowv" == "$(apt search "^linux-headers-nvidia$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowhv="${GREEN}o" ||
                    lowhv="${RED}x"
                printf "$prmpth" "linux-image-nvidia" "$lowv" "linux-headers-nvidia" "$lowhv" 
                for i in $(apt-cache -qq search 'linux-image-nvidia-[[:digit:]+].*' | sort -V | grep --color=never -oPf <(echo 'linux-image-nvidia-\d\.\d+') | uniq); do 
                    local k="$(echo "$i" | sed 's/linux-image-nvidia-//')" 
                    available="$available linux-image-nvidia-$k" 
                    lowv=$(apt search "linux-image-nvidia-$k" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                    [[ "$lowv" == "$(apt search "linux-headers-nvidia-$k" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                        lowhv="${GREEN}o" ||
                        lowhv="${RED}x"
                    printf "$prmpth" "linux-image-nvidia-$k" "$lowv" "linux-headers-nvidia-$k" "$lowhv" 
                done 
                available="$available linux-image-nvidia-hwe-$release linux-image-nvidia-hwe-$release-edge" 
                lowv=$(apt search "^linux-image-nvidia-hwe-$release$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowv" == "$(apt search "^linux-headers-nvidia-hwe-$release$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowhv="${GREEN}o" ||
                    lowhv="${RED}x"
                lowedgv=$(apt search "^linux-image-nvidia-hwe-$release-edge$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowedgv" == "$(apt search "^linux-headers-nvidia-hwe-$release-edge$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowedghv="${GREEN}o" ||
                    lowedghv="${RED}x"
                
                printf "$prmpth" "linux-image-nvidia-hwe-$release" "$lowv" "linux-headers-nvidia-hwe-$release" "$lowhv" 
                printf "$prmpth" "linux-image-nvidia-hwe-$release-edge" "$lowedgv" "linux-headers-nvidia-hwe-$release-edge" "$lowedghv" 
                printf "${cyan}'Linux kernel designed to improve performance while using nvidia devices, like GPU's.\n${YELLOW}Note: This mostly unnecesary and you would most definitely be getting very similar performance from using the latest up-to-date nvidia drivers on a generic kernel using up-to-date drivers and this kernel\n\n${normal}"
            fi
            
            if test -n "$(apt search "^linux-virtual$" 2> /dev/null)"; then
                available="$available linux-virtual" 
                lowv=$(apt search "^linux-virtual$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowv" == "$(apt search "^linux-headers-virtual$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowhv="${GREEN}o" ||
                    lowhv="${RED}x"
                printf "$prmpth" "linux-virtual" "$lowv" "linux-headers-virtual" "$lowhv" 
                available="$available linux-image-virtual" 
                lowv=$(apt search "^linux-image-virtual$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowv" == "$(apt search "^linux-headers-virtual$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowhv="${GREEN}o" ||
                    lowhv="${RED}x"
                printf "$prmpth" "linux-image-virtual" "$lowv" "linux-headers-virtual" "$lowhv" 
                for i in $(apt-cache -qq search 'linux-image-virtual-[[:digit:]+].*' | sort -V | grep --color=never -oPf <(echo 'linux-image-virtual-\d\.\d+') | uniq); do 
                    local k="$(echo "$i" | sed 's/linux-image-virtual-//')" 
                    available="$available linux-image-virtual-$k" 
                    lowv=$(apt search "linux-image-virtual-$k" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                    [[ "$lowv" == "$(apt search "linux-headers-virtual-$k" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                        lowhv="${GREEN}o" ||
                        lowhv="${RED}x"
                    printf "$prmpth" "linux-image-virtual-$k" "$lowv" "linux-headers-virtual-$k" "$lowhv" 
                done 
                available="$available linux-image-virtual-hwe-$release linux-headers-virtual-hwe-$release-edge" 
                lowv=$(apt search "^linux-image-virtual-hwe-$release$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowv" == "$(apt search "^linux-headers-virtual-hwe-$release$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowhv="${GREEN}o" ||
                    lowhv="${RED}x"
                lowedgv=$(apt search "^linux-image-virtual-hwe-$release-edge$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lowedgv" == "$(apt search "^linux-headers-virtual-hwe-$release-edge$" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lowedghv="${GREEN}o" ||
                    lowedghv="${RED}x"
                
                printf "$prmpth" "linux-image-virtual-hwe-$release" "$lowv" "linux-headers-virtual-hwe-$release" "$lowhv" 
                printf "$prmpth" "linux-image-virtual-hwe-$release-edge" "$lowedgv" "linux-headers-virtual-hwe-$release-edge" "$lowedghv" 
                printf "${cyan}'Linux kernel is designed for use to run inside Virtual machines\nThe virtual kernel only includes the necessary drivers to run inside popular virtualization technologies such as KVM, Xen, Virtualbox and VMWare'\n\n${normal}"
            fi

            local lqrx lqrxh 
            if test -n "$(apt search "linux-image-liquorix-amd64" 2> /dev/null)"; then
                lqrx=$(apt search "linux-image-liquorix-amd64" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                [[ "$lqrx" == "$(apt search "linux-headers-liquorix-amd64" 2> /dev/null | awk 'NR==3{print $2;}' | xargs)" ]] &&
                    lqrxh="${GREEN}o" ||
                    lqrxh="${RED}x"
                printf "$prmpth" "linux-image-liquorix-amd64" "$lqrx" "linux-headers-liquorix-amd64" "$lqrxh"
            else
                printf "$prmpth" "linux-image-liquorix-amd64" "Not yet available" "-" "-"
            fi
            available="$available linux-image-liquorix-amd64" 
            printf "${cyan}'Liquorix is an enthusiast Linux kernel designed for uncompromised responsiveness in interactive systems, enabling low latency compute in A/V production, and reduced frame time deviations in games.\n\n${normal}"
            printf "${cyan}'Read more about it at: https://liquorix.net/'\n${normal}" 

            local xanmlts1 xanmlts2 xanmlts3 xanm2 xanm3 xanmedg2 xanmedg3 xanmrt2 xanmrt3 
            if test -n "$(apt search "linux-xanmod-lts-x64v1" 2> /dev/null)"; then
                xanmlts1=$(apt search "linux-xanmod-lts-x64v1" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                xanmlts2=$(apt search "linux-xanmod-lts-x64v2" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                xanmlts3=$(apt search "linux-xanmod-lts-x64v3" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                xanm2=$(apt search "linux-xanmod-x64v2" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                xanm3=$(apt search "linux-xanmod-x64v3" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                xanmedg2=$(apt search "linux-xanmod-edge-x64v2" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
                xanmedg3=$(apt search "linux-xanmod-edge-x64v3" 2> /dev/null | awk 'NR==3{print $2;}' | xargs) 
            else
                xanmlts1="Not yet available" xanmlts2="Not yet available" xanmlts3="Not yet available"  
                xanm2="Not yet available" xanm3="Not yet available"  
                xanmedg2="Not yet available" xanmedg3="Not yet available"  
            fi
            available="$available linux-xanmod-lts-x64v3 linux-xanmod-lts-x64v2 linux-xanmod-lts-x64v1 linux-xanmod-x64v3 linux-xanmod-x64v2 linux-xanmod-edge-x64v3 linux-xanmod-edge-x64v2 linux-xanmod-rt-x64v3 linux-xanmod-rt-x64v2" 
            printf "$prmpth" "linux-xanmod-lts-x64v3" "$xanmlts3" "Headers included in main package" "-"
            printf "$prmpth" "linux-xanmod-lts-x64v2" "$xanmlts2" "Headers included in main package" "-"
            printf "$prmpth" "linux-xanmod-lts-x64v1" "$xanmlts1" "Headers included in main package" "-"
            printf "$prmpth" "linux-xanmod-x64v3" "$xanm3" "Headers included in main package" "-"
            printf "$prmpth" "linux-xanmod-x64v2" "$xanm2" "Headers included in main package" "-"
            printf "$prmpth" "linux-xanmod-edge-x64v3" "$xanmedg3" "Headers included in main package" "-"
            printf "$prmpth" "linux-xanmod-edge-x64v2" "$xanmedg2" "Headers included in main package" "-"

            printf "${cyan}'XanMod is a general-purpose Linux kernel distribution with custom settings and new features. Built to provide a stable, smooth and solid system experience.'\n${normal}"
            printf "${cyan}'x86-64 v1 support includes: AMD K8-family, AMD K10-family, AMD Family 10h (Barcelona), Intel Pentium 4 / Xeon (Nocona), Intel Core 2 (all variants), All x86-64 CPUs\n${normal}"
            printf "${cyan}'x86-64 v2 support includes: AMD Family 14h - 16h (Bobcat - Steamroller, excluding 15h Excavator), Intel 1st Gen to 3rd Gen Core, Intel low-power Silvermont and Goldmont (all variants)\n${normal}"
            printf "${cyan}'x86-64 v3 support includes: AMD Family 15h (Excavator), AMD Family 17h - 19h (Zen, Zen+, Zen 2 and Zen 3), Intel 4th Gen to 15th Gen Core (Haswell to Lunar / Arrow Lake), Intel low-power Silvermont and Goldmont (all variants)\n${normal}"
            printf "${cyan}'See all architectures listed at: https://xanmod.org/'\n\n${normal}"
           
            local howinstll 
            if hash mainline &> /dev/null; then
                reade -Q 'GREEN' -i 'mainline both apt' -p "Choose to install with mainline, apt or both? [Mainline/both/apt]: " howinstll 
            else 
                howinstll="apt" 
            fi
       
            local nstll
            if hash fzf &> /dev/null; then
                available=$(echo "$available $(apt-cache -qq search '^linux*' 2> /dev/null | grep 'kernel' | grep -Eiv '[^and ]headers|[^and] drivers|extra drivers for|^linux-modules*|^linux-objects|^linux-signatures| docs | doc |^linux-doc |^linux-crashdump |tool|buildinfo|library|kernel module|daemon$|services$|installed' | awk '{print $1}')" | uniq) 
                if [[ "$howinstll" == 'both' ]]; then 
                    nstll=$(eval "echo \"$mainlines $available\" | tr ' ' '\n' | fzf --reverse --height 50% --preview '[[ {1} =~ ^linux ]] && $pac_info {1} 2> /dev/null || echo \"Mainline kernel version {1} with headers\"'")
                elif [[ "$howinstll" == 'mainline' ]]; then
                    nstll=$(echo "$mainlines" | tr ' ' '\n' | fzf --reverse --height 50% --preview 'echo "Mainline kernel version {1} with headers"')
                elif [[ "$howinstll" == 'apt' ]]; then
                    nstll=$(eval "echo \"$available\" | tr ' ' '\n' | fzf --reverse --height 50% --preview '$pac_info {1} 2> /dev/null'")
                fi
            fi
            
            if test -n "$nstll"; then
                if [[ "$nstll" =~ ^linux ]]; then
                   
                    if [[ "$i" =~ 'liquorix' ]] && test -z "$(apt search "$i" 2> /dev/null)"; then
                        if ! hash add-apt-repository &> /dev/null; then
                            printf "${CYAN}add-apt-repository${normal} is not installed (cmd tool for installing extra repositories/ppas on debian systems - Needed for liquorix kernel)\n"
                            readyn -p "Install add-apt-repository?" add_apt_ins
                            if [[ $add_apt_ins == 'y' ]]; then
                                eval "$pac_ins_y software-properties-common"
                            fi
                            unset add_apt_ins
                        fi
                        sudo add-apt-repository ppa:damentz/liquorix
                        sudo apt update
                    elif [[ "$i" =~ 'xanmod' ]] && test -z "$(apt search "$i" 2> /dev/null)"; then
                        curl https://dl.xanmod.org/archive.key | sudo gpg --dearmor -vo /etc/apt/keyrings/xanmod-archive-keyring.gpg 
                        echo "deb [signed-by=/etc/apt/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/xanmod-release.list
                        sudo apt update
                    fi


                    local extra nstllextra extras=( $(apt show $nstll 2> /dev/null | grep 'Depends: ' | sed -e 's/Depends: //' -e 's/(.*),//g' -e 's/(.*)//g' -e 's/,//g' ) ) extras2=( $(apt show $nstll 2> /dev/null | grep 'Recommends: ' | sed -e 's/Recommends: //' -e 's/(.*),//g' -e 's/(.*)//g' -e 's/,//g' ) )

                    for i in ${extras[@]}; do
                        if ! [[ $i =~ 'image' || $i =~ 'ubuntu-kernel-accessories' ]]; then
                            [[ "$i" =~ 'headers' ]] && 
                                readyn -p "Also install headers package ${CYAN}'$i'${GREEN}?" nstllextra ||
                                readyn -p "Also install package ${CYAN}'$i'${GREEN}?" nstllextra 
                            if [[ "$nstllextra" == 'y' ]]; then
                                nstll="$nstll $i"
                            fi
                            nstllextra=''
                        fi
                    done

                    for i in ${extras2[@]}; do
                        if ! [[ $i =~ 'image' || $i =~ 'ubuntu-kernel-accessories' ]]; then
                            [[ $i =~ 'headers' ]] && 
                                readyn -p "Also install headers package ${CYAN}'$i'${GREEN}?" nstllextra ||
                                readyn -p "Also install package ${CYAN}'$i'${GREEN}?" nstllextra 
                            if [[ "$nstllextra" == 'y' ]]; then
                                nstll="$nstll $i"
                            fi
                            nstllextra=''
                        fi
                    done

                    eval "${pac_ins_y} $nstll"
                else
                    mainline install $nstll
                fi
            fi
        fi

    elif [[ "$distro_base" == "Arch" ]]; then

        local prmpth="${green}%-20s %-20s %-25s %-25s\n" 
        local prmpth1="${cyan}%s\n\n" 

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
        elif test -z "$AUR_pac" && hash pamac &> /dev/null && grep -q "#EnableAUR" /etc/pamac.conf; then
            
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
                elif [[ "$distro" == 'Manjaro' ]] && (test -f ~/.bash_aliases.d/package_managers.sh || test -f $DIR/aliases/.bash_aliases.d/package_managers.sh); then  
                test -f ~/.bash_aliases.d/package_managers.sh && . ~/.bash_aliases.d/package_managers.sh
                test -f $DIR/aliases/.bash_aliases.d/package_managers.sh && . $DIR/aliases/.bash_aliases.d/package_managers.sh
                local nstall_arch
            #elif [[ "$nable_aur" == 'n' ]] && ! [[ "$distro" == 'Arch' ]]; then 
            #    printf "${green}Another way to install the latest kernel for ${GREEN}$distro${green} is to basically 'change distribution to ${CYAN}Arch${green}' by configuring Arch-specific repositories (also called mirrors) for pacman to allow the installation of 'linux-lts' (and other kernels)\n${YELLOW}(Warning - this process is ${RED}highly risky when done incorrectly${YELLOW} and could lead to f.ex. pacman becoming unusable if not allowing packages to downgrade while updating after configuring said repositories, also certain $distro-specific packages (like mhwd or pacman-mirrors) will become impossible to install/update/maintain\!\!)\n" 
            #    readyn -n -p "Install Arch specific repositories in ${CYAN}/etc/pacman.d/mirrorlist${YELLOW}, then update?\n" nstall_arch 
            #    if [[ "$nstall_arch" == 'y' ]]; then
            #        if test -f ~/.bash_aliases.d/package_managers.sh; then
            #            . ~/.bash_aliases.d/package_managers.sh
            #        fi
            #        if test -f $DIR/aliases/.bash_aliases.d/package_managers.sh; then
            #            . $DIR/aliases/.bash_aliases.d/package_managers.sh
            #        fi
            #        pacman-fzf-add-arch-repositories
            #    fi
            fi
        fi
         

        printf "${GREEN}Available Kernels:\n"
        printf "${GREEN}%-20s %-20s %-25s %-25s\n" "Name" "Version" "Headers" "Headers-Version-Same"
        
        local available stablv stablehv ltsv ltshv harnenedv hardenedhv rtv rthv rtltsv rtltshv zenv zenhv 
        if test -n "$(pacman -Si 'linux' 2> /dev/null)"; then
            available="linux" 
            stablv=$(pacman -Si 'linux' | grep Version | awk '{$1="";$2=""; print}' | xargs) 
            [[ "$blev" == "$(pacman -Si 'linux-headers' | grep Version | awk '{$1="";$2=""; print}' | xargs)" ]] &&
                stablehv="${GREEN}o" ||
                stablehv="${RED}x"
            printf "$prmpth" "linux" "$stablv" "linux-headers" "$stablehv" 
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
            local ks=$(eval "$pac_search '^linux[0-9]+$' | sed -n '1p; /^[^[:space:]]/ {N;/[\^n]*\n\t/!p;}' | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module|installed' | sed -E 's,core/|extra/|multilib/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sed 's/\(x[0-9]\)/\1./' | sort -rV | sed 's/\.//g'")                     
            available="$available $ks"
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
                
            local kernel kern_AUR 
            if test -n "$AUR_search_q" && test -n "$AUR_info"; then
                readyn -p "These kernel packages were only from official repositories. Also list unofficial (AUR) kernel packages?" kern_AUR 
                # local ltss=$(eval "$AUR_search_q linux-lts | grep 'linux-lts[[:digit:]+]' | cut -d- -f-2 | awk '{print \$1}' | uniq | tr '\n' ' ' | xargs")
                # No header : linux-drm-tip-git linux-drm-next-git  
                if [[ $kern_AUR == 'y' ]]; then
                    if hash fzf &> /dev/null; then
                        kernel=$(eval "$AUR_search linux | sed -n '1p; /^[^[:space:]]/ {N;/[\^n]*\n\t/!p;}' | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module|installed' | sed -E 's,core/|extra/|multilib/|aur/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V | fzf --reverse --height 50% --preview 'cat <(eval \"$AUR_info {1}\")'")
                    fi
                else
                    if hash fzf &> /dev/null; then
                        kernel=$(eval "$pac_search linux | sed -n '1p; /^[^[:space:]]/ {N;/[\^n]*\n\t/!p;}' | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module|installed' | sed -E 's,core/|extra/|multilib/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V | tac | fzf --reverse --height 50% --preview 'cat <(pacman -Si {1})'")
                    fi 
                fi
            else
                if hash fzf &> /dev/null; then
                    kernel=$(eval "$pac_search linux | sed -n '1p; /^[^[:space:]]/ {N;/[\^n]*\n\t/!p;}' | grep -i -B 1 -E 'kernel |kernel,' --no-group-separator | paste -d \"\t\" - - | grep -Eiv '[^and ]headers|docs|tool|kernel module|installed' | sed -E 's,core/|extra/|multilib/,,g' | grep '^linux' | uniq | awk '{print \$1}' | sort -V | tac | fzf --reverse --height 50% --preview 'cat <(pacman -Si {1})'")
                fi
            fi

            if test -n "$kernel"; then
                local kernelh="$kernel-headers" 
                if [[ $kernel =~ "-bin" ]]; then
                    kernelh=$(echo $kernel | sed 's/-bin/-headers-bin/g') 
                elif [[ $kernel == "linux-meta" ]]; then
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

                #local defkern
                #readyn -p "Set $kernel as default?" defkern
                #if [[ $defkern == 'y' ]]; then
                #    switch-default-kernel $kernel     
                #fi
                printf "${GREEN}You can list installed kernels using ${CYAN}'list-installed-kernels'${GREEN}\n"
                printf "${GREEN}, switch to another kernel using ${CYAN}'switch-default-kernel'${GREEN}\n"
                printf "${GREEN}and remove unused kernels using ${CYAN}'remove-kernels'${GREEN}\n" 
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
                local pacc_search_q pacc_ins_y
                if test -n "$AUR_search_q"; then
                    pacc_search_q="$AUR_search_q"
                    pacc_ins_y="$AUR_ins_y"
                else
                    pacc_search_q="$pac_search_q"
                    pacc_ins_y="$pac_ins_y"
                fi
                if [[ "$distro" == 'Manjaro' ]] && ( (test -n "$(pamac search --installed linux-meta)" && pamac info linux-meta | grep 'Depends On' | grep -q "$kernel") || (test -n "$(pamac search --installed linux-lts-meta)" && pamac info linux-lts-meta | grep 'Depends On' | grep -q "$kernel")); then
                    if test -n "$(pamac search --installed linux-meta)" && pamac info 'linux-meta' | grep 'Depends On' | grep -q "$kernel"; then 
                        printf "${GREEN}Installing ${CYAN}linux-headers-meta${normal}\n" 
                        pamac install --no-confirm linux-headers-meta
                    elif test -n "$(pamac search --installed linux-lts-meta)" && pamac info 'linux-lts-meta' | grep 'Depends On' | grep -q "$kernel"; then 
                        printf "${GREEN}Installing ${CYAN}linux-lts-headers-meta${normal}\n" 
                        pamac install --no-confirm linux-lts-headers-meta
                    fi
                elif test -n "$(eval "$pacc_search_q $kernel-headers")"; then
                    printf "${GREEN}Installing ${CYAN}$kernel-headers${normal}\n" 
                    eval "$pacc_ins_y $kernel-headers"
                elif [[ "$kernel" =~ '-bin' ]] && test -n "$(eval "echo $kernel | sed 's/-bin/-headers-bin/g' | xargs $pacc_search_q" )"; then   
                    local headers="$(echo $kernel | sed 's/-bin/-headers-bin/g')" 
                    printf "${GREEN}Installing ${CYAN}$headers${normal}\n" 
                    eval "$pacc_ins_y $headers"
                fi
            else
                printf "${YELLOW}Uncertain which kernel package relevant for current kernel\nTry looking for yourself using your packagemanager (f.ex. pacman)\n"
            fi
        fi
    fi
}
