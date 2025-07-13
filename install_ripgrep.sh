#!/bin/bash

if ! test -f aliases/.bash_aliases.d/package_managers.sh; then
    source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/package_managers.sh)
else
    source aliases/.bash_aliases.d/package_managers.sh
fi

if ! hash rg &> /dev/null; then 
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
        cp $file $HOME 
        if grep -q 'export RIPGREP_CONFIG_PATH' $ENV; then
            sed -i 's|#export RIPGREP_CONFIG_PATH=|export RIPGREP_CONFIG_PATH=|g' $ENV
            sed -i 's|export RIPGREP_CONFIG_PATH=.*|export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc|g' $ENV
        else 
            echo 'export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc' >> $ENV &> /dev/null
        fi
    } 
    yes-edit-no -f ripgrep_conf -g "$file" -p "Install .ripgreprc at $HOME?" -c "test -f ~/.ripgreprc || test -n \"$(test -f ~/.ripgreprc && diff $file ~/.ripgreprc)\"" 
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will check whether root dir exists and whether it contains a .ripgreprc config file"
if sudo test -d /root && ! sudo test -f /root/.ripgreprc; then 
    function ripgrep_conf_r(){
        sudo cp $file /root 
        if sudo grep -q 'export RIPGREP_CONFIG_PATH' $ENV_R; then
            sudo sed -i 's|#export RIPGREP_CONFIG_PATH=|export RIPGREP_CONFIG_PATH=|g' $ENV_R
            sudo sed -i 's|export RIPGREP_CONFIG_PATH=.*|export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc|g' $ENV_R
        else 
            echo 'export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc' | sudo tee -a $ENV_R &> /dev/null
        fi
    } 
    yes-edit-no -f ripgrep_conf_r -g "$file" -p "Install .ripgreprc at /root?" 
fi
