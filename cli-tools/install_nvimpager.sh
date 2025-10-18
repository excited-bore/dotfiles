hash nvimpager &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi


if ! hash nvim &> /dev/null ; then
   if ! test -f ./install_nvim.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_nvim.sh)
    else
        . ./install_nvim.sh
    fi
fi

if ! hash scdoc &> /dev/null; then
   eval "$pac_ins_y scdoc"
fi

if ! hash nvimpager &> /dev/null; then
    if ! hash git &> /dev/null; then
        eval "$pac_ins_y git"
    fi
    (cd $TMPDIR
    git clone https://github.com/lucc/nvimpager
    cd nvimpager
    make PREFIX=$HOME/.local install
    cd ..
    command rm -fr nvimpager
    )
fi

readyn -p "Copy configuration from $XDG_CONFIG_HOME/nvim/ to $XDG_CONFIG_HOME/nvimpager/ ?" conf
if [[ "$conf" == "y" ]]; then
    if ! test -d $XDG_CONFIG_HOME/nvimpager; then
        mkdir $XDG_CONFIG_HOME/nvimpager
    fi
    cp $XDG_CONFIG_HOME/nvim/* $XDG_CONFIG_HOME/nvimpager/
fi

readyn -p "Set nvimpager as default pager for $USER?" nvmpg_usr
if [[ "y" == "$nvmpg_usr" ]]; then
    if grep -q "PAGER" $ENV; then 
        sed -i "s|.export PAGER=|export PAGER=|g" $ENV
        sed -i "s|export PAGER=.*|export PAGER=$(whereis nvimpager | awk '{print $2;}')|g" $ENV
    else
        printf "export PAGER=$(whereis nvimpager | awk '{print $2;}')\n" >> $ENV
    fi
fi
unset nvmpg_usr

readyn -Y 'YELLOW' -p "Set nvimpager default pager for root?" nvmpg_root
if [[ "y" == "$nvmpg_root" ]]; then
    if sudo grep -q "PAGER" $ENV_R; then
        sudo sed -i "s|.export PAGER=|export PAGER=|g" $ENV_R
        sudo sed -i "s|export PAGER=.*|export PAGER=$(whereis nvimpager | awk '{print $2;}')|g" $ENV_R
    else
        printf "export PAGER=$(whereis nvimpager | awk '{print $2;}')\n" | sudo tee -a $ENV_R
    fi
fi
unset nvmpg_root
