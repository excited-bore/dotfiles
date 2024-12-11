#!/bin/bash

if ! type reade &> /dev/null && test -f ~/.bash_aliases.d/00-rlwrap_scripts.sh; then
    source ~/.bash_aliases.d/00-rlwrap_scripts.sh
fi

#linux_curr=$(sudo mhwd-kernel --listinstalled | awk 'NR==1{print $4;}' | cut -d\( -f2- | cut -d\) -f1)
#linux_lts='linux66'

alias pamac-list-installed="pamac list --installed "
alias manjaro-GPU-list-drivers="sudo mhwd -l -d"
alias manjaro-GPU-list-installed-drivers="sudo mhwd -li -d" 
alias manjaro-GPU-install-driver-free="sudo mhwd -a pci free 0300"
alias manjaro-GPU-install-driver-proprietary="sudo mhwd -a pci nonfree 0300"
alias manjaro-GPU-check-driver="sudo mhwd-gpu --check"
alias manjaro-GPU-status-driver="sudo mhwd-gpu --status"
alias manjaro-GPU-set-module-driver="sudo mhwd-gpu --setmod"
# sudo mhwd-gpu --setxorg /etc/x11/xorg.conf

function manjaro-GPU-remove-driver-by-name(){
    sudo mhwd -r pci "$1";
}

function manjaro-install-kernel(){
    kernels="$(sudo mhwd-kernel --list | awk 'NR>1{print $2;}')"
    kernels="$(echo $kernels | sed "s/\<$linux_lts\> //g")"
    readyn -p "Remove current kernel after installation?" rm_af
    rm_af="$(test $rm_af == 'y' && echo 'rmc' || echo '')"    
    kernels_p=$(echo $kernels | tr " " '/')
    linux_lts_p="$(echo $linux_lts | tr '[:lower:]' '[:upper:]')"
    reade -Q 'GREEN' -i "$linux_lts $kernels" -p "Install which one [$linux_lts_p/$kernels_p]: " kern
    sudo mhwd-kernel -i $kern $rm_af
    sudo mhwd-kernel --listinstalled
    unset kern kernels rm_af linux_lts_p kernels_p 
}

function manjaro-remove-kernel(){
    kernels="$(sudo mhwd-kernel --listinstalled | awk 'NR>2{print $2;}')"
    frst="$(echo $kernels | awk '{print $1}')"
    frst_p="$(echo $frst | tr '[:lower:]' '[:upper:]')"
    kernels="$(echo $kernels | sed "s/\<$frst\>//g")"
    if ! test -z $kernels; then
        kernels_p="/$(echo $kernels | tr " " '/')"
    else
        kernels_p=''
    fi
    reade -Q 'GREEN' -i "$frst $kernels" -p "Remove which one [$frst_p$kernels_p]: "  kern
    sudo mhwd-kernel -r $kern
    sudo mhwd-kernel --listinstalled
    unset kern kernels frst frst_p kernels_p 
} 
