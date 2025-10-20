# https://github.com/paoloantinori/hhighlighter

hash ack &> /dev/null && SYSTEM_UPDATED='TRUE'

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

if ! hash ack &> /dev/null; then
    if ! test -f $TOP/cli-tools/install_ack.sh; then
        source <(wget-curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/install_ack.sh)
    else
        . $TOP/cli-tools/install_ack.sh
    fi 
fi

if test -d ~/.aliases.d/ && ! test -f ~/.aliases.d/h.sh; then
    sudo wget-aria-dir ~/.aliases.d/ https://raw.githubusercontent.com/paoloantinori/hhighlighter/refs/heads/master/h.sh
    #printf '\nh "$@\n\"' | sudo tee -a /usr/bin/h &> /dev/null 
    #sudo chmod 0755 /usr/bin/h 
    source ~/.aliases.d/h.sh
fi

h --help 
