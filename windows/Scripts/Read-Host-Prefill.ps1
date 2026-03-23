function Read-Host-Prefill {
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [string]$Prompt,

        [Parameter()]
        [switch]$AsSecureString,

	[string[]]$Prefills,

	[string]$ForegroundColor
    )

    $Verbose = $PSBoundParameters.ContainsKey('Verbose')   

    # Import system.windows.form for autotyping first entry later on
    Add-Type -AssemblyName System.Windows.Forms
  
    $hist = Get-Content (Get-PSReadlineOption).HistorySavePath
    
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    
    # If PSReadline isn't initialized yet... 
    try {
        [Microsoft.PowerShell.PSConsoleReadLine]::GetHistoryItems() | Out-Null
    } catch {
        # .. force PSReadLine to initialize by calling ReadLine once before doing anything else
	[System.Windows.Forms.SendKeys]::SendWait("{ENTER}")
        [Microsoft.PowerShell.PSConsoleReadLine]::ReadLine($Host.Runspace, $ExecutionContext) | Out-Null
    }
    # Add-History would otherwise throw errors if we didnt initialize PSReadline first

    # Remove first element from array if it exists because it will be autotyped instead of added to history
    if ( -not ($Prefills[0] -eq $Null)){
	$first = $Prefills[0]
    	$Prefills[0] = $Null
    }

    # Add autofill options to history
    foreach ($entry in $Prefills) {
        [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($entry)
    }

    if ( -not ( $Prompt -eq "")){
	if ( -not ($ForegroundColor -eq "")){
	    Write-Host "${Prompt}" -ForegroundColor $ForegroundColor -NoNewline
	} else {
	    Write-Host "${Prompt}" -NoNewline
	}
    }

    if ( Get-Variable first -ErrorAction SilentlyContinue){
    	[System.Windows.Forms.SendKeys]::SendWait("$first")
    }
    
    $result = [Microsoft.PowerShell.PSConsoleReadLine]::ReadLine($Host.Runspace, $ExecutionContext)

    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    
    Clear-Content (Get-PSReadlineOption).HistorySavePath

    if ($Verbose){
    	Write-Host "Reloading history save file"
    }
    
    # https://github.com/PowerShell/PSReadLine/issues/494
    
    $hist | % { [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($_) }
    
    return $result
}