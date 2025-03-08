#if ! test -f checks/check_system.sh; then
#     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
#else
#    . checks/check_system.sh
#fi
#
#if ! type reade &> /dev/null; then
#     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
#else
#    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
#fi

file=rm-prmpt/rm-prompt
if ! test -f $file; then
    tmp=$(mktemp) && curl -o $tmp https://raw.githubusercontent.com/excited-bore/dotfiles/main/rm-prmpt/rm-prompt
    file=$tmp
fi

#if ! type rm-prompt &> /dev/null; then
    #reade -Q 'GREEN' -i 'y' -p 'Install rm-prompt? (Rm but prompts files before deletion) [Y/n]: ' 'n' rm_ins
    #if test $rm_ins == 'y'; then
        echo "Next $(tput setaf 1)sudo$(tput sgr0) will install $(tput setaf 2)rm-prompt$(tput sgr0) inside $(tput bold)/usr/bin/$(tput sgr0)"
        sudo install -Dm777 $file -t "/usr/bin/" 
    #fi
#fi
