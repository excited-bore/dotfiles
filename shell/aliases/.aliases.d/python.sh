#python_install_user(){
#    python $@ install --user;
#}

pybuild='python -m build'
if hash python-build &> /dev/null; then
    pybuild='python-build'
fi

#alias python-twine-install="if ! type twine &> /dev/null; then pipx install twine; fi; if type build &> /dev/null; then pipx install build; fi"

alias pip='XDG_CACHE_HOME=/tmp pip'

alias python-version="python --version"

alias python-twine-upload-test="if hash deactivate &> /dev/null; then deactivate; fi; eval \"$pybuild\" && twine check dist/* && twine upload --repository testpypi dist/* && echo ''; rm dist/*"
alias python-twine-upload="if hash deactivate &> /dev/null; then deactivate; fi; eval \"$pybuild\" && twine check dist/* && twine upload dist/* && echo ''; rm dist/*"
alias python-venv="! test -d venv && ! test -d .venv && python3 -m venv .venv; test -d venv && source venv/bin/activate || test -d .venv && source .venv/bin/activate"
alias python-venv-activate="test -d venv && source venv/bin/activate || test -d .venv && source .venv/bin/activate"
alias python-venv-deactivate="deactivate"

alias pip-install-project="pip install ."
alias pip-clear-cache-all="pip cache purge"
alias pip-install-test="pip install -i https://test.pypi.org/simple/ "
alias pip-freeze-version="pip freeze"

alias python-pip-install-project="pip install ."
alias python-pip-clear-cache-all="pip cache purge"
alias python-pip-install-test="pip install -i https://test.pypi.org/simple/ "

if hash pyenv &> /dev/null; then
    alias pyenv-install="pyenv install "
    alias pyenv-uninstall="pyenv uninstall "

    alias pyenv-disable-globally="pyenv shell system; pyenv global system"

    function pyenv-enable(){
        local all vers 
        if test -z "$1" ; then
            reade -Q 'GREEN' -i "stable all" -p "What versions to list? [Stable/all]: " vers_all
            if [[ $vers_all == 'stable' ]]; then
                all="$(pyenv install -l | grep --color=never -E [[:space:]][0-9].*[0-9]$ | sed '/rc/d' | xargs| tr ' ' '\n' | tac)" 
            else
                all="$(pyenv install -l | awk 'NR>2 {print;}' | tac)" 
            fi
            printf "Python versions:\n${CYAN}$(echo $all | tr ' ' '\n' | tac | column)${normal}\n" 
            reade -Q 'GREEN' -i "$all" -p "Which version to install?: " vers  
        else
            vers="$1"
        fi
         
        reade -Q 'GREEN' -i "global local" -p "Set python version globally or locally? [Global/local]: " ansr 
        if [[ "$ansr" == 'global' ]]; then
            pyenv global "$vers" 
            readyn -p "Also set pyenv for shell? (only works if shell integration is enabled)" ansr
            [[ "$ansr" == 'y' ]] && pyenv shell "$vers"
        elif [[ "$ansr" == 'local' ]]; then
            pyenv local "$vers"
        fi
        printf "${bold}Version: ${normal}" 
        python --version
    } 

    function pyenv-install-and-enable(){
         local vers verss ansr all ansr 
         if test -z "$1" ; then
            reade -Q 'GREEN' -i "stable all" -p "What versions to list? [Stable/all]: " vers_all
            if [[ $vers_all == 'stable' ]]; then
                all="$(pyenv install -l | grep --color=never -E [[:space:]][0-9].*[0-9]$ | sed '/rc/d' | xargs| tr ' ' '\n' | tac)" 
            else
                all="$(pyenv install -l | awk 'NR>2 {print;}' | tac)" 
            fi
            printf "Python versions:\n${CYAN}$(echo $all | tr ' ' '\n' | tac | column)${normal}\n" 
            reade -Q 'GREEN' -i "$all" -p "Which version to install?: " vers  
        else
            vers="$1"
        fi
        
        if test -n "$vers"; then
            
            #set -o noglob
            #verss="$(pyenv versions | awk '{print $1;}' | sed '/system/d' )" 
            
            verss="$(pyenv completions global | sed '/--help/d; /system/d')" 

            [[ "${verss}" == *"$vers"* ]] && readyn -p "Python $vers is already installed. Reinstall?" ansr
            if [[ "$ansr" == 'y' ]]; then
                pyenv install "$vers" 
            fi
            if ! [[ "$ansr" == 'y' ]] || ! [[ $? == 0 ]]; then
                return 0
            fi
            
            pyenv-enable "$vers" 
        fi
    } 
    
fi
#complete -W "$(pyenv completions install | sed '/--.*/d' | sed '/system/d')" pyenv-install-globally
