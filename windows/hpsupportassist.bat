@echo off

where winget >nul 2>&1 || (
    echo "Installing winget (App Installer) from Microsoft Store..."
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -Name 'Microsoft.DesktopAppInstaller' -AllUsers | Out-Null; if (-not $?) {Start-Process 'ms-windows-store://pdp/?productid=9NBLGGH4NNS1'} else {Write-Host 'Already installed.'}"
)

where wget2 >nul 2>&1 || (
    set "INS_WGET=1" 
    winget install --id GNU.Wget2 --silent --accept-package-agreements --accept-source-agreements
) 

mkdir %TEMP%\HpSupport\
cd %TEMP%\HpSupport
wget2 -q https://ftp.hp.com/pub/softpaq/sp160001-160500/sp160330.exe
powershell -NoProfile -ExecutionPolicy Bypass -Command "%TEMP%\HpSupport\sp160330.exe"

if defined INS_WGET (
    winget remove --id GNU.Wget2 --silent --accept-package-agreements --accept-source-agreements
)

