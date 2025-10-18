hash h &> /dev/null && SYSTEM_UPDATED='TRUE'

if ! test -f ../checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . ../checks/check_all.sh
fi

if ! hash ack &> /dev/null; then
    if ! test -f install_ack.sh; then
        source <(wget-curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_ack.sh)
    else
        . ./install_ack.sh
    fi 
fi

if ! [ -f ../checks/check_aliases_dir.sh ]; then
    source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)
else
    . ../checks/check_aliases_dir.sh
fi 

if ! type h &> /dev/null; then
    sudo wget-aria-dir ~/.aliases.d/ https://raw.githubusercontent.com/paoloantinori/hhighlighter/refs/heads/master/h.sh
    #printf '\nh "$@\n\"' | sudo tee -a /usr/bin/h &> /dev/null 
    #sudo chmod 0755 /usr/bin/h 
fi
source ~/.aliases.d/h.sh
h --help 
