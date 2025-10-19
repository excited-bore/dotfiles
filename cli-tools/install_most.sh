# https://jedsoft.org/most/

hash most &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! test -f $TOP/checks/check_envvar.sh; then
     source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_envvar.sh) 
else
    . $TOP/checks/check_envvar.sh
fi

if ! hash most &> /dev/null; then
    if [[ $distro_base == "Arch" || $distro_base == "Debian" ]]; then
        eval "$pac_ins_y most"
    fi
fi

most=$(whereis most)
readyn -p "Set most default pager for $USER?" most_usr
if [[ "y" == "$most_usr" ]]; then
    if grep -q "MOST" $ENV; then 
        sed -i "s|.export MOST_SWITCHES=|export MOST_SWITCHES=|g" $ENV 
        sed -i "s|.export PAGER=|export PAGER=|g" $ENV
        sed -i "s|export PAGER=.*|export PAGER=$most|g" $ENV
        sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=\$PAGER|g" $ENV
        sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENV
    else
        printf "export PAGER=$most\n" >> $ENV
        printf "export SYSTEMD_PAGER=\$PAGER" >> $ENV
        printf "export SYSTEMD_PAGERSECURE=1" >> $ENV
    fi
fi
    
readyn -Y 'YELLOW' -p "Set most default pager for root?" most_root
if [[ "y" == "$most_root" ]]; then
    if sudo grep -q "MOST" $ENV_R; then
        sudo sed -i "s|.export MOST_SWITCHES=.*|export MOST_SWITCHES=.*|g" $ENV_R 
        sudo sed -i "s|.export PAGER=.*|export PAGER=$most|g" $ENV_R
        sudo sed -i "s|.export SYSTEMD_PAGER=.*|export SYSTEMD_PAGER=$PAGER|g" $ENV_R
        sudo sed -i "s|.export SYSTEMD_PAGERSECURE=.*|export SYSTEMD_PAGERSECURE=1|g" $ENV_R
    else
        printf "export PAGER=$most\n" | sudo tee -a $ENV_R
        printf "export SYSTEMD_PAGER=\$PAGER\n" | sudo tee -a $ENV_R
        printf "export SYSTEMD_PAGERSECURE=1\n" | sudo tee -a $ENV_R
    fi
fi

unset most most_usr most_root
