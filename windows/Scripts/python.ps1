
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

