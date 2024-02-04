#!/bin/bash
. ./aliases/rlwrap_scripts.sh
. ./checks/check_distro.sh


if [ ! -x "$(command -v go)" ]; then
    reade -Q "GREEN" -i "y" -p "Installer uses go. Install? [Y/n]: " "y n" go
    if [ "y" == "$go" ]; then
        ./install_go.sh
    fi
    unset go
fi

if [ -z "$GOPATH" ]; then
    reade -Q "GREEN" -i "y" -p "Installer uses go. In order to use go commandline tools, go binaries need to be sourced globally. Set GOPATH? [Y/n]: " "y n" gopth
    if [ "y" == "$gopth" ];  then
        
        reade -Q "CYAN" -i "$HOME/.local" -p "Set GOPATH (go packages): " -e gopth
        
        if grep -q "GOPATH" $PATHVAR; then
            sed -i "s|.export GOPATH=|export GOPATH=|g" $PATHVAR
            sed -i "s|export GOPATH=.*|export GOPATH=$gopth|g" $PATHVAR
            sed -i "s|.export PATH=\$PATH:\$GOPATH|export PATH=\$PATH:\$GOPATH|g" $PATHVAR
        else
            echo "export GOPATH=$gopth" >> $PATHVAR
            echo "export PATH=\$PATH:\$GOPATH" >> $PATHVAR
        fi     
        unset gopth goroot
    fi
fi

go install -v github.com/theimpostor/osc@latest
if [ ! -f ~/.bash_completion.d/osc ]; then
    touch ~/.bash_completion.d/osc
fi
osc completion bash > ~/.bash_completion.d/osc
source ~/.bashrc
