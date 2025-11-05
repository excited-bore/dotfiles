@echo off
where winget >nul 2>&1 || (
    echo "Installing winget (App Installer) from Microsoft Store..."
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -Name 'Microsoft.DesktopAppInstaller' -AllUsers | Out-Null; if (-not $?) {Start-Process 'ms-windows-store://pdp/?productid=9NBLGGH4NNS1'} else {Write-Host 'Already installed.'}"
)
