# https://github.com/talwat/lowfi

hash lowfi &> /dev/null && SYSTEM_UPDATED='TRUE'

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

if ! hash lowfi &> /dev/null; then
    if ! hash npm &> /dev/null; then
       if ! test -f $TOP/cli-tools/pkgmngrs/install_npm.sh; then
           source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_npm.sh) 
       else
           . $TOP/cli-tools/pkgmngrs/install_npm.sh 
       fi 
    else 
        sudo npm -g update 
    fi
    sudo npm install -g lowfi 
fi
