#!/usr/bin/env bash

if ! test -f checks/check_all.sh; then
    if type curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        printf "If not downloading/git cloning the scriptfolder, you should at least install 'curl' beforehand when expecting any sort of succesfull result...\n"
        return 1 || exit 1
    fi
else
    . ./checks/check_all.sh
fi

get-script-dir SCRIPT_DIR

if ! type lazygit &>/dev/null; then
    if [[ "$distro_base" == "Arch" ]]; then
        eval "${pac_ins}" lazygit
    elif [[ "$distro_base" == "Debian" ]]; then
        if ! test -z "$(apt search --names-only lazygit 2>/dev/null | awk 'NR>2 {print;}')"; then
            eval "${pac_ins}" lazygit
        else
            if ! type curl &>/dev/null; then
                #if [[ $distro_base == 'Debian' ]] || [[ $distro_base == 'Arch' ]]; then
                eval "${pac_ins}" curl
                #fi
            fi
            LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po --color=never '"tag_name": "v\K[^"]*')
            wget -O $TMPDIR/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            (cd $TMPDIR && tar xf $TMPDIR/lazygit.tar.gz)
            sudo install $TMPDIR/lazygit /usr/local/bin
        fi
    fi
    lazygit --version
    unset nstll
fi

#if ! type copy-to &>/dev/null; then
#    readyn -p "Install copy-to?" cpcnf
#    if [[ "y" == "$cpcnf" ]] || [ -z "$cpcnf" ]; then
#        if ! test -f install_copy-to.sh; then
#            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_copy-to.sh)"
#        else
#            . ./install_copy-to.sh
#        fi
#    fi
#fi
#
#if type copy-to &>/dev/null; then
#    if ! test -d ~/.bash_aliases.d/ || ! test -f ~/.bash_aliases.d/lazygit.sh || (test -f ~/.bash_aliases.d/lazygit.sh && ! grep -q "copy-to" ~/.bash_aliases.d/lazygit.sh); then
#        readyn -p "Set up an alias so copy-to does a 'run all' when starting up lazygit?" nstll
#        if [[ "$nstll" == "y" ]]; then
#            if ! test -f checks/check_aliases_dir.sh; then
#                eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_aliases_dir.sh)"
#            else
#                . ./checks/check_aliases_dir.sh
#            fi
#            if ! test -f ~/.bash_aliases.d/lazygit.sh; then
#                printf "alias lazygit=\"copy-to run all; lazygit\"\n" >~/.bash_aliases.d/lazygit.sh
#                echo "$(tput setaf 2)File in ~/.bash_aliases.d/lazygit.sh"
#            fi
#        fi
#        unset nstll
#    fi
#fi
#unset nstll
