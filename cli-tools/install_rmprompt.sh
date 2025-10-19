SYSTEM_UPDATED='true'

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

file=$TOP/cli-tools/rm-prmpt/rm-prompt
if ! test -f $file; then
    tmp=$(mktemp) && wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/rm-prmpt/rm-prompt > $tmp
    file=$tmp
fi

echo "Next $(tput setaf 1)sudo$(tput sgr0) will install $(tput setaf 2)rm-prompt$(tput sgr0) inside $(tput bold)/usr/local/bin/$(tput sgr0)"
yes-edit-no -g "$file" -p 'Install rm-prompt?' -c '! hash rm-prompt &> /dev/null' nstll
if [[ $nstll == 'y' ]]; then
    sudo install -Dm777 $file -t "/usr/local/bin/" 
    rm-prompt --help 
fi


#if ! type rm-prompt &> /dev/null; then
    #reade -Q 'GREEN' -i 'y' -p 'Install rm-prompt? (Rm but prompts files before deletion) [Y/n]: ' 'n' rm_ins
    #if test $rm_ins == 'y'; then
    #fi
#fi
