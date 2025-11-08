@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$key = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'; Set-ItemProperty $key AllowOptionalContent 2"
