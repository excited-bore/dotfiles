#!/bin/bash
. ./readline/rlwrap_scripts.sh
. ./checks/check_distro.sh

if [ ! -x "$(command -v pipx)" ]; then
    reade -Q "GREEN" -i "y" -p "Installer uses pipx. Install? [Y/n]: " "y n" py
    if [ "y" == "$py" ]; then
        if [ $distro == "Manjaro" ]; then
            yes | pamac install pipx
        elif [ $distro == "Arch" ]; then
            yes | sudo pacman -Su pipx
        elif [[ $distro == "Debian" || $distro_base == "Debian" ]]; then
            yes | sudo apt update
            yes | sudo apt install pipx
        fi
    fi
    unset py
fi
pipx install oscclip


#if [ ! -x "$(command -v go)" ]; then
#    reade -Q "GREEN" -i "y" -p "Installer uses go. Install? [Y/n]: " "y n" go
#    if [ "y" == "$go" ]; then
#        ./install_go.sh
#    fi
#    unset go
#fi
#
#if [ -z "$GOPATH" ]; then
#    reade -Q "GREEN" -i "y" -p "Installer uses go. In order to use go commandline tools, go binaries need to be sourced globally. Set GOPATH? [Y/n]: " "y n" gopth
#    if [ "y" == "$gopth" ];  then
#        
#        reade -Q "CYAN" -i "$HOME/.local" -p "Set GOPATH (go packages): " -e gopth
#        echo "${cyan}Only GOPATH is necessary. Setting GOROOT is usually for development reasons"
#        reade -Q "CYAN" -p "Set custom GOROOT? (Go tools, empty means leave default): " -e goroot 
#        
#        if grep -q "GOPATH" $PATHVAR; then
#            if [ -z "$goroot" ]; then
#                sed -i "s|.export GOPATH=|export GOPATH=|g" $PATHVAR
#                sed -i "s|export GOPATH=.*|export GOPATH=$gopth|g" $PATHVAR
#                sed -i "s|.export PATH=\$PATH:\$GOPATH|export PATH=\$PATH:\$GOPATH|g" $PATHVAR
#            else
#                sed -i "s|.export GOPATH=|export GOPATH=|g" $PATHVAR
#                sed -i "s|export GOPATH=.*|export GOPATH=$gopth|g" $PATHVAR
#                sed -i "s|.export GOROOT=|export GOROOT=|g" $PATHVAR
#                sed -i "s|export GOROOT=.*|export GOROOT=$goroot|g" $PATHVAR
#                sed -i "s|.export PATH=\$PATH:\$GOPATH|export PATH=\$PATH:\$GOPATH:\$GOROOT|g" $PATHVAR
#            fi
#        else
#             if [ -z "$goroot" ]; then   
#                echo "export GOPATH=$gopth" >> $PATHVAR
#                echo "export PATH=\$PATH:\$GOPATH" >> $PATHVAR
#            else
#                echo "export GOPATH=$gopth" >> $PATHVAR
#                echo "export GOROOT=$goroot" >> $PATHVAR
#                echo "export PATH=\$PATH:\$GOPATH:\$GOROOT" >> $PATHVAR
#            fi
#        fi     
#        unset gopth goroot
#    fi
#fi
#
#go install -v github.com/theimpostor/osc@latest
#if [ ! -f ~/.bash_aliases.d/osc ]; then
#    touch ~/.bash_aliases.d/osc
#fi
#osc completion bash > ~/.bash_aliases.d/osc
source ~/.bashrc
