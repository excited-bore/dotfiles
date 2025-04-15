
$pybuild='python -m build'

if (Get-Command python-build -ErrorAction SilentlyContinue) {
    $pybuild='python-build'
}

function python-fix-build-module{
    pip install 'build<0.10.0'
}

function python-twine-build-and-upload-testrepo { 
    if (Get-Command deactivate -ErrorAction SilentlyContinue) { deactivate } 
    Invoke-Expression $pybuild 
    twine check dist/* 
    twine upload --repository testpypi dist/* 
    Remove-Item dist/* 
}

function python-twine-build-and-upload { 
    if (Get-Command deactivate -ErrorAction SilentlyContinue) { deactivate } 
    Invoke-Expression $pybuild 
    twine check dist/* 
    twine upload dist/* 
    Remove-Item dist/* 
}

function python-venv { 
    if (-not (Test-Path venv) -and -not (Test-Path .venv)) { 
        python -m venv .venv 
        . .\.venv\Scripts\Activate.ps1 
    } elseif (Test-Path venv) { 
        . .\venv\Scripts\Activate.ps1 
    } elseif (Test-Path .venv) { 
        . .\.venv\Scripts\Activate.ps1 
    } 
}

function python-venv-activate { 
    if (Test-Path venv) { 
        . .\venv\Scripts\Activate.ps1 
    } elseif (Test-Path .venv) { 
        . .\.venv\Scripts\Activate.ps1 
    } 
}

function python-venv-deactivate { 
    deactivate 
}

function pip-update{
    python.exe -m pip install --upgrade pip
}

function python-install-project { 
    pip install . 
}

Set-Alias -Name pip-install-project -Value python-install-project 

function pip-clear-cache-all { 
    pip cache purge 
}

function pip-install-test ($args) { 
    pip install -i https://test.pypi.org/simple/ $args 
}

function pip-freeze-version { 
    pip freeze 
}

function python-pip-install-project(){ pip install . }
function python-pip-clear-cache-all(){ pip cache purge }
function python-pip-install-test(){ pip install -i https://test.pypi.org/simple/ }

#if (Get-Command pyenv -errorAction SilentlyContinue){
#    function pyenv-install(){ pyenv install }
#    function pyenv-uninstall(){ pyenv uninstall }
#
#    function pyenv-disable-globally(){ 
#        pyenv shell system 
#        pyenv global system 
#    }
#
#    function pyenv-enable(){
#         if ( ! $null -eq $args[0] ){
#            $vers_all = Read-Host "What versions to list? [Stable/all]"
#            if ( $vers_all -eq 'stable' ){
#                all="$(pyenv install -l | grep --color=never -E [[:space:]][0-9].*[0-9]$ | sed '/rc/d' | xargs| tr ' ' '\n' | tac)" 
#                frst="$(echo $all | awk '{print $1}')"
#                all="$(echo $all | sed "s/\<$frst\> //g")" 
#            }else{
#                all="$(pyenv install -l | awk 'NR>2 {print;}' | tac)" 
#                frst="$(echo $all | awk '{print $1}')"
#                all="$(echo $all | sed "s/\<$frst\> //g")" 
#            }
#            Write-Host "Python versions:\n${CYAN}$(echo $all | tr ' ' '\n' | tac | column)${normal}\n" 
#            reade -Q 'GREEN' -i "$frst $all" -p "Which version to install?: " vers  
#        }else{
#            vers="$1"
#        }
#         
#        reade -Q 'GREEN' -i "global local" -p "Set python version globally or locally? [Global/local]: " ansr 
#        if test "$ansr" == 'global'; then
#            pyenv global "$vers" 
#            readyn -p "Also set pyenv for shell? (only works if shell integration is enabled)" ansr
#            test "$ansr" == 'y' && pyenv shell "$vers"
#        elif test "$ansr" == 'local'; then
#            pyenv local "$vers"
#        fi
#        printf "${bold}Version: ${normal}" 
#        python --version
#    } 
#
#    function pyenv-install-and-enable(){
#        
#         if test -z "$1" ; then
#            reade -Q 'GREEN' -i "stable all" -p "What versions to list? [Stable/all]: " vers_all
#            if test $vers_all == 'stable'; then
#                all="$(pyenv install -l | grep --color=never -E [[:space:]][0-9].*[0-9]$ | sed '/rc/d' | xargs| tr ' ' '\n' | tac)" 
#                frst="$(echo $all | awk '{print $1}')"
#                all="$(echo $all | sed "s/\<$frst\> //g")" 
#            else
#                all="$(pyenv install -l | awk 'NR>2 {print;}' | tac)" 
#                frst="$(echo $all | awk '{print $1}')"
#                all="$(echo $all | sed "s/\<$frst\> //g")" 
#            fi
#            printf "Python versions:\n${CYAN}$(echo $all | tr ' ' '\n' | tac | column)${normal}\n" 
#            reade -Q 'GREEN' -i "$frst $all" -p "Which version to install?: " vers  
#        else
#            vers="$1"
#        fi
#        
#        if ! test -z "$vers"; then
#            
#            #set -o noglob
#            #verss="$(pyenv versions | awk '{print $1;}' | sed '/system/d' )" 
#            
#            verss="$(pyenv completions global | sed '/--help/d' | sed '/system/d')" 
#
#            [[ "${verss}" == *"$vers"* ]] && readyn -p "Python $vers is already installed. Reinstall?" ansr
#            if test "$ansr" == 'y'; then
#                pyenv install "$vers" 
#            fi
#            if ! test "$ansr" == 'y' || ! test $? == 0; then
#                return 0
#            fi
#            
#            pyenv-enable "$vers" 
#        fi
#        unset frst vers verss ansr all ansr
#    } 
#}
