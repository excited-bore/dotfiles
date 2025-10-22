hash pipx &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &>/dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash pipx &>/dev/null; then
    readyn -p "Install pipx? (for installing packages outside of virtual environments)" insppx
    if [[ "$insppx" == "y" ]]; then
        upg_pipx='n'
        if [[ "$machine" == 'Mac' ]] && type brew &>/dev/null; then
            echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pipx"
            brew install python python-pipx
            if awk "BEGIN {exit !($(pipx --version) < 1.6.0)}"; then
                pipx install pipx
                pipx upgrade pipx
                brew uninstall pipx
                export PATH=$PATH:$HOME/.local/bin
                upg_pipx='y'
            fi
        elif [[ "$distro_base" == "Arch" ]]; then
            echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pipx"
            eval "${pac_ins_y}" python-pipx
            if awk "BEGIN {exit !($(pipx --version) < 1.6.0)}"; then
                pipx install pipx
                pipx upgrade pipx
                sudo pacman -Rs pipx
                export PATH=$PATH:$HOME/.local/bin
                upg_pipx='y'
            fi
        elif [[ "$distro_base" == "Debian" ]]; then
            echo "This next $(tput setaf 1)sudo$(tput sgr0) will install pipx"
            eval "${pac_ins_y}" pipx
            if awk "BEGIN {exit !($(pipx --version) < 1.6.0)}"; then
                pipx install pipx
                pipx upgrade pipx
                sudo apt purge --autoremove -y pipx
                export PATH=$PATH:$HOME/.local/bin
                upg_pipx='y'
            fi
        fi

        if [[ "$upg_pipx" == 'y' ]]; then
            $HOME/.local/bin/pipx ensurepath
        else
            pipx ensurepath
        fi
        
	[[ "$SSHELL" == "bash" ]] && source ~/.bashrc 
	[[ "$SSHELL" == "zsh" ]] && source ~/.zshrc &> /dev/null	

        if ! [[ "$machine" == 'Windows' ]]; then
            readyn -p "Set to install packages globally (including for root)?" insppxgl
            if [[ "$insppxgl" == "y" ]]; then
                if [[ "$upg_pipx" == 'y' ]]; then
                    sudo $HOME/.local/bin/pipx --global ensurepath
                else
                    sudo pipx --global ensurepath
                fi
            fi
        fi

        if ! type activate-global-python-argcomplete &>/dev/null; then
            readyn -p "Install argcomplete with pipx? (autocompletion for python scripts)" pycomp
            if [[ "$pycomp" == 'y' ]]; then
                if [[ $upg_pipx == 'y' ]]; then
                    $HOME/.local/bin/pipx install argcomplete
                else
                    pipx install argcomplete
                fi

                if type activate-global-python-argcomplete &>/dev/null; then
                    activate-global-python-argcomplete --dest=/home/$USER/.bash_completion.d
                elif type activate-global-python-argcomplete3 &>/dev/null; then
                    activate-global-python-argcomplete3 --dest=/home/$USER/.bash_completion.d
                fi
            fi
        fi
    fi
fi
