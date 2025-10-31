# TODO: FIXME

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether you're using an nvidia gpu or not"

if sudo lspci -v | grep -qEi '^[0-9]+.*nvidia'; then
   # May just be applicable to manjaro 
    if [[ "$distro_base" == 'Arch' ]]; then
        if test -n "$AUR_pac"; then
            pacc_search_ins="$AUR_search_ins"; pacc_info="$AUR_info"; pacc_search="$AUR_search"
        else
            pacc_search_ins="$pac_search_ins"; pacc_info="$pac_info"; pacc_search="$pac_search"
        fi

        packages=() 
      
        # Nvidia-dkms 
        if [[ -z $(eval "$pacc_search_ins ^nvidia-dkms$") ]] || ([[ -n $(eval "$pacc_search_ins ^nvidia-*-dkms") ]] && version-higher "$(eval "$pacc_info nvidia-dkms | grep 'Version' | awk '{ print \$3 }'")" "$(eval "$pacc_search_ins ^nvidia-*-dkms | awk 'NR==1{ print \$2 }'")"); then
            [[ -n $(eval "$pacc_search_ins ^nvidia-*-dkms") ]] && 
                packages+=($(eval "$pacc_search_ins ^nvidia-*-dkms | awk 'NR==1 {print \$1}' | sed 's|local/||g'"))
        fi 

        # Nvidia-utils 
        if [[ -z $(eval "$pacc_search_ins ^nvidia-utils$") ]] || ([[ -n $(eval "$pacc_search_ins ^nvidia-*-utils") ]] && version-higher "$(eval "$pacc_info nvidia-utils | grep 'Version' | awk '{ print \$3 }'")" "$(eval "$pacc_search_ins ^nvidia-*-utils | awk 'NR==1{ print \$2 }'")"); then
            [[ -n $(eval "$pacc_search_ins ^nvidia-*-utils") ]] && 
                packages+=($(eval "$pacc_search_ins ^nvidia-*-utils | awk 'NR==1 {print \$1}' | sed 's|local/||g'"))
        fi 
       
        # Lib32-nvidia-utils 
        if [[ -z $(eval "$pacc_search_ins ^lib32-nvidia-utils$") ]] || ([[ -n $(eval "$pacc_search_ins ^lib32-nvidia-*-utils") ]] && version-higher "$(eval "$pacc_info lib32-nvidia-utils | grep 'Version' | awk '{ print \$3 }'")" "$(eval "$pacc_search_ins ^lib32-nvidia-*-utils | awk 'NR==1{ print \$2 }'")"); then
            [[ -n $(eval "$pacc_search_ins ^lib32-nvidia-*-utils") ]] && 
                packages+=($(eval "$pacc_search_ins ^lib32-nvidia-*-utils | awk 'NR==1 {print \$1}' | sed 's|local/||g'"))
        fi 

        # Nvidia-settings 
        if [[ -z $(eval "$pacc_search_ins ^nvidia-settings$") ]] || ([[ -n $(eval "$pacc_search_ins ^nvidia-*-settings") ]] && version-higher "$(eval "$pacc_info nvidia-settings | grep 'Version' | awk '{ print \$3 }'")" "$(eval "$pacc_search_ins ^nvidia-*-settings | awk 'NR==1{ print \$2 }'")"); then
            [[ -n $(eval "$pacc_search_ins ^nvidia-*-settings") ]] &&
                packages+=($(eval "$pacc_search_ins ^nvidia-*-settings | awk 'NR==1 {print \$1}' | sed 's|local/||g'"))
        fi 
    
        # Opencl-nvidia 
        if [[ -z $(eval "$pacc_search_ins ^opencl-nvidia$") ]] || ([[ -n $(eval "$pacc_search_ins ^opencl-nvidia-*") ]] && version-higher "$(eval "$pacc_info opencl-nvidia | grep 'Version' | awk '{ print \$3 }'")" "$(eval "$pacc_search_ins ^opencl-nvidia-* | awk 'NR==1{ print \$2 }'")"); then
            [[ -n $(eval "$pacc_search_ins ^opencl-nvidia-*") ]] && 
                packages+=($(eval "$pacc_search_ins ^opencl-nvidia-* | awk 'NR==1 {print \$1}' | sed 's|local/||g'"))
        fi 

        # Libxnvctrl
        if [[ -z $(eval "$pacc_search_ins ^libxnvctrl$") ]] || ([[ -n $(eval "$pacc_search_ins ^libxnvctrl-*") ]] && version-higher "$(eval "$pacc_info libxnvctrl | grep 'Version' | awk '{ print \$3 }'")" "$(eval "$pacc_search_ins ^libxnvctrl-* | awk 'NR==1{ print \$2 }'")"); then
            [[ -n $(eval "$pacc_search_ins ^libxnvctrl-*") ]] && 
                packages+=($(eval "$pacc_search_ins ^libxnvctrl-* | awk 'NR==1 {print \$1}' | sed 's|local/||g'"))
        fi 
    

        echo ${packages[@]} 
    fi
fi
