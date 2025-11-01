@echo off
:: 0 = Hide the search box/icon entirely
:: 1 = Show the search icon only (magnifying glass)
:: 2 = Show the full search box
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search'; Set-ItemProperty $key SearchboxTaskbarMode 1;"
