#!/bin/bash

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

if ! type activate-global-python-argcomplete &> /dev/null; then
    if [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins python3 python-is-python3"
    elif [[ $distro_base == "Arch" ]]; then
        eval "$pac_ins python"
    fi
fi

if type curl &> /dev/null && ! type pipx &> /dev/null; then
   if ! test -f install_pipx.sh; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh) 
    else
        . ./install_pipx.sh
    fi 
fi

if ! type pipx &> /dev/null && test -f $HOME/.local/bin/pipx; then
    $HOME/.local/bin/pipx install argcomplete
else
    pipx install argcomplete
fi

if type activate-global-python-argcomplete &> /dev/null; then
    activate-global-python-argcomplete --dest=/home/$USER/.bash_completion.d 
elif type activate-global-python-argcomplete3 &> /dev/null; then
    activate-global-python-argcomplete3 --dest=/home/$USER/.bash_completion.d 
fi
    
sed -i 's|.export PYTHON_ARGCOMPLETE_OK="True"|export PYTHON_ARGCOMPLETE_OK="True"|g' $ENVVAR

#if ! grep -q "python-argcomplete" ~/.bashrc; then
#    echo ". ~/.bash_completion.d/_python-argcomplete" >> ~/.bashrc
#fi

#reade -Q "YELLOW" -i "y" -p "Install python completion system wide? (/root/.bashrc) "" arg
#if [ "y" == "$arg" ]; then 
#    if type activate-global-python-argcomplete &> /dev/null; then
#        sudo activate-global-python-argcomplete --dest=/root/.bash_completion.d
#    elif type activate-global-python-argcomplete3 &> /dev/null; then
#        sudo activate-global-python-argcomplete3 --dest=/root/.bash_completion.d
#    fi
#    #if ! sudo grep -q "python-argcomplete" /root/.bashrc; then
#    #    printf "\n. ~/.bash_completion.d/_python-argcomplete" | sudo tee -a /root/.bashrc
#    #fi
#fi
