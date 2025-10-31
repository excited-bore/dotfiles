@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$key = 'HKCU:\SOFTWARE\Microsoft\Siuf\Rules'; Set-ItemProperty $key NumberOfSIUFInPeriod 0; if (Get-ItemProperty $key PeriodInNanoSeconds -ErrorAction SilentlyContinue) { Remove-ItemProperty $key PeriodInNanoSeconds; };"
