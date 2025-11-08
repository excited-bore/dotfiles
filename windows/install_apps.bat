@echo off

where winget >nul 2>&1 || (
    echo "Installing winget (App Installer) from Microsoft Store..."
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage -Name 'Microsoft.DesktopAppInstaller' -AllUsers | Out-Null; if (-not $?) {Start-Process 'ms-windows-store://pdp/?productid=9NBLGGH4NNS1'} else {Write-Host 'Already installed.'}"
)

winget install --id Adobe.Acrobat.Reader.64-bit --accept-package-agreements --accept-source-agreements
winget install --id VideoLAN.VLC --accept-package-agreements --accept-source-agreements
winget install --id BelgianGovernment.eIDViewer --accept-package-agreements --accept-source-agreements
winget install --id BelgianGovernment.eIDmiddleware --accept-package-agreements --accept-source-agreements
winget install --id TheDocumentFoundation.LibreOffice --accept-package-agreements --accept-source-agreements
winget install --id Mozilla.Firefox.nl --accept-package-agreements --accept-source-agreements
winget install --id Google.Chrome --accept-package-agreements --accept-source-agreements
