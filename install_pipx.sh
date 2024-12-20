# !/bin/bash
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


if ! type pipx &> /dev/null; then
    readyn -p "Install pipx? (for installing packages outside of virtual environments)" insppx
    if test $insppx == "y"; then
        upg_pipx='n' 
        if test $machine == 'Mac' && type brew &> /dev/null; then
            echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pipx"
            brew install python python-pipx
            if [[ $(pipx --version) < 1.6.0 ]]; then 
                pipx install pipx
                pipx upgrade pipx
                brew uninstall pipx 
                export PATH=$PATH:$HOME/.local/bin 
                upg_pipx='y' 
            fi
        elif test $distro_base == "Arch"; then 
            echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pipx"
            eval "$pac_ins python-pipx"
            if [[ $(pipx --version) < 1.6.0 ]]; then 
                pipx install pipx
                pipx upgrade pipx
                sudo pacman -Rs pipx 
                export PATH=$PATH:$HOME/.local/bin 
                upg_pipx='y' 
            fi
        elif test $distro_base == "Debian"; then
            echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pipx"
            eval "$pac_ins pipx"
            if [[ $(pipx --version) < 1.6.0 ]]; then 
                pipx install pipx
                pipx upgrade pipx
                sudo apt purge --autoremove -y pipx 
                export PATH=$PATH:$HOME/.local/bin 
                upg_pipx='y' 
            fi 
        fi

        if test $upg_pipx == 'y'; then 
            $HOME/.local/bin/pipx ensurepath
        else
            pipx ensurepath
        fi 
        source ~/.bashrc 

        if ! test $machine == 'Windows'; then 
            readyn -p "Set to install packages globally (including for root)?" insppxgl
            if test $insppxgl == "y"; then 
                if test $upg_pipx == 'y'; then 
                    sudo $HOME/.local/bin/pipx --global ensurepath
                else
                    sudo pipx --global ensurepath 
                fi
            fi
        fi 
        
        if ! type activate-global-python-argcomplete &> /dev/null; then
            readyn -p "Install argcomplete with pipx? (autocompletion for python scripts)" pycomp
            if test $pycomp == 'y'; then
                if test $upg_pipx == 'y'; then
                    $HOME/.local/bin/pipx install argcomplete
                else
                    pipx install argcomplete 
                fi 

                if type activate-global-python-argcomplete &> /dev/null; then
                    activate-global-python-argcomplete --dest=/home/$USER/.bash_completion.d 
                elif type activate-global-python-argcomplete3 &> /dev/null; then
                    activate-global-python-argcomplete3 --dest=/home/$USER/.bash_completion.d 
                fi
            fi 
        fi
    fi
fi

