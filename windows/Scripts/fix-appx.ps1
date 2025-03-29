
# https://github.com/PowerShell/PowerShell/issues/13138#issuecomment-1820195503

$PSDefaultParameterValues['Import-Module:UseWindowsPowerShell'] = { 
  if ((Get-PSCallStack)[1].Position.Text -match '\bAppX') { $true } 
} 
