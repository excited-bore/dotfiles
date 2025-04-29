#!/bin/bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi


if ! type nvim > /dev/null ; then
   if ! test -f ./install_nvim.sh; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/install_fzf.sh)
    else
        . ./install_nvim.sh
    fi
fi

if ! type scdoc &> /dev/null; then
   eval "$pac_ins scdoc"
fi

if ! type nvimpager &> /dev/null; then
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
    cp -fv ~/.config/nvim/* ~/.config/nvimpager/
fi

readyn -p "Set nvimpager as default pager for $USER?" moar_usr
if [[ "y" == "$moar_usr" ]]; then
    if grep -q "PAGER" $ENVVAR; then 
        sed -i "s|.export PAGER=|export PAGER=|g" $ENVVAR
        sed -i "s|export PAGER=.*|export PAGER=$(whereis nvimpager | awk '{print $2;}')|g" $ENVVAR
    else
        printf "export PAGER=$(whereis nvimpager | awk '{print $2;}')\n" >> $ENVVAR
    fi
fi

readyn -Y 'YELLOW' -p "Set nvimpager default pager for root?" moar_root
if [[ "y" == "$moar_root" ]]; then
    if sudo grep -q "PAGER" $ENVVAR_R; then
        sudo sed -i "s|.export PAGER=|export PAGER=|g" $ENVVAR_R
        sudo sed -i "s|export PAGER=.*|export PAGER=$(whereis nvimpager | awk '{print $2;}')|g" $ENVVAR_R
    else
        printf "export PAGER=$(whereis nvimpager | awk '{print $2;}')\n" | sudo tee -a $ENVVAR_R
    fi
fi
