hash lowfi &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash lowfi &> /dev/null; then
    if ! hash npm &> /dev/null; then
       if ! test -f pkgmngrs/install_npm.sh; then
           source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_npm.sh) 
       else
           . pkgmngrs/install_npm.sh 
       fi 
    else 
        sudo npm -g update 
    fi
    sudo npm install -g lowfi 
fi
