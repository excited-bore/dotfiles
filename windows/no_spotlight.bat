@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$key = 'HKCU:\SOFTWARE\Policies\Microsoft\Windows\CloudContent'; Set-ItemProperty $key DisableWindowsSpotlightFeatures 1;"
