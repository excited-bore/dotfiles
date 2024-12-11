# !/bin/bash
if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi
if ! test -f aliases/.bash_aliases.d/00-rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! type update-system &> /dev/null; then
    if ! test -f aliases/.bash_aliases.d/update-system.sh; then
        eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/update-system.sh)" 
    else
        . ./aliases/.bash_aliases.d/update-system.sh
    fi
fi

if test -z $SYSTEM_UPDATED; then
    readyn -Y "CYAN" -p "Update system?" updatesysm
    if test $updatesysm == "y"; then
        update-system                     
    fi
fi

if ! type bat &> /dev/null; then 
    if test $distro == "Arch" || test $distro == "Manjaro";then
        eval "$pac_ins bat"
    elif [ $distro_base == "Debian" ]; then
        eval "$pac_ins bat"
        if [ -x "$(command -v batcat)" ]; then
            mkdir -p ~/.local/bin
            ln -s /usr/bin/batcat ~/.local/bin/bat
        fi
    fi
fi 

if ! type batdiff &> /dev/null; then 
    readyn -p "Install bat-extras (includes batdiff/batgrep/batman/bat-modules/batpipe/batwatch)" bat
    if test "$bat" == "y"; then
        if test "$distro" == "Arch" || test "$distro" == "Manjaro";then
            eval "$pac_ins bat-extras"
        elif [ $distro_base == "Debian" ]; then
            #yes | eval "$pac_ins golang"
            #go install mvdan.cc/sh/v3/cmd/shfmt@latest
            git clone https://github.com/eth-p/bat-extras $TMPDIR/bat-extras
            chown -R $USER $TMPDIR/bat-extras
            (cd $TMPDIR/bat-extras && sudo ./build.sh --install --prefix=/usr)
        fi 
    fi
fi

unset bat 
