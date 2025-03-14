Import-Module $HOME\Documents\PowerShell\environment.ps1
Import-Module $HOME\Documents\PowerShell\Modules\copy-to.psm1
Import-Module -DisableNameChecking $HOME\Documents\PowerShell\Modules\general.psm1
Import-Module $HOME\Documents\PowerShell\Modules\bind_keys.psm1
Import-Module -DisableNameChecking $HOME\Documents\PowerShell\Modules\PSfzf.psm1
Import-Module $HOME\Documents\PowerShell\Modules\no-exes.psm1
Import-Module -DisableNameChecking $HOME\Documents\PowerShell\Modules\python.psm1

# This *needs* to be in the main folder

function r { . $PROFILE }
