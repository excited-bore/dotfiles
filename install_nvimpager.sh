#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ./checks/check_all.sh
fi


if ! hash nvim &> /dev/null ; then
   if ! test -f ./install_nvim.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.aliases.d/install_fzf.sh)
    else
        . ./install_nvim.sh
    fi
fi

if ! hash scdoc &> /dev/null; then
   eval "$pac_ins scdoc"
fi

if ! hash nvimpager &> /dev/null; then
    (cd $TMPDIR
    git clone https://github.com/lucc/nvimpager
    cd nvimpager
    make PREFIX=$HOME/.local install
    cd ..
    command rm -fr nvimpager
    )
fi

readyn -p 'Copy configuration from ~/.config/nvim/ to ~/.config/nvimpager/ ?' conf
if [[ "$conf" == "y" ]]; then
    if ! test -d ~/.config/nvimpager; then
        mkdir ~/.config/nvimpager
    fi
    cp ~/.config/nvim/* ~/.config/nvimpager/
fi

readyn -p "Set nvimpager as default pager for $USER?" moar_usr
if [[ "y" == "$moar_usr" ]]; then
    if grep -q "PAGER" $ENV; then 
        sed -i "s|.export PAGER=|export PAGER=|g" $ENV
        sed -i "s|export PAGER=.*|export PAGER=$(whereis nvimpager | awk '{print $2;}')|g" $ENV
    else
        printf "export PAGER=$(whereis nvimpager | awk '{print $2;}')\n" >> $ENV
    fi
fi

readyn -Y 'YELLOW' -p "Set nvimpager default pager for root?" moar_root
if [[ "y" == "$moar_root" ]]; then
    if sudo grep -q "PAGER" $ENV_R; then
        sudo sed -i "s|.export PAGER=|export PAGER=|g" $ENV_R
        sudo sed -i "s|export PAGER=.*|export PAGER=$(whereis nvimpager | awk '{print $2;}')|g" $ENV_R
    else
        printf "export PAGER=$(whereis nvimpager | awk '{print $2;}')\n" | sudo tee -a $ENV_R
    fi
fi
