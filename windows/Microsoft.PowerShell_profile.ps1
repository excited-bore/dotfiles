Import-Module $HOME\Documents\PowerShell\Modules\copy-to.psm1

# Source every script in the 'Scripts' folder that ends on '.ps1'

if (Test-Path "$($PSScriptRoot)\Scripts\*.ps1"){
  Get-Item (Join-Path -Path "$PSScriptRoot\Scripts" -ChildPath '*.ps1') | ForEach-Object {
           Write-Debug ("Importing sub-module {0}." -f $_.FullName)
           . $_.FullName
       }
}
