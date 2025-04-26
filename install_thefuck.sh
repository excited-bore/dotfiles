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

SCRIPT_DIR=$(get-script-dir)

if ! type thefuck &>/dev/null; then
    if [[ $machine == 'Mac' ]] && type brew &>/dev/null; then
        brew install thefuck
    elif [[ $distro_base == 'Arch' ]]; then
        eval "${pac_ins} thefuck"
    elif type pkg &>/dev/null; then
        pkg install thefuck
    elif type crew &>/dev/null; then
        crew install thefuck
    else
         
        [[ $distro_base == 'Debian' ]] &&
            eval "${pac_ins} python3-dev python3-pip python3-setuptools"
        
        if ! type pipx &>/dev/null; then
            if ! test -f install_pipx.sh; then
                source <(curl -fsSL https://raw.githubusercontent.com/excited-bore/dotfiles/main/install_pipx.sh)
            else
                . ./install_pipx.sh
            fi
        fi
        if test -f $HOME/.local/bin/pipx && ! type pipx &>/dev/null; then
            $HOME/.local/bin/pipx install thefuck
        elif type pipx &>/dev/null; then
            pipx install thefuck
        fi
        (cd $HOME/.local/share/pipx/venvs/thefuck
         ./python3 -m pip install setuptools
        )
        sed -i 's/from imp import load_source/import importlib.machinery/' $HOME/.local/share/python3.12/site-packages/thefuck/conf.py
        sed -i 's/settings = load_source(/settings = importlib.machinery.SourceFileLoader("settings", text_type(self.user_dir.joinpath("settings.py"))).load_module()/' $HOME/.local/share/python3.12/site-packages/thefuck/conf.py
        sed -i "/'settings', text_type(self.user_dir.joinpath('settings.py')))/d" $HOME/.local/share/python3.12/site-packages/thefuck/conf.py
        
        sed -i 's/from imp import load_source/import importlib.machinery/' $HOME/.local/share/pipx/venvs/thefuck/lib/python3.12/site-packages/thefuck//types.py
        sed -i 's/rule_module = load_source(name, str(path))/rule_module = importlib.machinery.SourceFileLoader(name, str(path)).load_module()/' $HOME/.local/share/pipx/venvs/thefuck/lib/python3.12/site-packages/thefuck//types.py
    fi
fi

if ! grep -q 'eval "$(thefuck --alias' ~/.bashrc; then
    reade -Q 'GREEN' -i 'f fuk fuck h hell heck hek oops ops egh huhn huh nono again agin asscreamIscream' -p "Alias for name 'thefuck'? [Empty: 'f' - 'thefuck' cant be used]: " ansr
    if [[ $ansr == 'thefuck' ]]; then
        printf "'thefuck' cant be aliased to 'thefuck'\n"
        printf "Using 'f' as alias\n"
        ansr='f'
    fi

    if ! test -z $ansr; then
        printf "eval \"\$(thefuck --alias $ansr)\"\n" >>~/.bashrc
    fi
    unset ansr
fi
