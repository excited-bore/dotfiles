# https://pypi.org/project/argcomplete/

hash activate-global-python-argcomplete &> /dev/null && SYSTEM_UPDATED='TRUE'

TOP=$(git rev-parse --show-toplevel 2> /dev/null)

if ! test -f $TOP/checks/check_all.sh; then
    if hash curl &> /dev/null; then
        source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    else
        source <(wget -qO- https://raw.githubusercontent.com/excited-bore/dotfiles/main/checks/check_all.sh)
    fi
else
    . $TOP/checks/check_all.sh
fi

if ! hash activate-global-python-argcomplete &> /dev/null; then
    if [[ $distro_base == "Debian" ]]; then
        eval "$pac_ins python3 python-is-python3"
    elif [[ $distro_base == "Arch" ]]; then
        eval "$pac_ins python"
    fi
fi

if ! hash pipx &> /dev/null; then
   if ! test -f $TOP/cli-tools/pkgmngrs/install_pipx.sh; then
        source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_pipx.sh) 
    else
        . $TOP/cli-tools/pkgmngrs/install_pipx.sh
    fi 
fi

if ! hash pipx &> /dev/null && test -f $HOME/.local/bin/pipx; then
    $HOME/.local/bin/pipx install argcomplete
else
    pipx install argcomplete
fi

if test -d ~/.bash_completion.d; then
    if hash activate-global-python-argcomplete &> /dev/null; then
        activate-global-python-argcomplete --dest=$HOME/.bash_completion.d 
    elif hash activate-global-python-argcomplete3 &> /dev/null; then
        activate-global-python-argcomplete3 --dest=$HOME/.bash_completion.d 
    fi
fi

if test -d ~/.zsh_completion.d/site-functions/; then
    if hash activate-global-python-argcomplete &> /dev/null; then
        activate-global-python-argcomplete --dest=$HOME/.zsh_completion.d/site-functions/ 
    elif hash activate-global-python-argcomplete3 &> /dev/null; then
        activate-global-python-argcomplete3 --dest=$HOME/.zsh_completion.d/site-functions/ 
    fi
fi

sed -i 's|.export PYTHON_ARGCOMPLETE_OK="True"|export PYTHON_ARGCOMPLETE_OK="True"|g' $ENV

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
