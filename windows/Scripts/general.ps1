# Get all available functions (and show them)

function Get-Functions ($a){
    if ($null -ne $a){
        Get-Command -Type Function -Name $a | Format-Table Name, Definition -Wrap
    }else{
        Get-Command -Type Function | Format-Table Name, Definition -Wrap
    }
}

Set-Alias -Name list-functions -Value Get-Functions

# Autocompletion for Functions

#function Register-FunctionCompletion {
#    $functionName = "Get-Functions"
#    
#    $function:TabExpansion2 = {
#        param($line, $lastWord)
#        
#        if ($line -like "$functionName*") {
#            $aliases = Get-Function | Where-Object { $_.Name -like "$lastWord*" } | Select-Object -ExpandProperty Name
#            return $aliases
#        }
#    }
#}
#
#Register-FunctionCompletion


# Get all aliases

function Get-Aliases ($a){
    if ($null -ne $a){
        Get-Command -Type Alias -Name $a | Format-Table Name, Definition -Wrap
    }else{
        Get-Command -Type Alias | Format-Table Name, Definition -Wrap
    }
}

Set-Alias -Name list-aliases -Value Get-Aliases

# Autocompletion for Aliases

#function Register-AliasCompletion {
#    $functionName = "Get-Aliases"
#    
#    $function:TabExpansion2 = {
#        param($line, $lastWord)
#        
#        if ($line -like "$functionName*") {
#            $aliases = Get-Alias | Where-Object { $_.Name -like "$lastWord*" } | Select-Object -ExpandProperty Name
#            return $aliases
#        }
#    }
#}
#
#Register-AliasCompletion

# Get powershell modules

Set-Alias -Name list-modules -Value Get-Module

# Get all commands

function Get-Commands-All {
    Get-Command | Format-Table CommandType, Name, Definition -Wrap
}

Set-Alias -Name list-commands -Value Get-Commands-All

# Get properties object

function Get-Properties-Object(){
    Get-Member -InputObject  
}

Set-Alias -Name list-object-properties -Value Get-Properties-Object

# Get all COM ports

Set-Alias -Name Get-COM-ports -Value mode
Set-Alias -Name list-COM-ports -Value mode


# Shutdown / reboot

function shutdown-now {
    shutdown /f /t 0 /s 
}

function reboot {
    shutdown /f /t 0 /r
}

# Set 'where' to 'where.exe' instead of 'Where-Object' by

if (Get-Command where -Type Alias -Name Where-Object -ErrorAction SilentlyContinue){
    Remove-Item -Force Alias:where
    Set-Alias -Name where -Value where.exe
}

# Also set the same alias to 'Whereis'

if (Get-Command whereis -ErrorAction SilentlyContinue){
    Remove-Item -Force Alias:whereis
    Set-Alias -Name whereis -Value where.exe
}


# Set 'touch' for new file

Set-Alias -Name touch -Value New-Item 

# Reload profile

# https://stackoverflow.com/questions/567650/how-to-reload-user-profile-from-script-file-in-powershell

#function global:Reload-Profile {
#    @(
#        $Profile.AllUsersAllHosts,
#        $Profile.AllUsersCurrentHost,
#        $Profile.CurrentUserAllHosts,
#        $Profile.CurrentUserCurrentHost
#    ) | % {
#        if(Test-Path $_){
#            Write-Verbose "Running $_"
#            . $_
#        }
#    }
#}

function global:Reload-Profile{
    . $PROFILE
}

# r -> Reload profile

Get-Alias -Definition "Invoke-History" | grep.exe -q 'r ->' && Remove-Item -Force Alias:r && Set-Alias -Name r -Value Reload-Profile

# Remove recursively and forceably

function rm {
    Remove-Item -Recurse -Force
}

# Set 'type' to 'Get-Command' instead of 'Get-Content' which gives closer compatibility to bash

if (Get-Command -Type alias type -ErrorAction SilentlyContinue){
    Remove-Item -Force Alias:type
    function type { 
        if( $args ){ 
            Get-Command $args | Format-Table CommandType
        }else{ 
            Get-Command | Format-Table Name, CommandType 
        } 
    }
}



# Make symlink

function link-soft ($target, $link) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}

Set-Alias -Name symlink-soft -Value link-soft


# Up one directory

function x { Set-Location .. }


# Home directory

function c { Set-Location $HOME }


# Exit with one letter

function q { exit }

# Zip and unzip

Set-Alias -Name zip -Value Compress-Archive
Set-Alias -Name unzip -Value Expand-Archive

# (Access) Appsfolder
function Appsfolder(){
    Explorer Shell:AppsFolder 
}

Set-Alias -Name Open-Appsfolder -Value Appsfolder

# Execution policy unrestricted

function Set-Execution-Policy-Unrestricted{
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine
}

# nvim to vim
Set-Alias -Name vim -Value nvim

if ((Get-Alias man -ErrorAction SilentlyContinue) -and ((Get-Command nvim -ErrorAction SilentlyContinue) -or (Get-command less -ErrorAction SilentlyContinue))){
    Remove-Item -Force Alias:man
    if (Get-Command nvim -ErrorAction SilentlyContinue){
        function man($a){
            help.exe $a | nvim '+Man' -ErrorAction SilentlyContinue
        } 
    }else{
        function man($a){
            help.exe $a | less
        }
    }
}

# Check if vlc.exe exists, and if so add as an alias

if (Test-Path 'C:\Program Files\VideoLAN\VLC\vlc.exe' -PathType Leaf){ 
    Set-Alias -Name vlc -Value 'C:\Program Files\VideoLAN\VLC\vlc.exe' 
}
