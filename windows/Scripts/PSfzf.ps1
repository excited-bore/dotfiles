# Fzf

# Ctrl-t : Use fzf to browse (and open) multiple files  
# Ctrl-r : Spawn fzf file-browser/launcher

Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'

# Alt-c to select a directory. By default, Set-Location will be called with the selected directoryYou can override the default command with the following code in our $PROFILE:

# $commandOverride = [ScriptBlock]{ param($Location) Write-Host $Location }
# Set-PsFzfOption -AltCCommand $commandOverride

# Tab Expansion

# PSFzf can replace the standard tab completion:
Set-PSReadLineKeyHandler -Key Ctrl-Tab -ScriptBlock { Invoke-FzfTabCompletion }

# Set Ctrl-g to ripgrep-directory if 'InvokePsFzfRipgrep' exists
#
$rgexis = Get-Command rg -erroraction silentlycontinue
$batexis = Get-Command bat -erroraction silentlycontinue
if ($rgexis -And $batexis){
    function Ripgrep-Dir{ Invoke-PsFzfRipgrep -SearchString '' }
    Set-PSReadLineKeyHandler -Key Ctrl-g -ScriptBlock { Ripgrep-Dir }
}

# Set-PsFzfOption -TabExpansion
