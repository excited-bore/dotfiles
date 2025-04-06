# Sets the registry value 'PortableOperatingSystem' to 0 if it's 1
# Located at HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\

# https://stackoverflow.com/questions/7690994/running-a-command-as-administrator-using-powershell

if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))  
{  
  $arguments = "& '" +$myinvocation.mycommand.definition + "'"
  Start-Process powershell -Verb runAs -ArgumentList $arguments
  Break
}

# https://stackoverflow.com/questions/15511809/how-do-i-get-the-value-of-a-registry-key-and-only-the-value-using-powershell
$key = 'HKLM:\SYSTEM\CurrentControlSet\Control'
$value = (Get-ItemProperty -Path $key -Name PortableOperatingSystem).PortableOperatingSystem

if ( $value -eq 1 ){
    Set-ItemProperty -Path $key -Name PortableOperatingSystem -Value 0 
}
