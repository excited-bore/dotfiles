#!/bin/bash

if ! test -f aliases/.bash_aliases.d/rlwrap_scripts.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/aliases/.bash_aliases.d/rlwrap_scripts.sh)" 
else
    . ./aliases/.bash_aliases.d/rlwrap_scripts.sh
fi

if ! test -f checks/check_system.sh; then
     eval "$(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_system.sh)" 
else
    . ./checks/check_system.sh
fi

if ! type go &> /dev/null; then
    reade -Q "GREEN" -i "y" -p "Installer uses go. Install? [Y/n]: " "y n" go
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
#    reade -Q "GREEN" -i "y" -p "Installer uses go. In order to use go commandline tools, go binaries need to be sourced globally. Set GOPATH? [Y/n]: " "y n" gopth
#    if [ "y" == "$gopth" ];  then
#        
#        reade -Q "CYAN" -i "$HOME/.local" -p "Set GOPATH (go packages): " -e gopth
#        
#        if grep -q "GOPATH" $PATHVAR; then
#            sed -i "s|.export GOPATH=|export GOPATH=|g" $PATHVAR
#            sed -i "s|export GOPATH=.*|export GOPATH=$gopth|g" $PATHVAR
#            sed -i "s|.export PATH=\$PATH:\$GOPATH|export PATH=\$PATH:\$GOPATH|g" $PATHVAR
#        else
#            echo "export GOPATH=$gopth" >> $PATHVAR
#            echo "export PATH=\$PATH:\$GOPATH" >> $PATHVAR
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
