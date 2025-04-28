#!/usr/bin/env bash

if ! type reade &> /dev/null; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/00-rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/00-rlwrap_scripts.sh
fi

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
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

if ! type go &> /dev/null; then
    readyn -p "Installer uses go. Install?" go
    if [ "y" == "$go" ]; then
        if ! test -f install_go.sh; then
             eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_go.sh)" 
        else
            . ./install_go.sh
        fi
    fi
    unset go
fi

#if [ -z "$GOPATH" ]; then
#    readyn -p "Installer uses go. In order to use go commandline tools, go binaries need to be sourced globally. Set GOPATH?" gopth
#    if [ "y" == "$gopth" ];  then
#        
#        reade -Q "CYAN" -i "$HOME/.local" -p "Set GOPATH (go packages): " -e gopth
#        
#        if grep -q "GOPATH" $ENVVAR; then
#            sed -i "s|.export GOPATH=|export GOPATH=|g" $ENVVAR
#            sed -i "s|export GOPATH=.*|export GOPATH=$gopth|g" $ENVVAR
#            sed -i "s|.export PATH=\$PATH:\$GOPATH|export PATH=\$PATH:\$GOPATH|g" $ENVVAR
#        else
#            echo "export GOPATH=$gopth" >> $ENVVAR
#            echo "export PATH=\$PATH:\$GOPATH" >> $ENVVAR
#        fi     
#        unset gopth goroot
#    fi
#fi

go install -v github.com/theimpostor/osc@latest
if ! test -f checks/check_completions_dir.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_completions_dir.sh)" 
else
    . ./checks/check_completions_dir.sh
fi
osc completion bash > ~/.bash_completion.d/osc
source ~/.bashrc
