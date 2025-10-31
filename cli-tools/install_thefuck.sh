# https://github.com/nvbn/thefuck

hash thefuck &> /dev/null && SYSTEM_UPDATED='TRUE'

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

if ! hash thefuck &>/dev/null; then
    if [[ $machine == 'Mac' ]] && hash brew &>/dev/null; then
        brew install thefuck
    elif [[ $distro_base == 'Arch' ]]; then
        eval "${pac_ins_y} thefuck"
    elif hash pkg &>/dev/null; then
        pkg install thefuck
    elif hash crew &>/dev/null; then
        crew install thefuck
    else
         
        [[ $distro_base == 'Debian' ]] &&
            eval "${pac_ins_y} python3-dev python3-pip python3-setuptools"
        
        if ! hash pipx &>/dev/null; then
            if ! test -f $TOP/cli-tools/pkgmngrs/install_pipx.sh; then
                source <(wget-curl https://raw.githubusercontent.com/excited-bore/dotfiles/main/cli-tools/pkgmngrs/install_pipx.sh)
            else
                . $TOP/cli-tools/pkgmngrs/install_pipx.sh
            fi
        fi
        if test -f $HOME/.local/bin/pipx && ! type pipx &>/dev/null; then
            $HOME/.local/bin/pipx install thefuck
        elif type pipx &>/dev/null; then
            pipx install thefuck
        fi
        (cd $XDG_DATA_HOME/pipx/venvs/thefuck
         ./python3 -m pip install setuptools
        )
        sed -i 's/from imp import load_source/import importlib.machinery/' $XDG_DATA_HOME/python3.12/site-packages/thefuck/conf.py
        sed -i 's/settings = load_source(/settings = importlib.machinery.SourceFileLoader("settings", text_type(self.user_dir.joinpath("settings.py"))).load_module()/' $XDG_DATA_HOME/python3.12/site-packages/thefuck/conf.py
        sed -i "/'settings', text_type(self.user_dir.joinpath('settings.py')))/d" $XDG_DATA_HOME/python3.12/site-packages/thefuck/conf.py
        
        sed -i 's/from imp import load_source/import importlib.machinery/' $XDG_DATA_HOME/pipx/venvs/thefuck/lib/python3.12/site-packages/thefuck//types.py
        sed -i 's/rule_module = load_source(name, str(path))/rule_module = importlib.machinery.SourceFileLoader(name, str(path)).load_module()/' $XDG_DATA_HOME/pipx/venvs/thefuck/lib/python3.12/site-packages/thefuck//types.py
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
