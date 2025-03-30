#!/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
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
    fi
fi

if ! type rg &> /dev/null; then 
    if [[ $distro_base == "Arch" ]] || [[ "$distro_base" == 'Debian' ]]; then
        eval "${pac_ins} ripgrep"
    fi
fi

if test -f ripgrep/.ripgreprc; then
    file=ripgrep/.ripgreprc
else
    dir1="$(mktemp -d -t rg-XXXXXXXXXX)"
    curl -s -o $dir1/.ripgreprc https://raw.githubusercontent.com/excited-bore/dotfiles/main/ripgrep/.ripgreprc
    file=$dir1/.ripgreprc
fi

if ! test -f ~/.ripgreprc; then 
    function ripgrep_conf(){
        cp -fbv $file $HOME 
        if grep -q 'export RIPGREP_CONFIG_PATH' $ENVVAR; then
            sed -i 's|#export RIPGREP_CONFIG_PATH=|export RIPGREP_CONFIG_PATH=|g' $ENVVAR
            sed -i 's|export RIPGREP_CONFIG_PATH=.*|export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc|g' $ENVVAR
        else 
            echo 'export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc' >> $ENVVAR
        fi
    } 
    yes-no-edit -f ripgrep_conf -g "$file" -p "Install .ripgreprc at $HOME?" -i "y" -Q "GREEN"; 
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether root dir exists and whether it contains a .ripgreprc config file"
if sudo test -d /root && ! sudo test -f /root/.ripgreprc; then 
    function ripgrep_conf_r(){
        sudo cp -fbv $file /root 
        if sudo grep -q 'export RIPGREP_CONFIG_PATH' $ENVVAR_R; then
            sudo sed -i 's|#export RIPGREP_CONFIG_PATH=|export RIPGREP_CONFIG_PATH=|g' $ENVVAR_R
            sudo sed -i 's|export RIPGREP_CONFIG_PATH=.*|export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc|g' $ENVVAR_R
        else 
            echo 'export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc' | sudo tee -a $ENVVAR_R
        fi
    } 
    yes-no-edit -f ripgrep_conf_r -g "$file" -p "Install .ripgreprc at /root?" -i "y" -Q "GREEN"; 
fi
