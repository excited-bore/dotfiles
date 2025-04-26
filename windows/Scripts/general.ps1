# Powershell generally usefull aliases and variables

# Check if admin
# https://superuser.com/questions/749243/detect-if-powershell-is-running-as-administrator

$isAdmin = [bool](([System.Security.Principal.WindowsIdentity]::GetCurrent()).groups -match "S-1-5-32-544")

#if (-not (Get-Command sudo -errorAction SilentlyContinue)){
#    function sudo(){
#         runas /user:\administrator
#    }
#    
#}

$EDITOR = 'notepad'

if (Get-Command vim -errorAction SilentlyContinue){
   $EDITOR = 'vim'
}

if (Get-Command nvim -errorAction SilentlyContinue){
    $EDITOR = 'nvim'
}

function edit-powershell-profile(){
    & $EDITOR $PROFILE
}


#function Reade(){
#    param (
#        [CmdletBinding(PositionalBinding=$false)]
#        [parameter(mandatory=$true, position=0)]$Prompt,
#        [Parameter(Mandatory=$true)][string]$username,
#        [string]$password = $( Read-Host "Input password, please" )
#    )
#    $wshell = New-Object -ComObject wscript.shell
#    $wshell.SendKeys('dave'); $name = read-host -prompt 'What is your name'
#}


# Use 'BitTransfer' to copy items instead of Copy-item to reduce slow loadtimes
# https://stackoverflow.com/questions/2434133/progress-during-large-file-copy-copy-item-write-progress

# Also, copying to an empty destination will create a file first

Import-Module BitsTransfer
function cp () {
    [CmdletBinding()]
    Param
    (
        [parameter(mandatory=$true, position=0)]$Source,
        [parameter(mandatory=$true, position=1)]$Destination,
        [parameter(mandatory=$false, position=2, ValueFromRemainingArguments=$true)]$Remaining
    )
   
    if (Test-Path -Path $Destination -PathType Container){
        $newF = $(Get-Item $Source).BaseName + $(Get-Item $Source).Extension
        $Destination = Join-Path -Path $Destination -ChildPath $newF   
    }

    if ((Test-Path -Path $Source -PathType Leaf) -and -not (Test-Path -Path $Destination -PathType Leaf)){
         New-Item -ItemType File -Path $Destination -Force
    } 
    
    if ( $null -eq $Remaining ){
        Start-BitsTransfer -Source $Source -Destination $Destination
    }else{ 
        Start-BitsTransfer -Source $Source -Destination $Destination @Remaining
    }

}

if (Get-Command Add-Alias -errorAction SilentlyContinue){
    # Don't use Commandlets like Move-Item or Remove-Item because 
    # 1) They're more so used in scripts rather then straight from the shell
    # 2) Setting f.ex. Add-Alias 'Move-Item -Force' breaks 'mv'
    
    # ls shows hidden files
    Add-Alias ls 'ls -Force'
   
    # mv - move hidden files
    Add-Alias mv 'mv -Force'

    # cp - use bitstransfer
    Add-Alias cp 'cp -Verbose'

    # rm removes hidden files and recursively (everything in folder) 
    Add-Alias rm 'rm -Force -Recurse'

}

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

# Move-Item also moves hidden items

#function Move-Item
#{
#    Move-Item -Force
#}


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

#if ( $isAdmin -eq $true -or (Get-Command sudo -errorAction SilentlyContinue)){
    function bios(){
        sudo shutdown /r /fw /f /t 0
    }
#}

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

$exst = Get-Alias -Definition "Invoke-History" | grep.exe 'r ->'
if ($exst.count -eq 1){
    Remove-Item -Force Alias:r 
    Set-Alias -Name r -Value Reload-Profile
}

# Set 'type' to 'Get-Command' instead of 'Get-Content' which gives closer compatibility to bash

if (Get-Command -Type alias type -ErrorAction SilentlyContinue){
    Remove-Item -Force Alias:type
    function type { 
        if( $args ){ 
            Get-Command @args | Format-Table CommandType
        }else{ 
            Get-Command | Format-Table Name, CommandType 
        } 
    }
}



# Make symlink

function link-soft($target, $link) { 
    if ($null -eq $link){
        if (Test-Path $target -PathType Leaf){
            $link = $(Get-Item $target).BaseName + $(Get-Item $target).Extension
        }elseif (Test-Path $target -PathType Container){

            $link = $(Get-Item $target).BaseName        
       }
    }
    if (Test-Path $link -PathType Leaf){
        New-Item -Path $link -ItemType SymbolicLink -Value $target
    }else{
        cmd /c mklink /d $link $target
    }
}

Set-Alias -Name symlink-soft -Value link-soft
Set-Alias -Name softlink -Value link-soft


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
    function man($a){
        if (Get-Command nvim -ErrorAction SilentlyContinue){
            if ($null -ne $a){
                if (Get-Command -Type CmdLet -Name $a){
                    Get-Help $a | nvim                  
                }else{
                    help.exe $a  | nvim 
                } 
            }else{
                help.exe | nvim
            } 
        }else{
            if ($null -ne $a){
                if (Get-Command -Type CmdLet -Name $a){
                    Get-Help $a | less.exe                
                }else{
                    help.exe $a | less.exe
                }
            }else{
                help.exe | less
            }
        }    
    }
}

# Check if vlc.exe exists, and if so add as an alias

if (Test-Path 'C:\Program Files\VideoLAN\VLC\vlc.exe' -PathType Leaf){ 
    Set-Alias -Name vlc -Value 'C:\Program Files\VideoLAN\VLC\vlc.exe' 
}

# Invoke-Expression to eval
Set-Alias -Name eval -Value "Invoke-Expression"

# if wget.exe doesn't exist, Invoke-WebRequest alias for wget

if (-not (Get-Command wget.exe -ErrorAction SilentlyContinue)){
   Set-Alias -Name wget -Value 'Invoke-WebRequest' 
}

# Grep and Sed replacements
# https://quisitive.com/using-sed-and-grep-in-powershell/

if (-not (Get-Command grep.exe -ErrorAction SilentlyContinue)){
   filter grep($keyword) { if (($_ | Out-String) -like "$keyword") { $_ } } 
}

if (-not (Get-Command sed.exe -ErrorAction SilentlyContinue)){
    filter sed($before, $after) { %{$_ -replace $before,$after} }
}

function install-Ubuntu(){
    wsl.exe --install -d Ubuntu
}

function update-all-wing(){
    sudo winget update --all --include-unknown
}

function upgrade-all-wing(){
    sudo winget upgrade --all --include-unknown
}

