@echo off

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'; $key1 = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState'; Set-ItemProperty $key HideFileExt 0; Set-ItemProperty $key1 FullPath 1; Stop-Process -processname explorer;"