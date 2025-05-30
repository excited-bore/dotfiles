SYSTEM_UPDATED='TRUE'

if ! hash ack &> /dev/null; then
    if ! test -f install_ack.sh; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_ack.sh)
    else
        . ./install_ack.sh
    fi 
fi

if ! test -f checks/check_aliases_dir.sh; then
    source <(curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)
else
    . ./checks/check_aliases_dir.sh
fi 

if ! type h &> /dev/null; then
    sudo wget-aria-dir ~/.bash_aliases.d/ https://raw.githubusercontent.com/paoloantinori/hhighlighter/refs/heads/master/h.sh
    #printf '\nh "$@\n\"' | sudo tee -a /usr/bin/h &> /dev/null 
    #sudo chmod 0755 /usr/bin/h 
fi
source ~/.bash_aliases.d/h.sh
h --help 
