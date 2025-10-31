$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
Set-ItemProperty $key HideFileExt 0
Set-ItemProperty $key FullPath 1

# Hidden Files
# Set-ItemProperty $key Hidden 1
# Set-ItemProperty $key ShowSuperHidden 1