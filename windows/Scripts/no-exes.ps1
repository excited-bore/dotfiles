# Get all command.exe commands in System32 and other common directories
$commandPaths = Get-Command -CommandType Application | Where-Object { $_.Path -like "C:\Windows\System32\*.exe" }

# Loop through each command and create an alias for it
foreach ($command in $commandPaths) {
    # Use the command name (without the '.exe') as the alias
    $aliasName = [System.IO.Path]::GetFileNameWithoutExtension($command.Name)

   # Check if the alias already exists
    if (-not (Get-Alias -Name $aliasName -ErrorAction SilentlyContinue)) {
        # Create an alias for the command if it doesn't exist
        Set-Alias -Name $aliasName -Value $command.Path
    }
}

# Verify the created aliases
#Get-Alias
