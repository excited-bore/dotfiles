hash snap &> /dev/null && SYSTEM_UPDATED='TRUE'

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


if ! hash snap &> /dev/null; then
    eval "$pac_ins_y snapd"
fi

if grep -q "SNAP" $ENV; then
    sed -i 's|#export PATH=$PATH:/bin/snap|export PATH=$PATH:/bin/snap|g' "$ENV"
else
    echo "export PATH=:\$PATH/bin/snap:/var/lib/snapd/snap/bin" >> "$ENV"
fi

sudo systemctl daemon-reload
sudo snap install core
